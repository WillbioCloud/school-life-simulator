extends Node3D
## Composition root only: delegates time, state, worlds, NPCs, UI and activities.
const WORLD_PATH := "res://scenes/world/%s.tscn"
var world: Node3D
var player: SchoolPlayer
var camera: FollowCamera
var npcs: NPCManager
var light: Daylight
var ui: GameUI
var actions: GameActions
var nearest: InteractionPoint
var running: bool = false
var transitioning: bool = false
var interacting_npc: NPCActor

func _ready() -> void:
	get_window().title = "School Life — First Week"
	GameControls.install()
	light = Daylight.new()
	add_child(light)
	camera = FollowCamera.new()
	add_child(camera)
	npcs = NPCManager.new()
	add_child(npcs)
	ui = GameUI.new()
	ui.resolve_name = npcs.display_name
	add_child(ui)
	actions = GameActions.new()
	actions.game = self
	add_child(actions)
	ui.command.connect(actions.dispatch)
	GameTime.bedtime.connect(func(): call_deferred("_forced_sleep"))
	load_region("neighborhood","start",false)
	player.hide()
	camera.target = null
	camera.position = Vector3(1,0,-14)
	camera.zoom = 34
	camera.actual_zoom = 34
	camera.camera.size = 34
	ui.main_menu()

func load_region(id: String, spawn: String = "start", record: bool = true, saved_position: Variant = null) -> void:
	if not id in GameState.SCENES:
		return
	nearest = null
	if is_instance_valid(world):
		remove_child(world)
		world.queue_free()
	if is_instance_valid(player):
		remove_child(player)
		player.queue_free()
	world = load(WORLD_PATH % id).instantiate()
	add_child(world)
	GameState.scene_id = id
	player = SchoolPlayer.new()
	add_child(player)
	player.position = world.spawns.get(spawn,world.spawns.values()[0]) if saved_position == null else saved_position
	player.velocity = Vector3.ZERO
	GameState.player_position = player.position
	camera.target = player
	camera.zoom = 26 if id == "neighborhood" else 21
	if id == "bedroom":
		camera.zoom = 17
	elif id == "classroom":
		camera.zoom = 25
	camera.snap()
	player.camera = camera.camera
	npcs.set_region(id)
	light.indoor = id != "neighborhood"
	light.update_lighting()
	if record:
		GameState.mark(id)
	ui.refresh()

func transition(id: String, spawn: String) -> void:
	if transitioning:
		return
	transitioning = true
	GameTime.paused = true
	player.enabled = false
	var fade := ColorRect.new()
	fade.color = Color(0.94,0.92,0.85,0)
	ui.root.add_child(fade)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var tween := create_tween()
	tween.tween_property(fade,"color:a",1.0,0.18)
	await tween.finished
	load_region(id,spawn)
	tween = create_tween()
	tween.tween_property(fade,"color:a",0.0,0.22)
	await tween.finished
	fade.queue_free()
	transitioning = false
	GameTime.paused = not ui.current_modal.is_empty()

func start_new(data: Dictionary) -> void:
	GameState.reset(data.name,data.skin,data.hair,{"origin":data.get("origin","capital"),"reason":data.get("reason","own_choice"),"talent":data.get("talent","dedicated"),"traits":data.get("traits",[])})
	GameTime.reset()
	actions.session = null
	load_region("bedroom","start")
	running = true
	ui.begin_play()
	ui.open_modal("Bom dia, Hoshikawa","SEGUNDA-FEIRA  /  1º DE ABRIL","welcome")
	ui.text_block("A luz da manhã atravessa as cortinas do seu novo quarto. Lá fora, a cidade já está acordando.\n\nSua avó deixou um bilhete na sala. A escola espera por você às 08:25 — mas primeiro, respire. Este é só o começo.")
	ui.text_block("Use WASD para caminhar. Aproxime-se de portas e objetos e pressione E.\n\nTab abre seu celular com a agenda, o caderno e o grupo da turma; M mostra o caminho para a escola.")
	ui.option("Levantar e começar   →","close",{},true)

