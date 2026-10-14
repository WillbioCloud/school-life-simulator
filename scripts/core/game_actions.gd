class_name GameActions
extends Node
## UI commands and playable activity transactions. World geometry contains no UI logic.
var game: Node3D
var session: ClassSession

func dispatch(action: String, data: Dictionary) -> void:
	var ui: GameUI = game.ui
	match action:
		"new": game.start_new(data)
		"load": game.load_saved()
		"load_backup": game.load_saved(true)
		"save":
			game.save_current()
			ui.close_modal()
		"close": ui.close_modal()
		"modal_closed":
			if is_instance_valid(game.interacting_npc):
				game.interacting_npc.talking = false
			game.interacting_npc = null
		"phone": ui.show_phone(str(data.get("tab", "agenda")))
		"bag": ui.show_bag()
		"map": ui.show_map()
		"calendar": ui.show_calendar()
		"pause": ui.show_pause()
		"settings": ui.show_settings()
		"camera":
			game.camera.set_projection(not GameState.camera_perspective)
			ui.show_settings()
		"shadows":
			GameState.shadows = not GameState.shadows
			game.light.update_lighting()
			ui.show_settings()
		"fullscreen":
			var fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if fullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN)
		"credits":
			ui.open_modal("Feito para começar","CRÉDITOS  /  PRÉ-ALPHA 0.2")
			ui.text_block("School Life — First Week\nDireção de conceito: documento mestre School Life 3D V3.0.\n\nImplementação: Godot 4 e GDScript.\nArte: geometria original criada para este protótipo.\nEngine: Godot Engine, licença MIT.\n\nSem modelos, músicas ou personagens copiados de outras obras. Sem mecânicas agrícolas.")
		"quit":
			if OS.has_feature("web"):
				ui.open_modal("Até a próxima","SCHOOL LIFE")
				ui.text_block("Você pode fechar esta aba do navegador.")
			else:
				get_tree().quit()
		"confirm_title":
			_confirm("Voltar ao início?","O progresso desde o último salvamento será perdido.","title")
		"confirm_load":
			_confirm("Carregar sua história?","O progresso não salvo será substituído pelo último save.","load")
		"title": game.return_to_title()
		"sleep": game.sleep_day()
		"rest":
			if not _enough_time(30): return
			GameState.restore_energy(20)
			GameTime.advance(30)
			ui.close_modal()
			ui.toast("Uma pausa faz bem. +20 energia · 30 minutos se passaram.")
		"study":
			if not _enough_time(60): return
			if not GameState.spend_energy(10): return
			var subject := str(data.get("subject", _weakest_subject()))
			var applied := GameState.gain_mastery(subject, 3)
			GameTime.advance(60)
			ui.close_modal()
			GameState.log_day("Estudou %s em casa." % Timetable.subject_name(subject))
			ui.toast("Uma página de cada vez. +%d Domínio em %s · 60 minutos." % [applied, Timetable.subject_name(subject)] if applied > 0 else "Você releu tudo, mas o Domínio de %s já atingiu o teto de hoje (+6). 60 minutos." % Timetable.subject_name(subject))
		"eat":
			if int(GameState.inventory.get("Onigiri",0)) <= 0: return
			if GameState.energy >= 100:
				ui.toast("Você já está com a energia cheia. Guarde o lanche para depois.")
				return
			GameState.inventory.Onigiri -= 1
			GameState.restore_energy(25)
			ui.show_bag()
		"buy":
			if GameState.money < 200:
				ui.text_block("Você não tem ienes suficientes.")
				return
			GameState.money -= 200
			GameState.inventory.Onigiri = int(GameState.inventory.get("Onigiri",0))+1
			GameState.changed.emit()
			ui.close_modal()
			ui.toast("Onigiri guardado na mochila. −¥200")
		"wait_class":
			var period := SchoolSchedule.current_or_next(GameTime.minute)
			if not period.is_empty():
				GameTime.advance(maxi(0,int(period.start)-GameTime.minute))
			show_class()
		"class_cmd": class_command(data)
		"reply": _reply(data)
		"diary_note": _diary_note(str(data.get("note", "")))

