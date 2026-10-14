extends Node
## Protagonist state. Save format v3 (seção 61.4): every new field is optional on read.
signal changed
signal notice(text: String)
const SCENES := ["bedroom", "home", "neighborhood", "school_hall", "classroom"]
const DEFAULT_STATS := {"Conhecimento": 15, "Carisma": 5, "Condicionamento": 3, "Criatividade": 5, "Disciplina": 10, "Empatia": 5}
const SUBJECTS := ["literature", "math", "english", "history", "science", "pe", "art", "home_ec"]
const TALENTS := {
	"dedicated": {"name": "Dedicado", "item": "Caderno de capa dura", "mastery": "math",
		"stats": {"Conhecimento": 15, "Carisma": 5, "Condicionamento": 3, "Criatividade": 5, "Disciplina": 10, "Empatia": 5}},
	"athlete": {"name": "Atleta", "item": "Tênis de corrida", "mastery": "pe",
		"stats": {"Conhecimento": 8, "Carisma": 6, "Condicionamento": 12, "Criatividade": 3, "Disciplina": 8, "Empatia": 6}},
	"artist": {"name": "Artista", "item": "Estojo de lápis de desenho", "mastery": "art",
		"stats": {"Conhecimento": 9, "Carisma": 5, "Condicionamento": 4, "Criatividade": 14, "Disciplina": 5, "Empatia": 6}},
	"social": {"name": "Sociável", "item": "Capinha de celular chamativa", "mastery": "english",
		"stats": {"Conhecimento": 8, "Carisma": 13, "Condicionamento": 5, "Criatividade": 5, "Disciplina": 4, "Empatia": 8}}}
const ORIGINS := {"capital": {"name": "Capital", "item": "Cartão de trem antigo"},
	"countryside": {"name": "Interior", "item": "Amuleto do vilarejo"},
	"abroad": {"name": "Retorno do exterior", "item": "Caderno bilíngue"}}
const REASONS := {"parents_abroad": "Transferência dos pais para o exterior",
	"separation": "Recomeço após a separação dos pais", "own_choice": "Escolha própria"}
const TRAITS := {"curious": "Curioso", "shy": "Tímido", "sociable": "Sociável", "competitive": "Competitivo",
	"dreamer": "Sonhador", "practical": "Prático", "stubborn": "Teimoso", "observant": "Observador",
	"playful": "Brincalhão", "careful": "Cuidadoso"}
const MOODS := {"calm": "Tranquilo", "upbeat": "Animado", "inspired": "Inspirado", "tired": "Cansado", "anxious": "Ansioso", "sad": "Triste"}
const BOND_LEVELS := [50, 150, 300, 500, 750]
const BOND_NAMES := ["Estranho", "Conhecido", "Colega", "Amigo", "Amigo próximo", "Laço profundo"]
const MASTERY_DAILY_CAP := 6
const ALLOWANCE := 3000
var player_name: String = "Haru"
var skin: String = "efbd98"
var hair: String = "393940"
var scene_id: String = "bedroom"
var player_position := Vector3(0, 0.1, 2)
var energy: float = 100.0
var money: int = 1500
var attributes: Dictionary = DEFAULT_STATS.duplicate()
var inventory: Dictionary = {"Onigiri": 1}
var relationships: Dictionary = {}
var talked: Dictionary = {}
var attendance: Dictionary = {}
var flags: Dictionary = {}
var background: Dictionary = {"origin": "capital", "reason": "own_choice", "talent": "dedicated", "traits": []}
var mastery: Dictionary = {}
var cards: Array = []
var notebook_pages: Dictionary = {}
var questions_seen: Array = []
var reputation: Dictionary = {"academic": 0, "sports": 0, "social": 0, "institutional": 0}
var discipline: Dictionary = {"term_points": 0, "history": []}
var mood: Dictionary = {"state": "calm", "until": ""}
var diary: Array = []
var day_log: Array = []
var counters: Dictionary = {}
var quests: Dictionary = {}
var mastery_today: Dictionary = {"stamp": "", "gains": {}}
var camera_perspective: bool = false
var shadows: bool = true

func reset(character_name: String = "Haru", skin_color: String = "efbd98", hair_color: String = "393940", profile: Dictionary = {}) -> void:
	player_name = character_name.strip_edges().left(24)
	if player_name.is_empty():
		player_name = "Haru"
	skin = skin_color
	hair = hair_color
	scene_id = "bedroom"
	player_position = Vector3(0, 0.1, 2)
	energy = 100.0
	money = 1500
	attributes = DEFAULT_STATS.duplicate()
	inventory = {"Onigiri": 1}
	relationships = {}
	talked = {}
	attendance = {}
	flags = {}
	background = {"origin": "capital", "reason": "own_choice", "talent": "dedicated", "traits": []}
	mastery = {}
	cards = []
	notebook_pages = {}
	questions_seen = []
	reputation = {"academic": 0, "sports": 0, "social": 0, "institutional": 0}
	discipline = {"term_points": 0, "history": []}
	mood = {"state": "calm", "until": ""}
	diary = []
	day_log = []
	counters = {}
	quests = {}
	mastery_today = {"stamp": "", "gains": {}}
	apply_profile(profile)
	changed.emit()

