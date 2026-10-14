class_name SchoolSchedule
extends RefCounted
static var periods: Array = []

static func load_data() -> void:
	if periods.is_empty():
		periods = JSON.parse_string(FileAccess.get_file_as_string("res://data/schedule.json"))

static func current_or_next(minute: int) -> Dictionary:
	load_data()
	if not GameTime.is_school_day():
		return {}
	for period in periods:
		if minute < int(period.end):
			return period
	return {}

static func next_label() -> String:
	var period := current_or_next(GameTime.minute)
	if period.is_empty():
		return "Tempo livre · explore no seu ritmo"
	if GameTime.minute >= period.start:
		return "%s · até %s" % [period.title, GameTime.clock(period.end)]
	return "%s · %s" % [period.title, GameTime.clock(period.start)]

static func attend(choice: String) -> String:
	var period := current_or_next(GameTime.minute)
	if period.is_empty() or GameTime.minute < period.start:
		return "A atividade ainda não começou."
	var key := GameTime.stamp() + ":" + str(period.id)
	if GameState.attendance.has(key):
		return "Você já participou desta atividade."
	if not GameState.spend_energy(5):
		return "Energia insuficiente. Descanse ou coma um onigiri."
	var late: bool = GameTime.minute > int(period.start) + 5
	GameState.attendance[key] = {"late": late, "choice": choice, "subject": period.subject}
	GameState.improve(str(period.subject), 2)
	if choice == "help":
		GameState.improve("Empatia", 2)
	else:
		GameState.improve("Disciplina", 1)
	GameState.mark("class")
	GameTime.advance(int(period.end) - GameTime.minute)
	return "%s concluído. +2 %s%s\n%s" % [period.title, period.subject,
		" · +2 Empatia" if choice == "help" else " · +1 Disciplina",
		"Chegada tardia registrada, sem penalidade permanente." if late else "Participação registrada. Seu primeiro passo conta!"]
