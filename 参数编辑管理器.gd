extends RefCounted
class_name 参数编辑管理器

var _宿主: Node = null
var _参数容器: VBoxContainer = null
var _核心命令输入: TextEdit = null
var _预设名输入 = null

var _获取正在加载UI回调: Callable
var _设置正在加载UI回调: Callable
var _自动保存当前预设回调: Callable
var _更新预览回调: Callable
var _注入通用样式回调: Callable
var _清洗文本回调: Callable

func 初始化(宿主: Node, 参数容器: VBoxContainer, 核心命令输入: TextEdit, 预设名输入, 获取正在加载UI回调: Callable, 设置正在加载UI回调: Callable, 自动保存当前预设回调: Callable, 更新预览回调: Callable, 注入通用样式回调: Callable, 清洗文本回调: Callable):
	_宿主 = 宿主
	_参数容器 = 参数容器
	_核心命令输入 = 核心命令输入
	_预设名输入 = 预设名输入
	_获取正在加载UI回调 = 获取正在加载UI回调
	_设置正在加载UI回调 = 设置正在加载UI回调
	_自动保存当前预设回调 = 自动保存当前预设回调
	_更新预览回调 = 更新预览回调
	_注入通用样式回调 = 注入通用样式回调
	_清洗文本回调 = 清洗文本回调

func 创建参数行(键: String, 备注: String, 当前值: String):
	var 行 = HBoxContainer.new()
	行.add_theme_constant_override("separation", 10)
	var 键输入 = TextEdit.new()
	键输入.text = 键
	键输入.name = "Key"
	键输入.placeholder_text = "变量键"
	键输入.custom_minimum_size = Vector2(120, 0)
	键输入.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	键输入.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	键输入.scroll_fit_content_height = true
	键输入.context_menu_enabled = false
	键输入.text_changed.connect(func(): _自动保存并更新预览())
	键输入.focus_entered.connect(_更新预览回调)
	键输入.focus_exited.connect(_更新预览回调)
	var 值输入 = TextEdit.new()
	值输入.text = 当前值
	值输入.name = "Value"
	值输入.placeholder_text = "值"
	值输入.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	值输入.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	值输入.scroll_fit_content_height = true
	值输入.context_menu_enabled = false
	值输入.text_changed.connect(func(): _自动保存并更新预览())
	值输入.focus_entered.connect(_更新预览回调)
	值输入.focus_exited.connect(_更新预览回调)
	var 备注输入 = TextEdit.new()
	备注输入.text = 备注
	备注输入.name = "Note"
	备注输入.placeholder_text = "参数说明..."
	备注输入.custom_minimum_size = Vector2(200, 0)
	备注输入.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	备注输入.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	备注输入.scroll_fit_content_height = true
	备注输入.context_menu_enabled = false
	备注输入.text_changed.connect(func(): _自动保存并更新预览())
	备注输入.focus_entered.connect(_更新预览回调)
	备注输入.focus_exited.connect(_更新预览回调)
	var 删除按钮 = Button.new()
	删除按钮.text = " ✖ "
	删除按钮.add_theme_color_override("font_color", Color.INDIAN_RED)
	删除按钮.focus_mode = Control.FOCUS_CLICK
	删除按钮.pressed.connect(func():
		if !is_instance_valid(行): return
		行.queue_free()
		_宿主.get_tree().process_frame.connect(func(): _自动保存并更新预览(), CONNECT_ONE_SHOT)
	)
	行.add_child(键输入)
	行.add_child(值输入)
	行.add_child(备注输入)
	行.add_child(删除按钮)
	for ctrl in [行, 键输入, 值输入, 备注输入]:
		ctrl.gui_input.connect(func(e):
			if is_instance_valid(行) and e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_RIGHT:
				弹出参数右键菜单(行)
		)
	var 插入索引 = -1
	if not _获取正在加载UI():
		var 焦点 = _宿主.get_viewport().gui_get_focus_owner()
		if 焦点:
			if 焦点 == _核心命令输入:
				插入索引 = 0
			else:
				var 列表 = _参数容器.get_children()
				for i in range(列表.size()):
					if 列表[i].is_ancestor_of(焦点):
						插入索引 = i + 1
						break
	_参数容器.add_child(行)
	if 插入索引 != -1:
		_参数容器.move_child(行, 插入索引)
	if _注入通用样式回调.is_valid():
		_注入通用样式回调.call(行)
	_调用更新预览()
	if not _获取正在加载UI():
		_宿主.get_tree().process_frame.connect(func():
			if is_instance_valid(键输入):
				键输入.grab_focus()
		, CONNECT_ONE_SHOT)

