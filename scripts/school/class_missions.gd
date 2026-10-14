class_name ClassMissions
extends RefCounted
## Missões de Sala (seção 46.7): scripted scenarios stored in data/missions/class/*.json.
## This class only loads data and decides which mission a period triggers; ClassSession runs the steps.
static var missions: Array = []

static func load_data() -> void:
	if not missions.is_empty():
		return
	var index: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/missions/class/index.json"))
	for id in index:
		var path := "res://data/missions/class/%s.json" % id
		if FileAccess.file_exists(path):
			missions.append(JSON.parse_string(FileAccess.get_file_as_string(path)))

static func mission(id: String) -> Dictionary:
	load_data()
	for data in missions:
		if str(data.id) == id:
			return data
	return {}

static func completed(id: String) -> bool:
	return str(GameState.quests.get(id, {}).get("state", "")) == "completed"

static func _date_value(month: int, day: int) -> int:
	# School years run April→March, so count months from April.
	return ((month - 4 + 12) % 12) * 100 + day

## Which mission (if any) occupies this period. `session` provides subject, period, context and rng.
static func scheduled(session: ClassSession) -> Dictionary:
	load_data()
	var today := _date_value(GameTime.month, GameTime.day)
	for data in missions:
		if completed(str(data.id)):
			continue
		var trigger: Dictionary = data.get("trigger", {})
		var from: Array = trigger.get("from", [4, 1])
		var to: Array = trigger.get("to", from)
		var first := _date_value(int(from[0]), int(from[1]))
		var last := _date_value(int(to[0]), int(to[1]))
		if today < first or today > last:
			continue
		if trigger.has("subject") and session.subject_id != str(trigger.subject):
			continue
		if bool(trigger.get("theory", false)) and not bool(session.period.get("theory", false)):
			continue
		if trigger.has("neighbor") and not session.neighbor_present(str(trigger.neighbor)):
			continue
		if bool(trigger.get("first_attended", false)) and GameState.flags.has("intro_done"):
			continue
		if trigger.has("chance") and today != last:
			if not session.rng.chance(float(trigger.chance)):
				continue
		return data
	return {}

## Question ids fixed by missions not yet completed: kept out of the random pool so the
## scripted moment is never a repetition (seção 46.6, regra "nunca repetir").
static func reserved_questions() -> Array:
	load_data()
	var result: Array = []
	for data in missions:
		if completed(str(data.id)):
			continue
		for entry in data.get("steps", []):
			if str(entry.get("type", "")) == "question" and entry.has("question"):
				result.append(str(entry.question))
	return result

static func step(data: Dictionary, id: String) -> Dictionary:
	for entry in data.get("steps", []):
		if str(entry.id) == id:
			return entry
	return {}

static func first_step(data: Dictionary) -> Dictionary:
	var steps: Array = data.get("steps", [])
	return steps[0] if not steps.is_empty() else {}

const ORIGIN_FACTS := {"capital": "“Vim da capital. Aqui é tão silencioso que eu acordo com os pássaros.”",
	"countryside": "“Vim de uma vila nas montanhas. Hoshikawa, para mim, é cidade grande.”",
	"abroad": "“Morei fora do Japão por alguns anos. Ainda penso em inglês às vezes.”"}
const TALENT_FACTS := {"dedicated": "“Gosto de estudar com calma. De preferência com chá.”",
	"athlete": "“Corro de manhã. Quase todo dia.”",
	"artist": "“Desenho. Em qualquer papel que aparecer.”",
	"social": "“Gosto de conhecer gente. Então… oi.”"}

## Replaces {name}, {teacher}, {origin_fact} and {talent_fact} in mission texts.
static func fill(text: String, teacher: String) -> String:
	return text.replace("{name}", GameState.player_name).replace("{teacher}", teacher) \
		.replace("{origin_fact}", str(ORIGIN_FACTS.get(str(GameState.background.get("origin", "capital")), ""))) \
		.replace("{talent_fact}", str(TALENT_FACTS.get(str(GameState.background.get("talent", "dedicated")), "")))

## Effects shared by missions and generic moments. Returns human-readable lines for the summary.
static func apply_effects(effects: Dictionary, names: Dictionary = {}) -> Array:
	var lines: Array = []
	if effects.is_empty():
		return lines
	for flag in effects.get("flags", []):
		GameState.mark(str(flag))
	var bonds: Dictionary = effects.get("bond", {})
	for id in bonds:
		var amount := int(bonds[id])
		if amount == 0:
			continue
		GameState.add_bond(str(id), amount)
		lines.append("%s%d vínculo · %s" % ["+" if amount > 0 else "", amount, names.get(str(id), str(id).capitalize())])
	var stats: Dictionary = effects.get("attributes", {})
	for key in stats:
		GameState.improve(str(key), int(stats[key]))
		lines.append("%s%d %s" % ["+" if int(stats[key]) > 0 else "", int(stats[key]), key])
	var gains: Dictionary = effects.get("mastery", {})
	for subject in gains:
		var applied := GameState.gain_mastery(str(subject), int(gains[subject]))
		if applied > 0:
			lines.append("+%d Domínio · %s" % [applied, Timetable.subject_name(str(subject))])
	for card in effects.get("cards", []):
		if GameState.add_card(str(card)):
			lines.append("Novo cartão: " + str(QuestionBank.card(str(card)).get("title", card)))
	var rep: Dictionary = effects.get("reputation", {})
	for kind in rep:
		GameState.add_reputation(str(kind), int(rep[kind]))
		lines.append("+%d reputação %s" % [int(rep[kind]), {"academic": "acadêmica", "sports": "esportiva", "social": "social", "institutional": "institucional"}.get(str(kind), str(kind))])
	if effects.has("energy"):
		if int(effects.energy) >= 0:
			GameState.restore_energy(int(effects.energy))
		else:
			GameState.drain_energy(-int(effects.energy))
	if effects.has("money"):
		GameState.money = maxi(0, GameState.money + int(effects.money))
	if effects.has("mood"):
		GameState.set_mood(str(effects.mood), int(effects.get("mood_days", 1)))
		lines.append("Humor: %s" % GameState.mood_name())
	var counts: Dictionary = effects.get("counters", {})
	for name in counts:
		GameState.add_counter(str(name), int(counts[name]))
	if int(effects.get("occurrence", 0)) > 0:
		GameState.add_occurrence(str(effects.get("occurrence_text", "Ocorrência leve em aula.")), int(effects.occurrence))
		lines.append("Ocorrência leve registrada")
	if effects.has("log"):
		GameState.log_day(str(effects.log))
	return lines
