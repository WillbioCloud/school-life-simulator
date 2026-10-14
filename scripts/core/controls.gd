class_name GameControls
extends RefCounted
static func install() -> void:
	var keys := {"move_left": [KEY_A, KEY_LEFT], "move_right": [KEY_D, KEY_RIGHT],
		"move_up": [KEY_W, KEY_UP], "move_down": [KEY_S, KEY_DOWN], "run": [KEY_SHIFT],
		"interact": [KEY_E], "phone": [KEY_TAB], "map": [KEY_M], "menu": [KEY_ESCAPE], "bag": [KEY_I]}
	for action in keys:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for key in keys[action]:
			var event := InputEventKey.new()
			event.physical_keycode = key
			InputMap.action_add_event(action, event)
