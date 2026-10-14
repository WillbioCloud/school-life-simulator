class_name QuestionBank
extends RefCounted
## Question bank and content cards (seção 47). One JSON file per subject under
## data/questions/ and data/cards/. Draws are deterministic through SeededRng.
const QUESTION_SUBJECTS := ["literature", "math", "english", "science"]
const CARD_SUBJECTS := ["literature", "math", "english", "science"]
const REWARDS := {1: {"mastery": 1, "reputation": 1, "teacher": 1}, 2: {"mastery": 2, "reputation": 2, "teacher": 1}, 3: {"mastery": 3, "reputation": 4, "teacher": 2}}
static var questions: Dictionary = {}
static var by_subject: Dictionary = {}
static var cards: Dictionary = {}
static var cards_by_subject: Dictionary = {}

static func load_data() -> void:
	if not questions.is_empty():
		return
	for subject in QUESTION_SUBJECTS:
		var path := "res://data/questions/%s.json" % subject
		if not FileAccess.file_exists(path):
			continue
		by_subject[subject] = []
		for data in JSON.parse_string(FileAccess.get_file_as_string(path)):
			questions[data.id] = data
			by_subject[subject].append(data.id)
	for subject in CARD_SUBJECTS:
		var path := "res://data/cards/%s.json" % subject
		if not FileAccess.file_exists(path):
			continue
		cards_by_subject[subject] = []
		for data in JSON.parse_string(FileAccess.get_file_as_string(path)):
			cards[data.id] = data
			cards_by_subject[subject].append(data.id)

static func question(id: String) -> Dictionary:
	load_data()
	return questions.get(id, {})

static func card(id: String) -> Dictionary:
	load_data()
	return cards.get(id, {})

static func has_questions(subject: String) -> bool:
	load_data()
	return not by_subject.get(subject, []).is_empty()

static func card_ids(subject: String, unit: int = 0) -> Array:
	load_data()
	var result: Array = []
	for id in cards_by_subject.get(subject, []):
		if unit == 0 or int(cards[id].unit) == unit:
			result.append(id)
	return result

## Difficulty levels drawn for a mastery value (seção 46.6), optionally shifted by one.
static func levels_for(mastery: int, shift: int = 0) -> Array:
	var levels: Array = [1] if mastery < 30 else ([1, 2] if mastery < 70 else [2, 3])
	if shift != 0:
		var shifted: Array = []
		for level in levels:
			shifted.append(clampi(int(level) + shift, 1, 3))
		levels = shifted
	return levels

## Picks a question of the subject/unit among the given levels, avoiding ids in `exclude`
## (recently seen or reserved by missions). When every question of those levels was seen,
## the search widens to the other levels before any repetition is allowed.
static func pick(subject: String, unit: int, levels: Array, rng: SeededRng, exclude: Array = []) -> Dictionary:
	load_data()
	var fallback: Array = []
	for attempt in [levels, [1, 2, 3]]:
		var pool: Array = []
		for id in by_subject.get(subject, []):
			var data: Dictionary = questions[id]
			if int(data.unit) != unit or not attempt.has(int(data.level)):
				continue
			if attempt == levels:
				fallback.append(id)
			if not exclude.has(id):
				pool.append(id)
		if not pool.is_empty():
			return questions[rng.pick(pool)]
	if fallback.is_empty():
		return {}
	return questions[rng.pick(fallback)]

## Presentation copy: options shuffled deterministically; each keeps its original index.
static func present(data: Dictionary, rng: SeededRng) -> Dictionary:
	var options: Array = []
	for i in range(data.options.size()):
		options.append({"text": str(data.options[i]), "orig": i})
	if str(data.get("type", "choice")) != "truefalse":
		options = rng.shuffled(options)
	return {"id": str(data.id), "subject": str(data.subject), "level": int(data.level), "prompt": str(data.prompt),
		"options": options, "answer": int(data.answer), "explain": str(data.get("explain", "")), "card": str(data.get("card", "")),
		"type": str(data.get("type", "choice"))}

static func is_correct(presented: Dictionary, position: int) -> bool:
	if position < 0 or position >= presented.options.size():
		return false
	return int(presented.options[position].orig) == int(presented.answer)

## Removes one wrong alternative (Pedir ajuda ao vizinho). Returns false if nothing was removed.
static func eliminate_wrong(presented: Dictionary, rng: SeededRng) -> bool:
	var wrong: Array = []
	for i in range(presented.options.size()):
		if int(presented.options[i].orig) != int(presented.answer):
			wrong.append(i)
	if wrong.size() <= 1 and presented.options.size() <= 2:
		return false
	if wrong.is_empty():
		return false
	presented.options.remove_at(int(rng.pick(wrong)))
	return true

static func reward(level: int) -> Dictionary:
	return REWARDS.get(clampi(level, 1, 3), REWARDS[1])

## Authoring rules of seção 47.5, used by the automated tests (seção 61.6).
static func validate() -> Array:
	load_data()
	var errors: Array = []
	var seen: Dictionary = {}
	var per_level: Dictionary = {}
	for id in questions:
		var data: Dictionary = questions[id]
		if seen.has(id):
			errors.append("id duplicado: " + str(id))
		seen[id] = true
		var options: Array = data.get("options", [])
		if options.size() < 2 or options.size() > 4:
			errors.append("%s: número de alternativas inválido" % id)
		if int(data.get("answer", -1)) < 0 or int(data.get("answer", -1)) >= options.size():
			errors.append("%s: answer fora do intervalo" % id)
		if not cards.has(str(data.get("card", ""))):
			errors.append("%s: cartão inexistente %s" % [id, data.get("card", "")])
		if str(data.get("explain", "")).strip_edges().is_empty():
			errors.append("%s: explain vazio" % id)
		if not [1, 2, 3].has(int(data.get("level", 0))):
			errors.append("%s: nível inválido" % id)
		var bucket := "%s:%d:%d" % [data.subject, int(data.unit), int(data.level)]
		per_level[bucket] = int(per_level.get(bucket, 0)) + 1
	for subject in by_subject:
		for level in [1, 2, 3]:
			var bucket := "%s:1:%d" % [subject, level]
			if int(per_level.get(bucket, 0)) < 4:
				errors.append("%s: menos de 4 questões no nível %d da unidade 1" % [subject, level])
	for id in cards:
		var data: Dictionary = cards[id]
		if str(data.get("title", "")).is_empty() or str(data.get("text", "")).is_empty():
			errors.append("cartão incompleto: " + str(id))
	return errors
