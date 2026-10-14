class_name DayCycle
extends RefCounted
## End-of-day and start-of-day bookkeeping (seções 45.7, 45.8, 55.3): diary entry, mood refresh,
## weekly allowance. Pure state transitions — the UI only shows what these return.
const DIARY_LIMIT := 28
const ALLOWANCE_START := {"month": 4, "day": 8}

## Summarises the day in three lines and stores it in the diary. Called before GameTime.sleep().
static func close_day(forced: bool, tired: bool) -> Dictionary:
	var lines: Array = []
	var stamp := GameTime.stamp()
	var periods := 0
	var windows := 0
	var occurrences := 0
	for key in GameState.attendance:
		if str(key).begins_with(stamp + ":"):
			periods += 1
			windows += int(GameState.attendance[key].get("questions", 0))
			occurrences += int(GameState.attendance[key].get("occurrences", 0))
	if GameTime.is_school_day():
		if periods == 0:
			lines.append("Um dia letivo sem aulas. A carteira C2 ficou vazia." if GameState.flags.has("class") else "Primeiro contato com Hoshikawa: casa, rua e escola.")
		else:
			lines.append("%d período%s na 1-A, %d pergunta%s respondida%s em aula%s." % [periods, "s" if periods != 1 else "", windows, "s" if windows != 1 else "", "s" if windows != 1 else "", (" e %d ocorrência leve" % occurrences) if occurrences == 1 else ((" e %d ocorrências leves" % occurrences) if occurrences > 1 else "")])
	else:
		lines.append("Fim de semana em Hoshikawa.")
	var talked_today: Array = []
	for id in GameState.talked:
		if str(GameState.talked[id]) == stamp:
			talked_today.append(str(id))
	var social := ""
	if not talked_today.is_empty():
		social = "Conversou com %d pessoa%s." % [talked_today.size(), "s" if talked_today.size() != 1 else ""]
	for line in GameState.day_log:
		if str(line).begins_with("Missão") or str(line).begins_with("Cartão de Memória"):
			social += (" " if not social.is_empty() else "") + str(line)
			break
	if social.is_empty():
		social = str(GameState.day_log[-1]) if not GameState.day_log.is_empty() else "Um dia quieto, de observar."
	lines.append(social)
	var mood_line := "Humor: %s." % GameState.mood_name().to_lower()
	if forced:
		mood_line = "O sono venceu antes da cama. " + mood_line
	elif tired:
		mood_line = "Dormiu tarde. " + mood_line
	lines.append(mood_line)
	var entry := {"date": "%s · %02d/%02d" % [GameTime.WEEKDAYS[(GameTime.day - 1) % 7], GameTime.day, GameTime.month], "stamp": stamp, "lines": lines, "note": ""}
	GameState.diary.append(entry)
	while GameState.diary.size() > DIARY_LIMIT:
		GameState.diary.pop_front()
	GameState.counters["days_slept"] = int(GameState.counters.get("days_slept", 0)) + 1
	GameState.day_log.clear()
	GameState.flags["late_night"] = tired
	return entry

## Applies the new morning: energy, mood expiry, allowance. Returns lines for the morning screen.
static func open_day() -> Array:
	var lines: Array = []
	var tired := bool(GameState.flags.get("late_night", false))
	GameState.flags.erase("late_night")
	GameState.energy = 80 if tired else 100
	GameState.refresh_mood()
	if tired:
		GameState.set_mood("tired", 1)
		lines.append("Você acorda cansado: custos de energia 20% maiores hoje.")
	elif GameState.mood.get("state", "calm") == "calm" and GameTime.is_school_day() and (GameTime.day - 1) % 7 == 0:
		GameState.set_mood("upbeat", 1)
		lines.append("Segunda-feira animada: +1 Domínio extra em cada aula de hoje.")
	if allowance_due():
		GameState.money += GameState.ALLOWANCE
		GameState.counters["allowance_" + GameTime.stamp()] = 1
		lines.append("Mesada: vovó deixou ¥%d em cima da mesa da cozinha." % GameState.ALLOWANCE)
	GameState.changed.emit()
	return lines

## Mondays from 8 April on (seção 55.3), once per date.
static func allowance_due() -> bool:
	if (GameTime.day - 1) % 7 != 0:
		return false
	var today := ((GameTime.month - 4 + 12) % 12) * 100 + GameTime.day
	var first := ((int(ALLOWANCE_START.month) - 4 + 12) % 12) * 100 + int(ALLOWANCE_START.day)
	return today >= first and not GameState.counters.has("allowance_" + GameTime.stamp())
