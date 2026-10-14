class_name GameUI
extends CanvasLayer
signal command(action: String, payload: Dictionary)
const INK := Color("2d504b")
const MUTED := Color("70847a")
const PAPER := Color("f6f1e4")
const ACCENT := Color("b97860")
var root: Control
var hud: Control
var menu: Control
var overlay: Control
var modal_body: VBoxContainer
var clock_label: Label
var date_label: Label
var season_label: Label
var location_label: Label
var schedule_label: Label
var goal_label: Label
var energy_label: Label
var energy_bar: ProgressBar
var interact_panel: PanelContainer
var interact_label: Label
var toast_label: Label
var toast_remaining: float = 0
var current_modal: String = ""
var playing: bool = false
var close_allowed: bool = true

func _ready() -> void:
	layer = 10
	root = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = _theme()
	add_child(root)
	_build_hud()
	GameTime.changed.connect(refresh)
	GameState.changed.connect(refresh)
	GameState.notice.connect(toast)
	refresh()

func _theme() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 19
	theme.set_color("font_color","Label",INK)
	theme.set_color("font_color","Button",INK)
	theme.set_color("font_hover_color","Button",INK)
	theme.set_color("font_pressed_color","Button",PAPER)
	theme.set_color("font_disabled_color","Button",Color("acafa1"))
	theme.set_stylebox("normal","Button",_style(Color("e6e8d9"),10,16))
	theme.set_stylebox("hover","Button",_style(Color("d7dfcc"),10,16))
	theme.set_stylebox("pressed","Button",_style(INK,10,16))
	theme.set_stylebox("disabled","Button",_style(Color("eceade"),10,16))
	var focus := _style(Color(0,0,0,0),10,0)
	focus.border_color = ACCENT
	focus.set_border_width_all(2)
	theme.set_stylebox("focus","Button",focus)
	theme.set_stylebox("normal","LineEdit",_style(Color("e6e8d9"),8,14))
	theme.set_color("font_color","LineEdit",INK)
	theme.set_color("caret_color","LineEdit",INK)
	theme.set_constant("separation","VBoxContainer",12)
	theme.set_constant("separation","HBoxContainer",12)
	return theme

func _style(color: Color, radius: int = 14, margin: int = 22) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.set_corner_radius_all(radius)
	box.content_margin_left = margin
	box.content_margin_right = margin
	box.content_margin_top = margin
	box.content_margin_bottom = margin
	return box

func label(text: String, size: int = 19, color: Color = INK, wrap: bool = false) -> Label:
	var item := Label.new()
	item.text = text
	item.add_theme_font_size_override("font_size",size)
	item.add_theme_color_override("font_color",color)
	if wrap:
		item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return item

func button(text: String, callback: Callable, primary: bool = false) -> Button:
	var item := Button.new()
	item.text = text
	item.custom_minimum_size.y = 50
	item.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	if primary:
		item.add_theme_stylebox_override("normal",_style(INK,10,16))
		item.add_theme_stylebox_override("hover",_style(Color("3e6b60"),10,16))
		item.add_theme_color_override("font_color",PAPER)
		item.add_theme_color_override("font_hover_color",PAPER)
	item.pressed.connect(callback)
	return item

func _panel(parent: Control, anchors: Vector4, offsets: Vector4) -> PanelContainer:
	var panel := PanelContainer.new()
	parent.add_child(panel)
	panel.anchor_left = anchors.x
	panel.anchor_top = anchors.y
	panel.anchor_right = anchors.z
	panel.anchor_bottom = anchors.w
	panel.offset_left = offsets.x
	panel.offset_top = offsets.y
	panel.offset_right = offsets.z
	panel.offset_bottom = offsets.w
	panel.add_theme_stylebox_override("panel",_style(Color(0.965,0.945,0.893,0.95)))
	return panel

