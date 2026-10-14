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
## Set by Game: resolves character ids to display names (NPCManager.display_name).
var resolve_name: Callable = func(id: String) -> String: return id.capitalize()

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
	goal_box.add_child(label("SUA PRIMEIRA SEMANA",12,ACCENT))
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
	energy_label.text = "Energia · %d   ·   %s" % [int(GameState.energy), GameState.mood_name()]
	energy_bar.value = GameState.energy

func _process(delta: float) -> void:
	if playing:
		energy_bar.value = GameState.energy
		energy_label.text = "Energia · %d   ·   %s" % [int(GameState.energy), GameState.mood_name()]
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
	box.add_child(label("F I R S T   W E E K",18,ACCENT))
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
	box.add_child(label("PRÉ-ALPHA 0.2  ·  GODOT 4.7.2\nArte e sistemas em desenvolvimento",13,MUTED))

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

func speech(speaker: String, text: String) -> void:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation",2)
	box.add_child(label(speaker.to_upper(),12,ACCENT))
	box.add_child(label(text,20,INK,true))
	modal_body.add_child(box)

func card_block(text: String) -> void:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel",_style(Color("eef0e2"),10,16))
	panel.add_child(label(text,17,INK,true))
	modal_body.add_child(panel)

## Renders a "screen" dictionary produced by ClassSession (seção 46.3): body blocks, option
## buttons, an answer grid and tool buttons. Every button emits command("class_cmd", payload).
func render_screen(screen: Dictionary) -> void:
	if screen.is_empty():
		return
	open_modal(str(screen.get("title","Aula")),str(screen.get("kicker","VIDA ESCOLAR")),"class",false)
	for block in screen.get("body",[]):
		if block is String:
			text_block(block)
		elif block.has("speaker"):
			speech(str(block.speaker),str(block.text))
		elif block.has("muted"):
			modal_body.add_child(label(str(block.muted),15,MUTED,true))
		elif block.has("card"):
			card_block(str(block.card))
		else:
			text_block(str(block.get("text","")))
	var grid_items: Array = screen.get("grid",[])
	if not grid_items.is_empty():
		var grid := GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation",12)
		grid.add_theme_constant_override("v_separation",12)
		modal_body.add_child(grid)
		for entry in grid_items:
			var payload: Dictionary = entry.payload
			var item := button(str(entry.text),func(): command.emit("class_cmd",payload))
			item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			item.custom_minimum_size = Vector2(320,58)
			item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			item.alignment = HORIZONTAL_ALIGNMENT_LEFT
			grid.add_child(item)
	var tools: Array = screen.get("tools",[])
	if not tools.is_empty():
		var row := HBoxContainer.new()
		modal_body.add_child(row)
		for entry in tools:
			var payload: Dictionary = entry.payload
			var item := button(str(entry.text),func(): command.emit("class_cmd",payload))
			item.add_theme_font_size_override("font_size",15)
			item.custom_minimum_size.y = 40
			row.add_child(item)
	for entry in screen.get("options",[]):
		var payload: Dictionary = entry.payload
		var item := button(str(entry.text),func(): command.emit("class_cmd",payload),bool(entry.get("primary",false)))
		item.disabled = bool(entry.get("disabled",false))
		item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		modal_body.add_child(item)
		var hint := str(entry.get("hint",""))
		if not hint.is_empty():
			modal_body.add_child(label(hint,13,MUTED,true))
	if screen.has("footer"):
		modal_body.add_child(label(str(screen.footer),13,MUTED,true))

## Four-step creator (seção 45.2): identity, origin, talent, traits. Steps share one draft dictionary.
var creator_draft: Dictionary = {}

func show_character_creator(step: int = 1) -> void:
	if step == 1 and creator_draft.is_empty():
		creator_draft = {"name":"Haru","skin":0,"hair":0,"origin":"capital","reason":"own_choice","talent":"dedicated","traits":[]}
	var titles := {1:"Um novo começo",2:"De onde você vem",3:"O que você faz bem",4:"Como você é"}
	open_modal(str(titles[step]),"CRIE SEU PROTAGONISTA  ·  PASSO %d DE 4" % step,"creator")
	match step:
		1: _creator_identity()
		2: _creator_origin()
		3: _creator_talent()
		4: _creator_traits()

func _creator_nav(step: int, next_text: String = "Próximo   →") -> void:
	var row := HBoxContainer.new()
	modal_body.add_child(row)
	if step > 1:
		row.add_child(button("←   Voltar",func(): show_character_creator(step-1)))
	var forward := button(next_text,func():
		if step < 4:
			show_character_creator(step+1)
		else:
			var draft := creator_draft.duplicate(true)
			creator_draft = {}
			command.emit("new",{"name":draft.name,"skin":["efbd98","d4a47e","bc896d","805941"][draft.skin],"hair":["393940","76523c","a36344","3a5262"][draft.hair],
				"origin":draft.origin,"reason":draft.reason,"talent":draft.talent,"traits":draft.traits}),true)
	forward.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(forward)

