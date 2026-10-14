class_name NPCManager
extends Node3D
var definitions: Array = []
var actors: Dictionary = {}
var active_entries: Dictionary = {}
var scene_id: String = ""

func _ready() -> void:
	definitions = JSON.parse_string(FileAccess.get_file_as_string("res://data/npcs.json"))
	GameTime.changed.connect(sync)

func definition(id: String) -> Dictionary:
	for data in definitions:
		if data.id == id:
			return data
	return {}

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
