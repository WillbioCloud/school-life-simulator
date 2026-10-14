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

## Drives a ClassSession with a policy until the summary screen. Returns the question ids shown.
func drive(session: ClassSession, screen: Dictionary, policy: Callable) -> Array:
	var seen: Array = []
	var guard := 0
	while not screen.is_empty() and not bool(screen.get("final", false)) and guard < 300:
		guard += 1
		if str(screen.get("id", "")) == "question" and (seen.is_empty() or seen[-1] != str(session.pending.question.id)):
			seen.append(str(session.pending.question.id))
		var payload: Dictionary = policy.call(session, screen)
		screen = session.handle(payload)
	check(guard < 300, "Session %s terminates" % session.key)
	return seen

## Default policy: chosen posture, correct answers, first enabled option otherwise.
func policy(posture: String) -> Callable:
	return func(session: ClassSession, screen: Dictionary) -> Dictionary:
		match str(screen.get("id", "")):
			"posture":
				for option in screen.options:
					if str(option.payload.get("id", "")) == posture:
						return option.payload
				return screen.options[0].payload
			"question":
				var q: Dictionary = session.pending.question
				for i in range(q.options.size()):
					if int(q.options[i].orig) == int(q.answer):
						return {"cmd": "answer", "index": i}
		for option in screen.get("options", []):
			if not bool(option.get("disabled", false)):
				return option.payload
		return {"cmd": "next"}