func _build_hud() -> void:
	hud = Control.new()
	root.add_child(hud)
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var context := _panel(hud,Vector4(0,0,0,0),Vector4(30,28,408,145))
	var context_box := VBoxContainer.new()
	context.add_child(context_box)
	context_box.add_child(label("H O S H I K A W A",13,MUTED))
	location_label = label("Bairro residencial",24)
	context_box.add_child(location_label)
	schedule_label = label("Homeroom · 08:25",15,MUTED,true)
	context_box.add_child(schedule_label)
	var time_panel := _panel(hud,Vector4(1,0,1,0),Vector4(-284,28,-30,200))
	var time_box := VBoxContainer.new()
	time_box.add_theme_constant_override("separation",3)
	time_panel.add_child(time_box)
	date_label = label("SEG · 01 ABR",16,MUTED)
	time_box.add_child(date_label)
	clock_label = label("06:30",48)
	time_box.add_child(clock_label)
	season_label = label("Primavera · Céu limpo",15,MUTED)
	time_box.add_child(season_label)
	var goal_panel := _panel(hud,Vector4(0,0,0,0),Vector4(30,166,370,270))
	var goal_box := VBoxContainer.new()
	goal_panel.add_child(goal_box)
	goal_box.add_child(label("SEU PRIMEIRO DIA",12,ACCENT))
	goal_label = label("",16,INK,true)
	goal_box.add_child(goal_label)
	var energy_panel := _panel(hud,Vector4(0,1,0,1),Vector4(30,-121,257,-30))
	var energy_box := VBoxContainer.new()
	energy_panel.add_child(energy_box)
	energy_label = label("Energia · 100",16)
	energy_box.add_child(energy_label)
	energy_bar = ProgressBar.new()
	energy_bar.custom_minimum_size = Vector2(170,7)
	energy_bar.show_percentage = false
	energy_bar.add_theme_stylebox_override("background",_style(Color("dcdcca"),4,0))
	energy_bar.add_theme_stylebox_override("fill",_style(Color("799885"),4,0))
	energy_box.add_child(energy_bar)
	var shortcuts := _panel(hud,Vector4(1,1,1,1),Vector4(-494,-106,-30,-30))
	var row := HBoxContainer.new()
	shortcuts.add_child(row)
	for entry in [["Tab  Celular","phone"],["I  Mochila","bag"],["M  Mapa","map"],["Esc","pause"]]:
		var action: String = entry[1]
		var item := button(entry[0],func(): command.emit(action,{}))
		item.add_theme_font_size_override("font_size",14)
		item.custom_minimum_size.y = 36
		row.add_child(item)
	interact_panel = _panel(hud,Vector4(0.5,1,0.5,1),Vector4(-220,-116,220,-45))
	interact_panel.add_theme_stylebox_override("panel",_style(INK,14,18))
	interact_label = label("E   Interagir",18,PAPER)
	interact_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	interact_panel.add_child(interact_label)
	interact_panel.hide()
	toast_label = label("",18,PAPER,true)
	hud.add_child(toast_label)
	toast_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	toast_label.offset_left = -360
	toast_label.offset_right = 360
	toast_label.offset_top = -196
	toast_label.offset_bottom = -129
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label.add_theme_color_override("font_shadow_color",INK)
	toast_label.add_theme_constant_override("shadow_offset_x",1)
	toast_label.add_theme_constant_override("shadow_offset_y",2)
	toast_label.hide()
	hud.hide()

func refresh() -> void:
	if not is_instance_valid(clock_label):
		return
	date_label.text = GameTime.date_label()
	clock_label.text = GameTime.clock()
	season_label.text = GameTime.season()+" · Céu limpo"
	var names := {"bedroom":"Seu quarto","home":"Casa da avó","neighborhood":"Bairro residencial","school_hall":"Escola Hoshikawa","classroom":"Sala 1-A"}
	location_label.text = names.get(GameState.scene_id,"Hoshikawa")
	schedule_label.text = SchoolSchedule.next_label()
	goal_label.text = GameState.objective()
	energy_label.text = "Energia · %d" % int(GameState.energy)
	energy_bar.value = GameState.energy

