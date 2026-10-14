class_name Daylight
extends Node3D
var sun: DirectionalLight3D
var environment: Environment
var indoor: bool = false

func _ready() -> void:
	sun = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48,-35,0)
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 75
	sun.light_angular_distance = 2
	add_child(sun)
	var world_env := WorldEnvironment.new()
	environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("d4e1d5")
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	world_env.environment = environment
	add_child(world_env)
	GameTime.changed.connect(update_lighting)
	update_lighting()

func update_lighting() -> void:
	if not sun:
		return
	var hour: float = GameTime.minute/60.0
	var daylight := clampf(sin((hour-5.5)/15.0*PI),0,1)
	var evening := clampf(1.0-absf(hour-18.0)/2.5,0,1)
	sun.light_energy = 0.25 + daylight*1.15
	sun.light_color = Color("fff0d2").lerp(Color("efae7d"),evening*0.65)
	sun.rotation_degrees.x = -25-daylight*38
	sun.shadow_enabled = GameState.shadows
	environment.background_color = Color("354e62").lerp(Color("b9c9b7"),daylight)
	environment.ambient_light_energy = 0.65 if indoor else 0.38+daylight*0.25
	for lamp in get_tree().get_nodes_in_group("night_lights"):
		lamp.light_energy = (1-daylight)*2.0
	for window in get_tree().get_nodes_in_group("windows"):
		var material: StandardMaterial3D = window.material_override
		material.emission_enabled = true
		material.emission = Color("edbb75")
		material.emission_energy_multiplier = (1-daylight)*0.6