func 智能解析并覆盖参数(文本: String):
	if _获取正在加载UI():
		return
	var 原始文本 = 文本.strip_edges()
	if 原始文本 == "":
		return
	var 规范文本 = 原始文本
	var 续行正则 = RegEx.new()
	续行正则.compile("\\s*[\\^\\\\]\\s*\\n")
	规范文本 = 续行正则.sub(规范文本, " ", true)
	规范文本 = 规范文本.replace("\r", " ").replace("\n", " ")
	var regex = RegEx.new()
	regex.compile("(\"[^\"]*\"|'[^']*'|[^\\s]+)")
	var matches = regex.search_all(规范文本)
	if matches.size() <= 1:
		return
	var raw_parts = []
	for m in matches:
		var p = m.get_string().strip_edges()
		if p != "" and p != "^" and p != "\\":
			raw_parts.append(p)
	var merged_parts = []
	var i = 0
	while i < raw_parts.size():
		var p = raw_parts[i]
		if p.begins_with("-") and i + 1 < raw_parts.size():
			var next_p = raw_parts[i + 1]
			if not next_p.begins_with("-") and not next_p in ["(", ")", "{", "}"]:
				p += " " + next_p
				i += 1
		merged_parts.append(p)
		i += 1
	if merged_parts.size() <= 0:
		return
	_设置正在加载UI(true)
	_核心命令输入.text = merged_parts[0]
	var 当前名 = _预设名输入.text.strip_edges()
	var 默认正则 = RegEx.new()
	默认正则.compile("^新模板(\\s*\\(副本\\))*$")
	if 当前名 == "" or 默认正则.search(当前名) or 当前名 == "新分类":
		_预设名输入.text = _调用清洗文本(原始文本)
	for 子 in _参数容器.get_children():
		子.queue_free()
	for k in range(1, merged_parts.size()):
		创建参数行("", "", merged_parts[k])
	_设置正在加载UI(false)
	_自动保存并更新预览()

func 弹出参数右键菜单(目标行: HBoxContainer):
	var menu = PopupMenu.new()
	_宿主.add_child(menu)
	menu.add_item("复制 (Copy)", 200)
	menu.add_item("粘贴 (Paste)", 201)
	menu.add_separator()
	menu.add_item("向下合并单行 (Merge Down)", 100)
	menu.add_item("合并至焦点行 (范围合并) (Ctrl+G)", 104)
	menu.add_item("将后续所有行合并至此 (Merge All Below)", 102)
	menu.add_item("将所有参数合并入核心命令 (Merge All to Core)", 103)
	menu.add_separator()
	menu.add_item("在此处下方添加变量 (Ctrl+B)", 101)
	var 焦点 = _宿主.get_viewport().gui_get_focus_owner()
	menu.id_pressed.connect(func(id):
		match id:
			200:
				if 焦点 is TextEdit:
					焦点.copy()
			201:
				if 焦点 is TextEdit:
					焦点.paste()
					_自动保存并更新预览()
			100:
				合并参数行(目标行)
			104:
				合并范围参数行(目标行)
			102:
				批量合并参数行(目标行, true)
			103:
				全部参数合并入核心()
			101:
				目标行.get_node("Value").grab_focus()
				创建参数行("", "", "")
		menu.queue_free()
	)
	menu.popup_on_parent(Rect2(_宿主.get_viewport().get_mouse_position(), Vector2.ZERO))

