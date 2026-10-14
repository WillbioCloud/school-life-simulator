class_name ClassSession
extends RefCounted
## One school period as a small state machine (seção 46.3). It produces "screens" — plain
## dictionaries that GameUI renders — and consumes commands; it never touches UI nodes.
## Plans, questions and risks come from SeededRng(date + period), so reloading changes nothing.
const BLOCK_MINUTES := 10
const HELP_BOND_LEVEL := 2
const HELP_MASTERY := 40

var period: Dictionary
var subject: Dictionary = {}
var subject_id: String = ""
var teacher: String = "Professor Sato"
var context: Dictionary = {}
var rng: SeededRng
var stamp: String = ""
var key: String = ""
var late_by: int = 0
var blocks_total: int = 1
var block: int = 0
var posture: Dictionary = {}
var posture_target: String = ""
var caught: bool = false
var plan: Array = []
var mission: Dictionary = {}
var mission_step: Dictionary = {}
var pending: Dictionary = {}
var ticker: Array = []
var summary: Array = []
var moments_done: Array = []
var occurrences: int = 0
var windows: int = 0
var questions_asked: int = 0
var finished: bool = false
var started: bool = false
var stay_until_end: bool = false
var last_screen: Dictionary = {}

func _init(p_period: Dictionary, p_context: Dictionary = {}) -> void:
	period = p_period
	context = p_context
	subject_id = str(period.get("subject", ""))
	subject = Timetable.subject(subject_id)
	teacher = str(period.get("teacher", "Professor Sato"))
	stamp = GameTime.stamp()
	key = SchoolSchedule.attendance_key(period)
	rng = SeededRng.from_string(stamp + ":" + str(period.id))

# ---------------------------------------------------------------- context helpers

func npc(id: String) -> Dictionary:
	return context.get("npcs", {}).get(id, {})

func npc_name(id: String) -> String:
	var data := npc(id)
	if data.is_empty():
		return str(Timetable.subject(subject_id).get("teacher_name", id.capitalize())) if id == Timetable.teacher_id(subject_id) else id.capitalize()
	return str(data.name).split(" ")[0]

func neighbor_present(id: String) -> bool:
	return context.get("present", []).has(id)

## Present neighbours by direction → id.
func neighbors() -> Dictionary:
	var result: Dictionary = {}
	var map: Dictionary = context.get("neighbors", {})
	for direction in map:
		var id := str(map[direction])
		if not id.is_empty() and neighbor_present(id):
			result[direction] = id
	return result

func neighbor_ids() -> Array:
	return neighbors().values()

func best_neighbor_bond() -> int:
	var best := 0
	for id in neighbor_ids():
		best = maxi(best, GameState.bond(str(id)))
	return best

## A neighbour who would pass a note: bond at or above `minimum` and willing to chat.
func note_sender(minimum: int = 50) -> String:
	var best := ""
	for id in neighbor_ids():
		if not bool(npc(str(id)).get("accepts_chat", false)) or npc(str(id)).get("notes", []).is_empty():
			continue
		if GameState.bond(str(id)) >= minimum and (best.is_empty() or GameState.bond(str(id)) > GameState.bond(best)):
			best = str(id)
	return best

## A neighbour struggling in this subject (Kenta in English, Tsubasa in Math).
func help_requester() -> String:
	for id in neighbor_ids():
		if npc(str(id)).get("help_subjects", []).has(subject_id):
			return str(id)
	return ""

## A neighbour able to help in the Janela de Questão (seção 46.6).
func helper() -> String:
	var best := ""
	for id in neighbor_ids():
		var mastery := int(npc(str(id)).get("mastery", {}).get(subject_id, 0))
		if GameState.bond_level(str(id)) >= HELP_BOND_LEVEL and mastery >= HELP_MASTERY:
			if best.is_empty() or mastery > int(npc(best).get("mastery", {}).get(subject_id, 0)):
				best = str(id)
	return best

func chat_partner() -> String:
	var best := ""
	for id in neighbor_ids():
		if bool(npc(str(id)).get("accepts_chat", false)) and (best.is_empty() or GameState.bond(str(id)) > GameState.bond(best)):
			best = str(id)
	return best

func fill(text: String) -> String:
	return ClassMissions.fill(text, teacher)

func names() -> Dictionary:
	var result: Dictionary = {}
	for id in context.get("npcs", {}):
		result[id] = npc_name(str(id))
	result[Timetable.teacher_id(subject_id)] = teacher
	return result

# ---------------------------------------------------------------- lifecycle

func start() -> Dictionary:
	last_screen = _start()
	return last_screen

func handle(payload: Dictionary) -> Dictionary:
	last_screen = _handle(payload)
	return last_screen

func _start() -> Dictionary:
	started = true
	late_by = maxi(0, GameTime.minute - int(period.start))
	blocks_total = maxi(1, int(ceil(float(int(period.end) - GameTime.minute) / BLOCK_MINUTES)))
	if late_by > 5:
		GameState.add_occurrence("Atraso de %d minutos em %s." % [late_by, period.title])
		occurrences += 1
		summary.append("Atraso de %d minutos registrado como ocorrência leve." % late_by)
	elif late_by > 0:
		summary.append("Chegada com %d minutos de atraso, dentro da tolerância." % late_by)
	mission = ClassMissions.scheduled(self)
	match str(period.get("kind", "class")):
		"class":
			if str(period.get("special", "")) == "study":
				return _screen_study()
			if str(period.get("special", "")) == "lhr":
				return _screen_simple("Hora da Turma", "Sato abre a palavra à turma: avisos, pedidos e decisões coletivas. Hina conduz com uma lista na mão.", "Participar da Hora da Turma")
			return _screen_posture()
		"homeroom":
			return _screen_simple(str(period.title), "Chamada rápida, avisos do dia e o recado de sempre: “um dia de cada vez”." if str(period.id) == "homeroom" else "Resumo do dia, lembretes para amanhã e a sala se esvaziando aos poucos.", "Participar")
		_:
			return _screen_simple(str(period.title), "Vassouras, panos e a divisão das tarefas. Limpar a própria sala faz parte do dia.", "Ajudar na limpeza")