func load_saved(backup: bool = false) -> void:
	if not SaveSystem.load_game(backup):
		ui.open_modal("Não foi possível carregar","SALVAMENTO","load_error")
		ui.text_block(SaveSystem.last_error+"\nSua partida atual não foi alterada.")
		if FileAccess.file_exists(SaveSystem.PATH+".bak"):
			ui.option("Tentar backup anterior","load_backup")
		return
	var pos := GameState.player_position
	actions.session = null
	load_region(GameState.scene_id,"start",false,pos)
	running = true
	ui.begin_play()
	ui.toast("Seu dia continua de onde você parou.")

func save_current() -> bool:
	GameState.player_position = player.position
	var success := SaveSystem.save_game()
	ui.toast("História salva. Até o próximo capítulo." if success else SaveSystem.last_error)
	return success

func sleep_day(forced: bool = false) -> void:
	var tired := GameTime.minute >= 1380
	GameTime.paused = true
	actions.session = null
	var entry := DayCycle.close_day(forced, tired)
	GameTime.sleep()
	var morning := DayCycle.open_day()
	if GameState.flags.has("class"):
		GameState.mark("slept")
	load_region("bedroom","start")
	ui.close_allowed = true
	ui.close_modal()
	var saved := save_current()
	ui.open_modal("Uma nova manhã","%s  /  %s" % [GameTime.date_label(),GameTime.clock()],"morning")
	ui.text_block(("O sono chegou antes de você. Você voltou ao quarto e descansou.\n\n" if forced else "Você guardou mais um dia na memória.\n\n") + ("Dormir tarde deixou um pouco de cansaço: energia 80/100." if tired else "Um bom descanso. Sua energia foi recuperada."))
	ui.modal_body.add_child(ui.label("DIÁRIO  ·  " + str(entry.get("date","")),13,ui.ACCENT))
	for line in entry.get("lines",[]):
		ui.modal_body.add_child(ui.label("· " + str(line),16,ui.INK,true))
	var note_input := LineEdit.new()
	note_input.placeholder_text = "Uma frase sua para este dia (opcional)"
	note_input.max_length = 140
	note_input.custom_minimum_size.y = 44
	ui.modal_body.add_child(note_input)
	for line in morning:
		ui.modal_body.add_child(ui.label(str(line),16,ui.ACCENT,true))
	if GameState.flags.has("slept") and not GameState.flags.has("first_day_toast"):
		GameState.mark("first_day_toast")
		ui.text_block("Ciclo First Day validado! Agora a semana segue: cada aula tem posturas, Janelas de Questão e vizinhos de carteira.")
	ui.text_block("Progresso salvo automaticamente." if saved else "Atenção: não foi possível salvar. " + SaveSystem.last_error)
	ui.modal_body.add_child(ui.button("Ver o que o dia traz   →",func(): ui.command.emit("diary_note",{"note":note_input.text}),true))

func _forced_sleep() -> void:
	if running:
		sleep_day(true)

func return_to_title() -> void:
	ui.close_allowed = true
	ui.close_modal()
	running = false
	GameTime.paused = true
	load_region("neighborhood","start",false)
	player.hide()
	camera.target = null
	camera.position = Vector3(1,0,-14)
	camera.camera.size = 34
	ui.main_menu()

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		return
	player.enabled = running and not transitioning and ui.current_modal.is_empty()
	if not player.enabled:
		ui.interaction("")
		return
	nearest = null
	var best := 100.0
	for point in get_tree().get_nodes_in_group("interactables"):
		var distance: float = player.global_position.distance_to(point.global_position)
		if distance > point.radius or distance >= best:
			continue
		var query := PhysicsRayQueryParameters3D.create(player.global_position+Vector3(0,1.25,0),point.global_position+Vector3(0,1.25,0),1)
		if not get_world_3d().direct_space_state.intersect_ray(query).is_empty():
			continue
		nearest = point
		best = distance
	ui.interaction(nearest.title if nearest else "")

func _unhandled_input(event: InputEvent) -> void:
	if not running or transitioning:
		return
	if event.is_action_pressed("menu"):
		if ui.current_modal.is_empty():
			ui.show_pause()
		else:
			ui.close_modal()
		get_viewport().set_input_as_handled()
		return
	if not ui.current_modal.is_empty():
		return
	if event.is_action_pressed("interact") and is_instance_valid(nearest):
		actions.interact(nearest)
	elif event.is_action_pressed("phone"):
		ui.show_phone()
	elif event.is_action_pressed("map"):
		ui.show_map()
	elif event.is_action_pressed("bag"):
		ui.show_bag()
