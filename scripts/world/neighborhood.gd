extends Node3D
var spawns := {"home": Vector3(10,0.1,15), "school": Vector3(0,0.1,-23), "start": Vector3(10,0.1,15)}

func _ready() -> void:
	Geo.box(self,Vector3(0,-0.4,0),Vector3(48,0.8,72),Color("9cae85"),true)
	Geo.box(self,Vector3(0,0.015,0),Vector3(7,0.06,61),Color("88918b"))
	for x in [-4.4,4.4]:
		Geo.box(self,Vector3(x,0.1,0),Vector3(1.75,0.22,61),Color("d9d5bd"))
		Geo.box(self,Vector3(x-signf(x)*0.78,0.22,0),Vector3(0.12,0.12,61),Color("eee7d2"))
	for z in range(-24,29,6):
		Geo.box(self,Vector3(0,0.06,z),Vector3(0.1,0.015,2),Color("dddaca"))
	# Residential side street makes a connected loop around the little park.
	Geo.box(self,Vector3(0,0.06,22),Vector3(35,0.1,4),Color("92998f"))
	Geo.box(self,Vector3(-16,0.06,8),Vector3(3.4,0.1,29),Color("a6ac9a"))
	Geo.box(self,Vector3(-9,0.07,-5),Vector3(18,0.1,3),Color("a6ac9a"))
	for x in range(-3,4):
		Geo.box(self,Vector3(x,0.13,21),Vector3(0.58,0.02,2.8),Color("eee8d4"))
	Geo.box(self,Vector3(8.5,0.15,14),Vector3(7.5,0.18,2.3),Color("d3c9ad"))
	_house(Vector3(12,0,8.5),Vector3(10,5.3,8),Color("e4cfab"),Color("527c7b"),"Casa da avó")
	Geo.doorway(self,Vector3(10,0.15,12.6),"CASA", "home", "outside")
	_house(Vector3(12,0,-7),Vector3(10,4.7,8),Color("e5e0c9"),Color("677685"),"")
	_house(Vector3(-11,0,-14),Vector3(10,4.5,9),Color("d7bfa3"),Color("856c62"),"")
	_house(Vector3(-11,0,28),Vector3(10,4.5,6),Color("e8d8b8"),Color("667f78"),"")
	_house(Vector3(12,0,28),Vector3(10,4.5,6),Color("d9c8aa"),Color("9a7465"),"")
	_school()
	_park()
	# A small closed storefront: exterior only in this prototype.
	Geo.box(self,Vector3(-10,1.6,-3),Vector3(6,3.2,4),Color("e9dec6"),true)
	Geo.box(self,Vector3(-10,2.65,-0.65),Vector3(6.4,0.3,1.3),Color("658c7d"))
	Geo.box(self,Vector3(-10,1.35,-0.94),Vector3(4.8,1.9,0.06),Color("729d9b"))
	Geo.text(self,Vector3(-10,3.25,-0.85),"KOMOREBI",30)
	InteractionPoint.create(self,Vector3(-10,0,0.4),"Ler · aviso do café","inspect",{"title":"Café Komorebi","text":"O cheiro de café recém-passado escapa pela janela.\n\nInterior e trabalho de meio período planejados para uma próxima etapa. Por enquanto, é parte da vizinhança."})
	_vending(Vector3(5.6,0,19))
	for z in [-20,-9,2,18]:
		_tree(Vector3(-5.8,0,z))
		_tree(Vector3(6,0,z-2))
	for z in [-19,3,25]:
		_lamp(Vector3(4.8,0,z))
	for z in [-18,5,26]:
		_pole(Vector3(-4.9,0,z))
	for z in [7,10,13,16]:
		Geo.box(self,Vector3(17.6,0.55,z),Vector3(0.18,1.1,2.8),Color("d9d6bd"),true)
	Geo.text(self,Vector3(1.5,0.13,-14),"ESCOLA  ↑",28,Color("f2e8ce")).rotation_degrees.x = -90
	Geo.text(self,Vector3(1.5,0.13,17),"HOSHIKAWA",23,Color("e9e2cb")).rotation_degrees.x = -90
	# Unseen boundaries keep this technical slice finite.
	for x in [-23,23]:
		Geo.box(self,Vector3(x,1,0),Vector3(0.6,2,72),Color("7e946f"),true)
	Geo.box(self,Vector3(0,1,35),Vector3(46,2,0.6),Color("7e946f"),true)
	Geo.box(self,Vector3(0,1,-35),Vector3(46,2,0.6),Color("7e946f"),true)