func _handle(payload: Dictionary) -> Dictionary:
	var cmd := str(payload.get("cmd", ""))
	match cmd:
		"close":
			finished = true
			return {}
		"simple":
			return _simple_participation()
		"study":
			return _study(str(payload.get("subject", "")))
		"posture":
			return _choose_posture(str(payload.get("id", "attention")), str(payload.get("target", "")))
		"review_menu":
			return _screen_review_menu()
		"next":
			return _continue()
		"stay":
			stay_until_end = true
			return _continue()
		"answer":
			return _answer(int(payload.get("index", -1)))
		"tool":
			return _tool(str(payload.get("tool", "")))
		"choice":
			return _choice(int(payload.get("index", -1)))
		"pick":
			return _pick(str(payload.get("id", "")))
	if posture.is_empty() and str(period.get("kind", "class")) == "class" and str(period.get("special", "")).is_empty():
		return _screen_posture()
	return _continue()

func kicker() -> String:
	return "%s  ·  %s  ·  %s–%s" % [str(period.title).to_upper() if str(period.get("kind")) != "class" else ("%dº PERÍODO" % int(period.get("slot", 0))), teacher.to_upper(), GameTime.clock(int(period.start)), GameTime.clock(int(period.end))]

func _title() -> String:
	return str(subject.get("name", period.title)) if not subject.is_empty() else str(period.title)

# ---------------------------------------------------------------- simple periods

func _screen_simple(title: String, text: String, button: String) -> Dictionary:
	var body: Array = [{"text": text}]
	if not mission.is_empty():
		body.append({"muted": "Algo diferente acontece hoje: " + str(mission.name)})
	return {"id": "simple", "title": title, "kicker": kicker(), "body": body,
		"options": [{"text": button, "payload": {"cmd": "simple"}, "primary": true}]}

func _simple_participation() -> Dictionary:
	GameState.drain_energy(2)
	GameState.improve("Disciplina", 1)
	summary.append("+1 Disciplina")
	if not mission.is_empty():
		return _mission_begin()
	return _finish()

func _screen_study() -> Dictionary:
	var options: Array = []
	for id in Timetable.core_subjects():
		if id == "pe":
			continue
		options.append({"text": "%s  (Domínio %d)" % [Timetable.subject_name(str(id)), GameState.mastery_of(str(id))], "payload": {"cmd": "study", "subject": id}})
	return {"id": "study", "title": "Estudo dirigido", "kicker": kicker(),
		"body": [{"text": "“Escolham uma matéria e usem bem este tempo.” Daichi já abriu o livro de Matemática; Yui tenta esconder um desenho dentro do caderno de Literatura."}],
		"options": options}

func _study(id: String) -> Dictionary:
	if not GameState.SUBJECTS.has(id):
		return _screen_study()
	GameState.drain_energy(5)
	var applied := GameState.gain_mastery(id, 2)
	summary.append("+%d Domínio em %s (estudo dirigido)" % [applied, Timetable.subject_name(id)])
	GameState.log_day("Estudo dirigido: %s." % Timetable.subject_name(id))
	return _finish()

# ---------------------------------------------------------------- posture

func _screen_posture() -> Dictionary:
	var body: Array = [{"speaker": teacher, "text": str(subject.get("opening", "A aula começa."))}]
	if late_by > 5:
		body.append({"muted": "Você chegou %d minutos depois do sinal. %s anota a ocorrência leve sem comentar." % [late_by, teacher]})
	var around := neighbors()
	if not around.is_empty():
		var parts: Array = []
		for direction in ["left", "right", "front", "back"]:
			if around.has(direction):
				parts.append("%s %s" % [npc_name(str(around[direction])), SeatMap.direction_label(direction)])
		body.append({"muted": "Vizinhos: " + ", ".join(parts) + "."})
	if not mission.is_empty():
		body.append({"muted": "Algo diferente acontece hoje: " + str(mission.name)})
	body.append({"text": "Como você passa esta aula?"})
	var options: Array = []
	var theory := bool(period.get("theory", false))
	for data in ClassDirector.postures():
		if bool(data.get("theory_only", false)) and not theory:
			continue
		var id := str(data.id)
		var entry := {"text": str(data.name), "hint": str(data.get("hint", "")), "payload": {"cmd": "posture", "id": id}, "primary": id == "attention"}
		match id:
			"chat":
				var partner := chat_partner()
				if partner.is_empty():
					continue
				entry.text = "Conversar baixinho com %s" % npc_name(partner)
				entry.payload.target = partner
			"review":
				entry.payload = {"cmd": "review_menu"}
			"attention":
				if not theory:
					entry.text = "Participar com vontade"
					entry.hint = "+2 Domínio · −5 energia"
			"rest":
				if not theory:
					entry.text = "Pegar leve hoje"
		options.append(entry)
	return {"id": "posture", "title": _title(), "kicker": kicker(), "body": body, "options": options}