## Talent, origin and traits chosen in the creator (seções 45.3, 45.5, 45.6).
func apply_profile(profile: Dictionary) -> void:
	var talent_id := str(profile.get("talent", "dedicated"))
	if not TALENTS.has(talent_id):
		talent_id = "dedicated"
	var origin_id := str(profile.get("origin", "capital"))
	if not ORIGINS.has(origin_id):
		origin_id = "capital"
	var reason_id := str(profile.get("reason", "own_choice"))
	if not REASONS.has(reason_id):
		reason_id = "own_choice"
	var traits: Array = []
	for trait_id in profile.get("traits", []):
		if TRAITS.has(str(trait_id)) and traits.size() < 2 and not traits.has(str(trait_id)):
			traits.append(str(trait_id))
	background = {"origin": origin_id, "reason": reason_id, "talent": talent_id, "traits": traits}
	var talent: Dictionary = TALENTS[talent_id]
	attributes = talent.stats.duplicate()
	for subject in SUBJECTS:
		mastery[subject] = int(attributes.Conhecimento)
	mastery[str(talent.mastery)] = int(mastery[str(talent.mastery)]) + 10
	if origin_id == "abroad":
		mastery.english = int(mastery.english) + 15
		mastery.literature = maxi(0, int(mastery.literature) - 5)
	inventory[str(talent.item)] = 1
	inventory[str(ORIGINS[origin_id].item)] = 1

func has_trait(trait_id: String) -> bool:
	return background.get("traits", []).has(trait_id)

func mark(flag: String) -> void:
	flags[flag] = true
	changed.emit()

func improve(attribute: String, amount: int) -> void:
	attributes[attribute] = clampi(int(attributes.get(attribute, 0)) + amount, 0, 100)
	changed.emit()

func energy_cost(amount: float) -> float:
	return amount * 1.2 if str(mood.get("state", "calm")) == "tired" else amount

func spend_energy(amount: float) -> bool:
	var cost := energy_cost(amount)
	if energy < cost:
		notice.emit("Que tal descansar ou comer um onigiri primeiro?")
		return false
	energy = maxf(0, energy - cost)
	changed.emit()
	return true

## Classes may drain energy below the cost; they never block participation.
func drain_energy(amount: float) -> void:
	energy = clampf(energy - energy_cost(amount), 0, 100)
	changed.emit()

func restore_energy(amount: float) -> void:
	energy = clampf(energy + amount, 0, 100)
	changed.emit()

## Domínio por matéria (seção 47.1): +6 per subject per day at most; never decreases.
## Every 10 points earned anywhere raise Conhecimento by 1 (seção 47.2). Returns the amount applied.
func gain_mastery(subject: String, amount: int) -> int:
	if amount <= 0 or not SUBJECTS.has(subject):
		return 0
	var stamp := GameTime.stamp()
	if str(mastery_today.get("stamp", "")) != stamp:
		mastery_today = {"stamp": stamp, "gains": {}}
	var today := int(mastery_today.gains.get(subject, 0))
	var allowed := clampi(MASTERY_DAILY_CAP - today, 0, amount)
	var current := int(mastery.get(subject, 0))
	allowed = mini(allowed, 100 - current)
	if allowed <= 0:
		return 0
	mastery[subject] = current + allowed
	mastery_today.gains[subject] = today + allowed
	var progress := int(counters.get("mastery_progress", 0)) + allowed
	while progress >= 10:
		progress -= 10
		improve("Conhecimento", 1)
	counters.mastery_progress = progress
	changed.emit()
	return allowed

func mastery_of(subject: String) -> int:
	return int(mastery.get(subject, 0))

func add_card(id: String) -> bool:
	if id.is_empty() or cards.has(id):
		return false
	cards.append(id)
	changed.emit()
	return true

func add_bond(id: String, amount: int) -> int:
	var value := clampi(int(relationships.get(id, 0)) + amount, 0, 1000)
	relationships[id] = value
	changed.emit()
	return value

func bond(id: String) -> int:
	return int(relationships.get(id, 0))

## Level 0 = unknown … 5 = Inseparável (seção 52.1: 50/150/300/500/750).
func bond_level(id: String) -> int:
	var points := bond(id)
	var level := 0
	for threshold in BOND_LEVELS:
		if points >= int(threshold):
			level += 1
	return level

func bond_level_name(id: String) -> String:
	return BOND_NAMES[bond_level(id)]

func add_reputation(kind: String, amount: int) -> void:
	reputation[kind] = clampi(int(reputation.get(kind, 0)) + amount, 0, 100)
	changed.emit()

func add_occurrence(text: String, points: int = 1) -> void:
	discipline.term_points = int(discipline.get("term_points", 0)) + points
	discipline.history.append({"date": GameTime.stamp(), "text": text, "points": points})
	changed.emit()

func set_mood(state: String, days: int = 1) -> void:
	if not MOODS.has(state):
		return
	mood = {"state": state, "until": _stamp_after(days)}
	changed.emit()

