extends Node3D
var spawns := {"start": Vector3(0,0.1,2), "home": Vector3(2.5,0.1,-2.8)}
func _ready() -> void:
	Geo.floor_room(self,Vector2(10,10))
	# Bed, quilt, pillow and bedside lamp.
	Geo.box(self,Vector3(-3,0.36,-1),Vector3(2.1,0.7,3.6),Color("a68666"),true)
	Geo.box(self,Vector3(-3,0.83,-1),Vector3(2,0.3,3.5),Color("f1e8d1"))
	Geo.box(self,Vector3(-3,1,-0.45),Vector3(2.02,0.13,2.3),Color("7b9e95"))
	for z in [-1.2,-0.75,-0.3,0.15,0.6]:
		Geo.box(self,Vector3(-3,1.08,z),Vector3(2.02,0.018,0.035),Color("b3c7b2"))
	Geo.box(self,Vector3(-3,1.04,-2.15),Vector3(1.45,0.22,0.62),Color("f7efdb"))
	Geo.box(self,Vector3(-3,0.9,-2.85),Vector3(2.2,1.8,0.15),Color("a38565"))
	InteractionPoint.create(self,Vector3(-1.5,0,-0.4),"Dormir · começar um novo dia","sleep")
	Geo.box(self,Vector3(-4.3,0.45,-2.5),Vector3(0.8,0.9,0.85),Color("c0996c"),true)
	Geo.cylinder(self,Vector3(-4.3,1.13,-2.5),0.08,0.45,Color("8d8063"))
	Geo.cylinder(self,Vector3(-4.3,1.45,-2.5),0.34,0.4,Color("efd5a1"),0.22)
	Geo.box(self,Vector3(0,0.035,1.6),Vector3(4.7,0.045,3.7),Color("aebaa0"))
	Geo.box(self,Vector3(0,0.062,1.6),Vector3(4.2,0.018,3.2),Color("bfc8ab"))
	Geo.desk(self,Vector3(-0.7,0,-3.5))
	InteractionPoint.create(self,Vector3(-0.7,0,-2),"Estudar · 60 min","study")
	Geo.box(self,Vector3(-0.7,1.1,-3.7),Vector3(0.55,0.35,0.08),Color("496966"))
	Geo.box(self,Vector3(-0.7,1.1,-3.64),Vector3(0.45,0.26,0.02),Color("93b2a7"))
	Geo.box(self,Vector3(-2,2.1,-4.86),Vector3(2.7,1.4,0.09),Color("789b9b"))
	for x in [-3.5,-0.5]:
		Geo.box(self,Vector3(x,2.1,-4.7),Vector3(0.4,1.8,0.13),Color("e0c5a1"))
	Geo.box(self,Vector3(4,1.2,-1.6),Vector3(1.4,2.4,2.2),Color("b89772"),true)
	Geo.box(self,Vector3(3.26,1.2,-1.6),Vector3(0.03,2.1,0.045),Color("826b54"))
	Geo.plant(self,Vector3(3.8,0,3.8))
	Geo.box(self,Vector3(1,2.35,-4.8),Vector3(0.8,1.1,0.05),Color("f6ecd4"))
	Geo.text(self,Vector3(1,2.35,-4.7),"ABR\n01",21,Color("57746c"))
	InteractionPoint.create(self,Vector3(1,0,-3.5),"Consultar calendário","calendar")
	Geo.doorway(self,Vector3(3,0,-4.85),"SALA", "home", "bedroom")
	Geo.text(self,Vector3(-3,2.5,-2.8),"seu novo cantinho",20,Color("547068"))