func _screen_review_menu() -> Dictionary:
	var options: Array = []
	for id in Timetable.core_subjects():
		if id == subject_id or id == "pe":
			continue
		options.append({"text": "Revisar %s  (Domínio %d)" % [Timetable.subject_name(str(id)), GameState.mastery_of(str(id))], "payload": {"cmd": "posture", "id": "review", "target": id}})
	options.append({"text": "Voltar", "payload": {"cmd": "posture", "id": "back_posture"}})
	return {"id": "review", "title": "Revisar outra matéria", "kicker": kicker(),
		"body": [{"text": "O caderno de outra matéria fica aberto por baixo do livro. %s pode perceber." % teacher}], "options": options}

func _choose_posture(id: String, target: String) -> Dictionary:
	if id == "back_posture":
		return _screen_posture()
	posture = ClassDirector.posture(id)
	if posture.is_empty():
		posture = ClassDirector.posture("attention")
	posture_target = target
	var risk := float(posture.get("risk", 0.0))
	if GameState.has_trait("careful"):
		risk *= 0.5
	if id == "review" and ["kawaguchi", "kurata"].has(Timetable.teacher_id(subject_id)):
		risk *= 1.5
	caught = risk > 0.0 and rng.chance(risk)
	_apply_posture()
	plan = ClassDirector.plan(self)
	GameState.log_day("%s: %s." % [_title(), str(posture.name)])
	return _continue()

func _apply_posture() -> void:
	var energy := float(posture.get("energy", 0))
	if energy > 0:
		GameState.drain_energy(energy)
	elif energy < 0:
		GameState.restore_energy(-energy)
	var bonus := 1 if str(GameState.mood.get("state", "")) == "upbeat" and int(posture.get("mastery", 0)) > 0 else 0
	var gained := GameState.gain_mastery(subject_id, int(posture.get("mastery", 0)) + bonus)
	if gained > 0:
		summary.append("+%d Domínio em %s (postura %s)" % [gained, Timetable.subject_name(subject_id), str(posture.name).to_lower()])
	elif int(posture.get("mastery", 0)) > 0:
		summary.append("Domínio de %s no teto diário (+6 por dia)." % Timetable.subject_name(subject_id))
	var cards_count := int(posture.get("cards", 0))
	if cards_count > 0 and GameState.has_trait("curious") and rng.chance(0.2):
		cards_count += 1
	_reveal_cards(cards_count)
	if int(posture.get("notebook", 0)) > 0:
		GameState.notebook_pages[subject_id] = int(GameState.notebook_pages.get(subject_id, 0)) + 1
		summary.append("+1 Página de Caderno de %s" % Timetable.subject_name(subject_id))
	match str(posture.id):
		"review":
			var applied := GameState.gain_mastery(posture_target, 1)
			summary.append("+%d Domínio em %s (revisão)" % [applied, Timetable.subject_name(posture_target)])
		"chat":
			if not posture_target.is_empty():
				GameState.add_bond(posture_target, 8)
				summary.append("+8 vínculo · %s" % npc_name(posture_target))
				var lines: Array = npc(posture_target).get("chat_lines", [])
				if not lines.is_empty():
					ticker.append(str(rng.pick(lines)))
		"window":
			if GameState.counter("window_day_" + stamp) == 0:
				GameState.add_counter("window_day_" + stamp)
				GameState.improve("Criatividade", 1)
				summary.append("+1 Criatividade (olhar pela janela)")
			GameState.set_mood("inspired", 2)
			summary.append("Humor: Inspirado por 2 dias")
			ticker.append("Lá fora, o telhado do ginásio brilha com a luz da manhã. Nada acontece — ainda. Você se sente inspirado.")
		"rest":
			summary.append("+8 energia (descanso discreto)")
	if caught:
		match str(posture.id):
			"rest", "chat":
				GameState.add_occurrence("Flagrado em aula de %s (%s)." % [_title(), str(posture.name).to_lower()])
				occurrences += 1
				summary.append("Ocorrência leve: flagrado em %s." % str(posture.name).to_lower())
				ticker.append("%s percebe. “%s… a aula é aqui na frente.” Ocorrência leve — e a próxima pergunta é sua." % [teacher, GameState.player_name])
				if str(posture.id) == "chat" and not posture_target.is_empty():
					ticker.append("%s também leva uma advertência e finge que está lendo." % npc_name(posture_target))
			"review":
				GameState.add_bond(Timetable.teacher_id(subject_id), -1)
				summary.append("%s percebeu a revisão de outra matéria." % teacher)
				ticker.append("%s vê o outro caderno aberto e não diz nada. O olhar diz tudo — e a próxima pergunta vem com nome." % teacher)
			_:
				ticker.append("%s nota sua atenção longe da aula. A próxima pergunta vem com o seu nome." % teacher)

func _reveal_cards(count: int) -> void:
	if count <= 0:
		return
	var unknown: Array = []
	for id in QuestionBank.card_ids(subject_id, 1):
		if not GameState.cards.has(id):
			unknown.append(id)
	if unknown.is_empty():
		if not QuestionBank.card_ids(subject_id, 1).is_empty():
			summary.append("Você já tem todos os cartões desta unidade.")
		return
	unknown = rng.shuffled(unknown)
	var titles: Array = []
	for i in range(mini(count, unknown.size())):
		GameState.add_card(str(unknown[i]))
		titles.append(str(QuestionBank.card(str(unknown[i])).get("title", unknown[i])))
	summary.append("Novos cartões: " + ", ".join(titles))

