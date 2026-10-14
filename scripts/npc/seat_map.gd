class_name SeatMap
extends RefCounted
## Seat map of class 1-A (data/classrooms/1a.json, seção 50). Seats are "C2"-style ids:
## a column letter (A by the window … D by the door) and a row number (1 = front).
static var data: Dictionary = {}

static func load_data() -> void:
	if data.is_empty():
		data = JSON.parse_string(FileAccess.get_file_as_string("res://data/classrooms/1a.json"))

static func term_key() -> String:
	# Term 1 is the only authored map so far (April–July); later terms use the same map until 0.6.
	return "1"

static func assignments() -> Dictionary:
	load_data()
	return data.terms.get(term_key(), {})

static func player_seat() -> String:
	load_data()
	return str(data.player_seat)

static func occupant(seat: String) -> String:
	return str(assignments().get(seat, ""))

static func seat_of(npc_id: String) -> String:
	for seat in assignments():
		if str(assignments()[seat]) == npc_id:
			return str(seat)
	return ""

static func valid(seat: String) -> bool:
	load_data()
	return seat.length() == 2 and data.columns.has(seat[0]) and data.rows.has(seat[1])

## Desk position in the classroom scene (the chair is chair_offset further back, +z).
static func desk_position(seat: String) -> Vector3:
	load_data()
	if not valid(seat):
		return Vector3.ZERO
	return Vector3(float(data.columns[seat[0]]), 0.0, float(data.rows[seat[1]]))

static func chair_position(seat: String) -> Vector3:
	load_data()
	return desk_position(seat) + Vector3(0, 0, float(data.get("chair_offset", 0.9)))

static func all_seats() -> Array:
	load_data()
	var seats: Array = []
	for row in data.rows:
		for column in data.columns:
			seats.append(str(column) + str(row))
	return seats

static func _shift(seat: String, column_delta: int, row_delta: int) -> String:
	load_data()
	var columns: Array = data.columns.keys()
	var rows: Array = data.rows.keys()
	var column_index := columns.find(seat[0]) + column_delta
	var row_index := rows.find(seat[1]) + row_delta
	if column_index < 0 or column_index >= columns.size() or row_index < 0 or row_index >= rows.size():
		return ""
	return str(columns[column_index]) + str(rows[row_index])

## Adjacent seats of a seat: left/right share the row, front/back share the column.
static func adjacent(seat: String) -> Dictionary:
	return {"left": _shift(seat, -1, 0), "right": _shift(seat, 1, 0), "front": _shift(seat, 0, -1), "back": _shift(seat, 0, 1)}

## Neighbours of the protagonist by direction → npc id ("" when the seat is empty).
static func neighbors_of_player() -> Dictionary:
	var result: Dictionary = {}
	var around := adjacent(player_seat())
	for direction in around:
		result[direction] = occupant(str(around[direction])) if not str(around[direction]).is_empty() else ""
	return result

static func direction_label(direction: String) -> String:
	return {"left": "à esquerda", "right": "à direita", "front": "na frente", "back": "atrás"}.get(direction, direction)