func context_all() -> Dictionary:
	var npcs: Dictionary = {}
	for data in NPCManager.load_definitions():
		npcs[str(data.id)] = data
	var neighbors := SeatMap.neighbors_of_player()
	return {"present": ["yui", "aiko", "daichi", "kenta", "hina", "tsubasa"], "neighbors": neighbors, "npcs": npcs}

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

	# ---- data integrity (seção 61.6)
	GameTime.reset()
	GameState.reset()
	var errors := QuestionBank.validate()
	check(errors.is_empty(),"Question bank follows authoring rules" + ("" if errors.is_empty() else ": " + str(errors)))
	check(QuestionBank.questions.size()>=60,"Minimal bank has at least 60 questions (%d)" % QuestionBank.questions.size())
	var counts := Timetable.weekly_counts()
	var total := 0
	for id in counts:
		total += int(counts[id])
	check(total==30,"Timetable fills 30 slots")
	check(int(counts.get("literature",0))==5 and int(counts.get("math",0))==5 and int(counts.get("english",0))==4,"Core subjects weekly load (5/5/4)")
	var monday := SchoolSchedule.day_periods(0)
	check(monday[1].subject=="literature" and monday[1].teacher=="Professor Sato" and bool(monday[1].theory),"Monday first period resolves to Literature with Sato")
	check(SchoolSchedule.day_periods(4)[6].special=="study","Friday sixth period is directed study")
	var around := SeatMap.neighbors_of_player()
	check(around.get("left","")=="yui" and around.get("right","")=="kenta" and around.get("front","")=="daichi" and around.get("back","")=="tsubasa","Seat map: Yui left, Kenta right, Daichi front, Tsubasa behind")
	check(SeatMap.chair_position("C2")==Vector3(0,0,2.1),"Player chair position from classroom data")
	check(NPCManager.load_definitions().size()==8,"Eight character sheets load")
	check(ClassMissions.mission("m01_first_call").steps.size()==3 and ClassMissions.reserved_questions().has("jl_u1_001"),"Missions load and reserve their fixed questions")
	GameTime.day = 6
	check(SchoolSchedule.current_or_next(505).is_empty(),"No weekend classes")
	GameTime.reset()

	# ---- deterministic rng
	var a := SeededRng.from_string("1-04-01:p1")
	var b := SeededRng.from_string("1-04-01:p1")
	var c := SeededRng.from_string("1-04-02:p1")
	var same := true
	var different := false
	for i in range(20):
		var x := a.range_int(0,1000)
		same = same and x == b.range_int(0,1000)
		different = different or x != c.range_int(0,1000)
	check(same and different,"Seeded rng is reproducible per date and period")

	# ---- protagonist profile and progression (seções 45, 47, 52)
	GameState.reset("Teste","efbd98","393940",{"talent":"athlete","origin":"abroad","traits":["careful","playful","curious"]})
	check(GameState.attributes.Condicionamento==12 and GameState.mastery_of("pe")==GameState.attributes.Conhecimento+10,"Talent sets attributes and +10 mastery")
	check(GameState.mastery_of("english")==GameState.attributes.Conhecimento+15 and GameState.mastery_of("literature")==GameState.attributes.Conhecimento-5,"Origin abroad adjusts English and Literature")
	check(GameState.background.traits.size()==2 and GameState.has_trait("careful") and not GameState.has_trait("curious"),"At most two traits")
	check(GameState.inventory.has("Caderno bilíngue") and GameState.inventory.has("Tênis de corrida"),"Origin and talent items in inventory")
	GameState.reset()
	var base_math := GameState.mastery_of("math")
	var knowledge := int(GameState.attributes.Conhecimento)
	check(GameState.gain_mastery("math",4)==4 and GameState.gain_mastery("math",4)==2 and GameState.gain_mastery("math",1)==0,"Mastery capped at +6 per subject per day")
	check(GameState.mastery_of("math")==base_math+6,"Mastery accumulates up to the cap")
	GameState.gain_mastery("science",4)
	check(GameState.attributes.Conhecimento==knowledge+1,"Every 10 mastery points raise Conhecimento")
	GameTime.sleep()
	check(GameState.gain_mastery("math",6)==6,"Cap resets on a new day")
	GameTime.reset()
	GameState.add_bond("yui",49)
	check(GameState.bond_level("yui")==0 and GameState.bond_level_name("yui")=="Estranho","Below 50 points there is no level")
	GameState.add_bond("yui",1)
	check(GameState.bond_level("yui")==1 and GameState.bond_level_name("yui")=="Conhecido","50 points reach level 1 (Conhecido)")
	GameState.add_bond("yui",-100)
	check(GameState.bond("yui")==0,"Bonds never go negative")
	GameState.set_mood("inspired",2)
	check(GameState.mood.state=="inspired" and GameState.mood.until=="1-04-03","Mood expiry stamp")
	GameTime.day = 4
	GameState.refresh_mood()
	check(GameState.mood.state=="calm","Mood expires after its days")
	GameTime.reset()
	for i in range(25):
		GameState.remember_question("q%d" % i)
	check(GameState.questions_seen.size()==20 and GameState.questions_seen[0]=="q5","Seen questions keep the last 20")
	GameState.set_mood("tired",1)
	GameState.energy = 100
	GameState.drain_energy(10)
	check(is_equal_approx(GameState.energy,88.0),"Tired mood raises energy costs by 20%")
	GameState.reset()

	# ---- class director (seção 46.8)
	GameTime.minute = 520
	var p1 := SchoolSchedule.by_id("p1")
	var session := ClassSession.new(p1, context_all())
	session.start()
	check(session.blocks_total==5 and session.late_by==0,"Five ten-minute blocks in a 50-minute period")
	session.posture = ClassDirector.posture("attention")
	session.plan = ClassDirector.plan(session)
	var interactive := 0
	for entry in session.plan:
		if str(entry.kind)=="question" and str(entry.get("target",""))=="player":
			interactive += 1
	check(session.plan.size()<=2 and interactive>=1,"First theory class of the day guarantees one player question, at most two moments")
	GameState.attendance["1-04-01:homeroom"] = {"windows":3}
	session.posture = ClassDirector.posture("attention")
	session.caught = false
	session.plan = ClassDirector.plan(session)
	var player_windows := 0
	for entry in session.plan:
		if bool(ClassDirector.moment(str(entry.kind)).get("interactive",false)) and str(entry.get("target","player"))=="player":
			player_windows += 1
	check(player_windows==0,"Daily window limit stops new interactive moments")
	GameState.attendance.clear()
	GameTime.minute = 530
	var late := ClassSession.new(p1, context_all())
	late.start()
	check(late.late_by==10 and int(GameState.discipline.term_points)==1 and late.blocks_total==4,"Arriving late registers an occurrence and shortens the period")
	GameState.reset()

	# ---- a full class, headless (seção 46.3)
	GameTime.minute = 520
	var lit := ClassSession.new(p1, context_all())
	var first_screen := lit.start()
	check(first_screen.id=="posture" and first_screen.options.size()>=4,"Class opens with the posture choice")
	var energy_before := GameState.energy
	var mastery_before := GameState.mastery_of("literature")
	var seen := drive(lit, first_screen, policy("attention"))
	lit.handle({"cmd":"close"})
	check(lit.finished and GameTime.minute==570 and GameState.attendance.has("1-04-01:p1"),"Class advances to the end of the period and records attendance")
	check(GameState.mastery_of("literature")>mastery_before and GameState.energy<energy_before,"Attention posture raises mastery and costs energy")
	check(GameState.cards.size()>=2,"Attention reveals cards")
	check(seen.size()>=1 and GameState.counter("questions_correct")>=1 and GameState.questions_seen.size()==seen.size(),"Question window shown, answered and remembered")
	check(GameState.flags.has("class"),"Class flag set for the First Day objective")

	# ---- Janela de Questão tools (seção 46.6)
	GameState.reset()
	GameState.add_bond("daichi",150)
	GameTime.minute = 580
	var math_p := SchoolSchedule.by_id("p2")
	check(math_p.subject=="math","Monday second period is Math")
	var tools_session := ClassSession.new(math_p, context_all())
	tools_session.start()
	tools_session.posture = ClassDirector.posture("attention")
	var qscreen := tools_session._open_question({"question":"ma_u1_001"}, {"kind":"moment"})
	var tool_ids: Array = []
	for t in qscreen.tools:
		tool_ids.append(str(t.payload.tool))
	check(qscreen.id=="question" and qscreen.grid.size()==4 and tool_ids.has("help") and tool_ids.has("skip") and not tool_ids.has("notebook"),"Question window offers help (Daichi, level 2, mastery 72) and skip, no notebook yet")
	var after_help := tools_session.handle({"cmd":"tool","tool":"help"})
	var still_correct := false
	for option in tools_session.pending.question.options:
		if int(option.orig)==int(tools_session.pending.question.answer):
			still_correct = true
	check(after_help.grid.size()==3 and still_correct,"Help removes one wrong alternative and keeps the right one")
	GameState.notebook_pages.math = 1
	var after_pages := tools_session._screen_question()
	var has_notebook := false
	for t in after_pages.tools:
		if str(t.payload.tool)=="notebook":
			has_notebook = true
	check(has_notebook,"Notebook pages unlock Consultar caderno")
	var after_notebook := tools_session.handle({"cmd":"tool","tool":"notebook"})
	var shows_card := false
	for block in after_notebook.body:
		if block is Dictionary and block.has("card"):
			shows_card = true
	check(shows_card and GameState.cards.has("ma_u1_c01"),"Consultar caderno shows and grants the related card")
	var mastery_math := GameState.mastery_of("math")
	var skipped := tools_session.handle({"cmd":"tool","tool":"skip"})
	check(skipped.id=="feedback" and skipped.title=="Explicação" and GameState.mastery_of("math")==mastery_math+1,"Não sei shows the explanation and still grants +1 mastery")
	GameState.reset()
	GameState.mark("intro_done")
	GameState.energy = 20
	GameTime.minute = 580
	var sleepy := ClassSession.new(math_p, context_all())
	sleepy.start()
	sleepy.posture = ClassDirector.posture("attention")
	var sleepy_plan := ClassDirector.plan(sleepy)
	var has_drowsy := false
	for entry in sleepy_plan:
		if str(entry.kind)=="drowsy":
			has_drowsy = true
	check(has_drowsy,"Low energy schedules the drowsy moment")
	var drowsy_screen := sleepy._screen_drowsy()
	sleepy.pending = {"kind":"drowsy"}
	var lay_down := sleepy._choice(1)
	check(drowsy_screen.id=="drowsy" and lay_down.id=="result" and GameState.energy==30 and int(GameState.discipline.term_points)==1,"Laying down restores energy and costs an occurrence")

	# ---- missions (seção 46.7): M-01 in homeroom, M-02 fixed question, M-04 cooperative
	GameState.reset()
	GameTime.minute = 505
	var hr := ClassSession.new(SchoolSchedule.by_id("homeroom"), context_all())
	var hr_screen := hr.start()
	check(not hr.mission.is_empty() and hr.mission.id=="m01_first_call","First homeroom schedules M-01")
	drive(hr, hr_screen, policy("attention"))
	hr.handle({"cmd":"close"})
	check(ClassMissions.completed("m01_first_call") and GameState.flags.has("intro_done") and GameTime.minute==515,"M-01 completes with its presentation choices")
	GameTime.day = 2
	GameTime.minute = 580
	var tue_p2 := SchoolSchedule.by_id("p2")
	check(tue_p2.subject=="literature","Tuesday second period is Literature")
	var m02 := ClassSession.new(tue_p2, context_all())
	var m02_screen := m02.start()
	check(m02.mission.id=="m02_sato_question","Sato's haiku question scheduled in the first Literature class after day 1")
	var m02_seen := drive(m02, m02_screen, policy("attention"))
	m02.handle({"cmd":"close"})
	check(ClassMissions.completed("m02_sato_question") and m02_seen.has("jl_u1_001"),"M-02 asks its fixed question and completes")
	GameTime.day = 9
	GameTime.minute = 700
	var p4 := SchoolSchedule.by_id("p4")
	check(p4.subject=="english","Tuesday fourth period is English")
	var m04 := ClassSession.new(p4, context_all())
	var m04_screen := m04.start()
	check(m04.mission.id=="m04_kenta_verb","Kenta's verb mission triggers in English with Kenta present")
	var m04_seen := drive(m04, m04_screen, policy("attention"))
	m04.handle({"cmd":"close"})
	check(ClassMissions.completed("m04_kenta_verb") and m04_seen.has("en_u1_016") and m04_seen.has("en_u1_017") and GameState.bond("kenta")>=10,"M-04 cooperative questions raise Kenta's bond")
	GameTime.reset()

	# ---- save v3 (seção 61.3)
	GameState.reset()
	GameState.money = 876
	GameState.inventory.Onigiri = 3
	GameState.relationships.yui = 45
	GameState.mark("talk")
	GameState.gain_mastery("math",3)
	GameState.add_card("ma_u1_c01")
	GameState.diary.append({"date":"SEG · 01/04","stamp":"1-04-01","lines":["a","b","c"],"note":""})
	check(SaveSystem.save_game(),"Versioned save writes successfully")
	var saved_math := GameState.mastery_of("math")
	GameState.money = 1
	GameState.cards.clear()
	check(SaveSystem.load_game(),"Save loads successfully")
	check(GameState.money==876 and GameState.inventory.Onigiri==3 and GameState.relationships.yui==45 and GameState.flags.has("talk"),"Economy, inventory, relationships and flags round trip")
	check(GameState.mastery_of("math")==saved_math and GameState.cards.has("ma_u1_c01") and GameState.diary.size()==1,"Mastery, cards and diary round trip")
	var payload := {"version":3,"player":GameState.serialize(),"time":GameTime.serialize()}
	payload.time.day = 15
	check(not SaveSystem.validate(payload).is_empty(),"Invalid dates rejected")
	payload.time.day = 1
	payload.player.scene = "unknown"
	check(not SaveSystem.validate(payload).is_empty(),"Unknown scenes rejected")
	payload.player.scene = "bedroom"
	payload.player.position = ["bad",0,0]
	check(not SaveSystem.validate(payload).is_empty(),"Malformed positions rejected")
	payload.player.position = [0,0,0]
	payload.player.mastery.math = 140
	check(not SaveSystem.validate(payload).is_empty(),"Mastery outside 0–100 rejected")
	var old := {"version":1,"player":GameState.serialize(),"time":GameTime.serialize()}
	old.player.erase("flags")
	for key in ["background","mastery","cards","notebook_pages","questions_seen","reputation","discipline","mood","diary","day_log","counters","quests","mastery_today"]:
		old.player.erase(key)
	var migrated := SaveSystem.migrate(old)
	check(SaveSystem.validate(migrated).is_empty() and int(migrated.version)==3,"v1 migrates through v2 to v3")
	var v2 := {"version":2,"player":{"name":"Antigo","skin":"efbd98","hair":"393940","scene":"home","position":[1,0.1,2],"energy":70,"money":300,
		"attributes":{"Conhecimento":22,"Carisma":5,"Condicionamento":3,"Criatividade":5,"Disciplina":10,"Empatia":5},"inventory":{"Onigiri":1},
		"relationships":{"yui":30},"talked":{},"attendance":{"1-04-01:homeroom":{"choice":"focus"}},"flags":{"class":true}},"time":{"year":1,"month":4,"day":2,"minute":600}}
	var v3 := SaveSystem.migrate(v2)
	check(SaveSystem.validate(v3).is_empty() and v3.player.mastery.literature==22 and v3.player.background.talent=="dedicated","v2 save migrates: mastery starts at saved Conhecimento")
	GameState.restore(v3.player)
	check(GameState.money==300 and GameState.mastery_of("math")==22 and GameState.relationships.yui==30 and GameState.attendance.has("1-04-01:homeroom"),"Migrated v2 state restores without losing progress")
	var file := FileAccess.open(SaveSystem.PATH,FileAccess.WRITE)
	file.store_string("{broken json")
	file.close()
	GameState.money = 876
	check(not SaveSystem.load_game() and GameState.money==876,"Corrupt save does not mutate current game")
	check(SaveSystem.save_game(),"Valid save can replace corrupt slot")
	check(SaveSystem.save_game() and FileAccess.file_exists(SaveSystem.PATH+".bak"),"Backup is retained")
	GameState.money = 2
	check(SaveSystem.load_game(true) and GameState.money==876,"Backup recovery")

	# ---- full composition, actual world instances and UI commands.
	var game: Node = load("res://scenes/main.tscn").instantiate()
	add_child(game)
	await get_tree().process_frame
	check(game.world != null and not game.running,"Main menu boots into 3D environment")
	game.start_new({"name":"Teste","skin":"bc896d","hair":"393940","origin":"countryside","talent":"social","traits":["sociable"]})
	check(game.player != null and GameState.scene_id=="bedroom" and GameState.background.talent=="social","New game starts in bedroom with the chosen profile")
	check(GameTime.paused,"Welcome dialogue pauses time")
	game.ui.close_modal()
	check(not GameTime.paused,"Closing dialog resumes time")
	for tab in ["agenda","notebook","stats","social","group","diary"]:
		game.ui.show_phone(tab)
		check(game.ui.current_modal=="phone","Phone tab renders: " + tab)
	var saved_minute := GameTime.minute
	GameTime._process(30)
	check(GameTime.minute==saved_minute,"Phone does not consume game time")
	game.ui.close_modal()
	for step in [1,2,3,4]:
		game.ui.show_character_creator(step)
		check(game.ui.current_modal=="creator","Creator step renders: %d" % step)
	game.ui.creator_draft = {}
	game.ui.close_modal()
	for region in ["home","neighborhood","school_hall","classroom"]:
		game.load_region(region)
		await get_tree().physics_frame
		check(GameState.scene_id==region and game.world.get_child_count()>0,"World loads: " + region)
	GameTime.minute = 505
	GameTime.changed.emit()
	game.npcs.sync()
	check(game.npcs.actors.has("yui") and game.npcs.actors.has("sato") and game.npcs.actors.has("kenta"),"Students and teacher attend classroom by schedule")
	check(game.npcs.actors.yui.seated and game.npcs.actors.yui.position.distance_to(SeatMap.chair_position("B2"))<0.5,"Classmates sit at their mapped seats")
	check(game.npcs.students_in_classroom().size()==5 and game.actions.class_context().neighbors.size()==3,"Class context at 08:25: Tsubasa still in the hall, three neighbours")
	GameTime.minute = 520
	game.npcs.sync()
	check(game.npcs.students_in_classroom().size()==6 and game.actions.class_context().neighbors.size()==4,"Class context at 08:40: six present, four neighbours")
	GameTime.minute = 505
	game.npcs.sync()
	game.actions._reply({"id":"yui","kind":"kind"})
	game.actions._reply({"id":"yui","kind":"kind"})
	check(GameState.relationships.yui==18,"Repeated daily conversation gives no extra affinity (sociable +3)")
	game.ui.close_modal()
	game.actions.show_class()
	check(game.ui.current_modal=="class" and not game.ui.close_allowed and game.actions.session != null,"Homeroom opens a non-dismissible class screen")
	var guard := 0
	while game.actions.session != null and guard < 100:
		guard += 1
		var screen_session: ClassSession = game.actions.session
		var ui_payload: Dictionary = policy("attention").call(screen_session, screen_session.last_screen)
		game.actions.class_command(ui_payload)
	check(game.actions.session==null and GameState.flags.has("class") and GameTime.minute==515 and ClassMissions.completed("m01_first_call"),"UI-driven homeroom completes M-01 and the period")
	check(game.ui.current_modal.is_empty(),"Class screen closes after the summary")
	game.load_region("neighborhood","school")
	GameTime.minute = 950
	game.npcs.sync()
	check(game.npcs.actors.has("ren") and game.npcs.actors.has("yui"),"NPCs follow after-school schedules")
	game.load_region("home","outside")
	game.load_region("bedroom","home")
	game.sleep_day()
	check(GameTime.day==2 and GameTime.minute==390 and GameState.energy==100,"Sleep begins the next playable day")
	check(GameState.flags.has("slept") and GameState.diary.size()==1 and GameState.diary[0].lines.size()==3,"Full First Day loop milestone writes a diary entry")
	check(SaveSystem.load_game() and GameTime.day==2,"Sleep autosave persists next morning")
	game.actions.dispatch("diary_note",{"note":"Primeiro dia."})
	check(GameState.diary[0].note=="Primeiro dia.","Diary note stored")
	GameTime.minute = 1400
	game.sleep_day()
	check(GameState.energy==80 and GameTime.day==3 and GameState.mood.state=="tired","Late sleep applies a mild energy penalty and the tired mood")
	game.ui.close_modal()
	GameTime.minute = 1439
	GameTime.advance(1)
	await get_tree().process_frame
	check(GameTime.day==4 and GameTime.minute==390,"Midnight fallback advances only one day")
	game.ui.close_modal()
	var money_before := GameState.money
	GameTime.day = 7
	game.sleep_day()
	check(GameTime.day==8 and GameState.money==money_before+3000,"Allowance arrives on the second Monday")
	game.ui.close_modal()
	game.sleep_day()
	check(GameState.money==money_before+3000,"Allowance is weekly, not daily")
	game.ui.close_modal()

	# ---- the acceptance run: seven days, every period, no repeated window, three bonds at level 1
	GameState.reset("Semana","efbd98","393940",{"talent":"dedicated"})
	GameTime.reset()
	game.load_region("classroom","hall")
	var all_seen: Array = []
	var duplicates := 0
	var periods_done := 0
	var windows_total := 0
	for day in range(1,8):
		GameTime.day = day
		GameTime.minute = 500
		if GameTime.is_school_day():
			for period in SchoolSchedule.day_periods():
				GameTime.minute = int(period.start)
				GameTime.changed.emit()
				game.npcs.sync()
				var posture_pick := "attention" if day % 2 == 1 else "notes"
				var run_session := ClassSession.new(period, game.actions.class_context())
				var run_seen := drive(run_session, run_session.start(), policy(posture_pick))
				run_session.handle({"cmd":"close"})
				for id in run_seen:
					if all_seen.has(id):
						duplicates += 1
					all_seen.append(id)
				windows_total += run_session.windows
				periods_done += 1
			for id in ["yui","kenta","tsubasa"]:
				game.actions._reply({"id":id,"kind":"kind"})
				game.ui.close_modal()
		DayCycle.close_day(false,false)
		DayCycle.open_day()
	check(periods_done==45,"Seven days: 45 periods played (5 school days × 9)")
	check(duplicates==0 and all_seen.size()>=5,"No Janela de Questão repeated across the week (%d windows)" % all_seen.size())
	var level_ones := 0
	for id in GameState.relationships:
		if GameState.bond_level(str(id))>=1:
			level_ones += 1
	check(level_ones>=3,"Three bonds reach level 1 in the first week")
	check(ClassMissions.completed("m01_first_call") and ClassMissions.completed("m02_sato_question"),"Week missions M-01 and M-02 completed")
	check(GameState.mastery_of("literature")>GameState.attributes.Conhecimento-10 and GameState.diary.size()==7,"Mastery grew and the diary has seven entries")
	check(SaveSystem.save_game() and SaveSystem.load_game(),"Week state saves and loads as v3")

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