# ---------------------------------------------------------------- exposition loop

func _continue() -> Dictionary:
	if not mission_step.is_empty():
		return _mission_goto(str(mission_step.get("next", "end")))
	while true:
		for entry in plan:
			if int(entry.block) <= block and not bool(entry.get("done", false)):
				entry.done = true
				if stay_until_end and str(entry.kind) != "mission" and not (str(entry.kind) == "question" and caught):
					continue
				var screen := _present(entry)
				if not screen.is_empty():
					return screen
		if block >= blocks_total:
			break
		block += 1
		GameTime.advance(mini(BLOCK_MINUTES, int(period.end) - GameTime.minute))
	return _finish()

func _present(entry: Dictionary) -> Dictionary:
	match str(entry.kind):
		"mission":
			return _mission_begin()
		"question":
			if str(entry.get("target", "player")) == "player":
				return _open_question({}, {"kind": "moment"})
			_npc_question()
			return {}
		"note":
			return _screen_note()
		"help_request":
			return _screen_help()
		"drowsy":
			return _screen_drowsy()
	return {}

func _flush_ticker(body: Array) -> void:
	for line in ticker:
		body.append({"muted": str(line)})
	ticker.clear()

func _progress() -> String:
	return "Bloco %d de %d  ·  %s" % [mini(block, blocks_total), blocks_total, GameTime.clock()]

func _continue_options(allow_stay: bool = true) -> Array:
	var options: Array = [{"text": "Continuar a aula", "payload": {"cmd": "next"}, "primary": true}]
	if allow_stay and block < blocks_total and not stay_until_end and not _forced_question_pending():
		options.append({"text": "Ficar até o fim sem novas interações", "payload": {"cmd": "stay"}})
	return options

func _forced_question_pending() -> bool:
	if not caught:
		return false
	for entry in plan:
		if str(entry.kind) == "question" and str(entry.get("target", "")) == "player" and not bool(entry.get("done", false)):
			return true
	return false

# ---------------------------------------------------------------- Janela de Questão

## Opens the question window. `fixed` may carry a question id or subject/level; `route` tells
## what to do with the result ({"kind": "moment"} or {"kind": "mission", "on_correct", "on_wrong"}).
func _open_question(fixed: Dictionary, route: Dictionary) -> Dictionary:
	var data: Dictionary = {}
	if fixed.has("question"):
		data = QuestionBank.question(str(fixed.question))
	if data.is_empty():
		var q_subject := str(fixed.get("subject", subject_id))
		var levels: Array = [int(fixed.level)] if fixed.has("level") else QuestionBank.levels_for(GameState.mastery_of(q_subject), 1 if caught else 0)
		var exclude: Array = GameState.questions_seen.duplicate()
		exclude.append_array(ClassMissions.reserved_questions())
		data = QuestionBank.pick(q_subject, 1, levels, rng, exclude)
	if data.is_empty():
		ticker.append("%s faz uma pergunta para a turma; ninguém responde e a aula segue." % teacher)
		return {}
	if str(route.get("kind", "moment")) == "moment":
		windows += 1
	questions_asked += 1
	moments_done.append("question")
	var presented := QuestionBank.present(data, rng)
	GameState.remember_question(str(data.id))
	pending = {"kind": "question", "question": presented, "route": route, "used": [], "intro": str(fixed.get("intro", "")),
		"partner": str(fixed.get("partner", "")), "tools": fixed.get("tools", []), "tutorial": bool(fixed.get("tutorial", false))}
	return _screen_question()

func _notebook_available() -> bool:
	var q: Dictionary = pending.question
	return str(posture.get("id", "")) == "notes" or int(GameState.notebook_pages.get(str(q.subject), 0)) > 0 or GameState.cards.has(str(q.card)) or pending.get("tools", []).has("notebook")

func _screen_question(feedback: String = "") -> Dictionary:
	var q: Dictionary = pending.question
	var q_subject := Timetable.subject(str(q.subject))
	var unit_name := str(q_subject.get("units", [""])[0]) if not q_subject.get("units", []).is_empty() else ""
	var body: Array = []
	_flush_ticker(body)
	if not str(pending.get("intro", "")).is_empty():
		body.append({"text": fill(str(pending.intro))})
		pending.intro = ""
	elif pending.route.kind == "moment":
		body.append({"speaker": teacher, "text": fill(str(subject.get("ask", "“Vamos ouvir você.”")))})
	if not feedback.is_empty():
		body.append({"muted": feedback})
	if pending.has("card_shown"):
		var card := QuestionBank.card(str(q.card))
		body.append({"card": "%s — %s" % [card.get("title", ""), card.get("text", "")]})
	body.append({"text": str(q.prompt)})
	var grid: Array = []
	for i in range(q.options.size()):
		grid.append({"text": "%s   %s" % [["A", "B", "C", "D"][i], q.options[i].text], "payload": {"cmd": "answer", "index": i}})
	var tools: Array = []
	if _notebook_available() and not pending.used.has("notebook"):
		tools.append({"text": "Consultar caderno", "payload": {"cmd": "tool", "tool": "notebook"}})
	var help := helper()
	if not help.is_empty() and not pending.used.has("help") and q.options.size() > 2 and str(GameState.mood.get("state", "")) != "anxious":
		tools.append({"text": "Pedir ajuda · %s" % npc_name(help), "payload": {"cmd": "tool", "tool": "help"}})
	tools.append({"text": "Não sei", "payload": {"cmd": "tool", "tool": "skip"}})
	var footer := "Nível %d  ·  %s" % [int(q.level), _progress()]
	if bool(pending.get("tutorial", false)):
		footer = "Janela de Questão: escolha uma alternativa. Consultar caderno mostra o cartão relacionado; Não sei pede a explicação sem punição.  ·  " + footer
	var partner := str(pending.get("partner", ""))
	return {"id": "question", "title": "%s · %s" % [str(q_subject.get("short", q.subject)), unit_name] if not partner.is_empty() else str(q_subject.get("name", q.subject)),
		"kicker": ("COM %s  ·  " % npc_name(partner).to_upper() if not partner.is_empty() else "JANELA DE QUESTÃO  ·  ") + teacher.to_upper(),
		"body": body, "grid": grid, "tools": tools, "footer": footer}

