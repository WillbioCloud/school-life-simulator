class_name ClassDirector
extends RefCounted
## Diretor de Aula (seção 46.8): decides what happens in a period. Missions first, then
## weighted draws from data/class_moments.json, with the same seed for the same date + period.
static var catalog: Dictionary = {}

static func load_data() -> void:
	if catalog.is_empty():
		catalog = JSON.parse_string(FileAccess.get_file_as_string("res://data/class_moments.json"))

static func moment(id: String) -> Dictionary:
	load_data()
	for data in catalog.moments:
		if str(data.id) == id:
			return data
	return {}

static func posture(id: String) -> Dictionary:
	load_data()
	for data in catalog.postures:
		if str(data.id) == id:
			return data
	return {}

static func postures() -> Array:
	load_data()
	return catalog.postures

static func max_per_period() -> int:
	load_data()
	return int(catalog.get("max_per_period", 2))

static func max_windows_per_day() -> int:
	load_data()
	return int(catalog.get("max_windows_per_day", 3))

## Builds the plan of a period: an array of {"block", "kind", ...} sorted by block.
static func plan(session: ClassSession) -> Array:
	load_data()
	var result: Array = []
	var budget := max_per_period()
	if not session.mission.is_empty():
		result.append({"block": clampi(int(session.mission.get("block", 1)), 0, session.blocks_total), "kind": "mission", "id": str(session.mission.id)})
		budget -= 1
	var windows_left := max_windows_per_day() - SchoolSchedule.windows_today()
	if not session.mission.is_empty():
		windows_left -= 1
	var theory := bool(session.period.get("theory", false))
	var candidates: Array = []
	var weights: Array = []
	for data in catalog.moments:
		var weight := float(data.get("weight", 1))
		if bool(data.get("theory", false)) and not theory:
			continue
		if bool(data.get("needs_questions", false)) and not QuestionBank.has_questions(session.subject_id):
			continue
		if data.has("max_energy") and GameState.energy > float(data.max_energy):
			continue
		if data.has("needs_neighbor_bond") and session.note_sender(int(data.needs_neighbor_bond)).is_empty():
			continue
		if bool(data.get("needs_helper_neighbor", false)) and session.help_requester().is_empty():
			continue
		match str(data.id):
			"question":
				weight *= 1.0 + float(session.posture.get("risk", 0.0)) * 2.0
			"note":
				weight *= 1.0 + float(session.best_neighbor_bond()) / 200.0
			"drowsy":
				if str(GameState.mood.get("state", "")) == "tired":
					weight *= 1.5
		candidates.append(data)
		weights.append(weight)
	# Guarantee: at least one interactive window per school day when the subject has questions.
	var forced_question := theory and not SchoolSchedule.interactive_today() and QuestionBank.has_questions(session.subject_id)
	if session.caught and QuestionBank.has_questions(session.subject_id):
		forced_question = true
	var picked: Array = []
	if forced_question and budget > 0:
		picked.append("question")
		budget -= 1
		windows_left -= 1
	# Exhaustion is not a lottery: when energy is below the threshold, the drowsy moment happens.
	for i in range(candidates.size()):
		if str(candidates[i].id) == "drowsy" and budget > 0:
			picked.append("drowsy")
			budget -= 1
			windows_left -= 1
			candidates.remove_at(i)
			weights.remove_at(i)
			break
	var guard := 0
	while budget > 0 and not candidates.is_empty() and guard < 12:
		guard += 1
		var index := session.rng.weighted(weights)
		if index < 0:
			break
		var data: Dictionary = candidates[index]
		candidates.remove_at(index)
		weights.remove_at(index)
		var kind := str(data.id)
		if picked.has(kind):
			continue
		if kind != "question" and bool(data.get("interactive", false)) and windows_left <= 0:
			continue
		picked.append(kind)
		budget -= 1
		if kind != "question" and bool(data.get("interactive", false)):
			windows_left -= 1
	# Spread the picked moments over the exposition blocks (1 … blocks_total).
	var free_blocks: Array = []
	for block in range(1, session.blocks_total + 1):
		var taken := false
		for entry in result:
			if int(entry.block) == block:
				taken = true
		if not taken:
			free_blocks.append(block)
	free_blocks = session.rng.shuffled(free_blocks)
	for kind in picked:
		var block := int(free_blocks.pop_front()) if not free_blocks.is_empty() else session.blocks_total
		var entry := {"block": block, "kind": kind}
		if kind == "question":
			# Questions beyond the daily window limit fall on a classmate instead (seção 46.8).
			var to_player := forced_question or session.caught
			if not to_player and windows_left > 0 and session.rng.chance(_player_chance(session)):
				to_player = true
				windows_left -= 1
			entry.target = "player" if to_player else "npc"
		result.append(entry)
	result.sort_custom(func(a, b): return int(a.block) < int(b.block))
	return result

static func _player_chance(session: ClassSession) -> float:
	var base := float(moment("question").get("player_chance", 0.55))
	return clampf(base + float(session.posture.get("risk", 0.0)), 0.0, 0.95)
