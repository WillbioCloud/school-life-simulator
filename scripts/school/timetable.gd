class_name Timetable
extends RefCounted
## Weekly timetable of class 1-A (seção 46.2). Period times stay in data/schedule.json;
## the subject of each slot depends on the weekday (data/timetable.json).
static var subjects: Dictionary = {}
static var order: Array = []
static var weekdays: Array = []

static func load_data() -> void:
	if not subjects.is_empty():
		return
	for data in JSON.parse_string(FileAccess.get_file_as_string("res://data/subjects.json")):
		subjects[data.id] = data
		order.append(data.id)
	weekdays = JSON.parse_string(FileAccess.get_file_as_string("res://data/timetable.json")).weekdays

static func subject(id: String) -> Dictionary:
	load_data()
	return subjects.get(id, {})

static func subject_name(id: String) -> String:
	var data := subject(id)
	return str(data.get("name", id)) if not data.is_empty() else id

## weekday 0 = Monday … 4 = Friday; slot 1..6.
static func subject_for(weekday: int, slot: int) -> String:
	load_data()
	if weekday < 0 or weekday >= weekdays.size():
		return ""
	var row: Array = weekdays[weekday]
	if slot < 1 or slot > row.size():
		return ""
	return str(row[slot - 1])

## The eight graded subjects, in curriculum order (no Hora da Turma / Estudo dirigido).
static func core_subjects() -> Array:
	load_data()
	var result: Array = []
	for id in order:
		if not subjects[id].has("special"):
			result.append(id)
	return result

static func teacher_name(subject_id: String) -> String:
	return str(subject(subject_id).get("teacher_name", "Professor Sato"))

static func teacher_id(subject_id: String) -> String:
	return str(subject(subject_id).get("teacher", "sato"))

## Occurrences of each subject across the week, for validation (seção 61.6).
static func weekly_counts() -> Dictionary:
	load_data()
	var counts: Dictionary = {}
	for row in weekdays:
		for id in row:
			counts[id] = int(counts.get(id, 0)) + 1
	return counts