func _tool(tool: String) -> Dictionary:
	if pending.get("kind", "") != "question":
		return _continue()
	var q: Dictionary = pending.question
	match tool:
		"notebook":
			pending.used.append("notebook")
			pending.card_shown = true
			GameState.add_card(str(q.card))
			return _screen_question("Você folheia o caderno discretamente.")
		"help":
			pending.used.append("help")
			var help := helper()
			var removed := QuestionBank.eliminate_wrong(q, rng)
			var feedback := "%s risca uma alternativa com a ponta do lápis." % npc_name(help) if removed else "%s dá de ombros: não dá para ajudar nesta." % npc_name(help)
			if rng.chance(0.15):
				GameState.add_occurrence("Cochicho durante pergunta de %s." % _title())
				occurrences += 1
				feedback += " %s percebe o cochicho: ocorrência leve para os dois." % teacher
			return _screen_question(feedback)
		"skip":
			return _resolve_question(false, true)
	return _screen_question()

func _answer(index: int) -> Dictionary:
	if pending.get("kind", "") != "question":
		return _continue()
	return _resolve_question(QuestionBank.is_correct(pending.question, index), false)

func _resolve_question(correct: bool, skipped: bool) -> Dictionary:
	var q: Dictionary = pending.question
	var route: Dictionary = pending.route
	var body: Array = []
	var level := int(q.level)
	var lines: Array = []
	if correct:
		var reward := QuestionBank.reward(level)
		var applied := GameState.gain_mastery(str(q.subject), int(reward.mastery))
		GameState.add_reputation("academic", int(reward.reputation))
		GameState.add_bond(Timetable.teacher_id(str(q.subject)), int(reward.teacher))
		lines.append("+%d Domínio · %s" % [applied, Timetable.subject_name(str(q.subject))])
		lines.append("+%d reputação acadêmica · +%d relação com %s" % [int(reward.reputation), int(reward.teacher), teacher])
		body.append({"speaker": teacher, "text": str(subject.get("praise", "“Muito bem.”"))})
		summary.append("Pergunta de nível %d respondida corretamente." % level)
		GameState.add_counter("questions_correct")
	else:
		var applied := GameState.gain_mastery(str(q.subject), 1)
		var correct_text := ""
		for option in q.options:
			if int(option.orig) == int(q.answer):
				correct_text = str(option.text)
		body.append({"speaker": teacher, "text": ("“Sem problema. A resposta é: %s.”" if skipped else "“Quase. A resposta era: %s.”") % correct_text})
		body.append({"text": str(q.explain)})
		lines.append("+%d Domínio · %s (explicação)" % [applied, Timetable.subject_name(str(q.subject))])
		summary.append("Pergunta de nível %d: %s." % [level, "você pediu a explicação" if skipped else "resposta errada, explicação anotada"])
	GameState.add_counter("questions_answered")
	for line in lines:
		body.append({"muted": line})
	var options := _continue_options()
	if route.kind == "mission":
		mission_step = {"next": str(route.on_correct if correct else route.on_wrong)}
		options = [{"text": "Continuar", "payload": {"cmd": "next"}, "primary": true}]
	pending = {}
	return {"id": "feedback", "title": "Certo!" if correct else ("Explicação" if skipped else "Não foi dessa vez"), "kicker": "JANELA DE QUESTÃO  ·  " + teacher.to_upper(),
		"body": body, "options": options, "footer": _progress()}

## A classmate answers instead (seção 46.8, item 6): their mastery decides.
func _npc_question() -> void:
	var candidates: Array = []
	for id in context.get("present", []):
		if not npc(str(id)).is_empty() and str(npc(str(id)).get("class", "")) != "staff":
			candidates.append(str(id))
	if candidates.is_empty():
		return
	var id := str(rng.pick(candidates))
	var mastery := int(npc(id).get("mastery", {}).get(subject_id, 30))
	var ok := rng.chance(clampf(0.35 + mastery * 0.006, 0.1, 0.95))
	moments_done.append("question:" + id)
	ticker.append("%s pergunta a %s… %s" % [teacher, npc_name(id), ("%s acerta. %s" % [npc_name(id), str(subject.get("correct_other", ""))]) if ok else "%s hesita e erra; %s explica para a turma." % [npc_name(id), teacher]])
	GameState.log_day("%s respondeu a %s em %s (%s)." % [npc_name(id), teacher, _title(), "acertou" if ok else "errou"])

# ---------------------------------------------------------------- generic moments