func 合并参数行(当前行: HBoxContainer):
	var children = _参数容器.get_children()
	var idx = children.find(当前行)
	if idx != -1 and idx < children.size() - 1:
		var 下一行 = children[idx + 1]
		var 下一值 = 下一行.get_node("Value").text
		当前行.get_node("Value").text += " " + 下一值
		下一行.queue_free()
		_宿主.get_tree().process_frame.connect(func(): _自动保存并更新预览(), CONNECT_ONE_SHOT)

func 批量合并参数行(起始行: HBoxContainer, _仅后续: bool):
	var children = _参数容器.get_children()
	var idx = children.find(起始行)
	if idx == -1:
		return
	var text_to_add = ""
	for i in range(idx + 1, children.size()):
		var line = children[i]
		if line.is_queued_for_deletion():
			continue
		text_to_add += " " + line.get_node("Value").text
		line.queue_free()
	起始行.get_node("Value").text += text_to_add
	_宿主.get_tree().process_frame.connect(func(): _自动保存并更新预览(), CONNECT_ONE_SHOT)

func 合并范围参数行(目标行: HBoxContainer):
	var 焦点 = _宿主.get_viewport().gui_get_focus_owner()
	if !is_instance_valid(焦点):
		return
	var 列表 = _参数容器.get_children()
	var 目标索引 = 列表.find(目标行)
	var 焦点索引 = -1
	for i in range(列表.size()):
		if 列表[i].is_ancestor_of(焦点):
			焦点索引 = i
			break
	if 焦点索引 == -1 or 焦点索引 == 目标索引:
		合并参数行(目标行)
		return
	var 起始 = min(焦点索引, 目标索引)
	var 结束 = max(焦点索引, 目标索引)
	var 头项 = 列表[起始]
	var 拼接文本 = ""
	for k in range(起始 + 1, 结束 + 1):
		var 项 = 列表[k]
		if 项.is_queued_for_deletion():
			continue
		拼接文本 += " " + 项.get_node("Value").text
		项.queue_free()
	头项.get_node("Value").text += 拼接文本
	_宿主.get_tree().process_frame.connect(func(): _自动保存并更新预览(), CONNECT_ONE_SHOT)

func 快捷范围合并():
	var mpos = _宿主.get_viewport().get_mouse_position()
	var 目标行 = null
	for line in _参数容器.get_children():
		if is_instance_valid(line) and line.get_global_rect().has_point(mpos):
			目标行 = line
			break
	if 目标行:
		合并范围参数行(目标行)

func 全部参数合并入核心():
	var text_to_add = ""
	for line in _参数容器.get_children():
		if line.is_queued_for_deletion():
			continue
		text_to_add += " " + line.get_node("Value").text
		line.queue_free()
	_核心命令输入.text += text_to_add
	_宿主.get_tree().process_frame.connect(func(): _自动保存并更新预览(), CONNECT_ONE_SHOT)

func _获取正在加载UI() -> bool:
	if _获取正在加载UI回调.is_valid():
		return bool(_获取正在加载UI回调.call())
	return false

func _设置正在加载UI(值: bool):
	if _设置正在加载UI回调.is_valid():
		_设置正在加载UI回调.call(值)

func _自动保存并更新预览():
	if _自动保存当前预设回调.is_valid():
		_自动保存当前预设回调.call()
	_调用更新预览()

func _调用更新预览():
	if _更新预览回调.is_valid():
		_更新预览回调.call()

func _调用清洗文本(文本: String) -> String:
	if _清洗文本回调.is_valid():
		return str(_清洗文本回调.call(文本))
	return 文本.strip_edges()
