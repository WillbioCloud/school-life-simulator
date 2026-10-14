class_name Geo
extends RefCounted
## Original low-poly prototype kit. No downloaded third-party art.
static var materials: Dictionary = {}

static func mat(color: Color) -> StandardMaterial3D:
	var key := color.to_html()
	if materials.has(key):
		return materials[key]
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.86
	materials[key] = m
	return m

static func box(parent: Node3D, pos: Vector3, size: Vector3, color: Color, collision: bool = false) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.material_override = mat(color)
	instance.position = pos
	parent.add_child(instance)
	if collision:
		var body := StaticBody3D.new()
		var shape := CollisionShape3D.new()
		var box_shape := BoxShape3D.new()
		box_shape.size = size
		shape.shape = box_shape
		body.add_child(shape)
		instance.add_child(body)
	return instance

static func cylinder(parent: Node3D, pos: Vector3, radius: float, height: float, color: Color, top: float = -1.0) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.bottom_radius = radius
	mesh.top_radius = radius if top < 0 else top
	mesh.height = height
	mesh.radial_segments = 10
	var item := MeshInstance3D.new()
	item.mesh = mesh
	item.material_override = mat(color)
	item.position = pos
	parent.add_child(item)
	return item

static func sphere(parent: Node3D, pos: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
	var mesh := SphereMesh.new()
	mesh.radial_segments = 12
	mesh.rings = 6
	var item := MeshInstance3D.new()
	item.mesh = mesh
	item.scale = size
	item.position = pos
	item.material_override = mat(color)
	parent.add_child(item)
	return item

static func text(parent: Node3D, pos: Vector3, value: String, size: int = 38, color: Color = Color("f5f1df")) -> Label3D:
	var label := Label3D.new()
	label.text = value
	label.font_size = size
	label.pixel_size = 0.012
	label.modulate = color
	label.outline_size = 2
	label.outline_modulate = Color("344c48")
	label.position = pos
	parent.add_child(label)
	return label

static func floor_room(parent: Node3D, size: Vector2, floor_color: Color = Color("c7a982")) -> void:
	box(parent, Vector3(0,-0.2,0), Vector3(size.x,0.4,size.y), floor_color, true)
	# Deliberate dollhouse cutaway: front/sides remain visually open, not physically open.
	box(parent, Vector3(0,1.65,-size.y/2), Vector3(size.x,3.3,0.22), Color("eee6d4"), true)
	box(parent, Vector3(-size.x/2,0.22,0), Vector3(0.22,0.44,size.y), Color("e0d1b7"), true)
	box(parent, Vector3(size.x/2,0.22,0), Vector3(0.22,0.44,size.y), Color("e0d1b7"), true)
	box(parent, Vector3(0,0.22,size.y/2), Vector3(size.x,0.44,0.22), Color("e0d1b7"), true)
	for x in range(-int(size.x/2)+1, int(size.x/2)):
		box(parent, Vector3(x,0.012,0), Vector3(0.015,0.008,size.y-0.2), Color("b99a74"))
	box(parent, Vector3(0,0.12,-size.y/2+0.15), Vector3(size.x,0.22,0.15), Color("947c66"))

static func doorway(parent: Node3D, pos: Vector3, label: String, target: String, spawn: String) -> void:
	box(parent, pos + Vector3(0,1.25,0), Vector3(1.65,2.5,0.14), Color("607d78"))
	box(parent, pos + Vector3(0,1.7,0.1), Vector3(1.35,0.75,0.05), Color("b4cdc4"))
	box(parent, pos + Vector3(0.5,1,0.16), Vector3(0.12,0.12,0.08), Color("efc879"))
	text(parent, pos + Vector3(0,2.85,0.1), label, 27)
	InteractionPoint.create(parent, pos + Vector3(0,0,1), "Abrir · " + label, "door", {"scene": target, "spawn": spawn})

static func plant(parent: Node3D, pos: Vector3) -> void:
	cylinder(parent, pos + Vector3(0,0.23,0),0.32,0.46,Color("c88466"),0.42)
	sphere(parent,pos+Vector3(0,0.85,0),Vector3(1.1,0.75,1.1),Color("719072"))

static func desk(parent: Node3D, pos: Vector3, marked: bool = false) -> void:
	box(parent,pos+Vector3(0,0.9,0),Vector3(1.25,0.12,0.8),Color("d4b381"),true)
	for x in [-0.46,0.46]:
		for z in [-0.27,0.27]:
			box(parent,pos+Vector3(x,0.43,z),Vector3(0.07,0.86,0.07),Color("657776"))
	box(parent,pos+Vector3(0,0.46,0.9),Vector3(0.65,0.1,0.55),Color("c39a66"),true)
	box(parent,pos+Vector3(0,0.8,1.14),Vector3(0.65,0.55,0.07),Color("c39a66"))
	for x in [-0.24,0.24]:
		box(parent,pos+Vector3(x,0.22,0.85),Vector3(0.06,0.44,0.06),Color("657776"))
	box(parent,pos+Vector3(0.12,1,0),Vector3(0.48,0.05,0.35),Color("e9e8d7"))
	if marked:
		var marker := cylinder(parent,pos+Vector3(0,0.03,1.8),0.6,0.035,Color("8ebcb0"))
		marker.name = "MyDeskMarker"
		text(parent,pos+Vector3(0,1.6,0),"SUA CARTEIRA",18,Color("355f55"))