func _process(delta: float) -> void:
	if playing:
		energy_bar.value = GameState.energy
		energy_label.text = "Energia · %d" % int(GameState.energy)
	if toast_remaining > 0:
		toast_remaining -= delta
		toast_label.visible = true
	else:
		toast_label.visible = false

func toast(text: String) -> void:
	toast_label.text = text
	toast_remaining = 6

func interaction(text: String) -> void:
	interact_panel.visible = not text.is_empty() and current_modal.is_empty()
	interact_label.text = "E   ·   " + text

func main_menu() -> void:
	playing = false
	GameTime.paused = true
	hud.hide()
	if is_instance_valid(menu):
		menu.queue_free()
	menu = Control.new()
	root.add_child(menu)
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var panel := _panel(menu,Vector4(0,0,0,1),Vector4(0,0,570,0))
	panel.add_theme_stylebox_override("panel",_style(Color(0.965,0.945,0.893,0.97),0,54))
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation",18)
	panel.add_child(box)
	box.add_child(label("H O S H I K A W A    /    J A P Ã O",15,MUTED))
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 28
	box.add_child(spacer)
	box.add_child(label("School\nLife",90))
	box.add_child(label("F I R S T   D A Y",18,ACCENT))
	box.add_child(label("Uma nova cidade. Um novo caderno.\nUma história que começa com você.",21,MUTED,true))
	var fill := Control.new()
	fill.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(fill)
	var continue_button := button("Continuar minha história   →",func(): command.emit("load",{}),true)
	continue_button.disabled = not SaveSystem.exists()
	box.add_child(continue_button)
	box.add_child(button("Novo jogo",show_character_creator,not SaveSystem.exists()))
	var row := HBoxContainer.new()
	box.add_child(row)
	for entry in [["Configurações","settings"],["Créditos","credits"],["Sair","quit"]]:
		var action: String = entry[1]
		var item := button(entry[0],func(): command.emit(action,{}))
		item.add_theme_font_size_override("font_size",15)
		row.add_child(item)
	box.add_child(label("PRÉ-ALPHA 0.1  ·  GODOT 4.7.2\nArte e sistemas em desenvolvimento",13,MUTED))

func begin_play() -> void:
	playing = true
	if is_instance_valid(menu):
		menu.queue_free()
		menu = null
	close_allowed = true
	close_modal()
	hud.show()
	GameTime.paused = false
	refresh()

func open_modal(title: String, kicker: String = "SCHOOL LIFE", id: String = "info", dismissible: bool = true) -> VBoxContainer:
	if is_instance_valid(overlay):
		root.remove_child(overlay)
		overlay.queue_free()
	GameTime.paused = true
	current_modal = id
	close_allowed = dismissible
	overlay = Control.new()
	root.add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new()
	dim.color = Color(0.10,0.19,0.18,0.47)
	overlay.add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := _panel(overlay,Vector4(0.5,0.5,0.5,0.5),Vector4(-380,-338,380,338))
	panel.add_theme_stylebox_override("panel",_style(PAPER,22,32))
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation",17)
	panel.add_child(layout)
	var header := HBoxContainer.new()
	layout.add_child(header)
	var heading := VBoxContainer.new()
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(heading)
	heading.add_child(label(kicker,13,ACCENT))
	heading.add_child(label(title,32))
	if dismissible:
		var close_button := button("×",close_modal)
		close_button.custom_minimum_size = Vector2(48,48)
		header.add_child(close_button)
	var separator := HSeparator.new()
	layout.add_child(separator)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	layout.add_child(scroll)
	modal_body = VBoxContainer.new()
	modal_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	modal_body.add_theme_constant_override("separation",15)
	scroll.add_child(modal_body)
	layout.add_child(label("TEMPO PAUSADO   ·   ESC PARA VOLTAR" if dismissible else "TEMPO PAUSADO   ·   ESCOLHA COMO CONTINUAR",12,MUTED))
	return modal_body

func close_modal() -> void:
	if not close_allowed:
		return
	if is_instance_valid(overlay):
		root.remove_child(overlay)
		overlay.queue_free()
		overlay = null
	current_modal = ""
	GameTime.paused = not playing
	command.emit("modal_closed",{})

