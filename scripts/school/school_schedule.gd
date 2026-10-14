class_name SchoolSchedule
extends RefCounted
## Fixed daily period slots (data/schedule.json) resolved against the weekly timetable.
static var periods: Array = []

static func load_data() -> void:
	if periods.is_empty():
		periods = JSON.parse_string(FileAccess.get_file_as_string("res://data/schedule.json"))

## Copies a raw slot and fills subject, title, teacher and attribute for the current weekday.
static func resolve(period: Dictionary, weekday: int = (GameTime.day - 1) % 7) -> Dictionary:
	var result: Dictionary = period.duplicate(true)
	if str(period.get("kind", "")) == "class":
		var subject_id := Timetable.subject_for(weekday, int(period.get("slot", 0)))
		var subject := Timetable.subject(subject_id)
		result.subject = subject_id
		result.title = str(subject.get("name", period.title))
		result.attribute = str(subject.get("attribute", "Conhecimento"))
		result.teacher = str(subject.get("teacher_name", "Professor Sato"))
		result.theory = bool(subject.get("theory", false))
		result.special = str(subject.get("special", ""))
	else:
		result.subject = ""
		result.attribute = "Disciplina"
		result.teacher = "Professor Sato"
		result.theory = false
		result.special = ""
	return result

static func current_or_next(minute: int) -> Dictionary:
	load_data()
	if not GameTime.is_school_day():
		return {}
	for period in periods:
		if minute < int(period.end):
			return resolve(period)
	return {}

static func by_id(id: String) -> Dictionary:
	load_data()
	for period in periods:
		if str(period.id) == id:
			return resolve(period)
	return {}

## Every slot of the given weekday, resolved (used by the agenda and by tests).
static func day_periods(weekday: int = (GameTime.day - 1) % 7) -> Array:
	load_data()
	var result: Array = []
	for period in periods:
		result.append(resolve(period, weekday))
	return result

static func next_label() -> String:
	var period := current_or_next(GameTime.minute)
	if period.is_empty():
		return "Tempo livre · explore no seu ritmo"
	if GameTime.minute >= int(period.start):
		return "%s · até %s" % [period.title, GameTime.clock(int(period.end))]
	return "%s · %s" % [period.title, GameTime.clock(int(period.start))]

static func attendance_key(period: Dictionary) -> String:
	return GameTime.stamp() + ":" + str(period.id)

static func attended(period: Dictionary) -> bool:
	return GameState.attendance.has(attendance_key(period))

## Interactive windows already used today (Intensidade das aulas: Normal = 3 por dia).
static func windows_today() -> int:
	var total := 0
	var prefix := GameTime.stamp() + ":"
	for key in GameState.attendance:
		if str(key).begins_with(prefix):
			total += int(GameState.attendance[key].get("windows", 0))
	return total

static func interactive_today() -> bool:
	return windows_today() > 0
