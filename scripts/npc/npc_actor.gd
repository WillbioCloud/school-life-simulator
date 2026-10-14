class_name NPCActor
extends CharacterBody3D
var data: Dictionary
var activity: String = ""
var visual: CharacterVisual
var point: InteractionPoint
var route: Array[Vector3] = []
var patrol: bool = false
var route_index: int = 0
var talking: bool = false
var seated_target: bool = false
var seated: bool = false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	var shape := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.27
	capsule.height = 1.8
	shape.position.y = 0.9
	shape.shape = capsule
	add_child(shape)
	visual = CharacterVisual.new()
	add_child(visual)
	visual.build(Color(data.skin),Color(data.hair),Color(data.coat),data.style)
	point = InteractionPoint.create(self,Vector3.ZERO,"Conversar · " + str(data.name),"npc",{"id":data.id})
	point.radius = 2.4
	var label := Geo.text(self,Vector3(0,2.65,0),data.name.split(" ")[0],21,Color("fcf4dd"))
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = false

func set_routine(entry: Dictionary, start_pos: Vector3) -> void:
	position = start_pos
	activity = str(entry.activity)
	patrol = entry.has("patrol")
	seated_target = bool(entry.get("seated", false))
	_set_seated(false)
	route.clear()
	route_index = 0
	var points: Array = entry.get("patrol",entry.get("via",[])).duplicate()
	if not patrol:
		points.append(entry.point)
	for p in points:
		route.append(Vector3(p[0],0.05,p[2]))
	# Spawning directly on a chair: sit at once instead of walking into the desk.
	if seated_target and start_pos.distance_to(route[route.size()-1]) < 0.3:
		_set_seated(true)

## Seated actors ignore chair collisions and face the board (seção 46.9).
func _set_seated(value: bool) -> void:
	if seated == value:
		return
	seated = value
	collision_mask = 0 if value else 1
	if is_instance_valid(visual):
		visual.set_seated(value)
		if value:
			visual.rotation.y = 0

func _physics_process(delta: float) -> void:
	if GameTime.paused or talking or route.is_empty() or seated:
		if is_instance_valid(visual):
			visual.animate(delta,0)
		return
	var goal: Vector3 = route[route_index]
	var direction := goal-position
	direction.y = 0
	if direction.length() < 0.28:
		if patrol:
			route_index = (route_index+1)%route.size()
		elif route_index < route.size()-1:
			route_index += 1
		elif seated_target:
			position = Vector3(goal.x, position.y, goal.z)
			_set_seated(true)
		velocity.x = 0
		velocity.z = 0
	else:
		var move := direction.normalized()* (2.7 if patrol else 1.9)
		velocity.x = move.x
		velocity.z = move.z
		visual.rotation.y = lerp_angle(visual.rotation.y,atan2(-move.x,-move.z),1-exp(-delta*8))
	velocity.y = 0 if is_on_floor() else velocity.y-delta*20
	move_and_slide()
	visual.animate(delta,Vector2(velocity.x,velocity.z).length())
