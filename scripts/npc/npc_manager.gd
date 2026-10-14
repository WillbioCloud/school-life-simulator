class_name NPCManager
extends Node3D
## Loads character sheets (data/characters/*.json, seção 61.2) and places actors by routine.
## Routine points may be coordinates or "seat:B2", resolved through the seat map (seção 50.3).
var definitions: Array = []
var actors: Dictionary = {}
var active_entries: Dictionary = {}
var scene_id: String = ""

func _ready() -> void:
	definitions = load_definitions()
	GameTime.changed.connect(sync)

static func load_definitions() -> Array:
	var result: Array = []
	var index: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/characters/index.json"))
	for id in index:
		var path := "res://data/characters/%s.json" % id
		if not FileAccess.file_exists(path):
			push_warning("Ficha de personagem ausente: " + path)
			continue
		var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
		for entry in data.get("routine", []):
			_resolve_point(entry)
		if data.has("weekend"):
			_resolve_point(data.weekend)
		result.append(data)
	return result

static func _resolve_point(entry: Dictionary) -> void:
	if entry.get("point") is String and str(entry.point).begins_with("seat:"):
		var seat := str(entry.point).trim_prefix("seat:")
		var pos := SeatMap.chair_position(seat)
		entry.seat = seat
		entry.point = [pos.x, 0, pos.z]
		entry.seated = true

func definition(id: String) -> Dictionary:
	for data in definitions:
		if data.id == id:
			return data
	return {}

func display_name(id: String) -> String:
	var data := definition(id)
	if data.is_empty():
		return str(Timetable.subject("english").get("teacher_name", id)) if id == "hill" else id.capitalize()
	return str(data.name)

func logical_entry(data: Dictionary) -> Dictionary:
	if not GameTime.is_school_day():
		if GameTime.minute >= 1080:
			return {"scene":"offscreen","point":[0,0,0],"activity":"Em casa"}
		return data.weekend
	var current: Dictionary = data.routine[0]
	for entry in data.routine:
		if GameTime.minute >= int(entry.start):
			current = entry
	return current

## Student ids whose routine places them in the classroom right now.
func students_in_classroom() -> Array:
	var result: Array = []
	for data in definitions:
		if str(data.get("class", "")) == "1-A" and str(logical_entry(data).scene) == "classroom":
			result.append(str(data.id))
	return result

func set_region(id: String) -> void:
	for actor in actors.values():
		remove_child(actor)
		actor.queue_free()
	actors.clear()
	active_entries.clear()
	scene_id = id
	sync()

func sync() -> void:
	for data in definitions:
		var id: String = data.id
		var entry := logical_entry(data)
		if entry.scene != scene_id:
			if actors.has(id):
				remove_child(actors[id])
				actors[id].queue_free()
				actors.erase(id)
				active_entries.erase(id)
			continue
		if active_entries.get(id,{}) == entry:
			continue
		var pos := Vector3(entry.point[0],0.1,entry.point[2])
		var actor: NPCActor
		if actors.has(id):
			actor = actors[id]
			pos = actor.position
		else:
			actor = NPCActor.new()
			actor.data = data
			add_child(actor)
			actors[id] = actor
		actor.set_routine(entry,pos)
		active_entries[id] = entry