func mood_name() -> String:
	return str(MOODS.get(str(mood.get("state", "calm")), "Tranquilo"))

## Moods expire at the start of the day after `until`.
func refresh_mood() -> void:
	var until := str(mood.get("until", ""))
	if str(mood.get("state", "calm")) != "calm" and (until.is_empty() or GameTime.stamp() > until):
		mood = {"state": "calm", "until": ""}
		changed.emit()

func _stamp_after(days: int) -> String:
	var day := GameTime.day
	var month := GameTime.month
	var year := GameTime.year
	for i in range(days):
		day += 1
		if day > 14:
			day = 1
			month = month % 12 + 1
			if month == 4:
				year += 1
	return "%d-%02d-%02d" % [year, month, day]

func log_day(text: String) -> void:
	if text.is_empty():
		return
	day_log.append(text)

func add_counter(name: String, amount: int = 1) -> int:
	counters[name] = int(counters.get(name, 0)) + amount
	return int(counters[name])

func counter(name: String) -> int:
	return int(counters.get(name, 0))

func remember_question(id: String) -> void:
	questions_seen.erase(id)
	questions_seen.append(id)
	while questions_seen.size() > 20:
		questions_seen.pop_front()

func objective() -> String:
	if not flags.has("home"):
		return "Um novo começo\nExplore a casa da sua avó."
	if not flags.has("school_hall"):
		return "O caminho das cerejeiras\nSiga a rua ao norte até a escola."
	if not flags.has("talk"):
		return "Um rosto conhecido\nConverse com alguém na escola."
	if not flags.has("class"):
		return "Seu lugar na turma 1-A\nSente-se na sua carteira e participe de um período."
	if not flags.has("slept"):
		return "Leve o dia com você\nVolte ao quarto e durma."
	if not flags.has("first_question"):
		return "Primeira semana\nParticipe das aulas, responda ao Sato e conheça seus vizinhos de carteira."
	var level_ones := 0
	for id in relationships:
		if bond_level(str(id)) >= 1:
			level_ones += 1
	if level_ones < 3:
		return "Primeira semana\nFaça três conhecidos de verdade (vínculo 50): conversas, bilhetes e ajuda em aula contam."
	return "Um dia de cada vez\nEscolha como viver sua próxima manhã."

func serialize() -> Dictionary:
	return {"name": player_name, "skin": skin, "hair": hair, "scene": scene_id,
		"position": [player_position.x, player_position.y, player_position.z],
		"energy": energy, "money": money, "attributes": attributes.duplicate(true),
		"inventory": inventory.duplicate(true), "relationships": relationships.duplicate(true),
		"talked": talked.duplicate(true), "attendance": attendance.duplicate(true), "flags": flags.duplicate(true),
		"background": background.duplicate(true), "mastery": mastery.duplicate(true), "cards": cards.duplicate(),
		"notebook_pages": notebook_pages.duplicate(true), "questions_seen": questions_seen.duplicate(),
		"reputation": reputation.duplicate(true), "discipline": discipline.duplicate(true), "mood": mood.duplicate(true),
		"diary": diary.duplicate(true), "day_log": day_log.duplicate(), "counters": counters.duplicate(true),
		"quests": quests.duplicate(true), "mastery_today": mastery_today.duplicate(true)}

func restore(data: Dictionary) -> void:
	reset(str(data.get("name", "Haru")), str(data.get("skin", "efbd98")), str(data.get("hair", "393940")), data.get("background", {}))
	scene_id = data.scene
	var p: Array = data.position
	player_position = Vector3(p[0], p[1], p[2])
	energy = clampf(float(data.get("energy", 100)), 0, 100)
	money = clampi(int(data.get("money", 1500)), 0, 9999999)
	for key in DEFAULT_STATS:
		attributes[key] = clampi(int(data.get("attributes", {}).get(key, DEFAULT_STATS[key])), 0, 100)
	inventory = data.get("inventory", {"Onigiri": 1}).duplicate(true)
	relationships = data.get("relationships", {}).duplicate(true)
	talked = data.get("talked", {}).duplicate(true)
	attendance = data.get("attendance", {}).duplicate(true)
	flags = data.get("flags", {}).duplicate(true)
	var saved_mastery: Dictionary = data.get("mastery", {})
	for subject in SUBJECTS:
		mastery[subject] = clampi(int(saved_mastery.get(subject, mastery.get(subject, attributes.Conhecimento))), 0, 100)
	cards = data.get("cards", []).duplicate()
	notebook_pages = data.get("notebook_pages", {}).duplicate(true)
	questions_seen = data.get("questions_seen", []).duplicate()
	reputation = data.get("reputation", reputation).duplicate(true)
	discipline = data.get("discipline", discipline).duplicate(true)
	mood = data.get("mood", mood).duplicate(true)
	diary = data.get("diary", []).duplicate(true)
	day_log = data.get("day_log", []).duplicate()
	counters = data.get("counters", {}).duplicate(true)
	quests = data.get("quests", {}).duplicate(true)
	mastery_today = data.get("mastery_today", {"stamp": "", "gains": {}}).duplicate(true)
	changed.emit()
