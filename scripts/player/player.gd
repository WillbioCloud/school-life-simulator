class_name SchoolPlayer
extends CharacterBody3D
var visual: CharacterVisual
var camera: Camera3D
var enabled: bool = false

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	var shape := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.3
	capsule.height = 1.8
	shape.shape = capsule
	shape.position.y = 0.9
	add_child(shape)
	visual = CharacterVisual.new()
	add_child(visual)
	visual.build(Color(GameState.skin), Color(GameState.hair), Color("3c5663"))

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left","move_right","move_up","move_down") if enabled else Vector2.ZERO
	var dir := Vector3.ZERO
	if camera:
		var right := camera.global_basis.x
		var forward := camera.global_basis.z
		right.y = 0
		forward.y = 0
		dir = (right.normalized() * input.x + forward.normalized() * input.y).limit_length()
	var running := enabled and Input.is_action_pressed("run") and GameState.energy > 0
	var speed := 6.5 if running else 3.7
	velocity.x = move_toward(velocity.x,dir.x*speed,delta*24)
	velocity.z = move_toward(velocity.z,dir.z*speed,delta*24)
	velocity.y = 0.0 if is_on_floor() else velocity.y - delta * 24
	move_and_slide()
	var horizontal := Vector2(velocity.x,velocity.z).length()
	if horizontal > 0.15:
		visual.rotation.y = lerp_angle(visual.rotation.y,atan2(-velocity.x,-velocity.z),1-exp(-delta*14))
		if running:
			GameState.energy = maxf(0,GameState.energy-delta*0.18)
	visual.animate(delta,horizontal)
	if position.y < -5:
		position = Vector3(0,0.3,2)
	GameState.player_position = position
