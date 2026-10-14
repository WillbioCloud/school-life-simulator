class_name FollowCamera
extends Node3D
var camera: Camera3D
var target: Node3D
var zoom: float = 22.0
var actual_zoom: float = 22.0
var fading: Dictionary = {}

func _ready() -> void:
	camera = Camera3D.new()
	camera.current = true
	camera.far = 180
	camera.near = 0.1
	add_child(camera)
	camera.position = Vector3(12,18,16).normalized() * 37
	camera.look_at_from_position(camera.position,Vector3.ZERO)
	set_projection(GameState.camera_perspective)

func set_projection(perspective: bool) -> void:
	GameState.camera_perspective = perspective
	if not camera:
		return
	camera.projection = Camera3D.PROJECTION_PERSPECTIVE if perspective else Camera3D.PROJECTION_ORTHOGONAL
	camera.fov = 34

func _unhandled_input(event: InputEvent) -> void:
	if GameTime.paused:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = maxf(zoom-1.5,12)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = minf(zoom+1.5,30)

func snap() -> void:
	if target:
		position = target.position + Vector3(0,0.4,-1.2)

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	position = position.lerp(target.position + Vector3(0,0.4,-1.2),1-exp(-delta*6))
	actual_zoom = lerpf(actual_zoom,zoom,1-exp(-delta*9))
	camera.size = actual_zoom
	if camera.projection == Camera3D.PROJECTION_PERSPECTIVE:
		camera.position = camera.position.normalized() * actual_zoom * 1.7
	else:
		camera.position = camera.position.normalized() * 37
	_fade_occluders(delta)

func _fade_occluders(delta: float) -> void:
	var hidden: Array[Node] = []
	var excluded: Array[RID] = []
	for i in range(5):
		var query := PhysicsRayQueryParameters3D.create(camera.global_position,target.global_position+Vector3(0,1,0),4,excluded)
		var hit := get_world_3d().direct_space_state.intersect_ray(query)
		if hit.is_empty():
			break
		var collider: Node = hit.collider
		excluded.append(collider.get_rid())
		if collider.has_meta("fade_root"):
			hidden.append(collider.get_meta("fade_root"))
	for root in get_tree().get_nodes_in_group("occluders"):
		var alpha := 0.18 if root in hidden else 1.0
		var current: float = lerpf(float(root.get_meta("alpha",1.0)),alpha,1-exp(-delta*10))
		root.set_meta("alpha",current)
		for mesh in root.get_meta("fade_meshes",[]):
			var material: StandardMaterial3D = mesh.material_override
			material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA if current < 0.99 else BaseMaterial3D.TRANSPARENCY_DISABLED
			material.albedo_color.a = current