func text_block(text: String) -> void:
	modal_body.add_child(label(text,20,INK,true))

func option(text: String, action: String, payload: Dictionary = {}, primary: bool = false) -> void:
	modal_body.add_child(button(text,func(): command.emit(action,payload),primary))

func show_character_creator() -> void:
	open_modal("Um novo começo","CRIE SEU PROTAGONISTA","creator")
	text_block("Você acaba de se mudar para a casa da sua avó em Hoshikawa. Amanhã é o começo de uma nova história — e ela precisa de um nome.")
	modal_body.add_child(label("COMO VOCÊ SE CHAMA?",13,MUTED))
	var name_input := LineEdit.new()
	name_input.text = "Haru"
	name_input.max_length = 24
	name_input.custom_minimum_size.y = 48
	modal_body.add_child(name_input)
	var skin_picker := OptionButton.new()
	for color_name in ["Pele · clara","Pele · média","Pele · morena","Pele · escura"]:
		skin_picker.add_item(color_name)
	skin_picker.custom_minimum_size.y = 46
	modal_body.add_child(skin_picker)
	var hair_picker := OptionButton.new()
	for color_name in ["Cabelo · preto","Cabelo · castanho","Cabelo · acobreado","Cabelo · azul escuro"]:
		hair_picker.add_item(color_name)
	hair_picker.custom_minimum_size.y = 46
	modal_body.add_child(hair_picker)
	modal_body.add_child(label("Aparência simplificada de protótipo. Editor completo planejado.",14,MUTED,true))
	if SaveSystem.exists():
		modal_body.add_child(label("Seu save atual só será substituído quando você salvar ou dormir nesta nova partida.",14,ACCENT,true))
	modal_body.add_child(button("Começar meu primeiro dia   →",func():
		command.emit("new",{"name":name_input.text,"skin":["efbd98","d4a47e","bc896d","805941"][skin_picker.selected],"hair":["393940","76523c","a36344","3a5262"][hair_picker.selected]}),true))

func show_phone(tab: String = "agenda") -> void:
	open_modal("Seu celular","%s  /  %s" % [GameState.player_name,GameTime.date_label()],"phone")
	var tabs := HBoxContainer.new()
	modal_body.add_child(tabs)
	for entry in [["Agenda","agenda"],["Personagem","stats"],["Contatos","social"]]:
		var id: String = entry[1]
		tabs.add_child(button(entry[0],func(): show_phone(id),tab==id))
	if tab == "agenda":
		text_block("%s\n%s" % [GameState.objective(),SchoolSchedule.next_label()])
		SchoolSchedule.load_data()
		for period in SchoolSchedule.periods:
			var key := GameTime.stamp()+":"+str(period.id)
			var suffix := "  ·  concluído" if GameState.attendance.has(key) else ""
			modal_body.add_child(label("%s – %s    %s%s" % [GameTime.clock(period.start),GameTime.clock(period.end),period.title,suffix],16,MUTED,true))
		if not GameTime.is_school_day():
			text_block("Fim de semana: não há aulas hoje. O horário acima é a referência dos dias letivos.")
		option("Abrir calendário de 14 dias","calendar")
	elif tab == "stats":
		text_block("%s · %dº ano · Turma 1-A\n¥ %d  ·  Energia %d/100" % [GameState.player_name,GameTime.year,GameState.money,int(GameState.energy)])
		for key in GameState.attributes:
			modal_body.add_child(label("%s     %d / 100" % [key,GameState.attributes[key]],19))
		text_block("Atividades escolares concluídas: %d\nClube: ainda não disponível neste protótipo." % GameState.attendance.size())
	else:
		if GameState.relationships.is_empty():
			text_block("Uma cidade cheia de novos rostos. Converse com alguém para adicionar seu primeiro contato.")
		for id in GameState.relationships:
			var names := {"yui":"Yui Tanaka","ren":"Ren Mori","sato":"Professor Sato"}
			text_block("%s\nVínculo inicial: %d / 1000" % [names.get(id,id),GameState.relationships[id]])
		modal_body.add_child(label("Esta versão valida apenas conhecer e conversar. Eventos de amizade, convites e romances ainda não foram implementados.",15,MUTED,true))