func _house(pos: Vector3, size: Vector3, wall: Color, roof: Color, label: String) -> void:
	var root := Node3D.new()
	root.position = pos
	add_child(root)
	Geo.box(root,Vector3(0,size.y/2,0),size,wall)
	Geo.box(root,Vector3(0,0.25,0),Vector3(size.x+0.3,0.5,size.z+0.3),Color("b5b4a4"))
	Geo.box(root,Vector3(0,size.y*0.5,0),Vector3(size.x+0.12,0.15,size.z+0.1),Color("d3bea0"))
	var roof_mesh := MeshInstance3D.new()
	var prism := PrismMesh.new()
	prism.size = Vector3(size.x+1.2,2.1,size.z+1.2)
	roof_mesh.mesh = prism
	roof_mesh.material_override = Geo.mat(roof)
	roof_mesh.position.y = size.y+0.8
	root.add_child(roof_mesh)
	for x in [-size.x*0.29,size.x*0.29]:
		for y in [1.5,size.y-1.1]:
			Geo.box(root,Vector3(x,y,size.z/2+0.05),Vector3(1.8,1.3,0.12),Color("f6edda"))
			var window := Geo.box(root,Vector3(x,y,size.z/2+0.13),Vector3(1.55,1.09,0.05),Color("86b0ad"))
			window.add_to_group("windows")
			Geo.box(root,Vector3(x,y,size.z/2+0.17),Vector3(0.06,1.12,0.06),Color("f1e7ce"))
			Geo.box(root,Vector3(x,y,size.z/2+0.17),Vector3(1.55,0.06,0.06),Color("f1e7ce"))
	if not label.is_empty():
		Geo.text(root,Vector3(0,size.y+2.35,0),label,25)
	_occluder(root,size,Vector3(0,size.y/2,0))

func _occluder(root: Node3D, size: Vector3, center: Vector3) -> void:
	var body := StaticBody3D.new()
	body.collision_layer = 5
	var shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = size
	shape.shape = box_shape
	shape.position = center
	body.add_child(shape)
	root.add_child(body)
	body.set_meta("fade_root",root)
	root.add_to_group("occluders")
	var meshes: Array[MeshInstance3D] = []
	for child in root.get_children():
		if child is MeshInstance3D:
			child.material_override = child.material_override.duplicate()
			meshes.append(child)
	root.set_meta("fade_meshes",meshes)

func _school() -> void:
	Geo.box(self,Vector3(0,0.1,-27),Vector3(21,0.24,10),Color("dbd7c2"))
	_house(Vector3(0,0,-32),Vector3(22,6.6,8),Color("eee4ca"),Color("607978"),"")
	Geo.box(self,Vector3(0,4.4,-27.75),Vector3(10.5,1.1,0.18),Color("426961"))
	Geo.text(self,Vector3(0,4.4,-27.6),"ESCOLA HOSHIKAWA",33)
	Geo.doorway(self,Vector3(0,0.22,-27.7),"ENTRADA", "school_hall", "outside")
	for x in [-8.5,8.5]:
		Geo.box(self,Vector3(x,1.6,-23.5),Vector3(0.8,3.2,0.8),Color("c7c4ae"),true)
		_tree(Vector3(x+signf(x)*3,0,-22))
	Geo.box(self,Vector3(0,0.14,-24.5),Vector3(5,0.28,3),Color("e5dec5"))

