extends Node
## Compressed Japanese school calendar. April starts school year 1.
signal changed
signal new_day
signal bedtime
const MONTHS := ["JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ"]
const WEEKDAYS := ["SEG", "TER", "QUA", "QUI", "SEX", "SÁB", "DOM"]
var year: int = 1
var month: int = 4
var day: int = 1
var minute: int = 390
var paused: bool = true
var accumulator: float = 0.0

func _process(delta: float) -> void:
	if paused:
		return
	accumulator += delta
	if accumulator >= 1.0:
		var steps := int(accumulator)
		accumulator -= steps
		advance(steps)

func reset() -> void:
	year = 1
	month = 4
	day = 1
	minute = 390
	accumulator = 0.0
	changed.emit()

func advance(minutes: int) -> void:
	minute = mini(minute + maxi(minutes, 0), 1440)
	changed.emit()
	if minute == 1440:
		paused = true
		bedtime.emit()

func sleep() -> void:
	day += 1
	if day > 14:
		day = 1
		month = month % 12 + 1
		if month == 4:
			year += 1
	minute = 390
	accumulator = 0.0
	new_day.emit()
	changed.emit()

func is_school_day() -> bool:
	return (day - 1) % 7 < 5

func stamp() -> String:
	return "%d-%02d-%02d" % [year, month, day]

func clock(value: int = -1) -> String:
	var m := minute if value < 0 else value
	return "%02d:%02d" % [m / 60, m % 60]

func date_label() -> String:
	return "%s  ·  %02d %s" % [WEEKDAYS[(day - 1) % 7], day, MONTHS[month - 1]]

func season() -> String:
	if month >= 3 and month <= 5:
		return "Primavera"
	if month >= 6 and month <= 8:
		return "Verão"
	if month >= 9 and month <= 11:
		return "Outono"
	return "Inverno"

func serialize() -> Dictionary:
	return {"year": year, "month": month, "day": day, "minute": minute}

func restore(data: Dictionary) -> void:
	year = int(data.year)
	month = int(data.month)
	day = int(data.day)
	minute = int(data.minute)
	accumulator = 0.0
	changed.emit()
