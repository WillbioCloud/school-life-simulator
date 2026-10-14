class_name GameActions
extends Node
## UI commands and playable activity transactions. World geometry contains no UI logic.
var game: Node3D

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
		"phone": ui.show_phone()
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
			ui.open_modal("Feito para começar","CRÉDITOS  /  PRÉ-ALPHA 0.1")
			ui.text_block("School Life — First Day\nDireção de conceito: documento mestre School Life 3D V2.0.\n\nImplementação: Godot 4 e GDScript.\nArte: geometria original criada para este protótipo.\nEngine: Godot Engine, licença MIT.\n\nSem modelos, músicas ou personagens copiados de outras obras. Sem mecânicas agrícolas.")
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
			GameState.energy = minf(100,GameState.energy+20)
			GameTime.advance(30)
			ui.close_modal()
			ui.toast("Uma pausa faz bem. +20 energia · 30 minutos se passaram.")
		"study":
			if not _enough_time(60): return
			if not GameState.spend_energy(10): return
			GameState.improve("Conhecimento",3)
			GameTime.advance(60)
			ui.close_modal()
			ui.toast("Uma página de cada vez. +3 Conhecimento · 60 minutos.")
		"eat":
			if int(GameState.inventory.get("Onigiri",0)) <= 0: return
			if GameState.energy >= 100:
				ui.toast("Você já está com a energia cheia. Guarde o lanche para depois.")
				return
			GameState.inventory.Onigiri -= 1
			GameState.energy = minf(100,GameState.energy+25)
			GameState.changed.emit()
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
		"attend":
			var result := SchoolSchedule.attend(data.get("choice","focus"))
			ui.open_modal("Mais uma página","VIDA ESCOLAR","class_result")
			ui.text_block(result)
			ui.option("Continuar meu dia","close",{},true)
		"reply": _reply(data)

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
		"study": _confirm("Abrir os cadernos?","Estudar por 60 minutos.\n+3 Conhecimento · custo de 10 de energia.\n\nSeu condicionamento não será reduzido: o custo principal é seu tempo.","study")
		"rest": _confirm("Ficar um pouco?","Descanse por 30 minutos e recupere até 20 de energia.","rest")
		"shop":
			ui.open_modal("Um lanche para o caminho","MÁQUINA AUTOMÁTICA  /  ¥ %d" % GameState.money,"shop")
			ui.text_block("Onigiri · ¥200\nRecupera 25 de energia quando consumido pela mochila.\n\nEconomia simplificada para testar compras e persistência.")
			ui.option("Comprar por ¥200","buy",{},true)
		"grandma":
			ui.open_modal("Um bilhete na mesa","CASA DA AVÓ","grandma")
			ui.text_block("“Bom dia, meu bem. Saí cedo para trabalhar. Deixei um onigiri na sua mochila.\n\nSua escola fica seguindo a rua para o norte. Se perder a hora, não se preocupe tanto. O importante é tentar de novo amanhã.\n\nFaça desta casa um lar.\nCom carinho, vovó.”")
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

func show_class() -> void:
	var ui: GameUI = game.ui
	var period := SchoolSchedule.current_or_next(GameTime.minute)
	ui.open_modal("Seu lugar na 1-A","VIDA ESCOLAR  /  %s" % GameTime.clock(),"class")
	if period.is_empty():
		ui.text_block("Não há mais atividades escolares hoje. Você pode explorar, estudar em casa ou descansar.\n\nAs aulas acontecem de segunda a sexta-feira.")
		return
	if GameTime.minute < period.start:
		ui.text_block("A próxima atividade é %s, às %s.\n\nVocê pode esperar na sua carteira. O relógio avançará até o começo — as rotinas dos outros estudantes também." % [period.title,GameTime.clock(period.start)])
		ui.option("Esperar até %s" % GameTime.clock(period.start),"wait_class",{},true)
		return
	ui.text_block("%s · %s–%s\n\nO professor propõe uma atividade. Ao lado, um colega hesita sobre como começar. Como você prefere participar?" % [period.title,GameTime.clock(period.start),GameTime.clock(period.end)])
	ui.option("Prestar atenção e fazer anotações","attend",{"choice":"focus"},true)
	ui.option("Ajudar o colega e aprender junto","attend",{"choice":"help"})
	ui.text_block("A participação avança até o fim do período e consome 5 de energia. Cada atividade pode ser concluída apenas uma vez por dia.")

func _talk(id: String) -> void:
	var data: Dictionary = game.npcs.definition(id)
	if data.is_empty(): return
	var ui: GameUI = game.ui
	game.interacting_npc = game.npcs.actors.get(id)
	if is_instance_valid(game.interacting_npc):
		game.interacting_npc.talking = true
	ui.open_modal(data.name,data.role.to_upper(),"dialogue")
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
	if GameState.talked.get(id,"") != GameTime.stamp():
		GameState.talked[id] = GameTime.stamp()
		GameState.relationships[id] = mini(int(GameState.relationships.get(id,0))+15,1000)
		GameState.improve("Empatia" if payload.kind=="kind" else "Carisma",1)
		GameState.mark("talk")
	game.ui.open_modal(data.name,"UMA PRIMEIRA CONEXÃO","dialogue")
	game.ui.text_block(data.reply)
	game.ui.text_block("+15 vínculo · uma boa conversa hoje. Repetir a conversa neste mesmo dia não concede pontos extras.")
	game.ui.option("Até a próxima","close",{},true)
