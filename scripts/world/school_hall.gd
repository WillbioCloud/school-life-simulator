extends Node3D
var spawns := {"outside": Vector3(0,0.1,2.6), "classroom": Vector3(4,0.1,-2.5)}
func _ready() -> void:
	Geo.floor_room(self,Vector2(18,11),Color("d7c4a0"))
	Geo.box(self,Vector3(0,0.03,2.9),Vector3(16,0.03,3),Color("b0c1b1"))
	for x in [-7,-6,-5,-4,-3,-2]:
		Geo.box(self,Vector3(x,1.05,-4.5),Vector3(0.9,2.1,0.8),Color("a7bbb1"),true)
		for y in [0.35,1.05,1.75]:
			Geo.box(self,Vector3(x,y,-4.06),Vector3(0.82,0.65,0.06),Color("bdcabe"))
			Geo.box(self,Vector3(x+0.22,y,-4),Vector3(0.09,0.04,0.025),Color("718d85"))
	Geo.doorway(self,Vector3(4,0,-5.3),"SALA 1-A", "classroom", "hall")
	Geo.box(self,Vector3(0,2.1,-5.32),Vector3(2,1.5,0.12),Color("bda37a"))
	for x in [-0.5,0.4]:
		Geo.box(self,Vector3(x,2.1,-5.22),Vector3(0.65,0.95,0.04),Color("f3ead1"))
	InteractionPoint.create(self,Vector3(0,0,-3.7),"Ler · quadro de avisos","calendar")
	# Exit is a floor portal in the cutaway wall, with a clear marker.
	Geo.box(self,Vector3(0,0.06,4.3),Vector3(2.8,0.05,1.5),Color("62887c"))
	Geo.text(self,Vector3(0,0.13,4.3),"SAÍDA",24).rotation_degrees.x = -90
	InteractionPoint.create(self,Vector3(0,0,4.1),"Sair · bairro residencial","door",{"scene":"neighborhood","spawn":"school"})
	Geo.plant(self,Vector3(8,0,-4.5))
	Geo.plant(self,Vector3(-8,0,4.2))
	Geo.text(self,Vector3(-4.5,2.9,-4.2),"ARMÁRIOS DE SAPATOS",21,Color("58766b"))
	Geo.text(self,Vector3(4,3.3,-5.25),"1º ANO   /   PRIMEIRO ANDAR",21,Color("58766b"))