func _park() -> void:
	Geo.box(self,Vector3(-10,0.07,11),Vector3(10,0.1,15),Color("b1bf8c"))
	Geo.box(self,Vector3(-8,0.14,12),Vector3(8,0.07,2.5),Color("dccdae"))
	for z in [7,16]:
		Geo.box(self,Vector3(-10,0.6,z),Vector3(3,0.18,0.85),Color("ad855f"),true)
		Geo.box(self,Vector3(-10,1.05,z+0.38),Vector3(3,0.75,0.12),Color("b89064"))
		for x in [-11,-9]:
			Geo.box(self,Vector3(x,0.27,z),Vector3(0.12,0.54,0.62),Color("4d6258"))
		InteractionPoint.create(self,Vector3(-10,0,z-1),"Sentar · descansar 30 min","rest")
	for x in [-13,-7]:
		_tree(Vector3(x,0,4))
		_tree(Vector3(x,0,18))
	Geo.plant(self,Vector3(-6,0,14))
	Geo.text(self,Vector3(-12,1.4,13),"PRAÇA DAS\nCEREJEIRAS",21)

func _tree(pos: Vector3) -> void:
	var root := Node3D.new()
	root.position = pos
	add_child(root)
	Geo.cylinder(root,Vector3(0,1.45,0),0.22,2.9,Color("8f7964"),0.16)
	var color := Color("eabbb2")
	if GameTime.season() == "Verão":
		color = Color("7ba778")
	elif GameTime.season() == "Outono":
		color = Color("c99769")
	elif GameTime.season() == "Inverno":
		color = Color("b8c8bb")
	Geo.sphere(root,Vector3(0,3.5,0),Vector3(3.6,1.35,3.3),color)
	Geo.sphere(root,Vector3(-0.8,3.2,0.5),Vector3(2.3,1,2.3),color.lightened(0.05))
	Geo.sphere(root,Vector3(0.9,3.8,-0.2),Vector3(2.5,1.1,2.5),color.lightened(0.09))
	_occluder(root,Vector3(0.48,2.8,0.48),Vector3(0,1.4,0))
	# Canopy also participates in camera occlusion, but not physical collisions.
	var canopy := StaticBody3D.new()
	canopy.collision_layer = 4
	canopy.collision_mask = 0
	var shape := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = 1.85
	shape.shape = sphere
	shape.position.y = 3.5
	canopy.add_child(shape)
	root.add_child(canopy)
	canopy.set_meta("fade_root",root)
	for i in range(7):
		var a := i * 2.39
		Geo.box(self,pos+Vector3(cos(a)*1.6,0.09,sin(a)*1.5),Vector3(0.14,0.015,0.1),color)

func _vending(pos: Vector3) -> void:
	Geo.box(self,pos+Vector3(0,1.15,0),Vector3(1.4,2.3,0.9),Color("ba6f61"),true)
	Geo.box(self,pos+Vector3(-0.15,1.45,0.47),Vector3(0.95,1.1,0.05),Color("dce1ce"))
	for x in [-0.45,-0.15,0.15]:
		for y in [1.1,1.5,1.8]:
			Geo.cylinder(self,pos+Vector3(x,y,0.55),0.08,0.22,Color("e6b665"))
	Geo.box(self,pos+Vector3(0,0.45,0.5),Vector3(0.75,0.25,0.05),Color("3c5354"))
	InteractionPoint.create(self,pos+Vector3(0,0,1.2),"Comprar · lanche ¥200","shop")

func _lamp(pos: Vector3) -> void:
	Geo.cylinder(self,pos+Vector3(0,1.8,0),0.065,3.6,Color("586c65"))
	Geo.box(self,pos+Vector3(0,3.65,0),Vector3(0.5,0.18,0.45),Color("eee3bd"))
	var light := OmniLight3D.new()
	light.position = pos+Vector3(0,3.3,0)
	light.light_color = Color("ffd9a0")
	light.omni_range = 7
	light.shadow_enabled = false
	light.add_to_group("night_lights")
	add_child(light)

func _pole(pos: Vector3) -> void:
	Geo.cylinder(self,pos+Vector3(0,3.3,0),0.09,6.6,Color("7d8074"))
	Geo.box(self,pos+Vector3(0,6,0),Vector3(1.5,0.12,0.14),Color("626d65"))
	if pos.z < 25:
		for x in [-0.5,0.5]:
			Geo.box(self,pos+Vector3(x,6.15,10),Vector3(0.025,0.025,20),Color("59675f"))
