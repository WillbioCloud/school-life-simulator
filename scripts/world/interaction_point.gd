class_name InteractionPoint
extends Node3D
var title: String = "Examinar"
var action: String = "inspect"
var payload: Dictionary = {}
var radius: float = 2.3

func _ready() -> void:
	add_to_group("interactables")

static func create(parent: Node3D, pos: Vector3, label: String, verb: String, data: Dictionary = {}) -> InteractionPoint:
	var point := InteractionPoint.new()
	point.position = pos
	point.title = label
	point.action = verb
	point.payload = data
	parent.add_child(point)
	return point
