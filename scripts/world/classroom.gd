extends Node3D
var spawns := {"hall": Vector3(7,0.1,3.3)}
func _ready() -> void:
	Geo.floor_room(self,Vector2(18,15),Color("cdb78d"))
	Geo.box(self,Vector3(0,2.1,-7.35),Vector3(10,1.85,0.18),Color("947d5b"))
	Geo.box(self,Vector3(0,2.1,-7.23),Vector3(9.7,1.57,0.08),Color("426858"))
	Geo.text(self,Vector3(0,2.2,-7.13),"Bem-vindos à turma 1-A\nUm novo ano. Um novo começo.",29,Color("ede8cf"))
	Geo.box(self,Vector3(0,0.93,-5.5),Vector3(2.7,0.15,1.1),Color("b39567"),true)
	Geo.box(self,Vector3(0,0.46,-5.6),Vector3(2.5,0.92,0.15),Color("c0a67c"))
	# Desks follow the seat map (data/classrooms/1a.json): the protagonist sits at C2, neighbours around.
	var player_seat := SeatMap.player_seat()
	for seat in SeatMap.all_seats():
		var pos := SeatMap.desk_position(seat)
		Geo.desk(self,pos,seat==player_seat)
		var occupant := SeatMap.occupant(seat)
		if not occupant.is_empty():
			var plate := Geo.text(self,pos+Vector3(-0.42,0.97,-0.22),occupant.capitalize().to_upper(),12,Color("4d5f5a"))
			plate.rotation_degrees.x = -90
	var chair := SeatMap.chair_position(player_seat)
	InteractionPoint.create(self,Vector3(chair.x,0,chair.z+0.9),"Sentar · sua carteira","class")
	for x in [-7,7]:
		Geo.box(self,Vector3(x,2.25,-7.24),Vector3(2.1,1.7,0.1),Color("8fb8b1"))
		Geo.box(self,Vector3(x,2.25,-7.13),Vector3(0.07,1.7,0.06),Color("f3e9cc"))
	Geo.plant(self,Vector3(-8,0,-6.5))
	Geo.doorway(self,Vector3(7,0,-7.3),"CORREDOR", "school_hall", "classroom")
	Geo.text(self,Vector3(7,1.2,5.8),"1-A",45,Color("4d7568"))
	InteractionPoint.create(self,Vector3(7,0,5.8),"Voltar · corredor","door",{"scene":"school_hall","spawn":"classroom"})