func _creator_identity() -> void:
	text_block("Você acaba de se mudar para a casa da sua avó em Hoshikawa. Amanhã é o começo de uma nova história — e ela precisa de um nome.")
	modal_body.add_child(label("COMO VOCÊ SE CHAMA?",13,MUTED))
	var name_input := LineEdit.new()
	name_input.text = str(creator_draft.name)
	name_input.max_length = 24
	name_input.custom_minimum_size.y = 48
	name_input.text_changed.connect(func(value: String): creator_draft.name = value)
	modal_body.add_child(name_input)
	var skin_picker := OptionButton.new()
	for color_name in ["Pele · clara","Pele · média","Pele · morena","Pele · escura"]:
		skin_picker.add_item(color_name)
	skin_picker.selected = int(creator_draft.skin)
	skin_picker.custom_minimum_size.y = 46
	skin_picker.item_selected.connect(func(index: int): creator_draft.skin = index)
	modal_body.add_child(skin_picker)
	var hair_picker := OptionButton.new()
	for color_name in ["Cabelo · preto","Cabelo · castanho","Cabelo · acobreado","Cabelo · azul escuro"]:
		hair_picker.add_item(color_name)
	hair_picker.selected = int(creator_draft.hair)
	hair_picker.custom_minimum_size.y = 46
	hair_picker.item_selected.connect(func(index: int): creator_draft.hair = index)
	modal_body.add_child(hair_picker)
	modal_body.add_child(label("Aparência simplificada de protótipo. Editor completo planejado.",14,MUTED,true))
	if SaveSystem.exists():
		modal_body.add_child(label("Seu save atual só será substituído quando você salvar ou dormir nesta nova partida.",14,ACCENT,true))
	_creator_nav(1)

func _creator_origin() -> void:
	text_block("Ninguém chega a Hoshikawa por acaso. De onde você veio — e por quê?")
	modal_body.add_child(label("ORIGEM",13,MUTED))
	var descriptions := {"capital":"Trânsito, trens lotados e silêncio em casa. Você começa com um Cartão de trem antigo.",
		"countryside":"Montanhas, vizinhos que sabem seu nome. Você começa com um Amuleto do vilarejo.",
		"abroad":"Alguns anos fora do Japão. +15 Domínio em Inglês, −5 em Literatura. Você começa com um Caderno bilíngue."}
	for id in GameState.ORIGINS:
		var origin_id: String = id
		modal_body.add_child(button("%s%s" % [GameState.ORIGINS[id].name, "   ✓" if creator_draft.origin == id else ""],func():
			creator_draft.origin = origin_id
			show_character_creator(2),creator_draft.origin == id))
		modal_body.add_child(label(descriptions[id],13,MUTED,true))
	modal_body.add_child(label("MOTIVO DA MUDANÇA",13,MUTED))
	var reason_picker := OptionButton.new()
	var reason_ids: Array = GameState.REASONS.keys()
	for id in reason_ids:
		reason_picker.add_item(GameState.REASONS[id])
	reason_picker.selected = reason_ids.find(creator_draft.reason)
	reason_picker.custom_minimum_size.y = 46
	reason_picker.item_selected.connect(func(index: int): creator_draft.reason = reason_ids[index])
	modal_body.add_child(reason_picker)
	_creator_nav(2)

func _creator_talent() -> void:
	text_block("Todo mundo chega com alguma coisa. O talento define seus atributos iniciais e um bônus de Domínio.")
	var descriptions := {"dedicated":"Estuda com método. Conhecimento e Disciplina altos.","athlete":"Corre todas as manhãs. Condicionamento alto.",
		"artist":"Desenha em qualquer papel. Criatividade alta.","social":"Faz amigos em cinco minutos. Carisma alto."}
	for id in GameState.TALENTS:
		var talent_id: String = id
		var talent: Dictionary = GameState.TALENTS[id]
		var stats: Array = []
		for key in talent.stats:
			stats.append("%s %d" % [key.left(4), talent.stats[key]])
		modal_body.add_child(button("%s%s" % [talent.name, "   ✓" if creator_draft.talent == id else ""],func():
			creator_draft.talent = talent_id
			show_character_creator(3),creator_draft.talent == id))
		modal_body.add_child(label("%s\n%s · +10 Domínio em %s · item: %s" % [descriptions.get(id,""), " · ".join(stats), Timetable.subject_name(str(talent.mastery)), talent.item],13,MUTED,true))
	_creator_nav(3)