func interact(point: InteractionPoint) -> void:
	var ui: GameUI = game.ui
	match point.action:
		"door": game.transition(point.payload.scene,point.payload.spawn)
		"calendar": ui.show_calendar()
		"inspect":
			ui.open_modal(point.payload.title,"HOSHIKAWA")
			ui.text_block(point.payload.text)
		"sleep":
			_confirm("Encerrar o dia?","Dormir avança apenas um dia e salva o progresso. Você acordará às 06:30.\n\nDormir depois das 23:00 deixa um pouco de cansaço na manhã seguinte.","sleep")
		"study": _study_menu()
		"rest": _confirm("Ficar um pouco?","Descanse por 30 minutos e recupere até 20 de energia.","rest")
		"shop":
			ui.open_modal("Um lanche para o caminho","MÁQUINA AUTOMÁTICA  /  ¥ %d" % GameState.money,"shop")
			ui.text_block("Onigiri · ¥200\nRecupera 25 de energia quando consumido pela mochila.\n\nEconomia simplificada para testar compras e persistência.")
			ui.option("Comprar por ¥200","buy",{},true)
		"grandma":
			ui.open_modal("Um bilhete na mesa","CASA DA AVÓ","grandma")
			ui.text_block("“Bom dia, meu bem. Saí cedo para trabalhar. Deixei um onigiri na sua mochila.\n\nSua escola fica seguindo a rua para o norte. Se perder a hora, não se preocupe tanto. O importante é tentar de novo amanhã.\n\nFaça desta casa um lar.\nCom carinho, vovó.”")
			if not GameState.flags.has("grandma_note"):
				GameState.mark("grandma_note")
				if GameState.add_card("jl_u1_c01"):
					ui.text_block("Embaixo do bilhete, um marcador de livro antigo com um haicai escrito à mão. Primeiro Cartão de Literatura: Haicai e as estações.")
			ui.option("Guardar o bilhete com carinho","close",{},true)
		"class": show_class()
		"npc": _talk(point.payload.id)

func _confirm(title: String, text: String, action: String) -> void:
	game.ui.open_modal(title,"UMA ESCOLHA DO SEU DIA","confirm")
	game.ui.text_block(text)
	game.ui.option("Sim, continuar","%s" % action,{},true)
	game.ui.option("Agora não","close")

func _enough_time(duration: int) -> bool:
	if GameTime.minute+duration >= 1440:
		game.ui.text_block("Está muito tarde para começar. É hora de voltar para a cama.")
		return false
	return true

func _weakest_subject() -> String:
	var best := "literature"
	for id in Timetable.core_subjects():
		if GameState.mastery_of(str(id)) < GameState.mastery_of(best):
			best = str(id)
	return best

func _study_menu() -> void:
	var ui: GameUI = game.ui
	ui.open_modal("Abrir os cadernos?","ESTUDO EM CASA  /  60 MINUTOS","study")
	ui.text_block("Estudar por 60 minutos custa 10 de energia e rende +3 Domínio na matéria escolhida (teto diário de +6 por matéria). A cada 10 pontos de Domínio, +1 Conhecimento.")
	for id in Timetable.core_subjects():
		if id == "pe":
			continue
		ui.option("%s  ·  Domínio %d" % [Timetable.subject_name(str(id)), GameState.mastery_of(str(id))], "study", {"subject": id}, id == _weakest_subject())
	ui.option("Agora não","close")

# ---------------------------------------------------------------- classes (seção 46)

## Who is in the classroom now, which of them sit next to the player, and their sheets.
func class_context() -> Dictionary:
	var present: Array = game.npcs.students_in_classroom()
	var npcs: Dictionary = {}
	for data in game.npcs.definitions:
		npcs[str(data.id)] = data
	var neighbors: Dictionary = {}
	var around := SeatMap.neighbors_of_player()
	for direction in around:
		if present.has(str(around[direction])):
			neighbors[direction] = str(around[direction])
	return {"present": present, "neighbors": neighbors, "npcs": npcs}

