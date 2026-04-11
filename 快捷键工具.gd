extends RefCounted
class_name 快捷键工具

func 主键码是否可用(主键码: Key) -> bool:
	if 主键码 == KEY_NONE:
		return false
	if 主键码 == KEY_CTRL or 主键码 == KEY_SHIFT or 主键码 == KEY_ALT or 主键码 == KEY_META:
		return false
	return true

func 按键事件转快捷键对象(键盘事件: InputEventKey) -> InputEventKey:
	if 键盘事件 == null:
		return null
	if not 主键码是否可用(键盘事件.keycode):
		return null
	var 快捷键 = InputEventKey.new()
	快捷键.keycode = 键盘事件.keycode
	快捷键.ctrl_pressed = 键盘事件.ctrl_pressed
	快捷键.shift_pressed = 键盘事件.shift_pressed
	快捷键.alt_pressed = 键盘事件.alt_pressed
	快捷键.meta_pressed = 键盘事件.meta_pressed
	return 快捷键

func 文本转快捷键对象(文本: String) -> InputEventKey:
	var 原文 = 文本.strip_edges()
	if 原文 == "":
		return null
	var 片段 = 原文.split("+", false)
	var 是否Ctrl = false
	var 是否Shift = false
	var 是否Alt = false
	var 是否Meta = false
	var 主键文本 = ""
	for 片段文本 in 片段:
		var 规范 = 片段文本.strip_edges().to_lower()
		match 规范:
			"ctrl", "control":
				是否Ctrl = true
			"shift":
				是否Shift = true
			"alt":
				是否Alt = true
			"meta", "win", "cmd":
				是否Meta = true
			_:
				if 主键文本 == "":
					主键文本 = 片段文本.strip_edges()
	if 主键文本 == "":
		return null
	var 主键码 = OS.find_keycode_from_string(主键文本)
	if not 主键码是否可用(主键码):
		return null
	var 快捷键 = InputEventKey.new()
	快捷键.keycode = 主键码
	快捷键.ctrl_pressed = 是否Ctrl
	快捷键.shift_pressed = 是否Shift
	快捷键.alt_pressed = 是否Alt
	快捷键.meta_pressed = 是否Meta
	return 快捷键

func 快捷键对象转文本(快捷键: InputEventKey) -> String:
	if 快捷键 == null:
		return ""
	var 片段: Array[String] = []
	if 快捷键.ctrl_pressed:
		片段.append("Ctrl")
	if 快捷键.shift_pressed:
		片段.append("Shift")
	if 快捷键.alt_pressed:
		片段.append("Alt")
	if 快捷键.meta_pressed:
		片段.append("Meta")
	var 主键名 = OS.get_keycode_string(快捷键.keycode)
	if 主键名 == "":
		return ""
	片段.append(主键名.to_upper())
	return "+".join(片段)

func 快捷键事件是否匹配(事件: InputEventKey, 快捷键: InputEventKey) -> bool:
	if 事件 == null or 快捷键 == null:
		return false
	return 事件.keycode == 快捷键.keycode \
		and 事件.ctrl_pressed == 快捷键.ctrl_pressed \
		and 事件.shift_pressed == 快捷键.shift_pressed \
		and 事件.alt_pressed == 快捷键.alt_pressed \
		and 事件.meta_pressed == 快捷键.meta_pressed