func _creator_traits() -> void:
	text_block("Escolha até dois traços. Eles mudam pequenas coisas: o custo de ignorar um bilhete, a chance de um flagrante, quem gosta de você primeiro.")
	var descriptions := {"curious":"Em aula, 20% de chance de um cartão extra ao prestar atenção.","shy":"Ignorar bilhetes e recusar conversas não custa nada.",
		"sociable":"+3 vínculo em toda conversa.","competitive":"Acertar perguntas difíceis rende um pouco mais de reputação (próximo marco).",
		"careful":"Risco de flagrante em aula reduzido pela metade.","playful":"Tsubasa gosta de você de cara: +50 vínculo na primeira conversa.",
		"dreamer":"Sabor por enquanto: muda falas e o diário em marcos futuros.","practical":"Sabor por enquanto: muda falas e o diário em marcos futuros.",
		"stubborn":"Sabor por enquanto: muda falas e o diário em marcos futuros.","observant":"Sabor por enquanto: muda falas e o diário em marcos futuros."}
	var picked: Array = creator_draft.traits
	for id in GameState.TRAITS:
		var trait_id: String = id
		var selected := picked.has(id)
		var item := button("%s%s" % [GameState.TRAITS[id], "   ✓" if selected else ""],func():
			if picked.has(trait_id):
				picked.erase(trait_id)
			elif picked.size() < 2:
				picked.append(trait_id)
			show_character_creator(4),selected)
		item.disabled = not selected and picked.size() >= 2
		modal_body.add_child(item)
		modal_body.add_child(label(descriptions.get(id,""),13,MUTED,true))
	modal_body.add_child(label("%s · %s · %s · %s" % [creator_draft.name, GameState.ORIGINS[creator_draft.origin].name, GameState.TALENTS[creator_draft.talent].name, ", ".join(picked.map(func(t): return GameState.TRAITS[t])) if not picked.is_empty() else "sem traços"],15,INK,true))
	_creator_nav(4,"Começar minha primeira semana   →")

func show_phone(tab: String = "agenda") -> void:
	open_modal("Seu celular","%s  /  %s" % [GameState.player_name,GameTime.date_label()],"phone")
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation",6)
	modal_body.add_child(tabs)
	for entry in [["Agenda","agenda"],["Caderno","notebook"],["Personagem","stats"],["Contatos","social"],["Turma","group"],["Diário","diary"]]:
		var id: String = entry[1]
		var item := button(entry[0],func(): show_phone(id),tab==id)
		item.add_theme_font_size_override("font_size",14)
		item.custom_minimum_size = Vector2(0,38)
		tabs.add_child(item)
	match tab:
		"agenda": _phone_agenda()
		"notebook": _phone_notebook()
		"stats": _phone_stats()
		"social": _phone_social()
		"group": _phone_group()
		"diary": _phone_diary()

func _phone_agenda() -> void:
	text_block("%s\n%s" % [GameState.objective(),SchoolSchedule.next_label()])
	if GameTime.is_school_day():
		for period in SchoolSchedule.day_periods():
			var suffix := "  ·  concluído" if SchoolSchedule.attended(period) else ""
			modal_body.add_child(label("%s – %s    %s%s" % [GameTime.clock(period.start),GameTime.clock(period.end),period.title,suffix],16,MUTED,true))
	else:
		text_block("Fim de semana: não há aulas hoje. Segunda-feira o horário da 1-A recomeça com Homeroom às 08:25.")
	var next_allowance := "Mesada: ¥%d toda segunda-feira, a partir de 8 de abril." % GameState.ALLOWANCE
	modal_body.add_child(label(next_allowance,14,MUTED,true))
	option("Abrir calendário de 14 dias","calendar")

func _phone_notebook() -> void:
	text_block("Domínio por matéria (0–100). Cada aula rende no máximo +6 por dia; a cada 10 pontos, +1 Conhecimento.")
	for id in Timetable.core_subjects():
		var subject_id: String = id
		var owned := 0
		var total := QuestionBank.card_ids(subject_id,1).size()
		for card in QuestionBank.card_ids(subject_id,1):
			if GameState.cards.has(card):
				owned += 1
		var pages := int(GameState.notebook_pages.get(subject_id,0))
		var line := "%s     %d / 100" % [Timetable.subject_name(subject_id), GameState.mastery_of(subject_id)]
		if total > 0:
			line += "     cartões %d/%d" % [owned,total]
		if pages > 0:
			line += "     páginas %d" % pages
		modal_body.add_child(label(line,17))
	if GameState.cards.is_empty():
		modal_body.add_child(label("Nenhum cartão ainda. Prestar atenção ou anotar em aula revela Cartões da unidade.",15,MUTED,true))
	else:
		modal_body.add_child(label("CARTÕES",13,ACCENT))
		for id in GameState.cards:
			var card := QuestionBank.card(str(id))
			if not card.is_empty():
				card_block("%s — %s" % [card.title, card.text])