func show_class() -> void:
	var ui: GameUI = game.ui
	var period := SchoolSchedule.current_or_next(GameTime.minute)
	if period.is_empty():
		ui.open_modal("Seu lugar na 1-A","VIDA ESCOLAR  /  %s" % GameTime.clock(),"class")
		ui.text_block("Não há mais atividades escolares hoje. Você pode explorar, estudar em casa ou descansar.\n\nAs aulas acontecem de segunda a sexta-feira.")
		return
	if SchoolSchedule.attended(period):
		ui.open_modal("Seu lugar na 1-A","VIDA ESCOLAR  /  %s" % GameTime.clock(),"class")
		ui.text_block("Você já participou de %s hoje. %s" % [period.title, SchoolSchedule.next_label()])
		return
	if GameTime.minute < int(period.start):
		ui.open_modal("Seu lugar na 1-A","VIDA ESCOLAR  /  %s" % GameTime.clock(),"class")
		ui.text_block("A próxima atividade é %s, às %s.\n\nVocê pode esperar na sua carteira. O relógio avançará até o começo — as rotinas dos outros estudantes também." % [period.title,GameTime.clock(period.start)])
		ui.option("Esperar até %s" % GameTime.clock(period.start),"wait_class",{},true)
		return
	session = ClassSession.new(period, class_context())
	ui.render_screen(session.start())

func class_command(payload: Dictionary) -> void:
	if session == null:
		game.ui.close_modal()
		return
	var screen := session.handle(payload)
	if session.finished or screen.is_empty():
		session = null
		game.ui.close_allowed = true
		game.ui.close_modal()
		if GameState.flags.has("class") and not GameState.flags.has("slept"):
			game.ui.toast("Período concluído. Quando o dia acabar, volte ao quarto e durma.")
		return
	game.ui.render_screen(screen)

# ---------------------------------------------------------------- conversations

func _talk(id: String) -> void:
	var data: Dictionary = game.npcs.definition(id)
	if data.is_empty(): return
	var ui: GameUI = game.ui
	game.interacting_npc = game.npcs.actors.get(id)
	if is_instance_valid(game.interacting_npc):
		game.interacting_npc.talking = true
	ui.open_modal(data.name,"%s  ·  %s" % [str(data.role).to_upper(), GameState.bond_level_name(id).to_upper()],"dialogue")
	var already: bool = GameState.talked.get(id,"") == GameTime.stamp()
	ui.text_block(data.repeat if already else data.intro)
	if already:
		ui.option("Até mais!","close",{},true)
	else:
		ui.option("Vai ser bom conhecer você melhor.","reply",{"id":id,"kind":"kind"},true)
		ui.option("Você parece ter planos para hoje!","reply",{"id":id,"kind":"curious"})

func _reply(payload: Dictionary) -> void:
	var id: String = payload.id
	var data: Dictionary = game.npcs.definition(id)
	if data.is_empty(): return
	var gained := 0
	if GameState.talked.get(id,"") != GameTime.stamp():
		GameState.talked[id] = GameTime.stamp()
		gained = 15
		if GameState.has_trait("sociable"):
			gained += 3
		if GameState.has_trait("playful") and id == "tsubasa" and not GameState.flags.has("playful_tsubasa"):
			GameState.mark("playful_tsubasa")
			gained += 50
		GameState.add_bond(id, gained)
		GameState.improve("Empatia" if payload.kind=="kind" else "Carisma",1)
		GameState.mark("talk")
		GameState.log_day("Conversou com %s." % str(data.name).split(" ")[0])
	game.ui.open_modal(data.name,"UMA PRIMEIRA CONEXÃO  ·  %s" % GameState.bond_level_name(id).to_upper(),"dialogue")
	game.ui.text_block(data.reply)
	game.ui.text_block(("+%d vínculo · uma boa conversa hoje." % gained if gained > 0 else "Vocês já conversaram hoje.") + " Repetir a conversa neste mesmo dia não concede pontos extras.")
	game.ui.option("Até a próxima","close",{},true)

func _diary_note(note: String) -> void:
	if GameState.diary.is_empty():
		return
	GameState.diary[GameState.diary.size() - 1].note = note.strip_edges().left(140)
	game.ui.close_modal()
	game.ui.toast("Anotação guardada no diário.")