func _screen_note() -> Dictionary:
	var sender := note_sender(50)
	if sender.is_empty():
		return {}
	windows += 1
	moments_done.append("note:" + sender)
	var text := str(rng.pick(npc(sender).get("notes", ["(um papel dobrado)"])))
	pending = {"kind": "note", "from": sender, "options": []}
	var options: Array = [{"text": "Ler e responder", "payload": {"cmd": "choice", "index": 0}, "primary": true, "hint": "+6 vínculo · risco de flagrante"}]
	pending.options.append("read")
	var others: Array = []
	for id in neighbor_ids():
		if str(id) != sender and bool(npc(str(id)).get("accepts_chat", false)):
			others.append(str(id))
	if not others.is_empty():
		options.append({"text": "Passar adiante para %s" % npc_name(others[0]), "payload": {"cmd": "choice", "index": 1}, "hint": "+3 vínculo com os dois"})
		pending.options.append("pass:" + others[0])
	else:
		pending.options.append("")
	options.append({"text": "Ignorar", "payload": {"cmd": "choice", "index": 2}})
	pending.options.append("ignore")
	var body: Array = []
	_flush_ticker(body)
	body.append({"text": "Um bilhete dobrado chega de %s, por baixo da carteira:" % npc_name(sender)})
	body.append({"card": text})
	return {"id": "note", "title": "Bilhete passado", "kicker": "MOMENTO DE AULA  ·  " + teacher.to_upper(), "body": body, "options": options, "footer": _progress()}

func _screen_help() -> Dictionary:
	var who := help_requester()
	if who.is_empty():
		return {}
	windows += 1
	moments_done.append("help:" + who)
	pending = {"kind": "help", "from": who}
	var body: Array = []
	_flush_ticker(body)
	body.append({"text": fill(str(npc(who).get("help_lines", {}).get(subject_id, "%s pede ajuda baixinho." % npc_name(who))))})
	return {"id": "help", "title": "Colega em apuros", "kicker": "MOMENTO DE AULA  ·  " + teacher.to_upper(), "body": body, "options": [
		{"text": "Explicar com calma", "payload": {"cmd": "choice", "index": 0}, "primary": true, "hint": "+8 vínculo · +1 Empatia · −3 energia"},
		{"text": "Passar a resposta", "payload": {"cmd": "choice", "index": 1}, "hint": "+10 vínculo · risco de flagrante · −1 Disciplina"},
		{"text": "Recusar com um gesto", "payload": {"cmd": "choice", "index": 2}}], "footer": _progress()}

func _screen_drowsy() -> Dictionary:
	windows += 1
	moments_done.append("drowsy")
	pending = {"kind": "drowsy"}
	var body: Array = []
	_flush_ticker(body)
	body.append({"text": "As letras do quadro começam a dançar. A voz de %s vira um zumbido morno. Seus olhos pesam." % teacher})
	var options: Array = [{"text": "Ficar acordado", "payload": {"cmd": "choice", "index": 0}, "primary": true, "hint": "teste de Disciplina"},
		{"text": "Deitar a cabeça só um pouquinho", "payload": {"cmd": "choice", "index": 1}, "hint": "+10 energia · ocorrência leve"}]
	return {"id": "drowsy", "title": "Sono em aula", "kicker": "MOMENTO DE AULA  ·  " + teacher.to_upper(), "body": body, "options": options, "footer": _progress()}

func _choice(index: int) -> Dictionary:
	match str(pending.get("kind", "")):
		"note":
			return _choice_note(index)
		"help":
			return _choice_help(index)
		"drowsy":
			return _choice_drowsy(index)
		"mission_choice":
			return _mission_choice(index)
	return _continue()

func _result(title: String, lines: Array, mission_next: String = "") -> Dictionary:
	var body: Array = []
	_flush_ticker(body)
	for line in lines:
		body.append({"text": str(line)} if not str(line).begins_with("+") and not str(line).begins_with("−") and not str(line).begins_with("Ocorrência") else {"muted": str(line)})
	pending = {}
	var options := _continue_options()
	if not mission_next.is_empty():
		mission_step = {"next": mission_next}
		options = [{"text": "Continuar", "payload": {"cmd": "next"}, "primary": true}]
	return {"id": "result", "title": title, "kicker": "MOMENTO DE AULA  ·  " + teacher.to_upper(), "body": body, "options": options, "footer": _progress()}

func _choice_note(index: int) -> Dictionary:
	var sender := str(pending.from)
	var kind := str(pending.options[clampi(index, 0, 2)])
	var lines: Array = []
	if kind == "read":
		GameState.add_bond(sender, 6)
		lines.append("Você responde no verso e devolve o papel sem olhar para trás.")
		lines.append("+6 vínculo · %s" % npc_name(sender))
		if rng.chance(float(ClassDirector.moment("note").get("catch_chance", 0.2))):
			GameState.add_occurrence("Bilhete flagrado em %s." % _title())
			occurrences += 1
			lines.append("%s estende a mão sem parar de falar. O bilhete some na mesa do professor." % teacher)
			lines.append("Ocorrência leve registrada")
		GameState.log_day("Bilhete de %s em %s: você respondeu." % [npc_name(sender), _title()])
	elif kind.begins_with("pass:"):
		var other := kind.trim_prefix("pass:")
		GameState.add_bond(sender, 3)
		GameState.add_bond(other, 3)
		lines.append("O papel segue viagem até %s, que segura o riso." % npc_name(other))
		lines.append("+3 vínculo · %s e %s" % [npc_name(sender), npc_name(other)])
		GameState.log_day("Bilhete de %s repassado para %s." % [npc_name(sender), npc_name(other)])
	else:
		lines.append("Você guarda o papel dentro do caderno sem ler. %s não insiste." % npc_name(sender))
		if GameState.has_trait("shy"):
			lines.append("Tímido: ignorar não custa nada a você.")
	return _result("Bilhete passado", lines)