func _phone_stats() -> void:
	var talent: Dictionary = GameState.TALENTS.get(str(GameState.background.get("talent","dedicated")),{})
	text_block("%s · %dº ano · Turma 1-A · carteira %s\n¥ %d  ·  Energia %d/100  ·  Humor: %s" % [GameState.player_name,GameTime.year,SeatMap.player_seat(),GameState.money,int(GameState.energy),GameState.mood_name()])
	modal_body.add_child(label("%s · %s · %s" % [GameState.ORIGINS.get(str(GameState.background.get("origin","capital")),{}).get("name","Capital"), talent.get("name","Dedicado"), ", ".join(GameState.background.get("traits",[]).map(func(t): return GameState.TRAITS.get(t,t))) if not GameState.background.get("traits",[]).is_empty() else "sem traços"],15,MUTED,true))
	for key in GameState.attributes:
		modal_body.add_child(label("%s     %d / 100" % [key,GameState.attributes[key]],19))
	var rep: Dictionary = GameState.reputation
	text_block("Reputação — acadêmica %d · social %d · esportiva %d · institucional %d\nOcorrências no trimestre: %d\nPeríodos concluídos: %d · Perguntas respondidas: %d (certas: %d)" % [rep.get("academic",0),rep.get("social",0),rep.get("sports",0),rep.get("institutional",0),int(GameState.discipline.get("term_points",0)),GameState.attendance.size(),GameState.counter("questions_answered"),GameState.counter("questions_correct")])
	for item in GameState.inventory:
		if str(item) != "Onigiri":
			modal_body.add_child(label("Item pessoal: %s" % item,15,MUTED))
	modal_body.add_child(label("Clube: ainda não disponível neste protótipo.",15,MUTED,true))

func _phone_social() -> void:
	if GameState.relationships.is_empty():
		text_block("Uma cidade cheia de novos rostos. Converse com alguém para adicionar seu primeiro contato.")
	var ids: Array = GameState.relationships.keys()
	ids.sort_custom(func(a, b): return GameState.bond(a) > GameState.bond(b))
	for id in ids:
		var name := str(resolve_name.call(str(id)))
		var seat := SeatMap.seat_of(str(id))
		var level := GameState.bond_level(str(id))
		var next_threshold := int(GameState.BOND_LEVELS[level]) if level < GameState.BOND_LEVELS.size() else 1000
		text_block("%s%s\n%s · %d / %d" % [name, ("  ·  carteira %s" % seat) if not seat.is_empty() else "", GameState.bond_level_name(str(id)), GameState.bond(str(id)), next_threshold])
	modal_body.add_child(label("Níveis de vínculo: 50 Conhecido · 150 Colega · 300 Amigo. Conversas, bilhetes e ajuda em aula contam.",15,MUTED,true))

func _phone_group() -> void:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/messages.json"))
	text_block(str(data.get("group","Grupo da 1-A")))
	var shown := 0
	for message in data.get("messages",[]):
		var when := int(message.month) * 10000 + int(message.day) * 100 + 0
		var now := GameTime.month * 10000 + GameTime.day * 100
		if when > now or (when == now and int(message.minute) > GameTime.minute):
			continue
		shown += 1
		var sender := str(resolve_name.call(str(message.from)))
		var box := VBoxContainer.new()
		box.add_theme_constant_override("separation",2)
		box.add_child(label("%s  ·  %02d/%02d %s" % [sender.to_upper(), int(message.day), int(message.month), GameTime.clock(int(message.minute))],12,ACCENT))
		box.add_child(label(str(message.text),17,INK,true))
		modal_body.add_child(box)
	if shown == 0:
		modal_body.add_child(label("Ainda sem mensagens. O grupo da turma começa a se mexer depois do primeiro dia.",15,MUTED,true))
	modal_body.add_child(label("Somente leitura nesta versão: responder no grupo chega com o sistema de mensagens (marco 0.3).",14,MUTED,true))

func _phone_diary() -> void:
	if GameState.diary.is_empty():
		text_block("O diário começa na primeira noite. Ao dormir, o jogo resume o dia em três linhas e você pode acrescentar uma frase sua.")
	var entries: Array = GameState.diary.duplicate()
	entries.reverse()
	for entry in entries:
		var box := VBoxContainer.new()
		box.add_theme_constant_override("separation",3)
		box.add_child(label(str(entry.get("date","")),12,ACCENT))
		for line in entry.get("lines",[]):
			box.add_child(label("· " + str(line),16,INK,true))
		if not str(entry.get("note","")).is_empty():
			box.add_child(label("“%s”" % entry.note,16,MUTED,true))
		modal_body.add_child(box)
	if not GameState.day_log.is_empty():
		modal_body.add_child(label("HOJE, ATÉ AGORA",13,ACCENT))
		for line in GameState.day_log:
			modal_body.add_child(label("· " + str(line),15,MUTED,true))

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
