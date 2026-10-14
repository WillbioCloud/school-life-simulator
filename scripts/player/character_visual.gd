class_name CharacterVisual
extends Node3D
var left_leg: Node3D
var right_leg: Node3D
var left_arm: Node3D
var right_arm: Node3D
var pace: float = 0.0
var body: Node3D
var seated: bool = false

func build(skin: Color, hair: Color, coat: Color, style: String = "student") -> void:
	body = Node3D.new()
	add_child(body)
	Geo.box(body,Vector3(0,1.06,0),Vector3(0.57,0.62,0.31),coat)
	Geo.box(body,Vector3(0,1.35,-0.17),Vector3(0.28,0.13,0.04),Color("f2eddd"))
	Geo.box(body,Vector3(0,1.15,-0.19),Vector3(0.08,0.3,0.03),Color("ba7168"))
	Geo.sphere(body,Vector3(0,1.7,0),Vector3(0.55,0.36,0.52),skin)
	Geo.sphere(body,Vector3(0,1.88,0.05),Vector3(0.61,0.21,0.57),hair)
	Geo.box(body,Vector3(0.16,1.75,0.11),Vector3(0.25,0.35,0.35),hair)
	Geo.box(body,Vector3(-0.16,1.89,-0.18),Vector3(0.26,0.18,0.12),hair)
	for x in [-0.11,0.11]:
		Geo.box(body,Vector3(x,1.7,-0.249),Vector3(0.055,0.07,0.027),Color("333945"))
	if style == "teacher":
		for x in [-0.11,0.11]:
			Geo.box(body,Vector3(x,1.72,-0.27),Vector3(0.16,0.025,0.025),Color("303e43"))
		body.scale.y = 1.1
	elif style == "student":
		Geo.box(body,Vector3(0,1.04,0.24),Vector3(0.45,0.48,0.22),Color("b28161"))
		Geo.box(body,Vector3(0,1.12,0.365),Vector3(0.25,0.16,0.03),Color("ceaa7c"))
	elif style == "runner":
		Geo.box(body,Vector3(0,1.2,-0.18),Vector3(0.48,0.06,0.03),Color("f5e9d4"))
	left_leg = _limb(Vector3(-0.15,0.75,0),Vector3(0.19,0.64,0.22),Color("344354"))
	right_leg = _limb(Vector3(0.15,0.75,0),Vector3(0.19,0.64,0.22),Color("344354"))
	left_arm = _limb(Vector3(-0.37,1.3,0),Vector3(0.16,0.5,0.19),coat)
	right_arm = _limb(Vector3(0.37,1.3,0),Vector3(0.16,0.5,0.19),coat)
	for limb in [left_leg,right_leg]:
		Geo.box(limb,Vector3(0,-0.65,-0.06),Vector3(0.23,0.14,0.37),Color("323d43"))
	for limb in [left_arm,right_arm]:
		Geo.sphere(limb,Vector3(0,-0.53,0),Vector3(0.17,0.13,0.18),skin)

func _limb(pos: Vector3, size: Vector3, color: Color) -> Node3D:
	var pivot := Node3D.new()
	pivot.position = pos
	body.add_child(pivot)
	Geo.box(pivot,Vector3(0,-size.y/2,0),size,color)
	return pivot

## Simple seated pose for classroom NPCs: knees forward, body lowered to chair height.
func set_seated(value: bool) -> void:
	seated = value
	if not is_instance_valid(body):
		return
	if seated:
		left_leg.rotation.x = 1.45
		right_leg.rotation.x = 1.45
		left_arm.rotation.x = 0.9
		right_arm.rotation.x = 0.9
		body.position.y = -0.3
	else:
		left_arm.rotation.x = 0
		right_arm.rotation.x = 0
		body.position.y = 0

func animate(delta: float, speed: float) -> void:
	if seated:
		return
	pace += delta * (8.0 if speed < 4.5 else 12.0)
	var amount := minf(speed / 5.0, 1.0) * 0.65
	left_leg.rotation.x = sin(pace) * amount
	right_leg.rotation.x = -sin(pace) * amount
	left_arm.rotation.x = -sin(pace) * amount * 0.7
	right_arm.rotation.x = sin(pace) * amount * 0.7
	body.position.y = absf(sin(pace)) * amount * 0.07
