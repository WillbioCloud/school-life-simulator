extends Node3D
var spawns := {"bedroom": Vector3(-4,0.1,-2.5), "outside": Vector3(4,0.1,-2.5)}
func _ready() -> void:
	Geo.floor_room(self,Vector2(14,11),Color("c5ae89"))
	Geo.doorway(self,Vector3(-4,0,-5.35),"QUARTO", "bedroom", "home")
	Geo.doorway(self,Vector3(4,0,-5.35),"RUA", "neighborhood", "home")
	Geo.box(self,Vector3(4,0.04,-3.7),Vector3(3.2,0.04,2.8),Color("b1b8ad"))
	Geo.box(self,Vector3(5.7,0.5,-3.4),Vector3(1,1,1.6),Color("af8d67"),true)
	Geo.box(self,Vector3(-3,0.04,1),Vector3(5,0.045,4.5),Color("b1ba91"))
	Geo.box(self,Vector3(-4.5,0.43,1),Vector3(1.5,0.86,3.1),Color("77958a"),true)
	Geo.box(self,Vector3(-5.1,0.95,1),Vector3(0.35,0.9,3.1),Color("6d8b7f"))
	Geo.box(self,Vector3(-4.5,0.98,-0.38),Vector3(1.5,0.5,0.28),Color("6d8b7f"))
	Geo.box(self,Vector3(-4.5,0.98,2.38),Vector3(1.5,0.5,0.28),Color("6d8b7f"))
	Geo.box(self,Vector3(-2,0.52,1),Vector3(1.7,0.18,2.1),Color("b49368"),true)
	Geo.cylinder(self,Vector3(-2,0.73,1),0.19,0.18,Color("eee4c8"))
	Geo.box(self,Vector3(-2.4,0.66,0.5),Vector3(0.5,0.04,0.37),Color("efe4c8"))
	InteractionPoint.create(self,Vector3(-2,0,-0.5),"Ler · bilhete da avó","grandma")
	InteractionPoint.create(self,Vector3(-3.4,0,2.6),"Descansar · 30 min","rest")
	# Kitchen counter, sink, refrigerator and dining table.
	Geo.box(self,Vector3(5.8,0.55,1.7),Vector3(1.5,1.1,4.1),Color("e4d8b8"),true)
	Geo.box(self,Vector3(5.8,1.16,1.7),Vector3(1.65,0.16,4.2),Color("879b92"))
	Geo.box(self,Vector3(5.8,1.25,1.4),Vector3(0.9,0.03,1),Color("bac5bb"))
	Geo.box(self,Vector3(5.8,1.26,1.4),Vector3(0.66,0.03,0.76),Color("6c8883"))
	Geo.box(self,Vector3(5.8,1.3,4.5),Vector3(1.6,2.6,1.5),Color("d4dbcc"),true)
	Geo.box(self,Vector3(4.97,1.1,4.5),Vector3(0.05,0.07,1.5),Color("a8b7ab"))
	Geo.box(self,Vector3(2.4,0.85,1.7),Vector3(2.2,0.16,2.8),Color("c4a274"),true)
	for x in [1.6,3.2]:
		for z in [0.7,2.7]:
			Geo.box(self,Vector3(x,0.42,z),Vector3(0.1,0.84,0.1),Color("b19165"))
	Geo.plant(self,Vector3(-6,0,4.5))
	Geo.text(self,Vector3(0,2.5,-5.2),"おかえり\nBEM-VINDO A CASA",23,Color("52736a"))