func show_calendar() -> void:
	open_modal("Seu calendário","ANO ESCOLAR %d  /  %s" % [GameTime.year,GameTime.season()],"calendar")
	text_block("%s · %s\n14 dias por mês. Cada mês começa na segunda-feira." % [GameTime.MONTHS[GameTime.month-1],GameTime.date_label()])
	var grid := GridContainer.new()
	grid.columns = 7
	grid.add_theme_constant_override("h_separation",14)
	grid.add_theme_constant_override("v_separation",14)
	modal_body.add_child(grid)
	for weekday in GameTime.WEEKDAYS:
		var item := label(weekday,15,MUTED)
		item.custom_minimum_size.x = 75
		item.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(item)
	for day in range(1,15):
		var cell := PanelContainer.new()
		cell.custom_minimum_size = Vector2(75,64)
		cell.add_theme_stylebox_override("panel",_style(INK if day==GameTime.day else Color("e6e8d9"),8,8))
		var number := label(str(day),23,PAPER if day==GameTime.day else INK)
		number.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cell.add_child(number)
		grid.add_child(cell)
	text_block("Segunda a sexta · aulas\nSábado e domingo · tempo livre")
	modal_body.add_child(label("Festivais e férias constam do plano de produção, mas ainda não têm eventos jogáveis na versão 0.1.",16,MUTED,true))

func show_map() -> void:
	open_modal("Um pedacinho de Hoshikawa","MAPA  /  EXPLORAÇÃO A PÉ","map")
	modal_body.add_child(TownMap.new())
	text_block("A rua das cerejeiras liga sua casa à escola. No caminho, há uma praça, bancos e uma máquina de lanches.")
	modal_body.add_child(label("Norte: escola  ·  Leste: sua casa\nAs demais regiões serão construídas depois da validação deste ciclo.",16,MUTED,true))

func show_bag() -> void:
	open_modal("Sua mochila","ITENS PESSOAIS  /  ¥ %d" % GameState.money,"bag")
	text_block("Caderno da turma 1-A\nSeu primeiro caderno em Hoshikawa. Ainda há muitas páginas em branco.")
	var count: int = int(GameState.inventory.get("Onigiri",0))
	text_block("Onigiri × %d\nUm lanche simples. Recupera 25 de energia." % count)
	if count > 0:
		option("Comer um onigiri","eat",{},true)
	modal_body.add_child(label("Dinheiro e inventário são preservados no salvamento.",16,MUTED,true))

func show_pause() -> void:
	open_modal("Um momento para respirar","PAUSA","pause")
	option("Voltar ao meu dia","close",{},true)
	option("Salvar jogo","save")
	option("Carregar último salvamento…","confirm_load")
	option("Configurações e controles","settings")
	option("Voltar ao início…","confirm_title")

func show_settings() -> void:
	open_modal("Do seu jeito","CONFIGURAÇÕES  /  COMPARAÇÃO DE CÂMERAS","settings")
	text_block("Câmera atual: %s" % ("perspectiva suave · FOV 34°" if GameState.camera_perspective else "ortográfica · elevada e fixa"))
	option("Alternar ortográfica / perspectiva","camera")
	option("Sombras: %s" % ("ligadas" if GameState.shadows else "desligadas"),"shadows")
	option("Alternar tela cheia / janela","fullscreen")
	text_block("WASD / setas · mover     Shift · correr\nE · interagir     Roda do mouse · zoom\nTab · celular     I · mochila     M · mapa\nEsc · fechar painel / pausar")
	modal_body.add_child(label("Menus e conversas pausam o tempo. Opções gráficas adicionais, áudio e controle estão planejados. As preferências desta tela duram esta sessão.",15,MUTED,true))
