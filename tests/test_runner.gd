extends Node
## Integration tests. Run via tests/run.sh to isolate user:// from real saves.
var failures: int = 0
var checks: int = 0

func _ready() -> void:
	if OS.get_environment("SCHOOL_LIFE_TEST") != "1":
		push_error("Use tests/run.sh: automated tests require an isolated save directory.")
		get_tree().quit(2)
		return
	call_deferred("run")

func check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("FAIL: " + description)
	else:
		print("PASS: " + description)

func run() -> void:
	GameTime.paused = true
	GameTime.reset()
	check(GameTime.date_label()=="SEG  ·  01 ABR" and GameTime.clock()=="06:30","Official first morning")
	for day in range(1,15):
		GameTime.day = day
		check(GameTime.is_school_day()==((day-1)%7<5),"Weekday rule: day %d" % day)
	GameTime.day = 14
	GameTime.sleep()
	check(GameTime.day==1 and GameTime.month==5 and GameTime.year==1,"14-day month rolls over")
	GameTime.month = 12
	GameTime.day = 14
	GameTime.sleep()
	check(GameTime.month==1 and GameTime.year==1,"January is still the same school year")
	GameTime.month = 3
	GameTime.day = 14
	GameTime.sleep()
	check(GameTime.month==4 and GameTime.year==2,"New school year starts in April")
	GameTime.reset()
	for i in range(168):
		GameTime.sleep()
	check(GameTime.year==2 and GameTime.month==4 and GameTime.day==1,"Exactly 168 days per school year")
	GameTime.reset()
	for i in range(504):
		GameTime.sleep()
	check(GameTime.year==4 and GameTime.month==4 and GameTime.day==1,"504 days across three complete years")
	GameTime.reset()
	GameState.reset()
	GameTime.minute = 505
	var before: int = GameState.attributes.Disciplina
	SchoolSchedule.attend("focus")
	check(GameTime.minute==515 and GameState.attendance.size()==1,"Class consumes time and records participation")
	check(GameState.attributes.Disciplina==before+3,"Activity-specific attribute gain")
	GameTime.minute = 505
	SchoolSchedule.attend("focus")
	check(GameState.attendance.size()==1 and GameState.attributes.Disciplina==before+3,"Duplicate attendance is not rewarded")
	GameTime.day = 6
	check(SchoolSchedule.current_or_next(505).is_empty(),"No weekend classes")
	GameTime.reset()
	GameState.reset()
	GameState.money = 876
	GameState.inventory.Onigiri = 3
	GameState.relationships.yui = 45
	GameState.mark("talk")
	check(SaveSystem.save_game(),"Versioned save writes successfully")
	GameState.money = 1
	check(SaveSystem.load_game(),"Save loads successfully")
	check(GameState.money==876 and GameState.inventory.Onigiri==3 and GameState.relationships.yui==45 and GameState.flags.has("talk"),"Economy, inventory, relationships and flags round trip")
	var payload := {"version":2,"player":GameState.serialize(),"time":GameTime.serialize()}
	payload.time.day = 15
	check(not SaveSystem.validate(payload).is_empty(),"Invalid dates rejected")
	payload.time.day = 1
	payload.player.scene = "unknown"
	check(not SaveSystem.validate(payload).is_empty(),"Unknown scenes rejected")
	payload.player.scene = "bedroom"
	payload.player.position = ["bad",0,0]
	check(not SaveSystem.validate(payload).is_empty(),"Malformed positions rejected")
	var old := {"version":1,"player":GameState.serialize(),"time":GameTime.serialize()}
	old.player.erase("flags")
	check(SaveSystem.validate(SaveSystem.migrate(old)).is_empty(),"v1 migrates to v2")
	var file := FileAccess.open(SaveSystem.PATH,FileAccess.WRITE)
	file.store_string("{broken json")
	file.close()
	check(not SaveSystem.load_game() and GameState.money==876,"Corrupt save does not mutate current game")
	check(SaveSystem.save_game(),"Valid save can replace corrupt slot")
	check(SaveSystem.save_game() and FileAccess.file_exists(SaveSystem.PATH+".bak"),"Backup is retained")
	GameState.money = 2
	check(SaveSystem.load_game(true) and GameState.money==876,"Backup recovery")
	# Full composition, actual world instances and UI commands.
	var game: Node = load("res://scenes/main.tscn").instantiate()
	add_child(game)
	await get_tree().process_frame
	check(game.world != null and not game.running,"Main menu boots into 3D environment")
	game.start_new({"name":"Teste","skin":"bc896d","hair":"393940"})
	check(game.player != null and GameState.scene_id=="bedroom","New game starts in bedroom")
	check(GameTime.paused,"Welcome dialogue pauses time")
	game.ui.close_modal()
	check(not GameTime.paused,"Closing dialog resumes time")
	game.ui.show_phone()
	var saved_minute := GameTime.minute
	GameTime._process(30)
	check(GameTime.minute==saved_minute,"Phone does not consume game time")
	game.ui.close_modal()
	for region in ["home","neighborhood","school_hall","classroom"]:
		game.load_region(region)
		await get_tree().physics_frame
		check(GameState.scene_id==region and game.world.get_child_count()>0,"World loads: " + region)
	GameTime.minute = 505
	GameTime.changed.emit()
	game.npcs.sync()
	check(game.npcs.actors.has("yui") and game.npcs.actors.has("sato"),"Student and teacher attend classroom by schedule")
	game.actions._reply({"id":"yui","kind":"kind"})
	game.actions._reply({"id":"yui","kind":"kind"})
	check(GameState.relationships.yui==15,"Repeated daily conversation gives no extra affinity")
	game.ui.close_modal()
	game.actions.dispatch("attend",{"choice":"help"})
	check(GameState.flags.has("class") and GameTime.minute==515,"Playable class choice completes an activity")
	game.ui.close_modal()
	game.load_region("neighborhood","school")
	GameTime.minute = 950
	game.npcs.sync()
	check(game.npcs.actors.has("ren") and game.npcs.actors.has("yui"),"NPCs follow after-school schedules")
	game.load_region("home","outside")
	game.load_region("bedroom","home")
	game.sleep_day()
	check(GameTime.day==2 and GameTime.minute==390 and GameState.energy==100,"Sleep begins the next playable day")
	check(GameState.flags.has("slept"),"Full First Day loop milestone")
	check(SaveSystem.load_game() and GameTime.day==2,"Sleep autosave persists next morning")
	game.ui.close_modal()
	GameTime.minute = 1400
	game.sleep_day()
	check(GameState.energy==80 and GameTime.day==3,"Late sleep applies only a mild energy penalty")
	game.ui.close_modal()
	GameTime.minute = 1439
	GameTime.advance(1)
	await get_tree().process_frame
	check(GameTime.day==4 and GameTime.minute==390,"Midnight fallback advances only one day")
	game.ui.close_modal()
	game.camera.set_projection(true)
	check(game.camera.camera.projection==Camera3D.PROJECTION_PERSPECTIVE,"Perspective comparison works")
	game.camera.set_projection(false)
	check(game.camera.camera.projection==Camera3D.PROJECTION_ORTHOGONAL,"Orthographic remains default option")
	for panel in ["map","calendar","bag","settings","phone","pause"]:
		game.actions.dispatch(panel,{})
		check(not game.ui.current_modal.is_empty() and GameTime.paused,"Panel opens and pauses: " + panel)
		game.ui.close_modal()
	game.load_region("neighborhood","home")
	await get_tree().physics_frame
	game.player.position = Vector3(0,0.2,10)
	for i in range(90):
		await get_tree().physics_frame
	check(game.player.position.y>-0.1 and game.player.position.y<0.3,"3D floor collision holds player")
	game.queue_free()
	await get_tree().process_frame
	print("\nRESULT: %d checks, %d failures" % [checks,failures])
	get_tree().quit(1 if failures else 0)
