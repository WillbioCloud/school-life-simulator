class_name TownMap
extends Control
const INK := Color("496960")
func _ready() -> void:
	custom_minimum_size = Vector2(620,330)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
	var width := size.x
	draw_style_box(_background(),Rect2(Vector2.ZERO,size))
	var center := width*0.51
	draw_line(Vector2(center,50),Vector2(center,300),Color("d4cdb7"),22)
	draw_line(Vector2(90,254),Vector2(width-65,254),Color("d4cdb7"),15)
	draw_line(Vector2(108,154),Vector2(center,154),Color("d4cdb7"),12)
	draw_line(Vector2(108,154),Vector2(108,254),Color("d4cdb7"),12)
	_building(Rect2(center-70,24,140,54),"ESCOLA",Color("93b1a2"))
	_building(Rect2(center+53,184,113,50),"SUA CASA",Color("d4b693"))
	_building(Rect2(135,175,113,55),"PRAÇA",Color("b4c58e"))
	_building(Rect2(160,104,90,40),"CAFÉ¹",Color("ccc6b0"))
	var marker := Vector2(center+100,210)
	if GameState.scene_id == "neighborhood":
		marker = Vector2(center+GameState.player_position.x*7,160+GameState.player_position.z*4.5)
	elif GameState.scene_id in ["classroom","school_hall"]:
		marker = Vector2(center,52)
	draw_circle(marker,10,Color("f7f0dc"))
	draw_circle(marker,6,Color("c67e64"))
	draw_string(ThemeDB.fallback_font,Vector2(width-63,30),"N ↑",HORIZONTAL_ALIGNMENT_LEFT,-1,19,INK)
	draw_string(ThemeDB.fallback_font,Vector2(20,315),"● Você está aqui       ¹ Exterior apenas · mapa do protótipo",HORIZONTAL_ALIGNMENT_LEFT,-1,15,INK)

func _building(rect: Rect2, label: String, color: Color) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(6)
	draw_style_box(style,rect)
	draw_string(ThemeDB.fallback_font,rect.position+Vector2(12,rect.size.y/2+5),label,HORIZONTAL_ALIGNMENT_LEFT,-1,15,INK)

func _background() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("e7e9d7")
	style.set_corner_radius_all(12)
	return style