func _choice_help(index: int) -> Dictionary:
	var who := str(pending.from)
	var lines: Array = []
	match index:
		0:
			GameState.drain_energy(3)
			GameState.add_bond(who, 8)
			GameState.improve("Empatia", 1)
			var total := GameState.add_counter("help_" + who)
			lines.append("Você explica em duas frases e um desenho na margem. %s entende — ou quase." % npc_name(who))
			lines.append("+8 vínculo · %s" % npc_name(who))
			lines.append("+1 Empatia")
			if total >= 2:
				lines.append("%s já pediu sua ajuda %d vezes. Uma monitoria no almoço começa a fazer sentido (próximo marco)." % [npc_name(who), total])
			GameState.log_day("Você explicou %s para %s." % [Timetable.subject_name(subject_id), npc_name(who)])
		1:
			GameState.add_bond(who, 10)
			GameState.improve("Disciplina", -1)
			lines.append("Você sussurra a resposta. %s copia aliviado — e não aprende nada." % npc_name(who))
			lines.append("+10 vínculo · %s" % npc_name(who))
			lines.append("−1 Disciplina")
			if rng.chance(float(ClassDirector.moment("help_request").get("catch_chance", 0.25))):
				GameState.add_occurrence("Cola flagrada em %s." % _title())
				occurrences += 1
				lines.append("%s para no meio da frase. “Vocês dois.” Ocorrência leve." % teacher)
				lines.append("Ocorrência leve registrada")
			GameState.log_day("Você passou a resposta para %s." % npc_name(who))
		_:
			lines.append("Você balança a cabeça e volta ao caderno. %s suspira e tenta sozinho." % npc_name(who))
			GameState.log_day("%s pediu ajuda; você recusou." % npc_name(who))
	return _result("Colega em apuros", lines)

func _choice_drowsy(index: int) -> Dictionary:
	var lines: Array = []
	if index == 0:
		var kenta_awake := neighbor_ids().has("kenta") and GameState.bond_level("kenta") >= 2
		var success := kenta_awake or rng.chance(0.45 + float(GameState.attributes.Disciplina) / 100.0)
		if kenta_awake:
			GameState.add_bond("kenta", 2)
			lines.append("Uma cutucada na costela. Kenta, sem olhar: “Combinado é combinado.”")
			lines.append("+2 vínculo · Kenta")
		if success:
			lines.append("Você respira fundo, endireita as costas e sobrevive ao bloco.")
			GameState.improve("Disciplina", 1)
			lines.append("+1 Disciplina")
		else:
			GameState.add_occurrence("Dormiu em %s." % _title())
			occurrences += 1
			GameState.restore_energy(4)
			lines.append("A cabeça pende. Quando você acorda, %s está parado ao lado da carteira. “Boa tarde.” A sala ri." % teacher)
			lines.append("Ocorrência leve registrada")
			lines.append("Os cartões deste bloco se perderam no sono.")
	else:
		GameState.add_occurrence("Dormiu de propósito em %s." % _title())
		occurrences += 1
		GameState.restore_energy(10)
		lines.append("Só um pouquinho. O braço vira travesseiro. %s nota, anota e segue a aula." % teacher)
		lines.append("+10 energia")
		lines.append("Ocorrência leve registrada")
	GameState.log_day("Sono em %s." % _title())
	return _result("Sono em aula", lines)

# ---------------------------------------------------------------- missions

func _mission_begin() -> Dictionary:
	moments_done.append("mission:" + str(mission.id))
	windows += 1
	GameState.quests[str(mission.id)] = {"state": "active", "step": ""}
	return _mission_show(ClassMissions.first_step(mission))

func _mission_goto(id: String) -> Dictionary:
	mission_step = {}
	if id == "end" or id.is_empty():
		GameState.quests[str(mission.id)] = {"state": "completed", "date": stamp}
		if mission.has("memory"):
			GameState.log_day("Cartão de Memória: " + str(mission.memory))
		summary.append("Missão de Sala concluída: %s" % str(mission.name))
		mission = {}
		return _continue()
	var step := ClassMissions.step(mission, id)
	if step.is_empty():
		return _mission_goto("end")
	return _mission_show(step)

func _mission_show(step: Dictionary) -> Dictionary:
	if step.is_empty():
		return _mission_goto("end")
	GameState.quests[str(mission.id)] = {"state": "active", "step": str(step.id)}
	var body: Array = []
	_flush_ticker(body)
	match str(step.type):
		"text":
			var lines := ClassMissions.apply_effects(step.get("effects", {}), names())
			if step.has("speaker"):
				body.append({"speaker": str(step.speaker), "text": fill(str(step.text))})
			else:
				body.append({"text": fill(str(step.text))})
			for line in lines:
				body.append({"muted": line})
			mission_step = {"next": str(step.get("next", "end"))}
			return {"id": "mission", "title": str(mission.name), "kicker": "MISSÃO DE SALA  ·  " + teacher.to_upper(), "body": body,
				"options": [{"text": "Continuar", "payload": {"cmd": "next"}, "primary": true}], "footer": _progress()}
		"choice":
			pending = {"kind": "mission_choice", "step": step}
			if step.has("speaker"):
				body.append({"speaker": str(step.speaker), "text": fill(str(step.text))})
			else:
				body.append({"text": fill(str(step.text))})
			var options: Array = []
			var index := 0
			for option in step.options:
				var entry := {"text": fill(str(option.text)), "payload": {"cmd": "choice", "index": index}, "primary": index == 0}
				var requires: Dictionary = option.get("requires", {})
				if requires.has("attribute") and int(GameState.attributes.get(str(requires.attribute), 0)) < int(requires.get("min", 0)):
					entry.disabled = true
					entry.hint = "Requer %s %d" % [requires.attribute, int(requires.min)]
				options.append(entry)
				index += 1
			return {"id": "mission", "title": str(mission.name), "kicker": "MISSÃO DE SALA  ·  " + teacher.to_upper(), "body": body, "options": options, "footer": _progress()}
		"multi":
			pending = {"kind": "mission_multi", "step": step, "picked": []}
			return _screen_multi()
		"question":
			var route := {"kind": "mission", "on_correct": str(step.get("on_correct", "end")), "on_wrong": str(step.get("on_wrong", "end"))}
			var screen := _open_question(step, route)
			if screen.is_empty():
				return _mission_goto(str(step.get("on_wrong", "end")))
			return screen
	return _mission_goto(str(step.get("next", "end")))

