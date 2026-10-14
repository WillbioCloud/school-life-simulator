extends Node
## One versioned slot; previous good save retained. Loading validates before mutation.
const PATH := "user://first_day.json"
const VERSION := 3
var last_error: String = ""

func exists() -> bool:
	return FileAccess.file_exists(PATH)

func save_game() -> bool:
	var payload := {"version": VERSION, "time": GameTime.serialize(), "player": GameState.serialize()}
	var error := validate(payload)
	if not error.is_empty():
		last_error = error
		return false
	var file := FileAccess.open(PATH + ".tmp", FileAccess.WRITE)
	if file == null:
		last_error = "Não foi possível criar o arquivo de salvamento."
		return false
	file.store_string(JSON.stringify(payload, "\t"))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		last_error = "Erro ao gravar. Seu save anterior foi preservado."
		return false
	if exists():
		var backup_error := DirAccess.copy_absolute(PATH, PATH + ".bak")
		if backup_error != OK:
			last_error = "Não foi possível preservar o backup."
			return false
	var result := DirAccess.rename_absolute(PATH + ".tmp", PATH)
	last_error = "" if result == OK else "Não foi possível finalizar o salvamento."
	return result == OK

func load_game(backup: bool = false) -> bool:
	var path := PATH + ".bak" if backup else PATH
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		last_error = "Nenhum salvamento disponível."
		return false
	var json := JSON.new()
	var parse_error := json.parse(file.get_as_text())
	file.close()
	var parsed: Variant = json.data
	if parse_error != OK or not parsed is Dictionary:
		last_error = "O arquivo de salvamento está danificado."
		return false
	var data: Dictionary = migrate(parsed)
	last_error = validate(data)
	if not last_error.is_empty():
		return false
	GameState.restore(data.player)
	GameTime.restore(data.time)
	return true

func migrate(data: Dictionary) -> Dictionary:
	var migrated := data.duplicate(true)
	if int(migrated.get("version", 0)) == 1:
		# v1 had the same core format, but no narrative milestone map.
		if migrated.get("player") is Dictionary:
			if not migrated.player.has("flags"):
				migrated.player.flags = {}
		migrated.version = 2
	if int(migrated.get("version", 0)) == 2:
		# v2 → v3 (seção 61.3): additive fields of the First Week milestone. Nothing is lost:
		# every subject starts at the saved Conhecimento, the profile is the neutral default.
		if migrated.get("player") is Dictionary:
			var p: Dictionary = migrated.player
			var knowledge := int(p.get("attributes", {}).get("Conhecimento", GameState.DEFAULT_STATS.Conhecimento))
			if not p.has("background"):
				p.background = {"origin": "capital", "reason": "own_choice", "talent": "dedicated", "traits": []}
			if not p.get("mastery", {}) is Dictionary or p.get("mastery", {}).is_empty():
				var mastery := {}
				for subject in GameState.SUBJECTS:
					mastery[subject] = clampi(knowledge, 0, 100)
				p.mastery = mastery
			for key in ["cards", "questions_seen", "diary", "day_log"]:
				if not p.get(key) is Array:
					p[key] = []
			for key in ["notebook_pages", "counters", "quests"]:
				if not p.get(key) is Dictionary:
					p[key] = {}
			if not p.get("reputation") is Dictionary:
				p.reputation = {"academic": 0, "sports": 0, "social": 0, "institutional": 0}
			if not p.get("discipline") is Dictionary:
				p.discipline = {"term_points": 0, "history": []}
			if not p.get("mood") is Dictionary:
				p.mood = {"state": "calm", "until": ""}
			if not p.get("mastery_today") is Dictionary:
				p.mastery_today = {"stamp": "", "gains": {}}
		migrated.version = 3
	return migrated

func validate(data: Dictionary) -> String:
	if int(data.get("version", 0)) != VERSION:
		return "Versão de save não suportada. O arquivo não foi alterado."
	if not data.get("time") is Dictionary or not data.get("player") is Dictionary:
		return "Save incompleto."
	var t: Dictionary = data.time
	for key in ["year", "month", "day", "minute"]:
		if not _number(t.get(key)):
			return "Calendário inválido."
	if t.year < 1 or t.month < 1 or t.month > 12 or t.day < 1 or t.day > 14 or t.minute < 0 or t.minute >= 1440:
		return "Data fora dos limites do calendário."
	var p: Dictionary = data.player
	if not p.get("scene") in GameState.SCENES:
		return "Ambiente desconhecido."
	if not p.get("position") is Array or p.position.size() != 3:
		return "Posição inválida."
	for value in p.position:
		if not _number(value) or absf(float(value)) > 1000:
			return "Posição fora dos limites."
	for key in ["attributes", "inventory", "relationships", "talked", "attendance", "flags", "background", "mastery", "notebook_pages", "reputation", "discipline", "mood", "counters", "quests", "mastery_today"]:
		if not p.get(key, {}) is Dictionary:
			return "Dados inválidos: " + key
	for key in ["cards", "questions_seen", "diary", "day_log"]:
		if not p.get(key, []) is Array:
			return "Dados inválidos: " + key
	for subject in p.get("mastery", {}):
		if not _number(p.mastery[subject]) or p.mastery[subject] < 0 or p.mastery[subject] > 100:
			return "Domínio fora dos limites."
	if not GameState.TALENTS.has(str(p.get("background", {}).get("talent", "dedicated"))):
		return "Talento desconhecido."
	if not GameState.MOODS.has(str(p.get("mood", {}).get("state", "calm"))):
		return "Humor desconhecido."
	for key in ["attributes", "inventory", "relationships"]:
		for value in p.get(key, {}).values():
			if not _number(value) or value < 0:
				return "Valor inválido: " + key
	for key in ["energy", "money"]:
		if not _number(p.get(key, 0)):
			return "Estado do personagem inválido."
	for key in ["name", "skin", "hair"]:
		if not p.get(key, "") is String:
			return "Aparência inválida."
	return ""

func _number(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))
