extends Node
signal changed
signal notice(text: String)
const SCENES := ["bedroom", "home", "neighborhood", "school_hall", "classroom"]
const DEFAULT_STATS := {"Conhecimento": 15, "Carisma": 5, "Condicionamento": 3, "Criatividade": 5, "Disciplina": 10, "Empatia": 5}
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
var camera_perspective: bool = false
var shadows: bool = true

func reset(character_name: String = "Haru", skin_color: String = "efbd98", hair_color: String = "393940") -> void:
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
	changed.emit()

func mark(flag: String) -> void:
	flags[flag] = true
	changed.emit()

func improve(attribute: String, amount: int) -> void:
	attributes[attribute] = mini(int(attributes.get(attribute, 0)) + amount, 100)
	changed.emit()

func spend_energy(amount: float) -> bool:
	if energy < amount:
		notice.emit("Que tal descansar ou comer um onigiri primeiro?")
		return false
	energy = maxf(0, energy - amount)
	changed.emit()
	return true

func objective() -> String:
	if not flags.has("home"):
		return "Um novo começo\nExplore a casa da sua avó."
	if not flags.has("school_hall"):
		return "O caminho das cerejeiras\nSiga a rua ao norte até a escola."
	if not flags.has("talk"):
		return "Um rosto conhecido\nConverse com alguém na escola."
	if not flags.has("class"):
		return "Seu lugar na turma 1-A\nParticipe de uma atividade na sua carteira."
	if not flags.has("slept"):
		return "Leve o dia com você\nVolte ao quarto e durma."
	return "Um dia de cada vez\nEscolha como viver sua próxima manhã."

func serialize() -> Dictionary:
	return {"name": player_name, "skin": skin, "hair": hair, "scene": scene_id,
		"position": [player_position.x, player_position.y, player_position.z],
		"energy": energy, "money": money, "attributes": attributes.duplicate(true),
		"inventory": inventory.duplicate(true), "relationships": relationships.duplicate(true),
		"talked": talked.duplicate(true), "attendance": attendance.duplicate(true), "flags": flags.duplicate(true)}

func restore(data: Dictionary) -> void:
	reset(str(data.get("name", "Haru")), str(data.get("skin", "efbd98")), str(data.get("hair", "393940")))
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
	changed.emit()