func _screen_multi() -> Dictionary:
	var step: Dictionary = pending.step
	var body: Array = [{"text": fill(str(step.get("prompt", "")))}]
	var picked: Array = pending.picked
	if not picked.is_empty():
		body.append({"muted": "Escolha mais %d." % (int(step.get("pick", 2)) - picked.size())})
	var options: Array = []
	for option in step.options:
		if picked.has(str(option.id)):
			continue
		options.append({"text": fill(str(option.text)), "payload": {"cmd": "pick", "id": str(option.id)}})
	return {"id": "mission", "title": str(mission.name), "kicker": "MISSÃO DE SALA  ·  " + teacher.to_upper(), "body": body, "options": options, "footer": _progress()}

func _pick(id: String) -> Dictionary:
	if str(pending.get("kind", "")) != "mission_multi":
		return _continue()
	var step: Dictionary = pending.step
	for option in step.options:
		if str(option.id) == id and not pending.picked.has(id):
			pending.picked.append(id)
			var lines := ClassMissions.apply_effects(_option_effects(option), names())
			for line in lines:
				ticker.append(line)
	if pending.picked.size() < int(step.get("pick", 2)):
		return _screen_multi()
	var lines: Array = ["A turma reage. %s anota os nomes na lista de presença." % teacher]
	return _result(str(mission.name), lines, str(step.get("next", "end")))

func _option_effects(option: Dictionary) -> Dictionary:
	var effects: Dictionary = option.get("effects", {}).duplicate(true)
	if option.has("effects_by_origin"):
		effects.merge(option.effects_by_origin.get(str(GameState.background.get("origin", "capital")), {}), true)
	if option.has("effects_by_talent"):
		effects.merge(option.effects_by_talent.get(str(GameState.background.get("talent", "dedicated")), {}), true)
	return effects

func _mission_choice(index: int) -> Dictionary:
	var step: Dictionary = pending.step
	if index < 0 or index >= step.options.size():
		return _mission_show(step)
	var option: Dictionary = step.options[index]
	var requires: Dictionary = option.get("requires", {})
	if requires.has("attribute") and int(GameState.attributes.get(str(requires.attribute), 0)) < int(requires.get("min", 0)):
		return _mission_show(step)
	var lines: Array = [fill(str(option.text))]
	var effects := _option_effects(option)
	if effects.has("log"):
		lines.append(fill(str(effects.log)))
	for line in ClassMissions.apply_effects(effects, names()):
		lines.append(line)
	var risk: Dictionary = option.get("risk", {})
	if not risk.is_empty() and rng.chance(float(risk.get("chance", 0.0))):
		lines.append(fill(str(risk.get("text", ""))))
		for line in ClassMissions.apply_effects(risk.get("effects", {}), names()):
			lines.append(line)
		occurrences += int(risk.get("effects", {}).get("occurrence", 0))
	return _result(str(mission.name), lines, str(option.get("next", step.get("next", "end"))))

# ---------------------------------------------------------------- end of period

func _finish() -> Dictionary:
	GameTime.advance(maxi(0, int(period.end) - GameTime.minute))
	GameState.attendance[key] = {"late": late_by > 5, "subject": subject_id, "posture": str(posture.get("id", "")),
		"moments": moments_done.duplicate(), "occurrences": occurrences, "windows": windows, "questions": questions_asked}
	GameState.mark("class")
	var body: Array = []
	_flush_ticker(body)
	if summary.is_empty():
		summary.append("Período concluído.")
	for line in summary:
		body.append({"muted": str(line)} if str(line).begins_with("+") or str(line).begins_with("Novos") else {"text": str(line)})
	body.append({"muted": "Energia %d  ·  Domínio em %s: %d" % [int(GameState.energy), Timetable.subject_name(subject_id), GameState.mastery_of(subject_id)] if not subject_id.is_empty() and GameState.SUBJECTS.has(subject_id) else "Energia %d" % int(GameState.energy)})
	var next := SchoolSchedule.current_or_next(GameTime.minute)
	if not next.is_empty():
		body.append({"muted": "A seguir: %s às %s." % [next.title, GameTime.clock(int(next.start))]})
	pending = {}
	return {"id": "summary", "title": "Fim do período", "kicker": kicker(), "body": body,
		"options": [{"text": "Continuar meu dia", "payload": {"cmd": "close"}, "primary": true}], "final": true}
