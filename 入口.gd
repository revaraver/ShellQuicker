extends Node

# 入口脚本 Pro++ (大师极简交互版 - 终极流畅版)
# 支持键盘流搜素、自适应备注、单实例锁定、混合导航、配置持久化

@onready var 树状菜单: Tree = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 树状菜单
@onready var 右键菜单: PopupMenu = $右键菜单
@onready var 搜索框: LineEdit = $布局容器 / 顶部导航 / MarginContainer / 工具栏 / 搜索框区域 / 搜索框
@onready var 搜文件夹备注勾选: CheckBox = $布局容器 / 顶部导航 / MarginContainer / 工具栏 / 搜索框区域 / 搜文件夹备注
@onready var 搜模板备注勾选: CheckBox = $布局容器 / 顶部导航 / MarginContainer / 工具栏 / 搜索框区域 / 搜模板备注
var 搜夹连带子项勾选: CheckBox

@onready var 字体缩小按钮: Button = $布局容器 / 顶部导航 / MarginContainer / 工具栏 / 搜索框区域 / 字体缩小按钮
@onready var 字体增大按钮: Button = $布局容器 / 顶部导航 / MarginContainer / 工具栏 / 搜索框区域 / 字体增大按钮
@onready var 配置选择: OptionButton = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 配置管理栏 / 配置选择
@onready var 配置刷新按钮: Button = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 配置管理栏 / 配置刷新按钮
@onready var 配置重命名按钮: Button = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 配置管理栏 / 配置重命名按钮
@onready var 配置新建按钮: Button = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 配置管理栏 / 配置新建按钮
@onready var 配置删除按钮: Button = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 配置管理栏 / 配置删除按钮

@onready var 预设面板 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板
@onready var 文件夹面板 = $布局容器 / 主体区域 / 右侧内容栈 / 文件夹详情面板

# 预设详情
@onready var 预设名输入 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 标题栏 / 预设名称输入
@onready var 预设说明输入 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 预设说明输入
@onready var 前缀命令输入 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 前缀栏 / 前缀命令输入
@onready var 核心命令输入 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 属性栏 / 核心命令输入
@onready var 参数容器 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 参数滚屏 / 参数容器
@onready var 参数滚屏 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 参数滚屏
@onready var 添加参数按钮 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 按钮栏 / 添加参数按钮
@onready var 快捷新建模板 = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 树快捷操作 / 快捷新建模板
@onready var 快捷新建文件夹 = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 树快捷操作 / 快捷新建文件夹
@onready var Shell选择 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 底部动作 / Shell选择
@onready var UTF8模式 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 底部动作 / UTF8模式
@onready var 多开开关 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 底部动作 / 多开许可
@onready var 执行时复制开关 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 底部动作 / 执行时复制
@onready var 预览标签 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 预览面板 / M / 预览布局 / 详情预览
@onready var 复制指令按钮 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 预览面板 / M / 预览布局 / 复制指令按钮
@onready var 智能解析按钮 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 属性栏 / 智能解析按钮
@onready var 执行按钮 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 底部动作 / 执行预设按钮

# 文件夹详情
@onready var 文件夹标题 = $布局容器 / 主体区域 / 右侧内容栈 / 文件夹详情面板 / 文件夹描述容器 / 文件夹名称标题
@onready var 文件夹描述 = $布局容器 / 主体区域 / 右侧内容栈 / 文件夹详情面板 / 文件夹描述输入

var 当前选中ID: String = ""
var 正在重命名状态: bool = false
var _正在加载UI: bool = false
var 播放图标: Texture2D
var 当前字体大小: int = 18
var 预览片段索引表: Array = [] # 格式: { "start": 0, "end": 10, "node": Node }

func _ready():
	# --- 窗口自适应初始大小 (屏幕的一半并居中) ---
	var screen_size = DisplayServer.screen_get_size()
	var window_size = screen_size / 2
	DisplayServer.window_set_size(window_size)
	var screen_pos = DisplayServer.screen_get_position()
	DisplayServer.window_set_position(screen_pos + (screen_size - window_size) / 2)

	# --- 强制高分辨率任务栏图标 ---
	var img_tex = load("res://icon.png") as Texture2D
	if img_tex: DisplayServer.set_icon(img_tex.get_image())

	_加载内置图标()
	树状菜单.select_mode = Tree.SELECT_MULTI
	树状菜单.allow_rmb_select = true
	树状菜单.set_script(load("res://树辅助.gd"))
	树状菜单.入口 = self
	
	# --- 加载全局持久化配置 ---
	当前字体大小 = 配置管理器.全局配置.get("字体大小", 18)
	搜文件夹备注勾选.button_pressed = 配置管理器.全局配置.get("搜文件夹备注", true)
	搜模板备注勾选.button_pressed = 配置管理器.全局配置.get("搜模板备注", true)
	多开开关.button_pressed = 配置管理器.全局配置.get("允许多开", false)
	执行时复制开关.button_pressed = 配置管理器.全局配置.get("执行时复制", false)
	
	# --- 动态添加新复选框 ---
	搜夹连带子项勾选 = CheckBox.new()
	搜夹连带子项勾选.text = "显示文件夹穿透"
	搜夹连带子项勾选.button_pressed = 配置管理器.全局配置.get("搜夹连带子项", true)
	var tree_parent = 树状菜单.get_parent()
	tree_parent.add_child(搜夹连带子项勾选)
	tree_parent.move_child(搜夹连带子项勾选, 树状菜单.get_index() + 2)
	
	_初始化UI()
	
	# 信号连接
	树状菜单.item_selected.connect(_树项被选中)
	树状菜单.item_mouse_selected.connect(_on_tree_mouse_selected)
	树状菜单.item_edited.connect(_树项编辑完成)
	树状菜单.item_activated.connect(_执行双击改名)
	树状菜单.button_clicked.connect(_树上运行图标被点击)
	树状菜单.gui_input.connect(_树状菜单输入)
	
	搜索框.text_changed.connect(_搜索框内容改变)
	搜索框.gui_input.connect(_搜索框内按键处理)
	
	搜文件夹备注勾选.toggled.connect(_on_search_config_toggled.bind("搜文件夹备注"))
	搜模板备注勾选.toggled.connect(_on_search_config_toggled.bind("搜模板备注"))
	搜夹连带子项勾选.toggled.connect(_on_search_config_toggled.bind("搜夹连带子项"))
	
	字体增大按钮.pressed.connect(_调整字体大小.bind(2))
	字体缩小按钮.pressed.connect(_调整字体大小.bind(-2))
	
	添加参数按钮.pressed.connect(func(): 创建参数行("", "", ""))
	执行按钮.pressed.connect(_点击执行)
	右键菜单.id_pressed.connect(_右键菜单项被按下)
	
	配置选择.item_selected.connect(_切换配置文件)
	配置刷新按钮.pressed.connect(_刷新配置列表UI)
	配置新建按钮.pressed.connect(_请求新建配置)
	配置重命名按钮.pressed.connect(_请求重命名配置)
	配置删除按钮.pressed.connect(_请求删除配置)
	快捷新建模板.pressed.connect(_右键菜单项被按下.bind(0))
	快捷新建文件夹.pressed.connect(_右键菜单项被按下.bind(1))
	
	预设名输入.text_changed.connect(_自动保存当前预设)
	预设名输入.focus_entered.connect(更新预览); 预设名输入.focus_exited.connect(更新预览)
	预设说明输入.text_changed.connect(_自动保存当前预设)
	前缀命令输入.text_changed.connect(_自动保存当前预设)
	前缀命令输入.focus_entered.connect(更新预览); 前缀命令输入.focus_exited.connect(更新预览)
	核心命令输入.text_changed.connect(_on_core_command_changed)
	核心命令输入.focus_entered.connect(更新预览); 核心命令输入.focus_exited.connect(更新预览)
	智能解析按钮.pressed.connect(func(): _智能解析并覆盖参数(核心命令输入.text))
	Shell选择.item_selected.connect(_on_executor_setting_changed)
	UTF8模式.toggled.connect(_on_executor_setting_changed)
	多开开关.toggled.connect(_on_allow_multiple_toggled)
	执行时复制开关.toggled.connect(_on_copy_on_execute_toggled)
	复制指令按钮.pressed.connect(_on_copy_command_pressed)

	
	文件夹描述.text_changed.connect(_自动保存当前文件夹)
	文件夹标题.text_changed.connect(_自动保存当前文件夹)
	
	var 主体区域 = $布局容器 / 主体区域
	主体区域.split_offset = 配置管理器.全局配置.get("split_offset", 350)
	主体区域.dragged.connect(_on_layout_dragged)
	
	_刷新配置列表UI(); 刷新树状菜单()
	
	for p in [预设面板, 文件夹面板]:
		p.mouse_filter = Control.MOUSE_FILTER_PASS
		p.gui_input.connect(_on_panel_gui_input.bind(p))
	
	# --- 延迟一帧执行，确保树已完全渲染 ---
	get_tree().process_frame.connect(func():
		var 上次ID = 配置管理器.全局配置.get("上次选中ID", "")
		树状菜单.deselect_all()
		if 树状菜单.get_root(): 树状菜单.get_root().set_collapsed(false)
		
		if 上次ID != "" and 配置管理器.树状数据.has(上次ID):
			_递归选中树项(树状菜单.get_root(), 上次ID)
		elif 树状菜单.get_root() and 树状菜单.get_root().get_first_child():
			树状菜单.get_root().get_first_child().select(0)
			_树项被选中()
	, CONNECT_ONE_SHOT)

	# --- 恢复搜索状态 ---
	var 历史搜索 = 配置管理器.全局配置.get("搜索保留", "")
	搜夹连带子项勾选.disabled = (历史搜索.strip_edges() == "")
	搜夹连带子项勾选.visible = !(历史搜索.strip_edges() == "")
	if 历史搜索 != "":
		搜索框.text = 历史搜索
		_搜索框内容改变(历史搜索)

func _加载内置图标():
	var svg = "<svg viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M8 5V19L19 12L8 5Z' fill='#00ff88'/></svg>"
	var img = Image.new(); img.load_svg_from_string(svg)
	播放图标 = ImageTexture.create_from_image(img)

func _初始化UI():
	Shell选择.clear()
	Shell选择.add_item("CMD (原始终端)", 0)
	Shell选择.add_item("PowerShell (原始终端)", 1)
	Shell选择.add_item("WT - CMD (新版终端)", 2)
	Shell选择.add_item("WT - PowerShell (新版终端)", 3)
	
	添加参数按钮.text = "＋ 添加新的命令行变量 (Ctrl+B)"
	执行按钮.text = "🚀 立即运行 (Enter / Ctrl+Enter)"
	右键菜单.clear()
	右键菜单.add_item("新建模板 (Ctrl+A)", 0)
	右键菜单.add_item("新建文件夹 (Ctrl+N)", 1)
	右键菜单.add_separator()
	右键菜单.add_item("重命名 (F2)", 5)
	右键菜单.add_item("克隆副本 (Ctrl+D)", 3)
	右键菜单.add_item("删除项目 (Delete)", 4)
	
	
	_注入通用样式(self )

func _调整字体大小(增量:int):
	当前字体大小 = clamp(当前字体大小 + 增量, 12, 48)
	配置管理器.全局配置["字体大小"] = 当前字体大小; 配置管理器.保存全局配置(); _注入通用样式(self )

func _注入通用样式(节点:Node):
	if 节点 is LineEdit or 节点 is Button or 节点 is Label or 节点 is Tree or 节点 is CheckBox or 节点 is TextEdit or 节点 is PopupMenu or 节点 is RichTextLabel:
		if 节点 is RichTextLabel:
			节点.add_theme_font_size_override("normal_font_size", 当前字体大小)
			节点.add_theme_font_size_override("bold_font_size", 当前字体大小)
			节点.add_theme_font_size_override("italics_font_size", 当前字体大小)
		else:
			节点.add_theme_font_size_override("font_size", 当前字体大小)
		
		if 节点 is Label:
			节点.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			
		if 节点 is LineEdit or 节点 is TextEdit:
			var box = StyleBoxFlat.new()
			box.bg_color = Color(0.18, 0.2, 0.23); box.set_border_width_all(1)
			box.border_color = Color(0.25, 0.28, 0.32); box.corner_radius_top_left = 4; box.corner_radius_top_right = 4; box.corner_radius_bottom_left = 4; box.corner_radius_bottom_right = 4
			box.content_margin_top = 8; box.content_margin_bottom = 8; box.content_margin_left = 10; box.content_margin_right = 10
			节点.add_theme_stylebox_override("normal", box)
			
			# 为多行输入框特殊处理 Tab 键切换焦点
			if 节点 is TextEdit:
				节点.gui_input.connect(_TextEdit组件输入.bind(节点))
		
		# 增强 Tree 的内部编辑器样式
		if 节点 is Tree:
			节点.add_theme_color_override("font_color", Color.WHITE)
			节点.add_theme_color_override("font_selected_color", Color.WHITE)
			# 设置 Tree 的自定义主题以影响 LineEdit 弹出
			var custom_theme = 节点.theme if 节点.theme else Theme.new()
			custom_theme.set_font_size("font_size", "LineEdit", 当前字体大小)
			节点.theme = custom_theme

	if 节点 is OptionButton:
		var popup = 节点.get_popup()
		if popup: _注入通用样式(popup)

	for 子 in 节点.get_children(): _注入通用样式(子)

func _TextEdit组件输入(event: InputEvent, 节点:TextEdit):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB:
			get_viewport().set_input_as_handled()
			if event.shift_pressed:
				var prev = 节点.find_prev_valid_focus()
				if prev: prev.grab_focus()
			else:
				var next = 节点.find_next_valid_focus()
				if next: next.grab_focus()
		
		# 名称框特殊逻辑：回车即清洗并确认
		if (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER) and not event.ctrl_pressed:
			if 节点 == 预设名输入 or 节点 == 文件夹标题:
				节点.text = _清洗文本(节点.text)
				节点.release_focus()
				get_viewport().set_input_as_handled()

func _清洗文本(文本:String) -> String:
	var 规范文本 = 文本
	var 续行正则 = RegEx.new()
	续行正则.compile("\\s*[\\^\\\\]\\s*\\n")
	规范文本 = 续行正则.sub(规范文本, " ", true)
	规范文本 = 规范文本.replace("\r", " ").replace("\n", " ")
	return 规范文本.strip_edges()

func _input(event):
	# 点击空白区域失去焦点 (不包含滚动条和按钮点击)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner and not focus_owner.get_global_rect().has_point(event.global_position):
			# 如果是名称输入框，点击空白时也要清洗
			if focus_owner == 预设名输入 or focus_owner == 文件夹标题:
				focus_owner.text = _清洗文本(focus_owner.text)
			
			get_tree().process_frame.connect(func():
				var new_focus = get_viewport().gui_get_focus_owner()
				if new_focus == null:
					if is_instance_valid(focus_owner): focus_owner.release_focus()
			, CONNECT_ONE_SHOT)

	if event is InputEventKey and event.pressed:
		var 焦点 = get_viewport().gui_get_focus_owner()
		var 选中 = 树状菜单.get_selected()
		
		# --- 强制/全局运行快捷键 ---
		if event.ctrl_pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
			_点击执行(); get_viewport().set_input_as_handled(); return
		
		# --- Shift + Enter 智能解析 (输入状态下也有效) ---
		if event.shift_pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
			_智能解析并覆盖参数(核心命令输入.text); get_viewport().set_input_as_handled(); return
		
		# --- 核心 Ctrl + N 特权：随时新建文件夹 ---
		if event.ctrl_pressed and event.keycode == KEY_N:
			_右键菜单项被按下.call_deferred(1); get_viewport().set_input_as_handled(); return
		
		# --- Ctrl + G 范围合并快捷键 (焦点到鼠标位置) ---
		if event.ctrl_pressed and event.keycode == KEY_G:
			_快捷范围合并()
			get_viewport().set_input_as_handled(); return
		
		# --- Ctrl + C 复制快捷键 (非输入状态) ---
		if event.ctrl_pressed and event.keycode == KEY_C:
			var 是否在输入 = (焦点 is LineEdit or 焦点 is TextEdit)
			if not 是否在输入:
				_on_copy_command_pressed()
				get_viewport().set_input_as_handled(); return
		
		if (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
			if !(焦点 is TextEdit):
				_点击执行(); get_viewport().set_input_as_handled(); return

		# --- 非焦点状态快捷键 (即非输入状态) ---
		if event.ctrl_pressed:
			var 是否在输入 = (焦点 is LineEdit or 焦点 is TextEdit)
			if not 是否在输入:
				if event.keycode == KEY_A: _右键菜单项被按下(0); return # 新建模板
				if event.keycode == KEY_D: _右键菜单项被按下(3); return # 克隆副本
			
			# 全局生效快捷键 (Ctrl+F 搜索 / Ctrl+B 添加参数)
			if event.keycode == KEY_F:
				搜索框.grab_focus(); 搜索框.select_all()
				get_viewport().set_input_as_handled(); return
			
			if event.keycode == KEY_B and 预设面板.visible:
				创建参数行("", "", ""); return
		if !选中 or 正在重命名状态: return
		if 焦点 == 树状菜单:
			match event.keycode:
				KEY_F2: _触发重命名(选中)
				KEY_DELETE: _点击删除动作()
				KEY_ENTER: _点击执行()
				KEY_D: if event.ctrl_pressed: _点击克隆动作()

# --- 键盘流辅助逻辑 ---

func _搜索框内按键处理(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			# 如果搜索框内有内容但没选中，先选中第一项，再依赖全局 Enter 运行
			if 树状菜单.get_selected() == null:
				_选中全树第一个可见项()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_DOWN:
			var 项 = _寻找第一个可见项(树状菜单.get_root())
			if 项:
				树状菜单.deselect_all(); 项.select(0); 树状菜单.scroll_to_item(项); _树项被选中()
				树状菜单.grab_focus(); get_viewport().set_input_as_handled()

func _选中全树第一个可见项():
	var 项 = _寻找第一个可见项(树状菜单.get_root())
	if 项: 树状菜单.deselect_all(); 项.select(0); 树状菜单.scroll_to_item(项); _树项被选中()

func _寻找第一个可见项(根:TreeItem) -> TreeItem:
	var 子 = 根.get_first_child()
	while 子:
		if 子.visible:
			var 数据 = 配置管理器.树状数据.get(子.get_metadata(0))
			if 数据 and 数据["类型"] == "预设": return 子
			var 内部项 = _寻找第一个可见项(子)
			if 内部项: return 内部项
		子 = 子.get_next()
	return null

# --- 树状菜单增强导航 ---

func _树状菜单输入(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_更新右键菜单项状态(); 右键菜单.position = get_viewport().get_mouse_position(); 右键菜单.show()
	
	if event is InputEventKey and event.pressed:
		if !event.ctrl_pressed and !event.shift_pressed:
			if event.keycode == KEY_UP:
				_手动导航移动(-1); get_viewport().set_input_as_handled()
			elif event.keycode == KEY_DOWN:
				_手动导航移动(1); get_viewport().set_input_as_handled()

func _手动导航移动(方向:int):
	var 当前 = 树状菜单.get_selected(); if !当前: return
	var 目标: TreeItem = _获取下一个可见项(当前) if 方向 == 1 else _获取上一个可见项(当前)
	if 目标 and 目标 != 树状菜单.get_root():
		树状菜单.deselect_all(); 目标.select(0); 树状菜单.scroll_to_item(目标); _树项被选中()

func _获取下一个可见项(项:TreeItem) -> TreeItem:
	if 项.get_first_child() and !项.collapsed: return 项.get_first_child()
	if 项.get_next(): return 项.get_next()
	var p = 项.get_parent()
	while p:
		if p.get_next(): return p.get_next()
		p = p.get_parent()
	return null

func _获取上一个可见项(项:TreeItem) -> TreeItem:
	var prev = 项.get_prev()
	if prev:
		var curr = prev
		while curr.get_first_child() and !curr.collapsed:
			var last = curr.get_first_child()
			while last.get_next(): last = last.get_next()
			curr = last
		return curr
	var p = 项.get_parent()
	return p if p != 树状菜单.get_root() else null
# --- 核心交互逻辑 ---

func _执行双击改名():
	var 选中 = 树状菜单.get_selected(); if 选中:_触发重命名(选中)

func 创建参数行(键:String, 备注:String, 当前值:String):
	var 行 = HBoxContainer.new(); 行.add_theme_constant_override("separation", 10)
	
	var 键输入 = TextEdit.new(); 键输入.text = 键; 键输入.name = "Key"; 键输入.placeholder_text = "变量键"; 键输入.custom_minimum_size = Vector2(120, 0)
	键输入.size_flags_horizontal = Control.SIZE_EXPAND_FILL; 键输入.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY; 键输入.scroll_fit_content_height = true
	键输入.context_menu_enabled = false # 关闭系统菜单
	键输入.text_changed.connect(func(): _自动保存当前预设(); 更新预览())
	键输入.focus_entered.connect(更新预览); 键输入.focus_exited.connect(更新预览)
	
	var 值输入 = TextEdit.new(); 值输入.text = 当前值; 值输入.name = "Value"; 值输入.placeholder_text = "值"; 值输入.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	值输入.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY; 值输入.scroll_fit_content_height = true
	值输入.context_menu_enabled = false # 关闭系统菜单
	值输入.text_changed.connect(func(): _自动保存当前预设(); 更新预览())
	值输入.focus_entered.connect(更新预览); 值输入.focus_exited.connect(更新预览)
	
	var 备注输入 = TextEdit.new(); 备注输入.text = 备注; 备注输入.name = "Note"; 备注输入.placeholder_text = "参数说明..."; 备注输入.custom_minimum_size = Vector2(200, 40)
	备注输入.size_flags_vertical = Control.SIZE_SHRINK_CENTER; 备注输入.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY; 备注输入.scroll_fit_content_height = true
	备注输入.context_menu_enabled = false # 关闭系统菜单
	备注输入.text_changed.connect(func(): _自动保存当前预设())
	
	var 删除按钮 = Button.new(); 删除按钮.text = " ✖ "; 删除按钮.add_theme_color_override("font_color", Color.INDIAN_RED); 删除按钮.focus_mode = Control.FOCUS_CLICK
	删除按钮.pressed.connect(func():
		if !is_instance_valid(行): return
		行.queue_free()
		get_tree().process_frame.connect(func(): _自动保存当前预设(); 更新预览(), CONNECT_ONE_SHOT)
	)
	
	行.add_child(键输入); 行.add_child(值输入); 行.add_child(备注输入); 行.add_child(删除按钮)
	
	# 右键合并功能支持
	var 响应界面 = [行, 键输入, 值输入, 备注输入]
	for ctrl in 响应界面:
		ctrl.gui_input.connect(func(e):
			if is_instance_valid(行) and e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_RIGHT:
				_弹出参数右键菜单(行)
		)

	# --- 智能插入位置逻辑 ---
	var 插入索引 = -1
	if not _正在加载UI:
		var 焦点 = get_viewport().gui_get_focus_owner()
		if 焦点:
			if 焦点 == 核心命令输入:
				插入索引 = 0
			else:
				var 列表 = 参数容器.get_children()
				for i in range(列表.size()):
					if 列表[i].is_ancestor_of(焦点):
						插入索引 = i + 1; break
	
	参数容器.add_child(行)
	if 插入索引 != -1: 参数容器.move_child(行, 插入索引)
	
	_注入通用样式(行); 更新预览()
	# 添加后如果非正在加载状态，则自动让新 Key 获得焦点，方便连续输入
	if not _正在加载UI:
		get_tree().process_frame.connect(func():
			if is_instance_valid(键输入): 键输入.grab_focus()
		, CONNECT_ONE_SHOT)

func _树项被选中():
	var 选中 = _获取所有选中项()
	if 选中.size() != 1: 当前选中ID = ""; 预设面板.hide(); 文件夹面板.hide(); return
	var 项 = 选中[0]; var id = 项.get_metadata(0)
	if id == 当前选中ID and (预设面板.visible or 文件夹面板.visible): return
	当前选中ID = id; 配置管理器.全局配置["上次选中ID"] = 当前选中ID; 配置管理器.保存全局配置()
	_加载数据到界面(配置管理器.树状数据.get(当前选中ID))

func _加载数据到界面(数据:Dictionary):
	if !数据: return
	_正在加载UI = true
	if 数据["类型"] == "文件夹":
		文件夹面板.show(); 预设面板.hide()
		文件夹标题.text = 数据["名称"]; 文件夹描述.text = 数据.get("描述", "")
	else:
		文件夹面板.hide(); 预设面板.show()
		_加载预设详情(数据)
	_正在加载UI = false

func _加载预设详情(数据:Dictionary):
	预设名输入.text = 数据["名称"]; 预设说明输入.text = 数据.get("描述", ""); 前缀命令输入.text = 数据.get("前缀命令", ""); 核心命令输入.text = 数据["固定命令"]; Shell选择.selected = 数据.get("Shell类型", 0)
	UTF8模式.button_pressed = 数据.get("UTF8模式", false)
	for 子 in 参数容器.get_children(): 子.queue_free()
	for 项 in 数据.get("参数列表", []): 创建参数行(项["键"], 项["备注"], 项.get("当前值", ""))
	更新预览()

func _智能解析并覆盖参数(文本:String):
	if _正在加载UI: return
	var 原始文本 = 文本.strip_edges()
	if 原始文本 == "": return
	
	# 1. 预处理：规范化续行符（Windows ^ 和 Linux \）
	# 将 " ^\n" 或 " \\\n" 替换为空格，合并为单行处理
	var 规范文本 = 原始文本
	var 续行正则 = RegEx.new()
	续行正则.compile("\\s*[\\^\\\\]\\s*\\n")
	规范文本 = 续行正则.sub(规范文本, " ", true)
	规范文本 = 规范文本.replace("\r", " ").replace("\n", " ") # 彻底抹平换行
	
	# 2. 正则拆分：识别引号路径、普通单词
	var regex = RegEx.new()
	regex.compile("(\"[^\"]*\"|'[^']*'|[^\\s]+)")
	var matches = regex.search_all(规范文本)
	if matches.size() <= 1: return
	
	var raw_parts = []
	for m in matches:
		var p = m.get_string().strip_edges()
		if p != "" and p != "^" and p != "\\": # 过滤无意义的孤立续行符
			raw_parts.append(p)
	
	# 3. 智能聚合：识别 -flag value 结构并合并为一行参数
	var merged_parts = []
	var i = 0
	while i < raw_parts.size():
		var p = raw_parts[i]
		# 如果是以 - 开头的标志位，且后面跟着一个普通值（不是标志位也不是括号），则合并
		if p.begins_with("-") and i + 1 < raw_parts.size():
			var next_p = raw_parts[i + 1]
			if not next_p.begins_with("-") and not next_p in ["(", ")", "{", "}"]:
				p += " " + next_p
				i += 1
		merged_parts.append(p)
		i += 1
	
	if merged_parts.size() <= 0: return

	# 4. 应用到 UI
	_正在加载UI = true
	# 第一个是核心命令
	核心命令输入.text = merged_parts[0]
	
	# 自动重命名判断
	var 当前名 = 预设名输入.text.strip_edges()
	var 默认正则 = RegEx.new(); 默认正则.compile("^新模板(\\s*\\(副本\\))*$")
	if 当前名 == "" or 默认正则.search(当前名) or 当前名 == "新分类":
		预设名输入.text = _清洗文本(原始文本)
	
	# 清空并重新填充参数列表
	for 子 in 参数容器.get_children(): 子.queue_free()
	for k in range(1, merged_parts.size()):
		创建参数行("", "", merged_parts[k])
	
	_正在加载UI = false
	_自动保存当前预设()
	更新预览()

func 刷新树状菜单():
	树状菜单.clear(); var 根 = 树状菜单.create_item(); 填充树递归("", 根)
	_动态更新当前搜索()
	if 当前选中ID != "": _递归选中树项(树状菜单.get_root(), 当前选中ID)

func _动态更新当前搜索():
	if is_instance_valid(搜索框) and 搜索框.text != "":
		var 根 = 树状菜单.get_root(); if 根:_搜索递归增强(根, 搜索框.text.to_lower(), false)

func 填充树递归(pid: String, parent_item: TreeItem):
	var nodes = 配置管理器.获取子节点(pid)
	for n in nodes:
		var item = 树状菜单.create_item(parent_item); item.set_text(0, n["名称"]); item.set_metadata(0, n["ID"])
		if n["类型"] == "文件夹": item.set_custom_color(0, Color.GOLDENROD)
		else: item.add_button(0, 播放图标, 0, false, "立即执行")
		填充树递归(n["ID"], item)

func _搜索框内容改变(新文本:String):
	配置管理器.全局配置["搜索保留"] = 新文本
	配置管理器.保存全局配置()
	
	if is_instance_valid(搜夹连带子项勾选):
		搜夹连带子项勾选.disabled = (新文本.strip_edges() == "")
		搜夹连带子项勾选.visible = !(新文本.strip_edges() == "")
		
	if 新文本 == "": 刷新树状菜单(); return
	var 根 = 树状菜单.get_root(); if 根:_搜索递归增强(根, 新文本.to_lower(), false)

func _搜索递归增强(项:TreeItem, 文本:String, 祖先强行显示: bool = false) -> bool:
	var id = 项.get_metadata(0); var 数据 = 配置管理器.树状数据.get(id)
	var 匹配名称 = 文本 in 项.get_text(0).to_lower(); var 匹配备注 = false
	if 数据:
		if 数据["类型"] == "文件夹" and 搜文件夹备注勾选.button_pressed:
			var 备注 = 数据.get("描述", "").to_lower()
			if 文本 in 备注: 匹配备注 = true
		elif 数据["类型"] == "预设" and 搜模板备注勾选.button_pressed:
			var 备注 = 数据.get("描述", "").to_lower()
			if 文本 in 备注: 匹配备注 = true
	var 自己匹配 = 匹配名称 or 匹配备注 or 祖先强行显示
	
	var 作为连带触发点 = false
	if 数据 and 数据["类型"] == "文件夹" and 搜夹连带子项勾选.button_pressed and (匹配名称 or 匹配备注):
		作为连带触发点 = true
		
	var 子项匹配 = false; var 子 = 项.get_first_child()
	while 子:
		if _搜索递归增强(子, 文本, 祖先强行显示 or 作为连带触发点): 子项匹配 = true
		子 = 子.get_next()
	项.visible = 自己匹配 or 子项匹配; return 项.visible

func _自动保存当前预设():
	if _正在加载UI or 当前选中ID == "": return
	var 数据 = 配置管理器.树状数据.get(当前选中ID); if !数据 or 数据["类型"] != "预设": return
	数据["名称"] = 预设名输入.text; 数据["描述"] = 预设说明输入.text; 数据["固定命令"] = 核心命令输入.text; 数据["Shell类型"] = Shell选择.selected
	数据["UTF8模式"] = UTF8模式.button_pressed
	数据["参数列表"] = []
	for 行 in 参数容器.get_children():
		if 行.is_queued_for_deletion(): continue
		数据["参数列表"].append({"键": 行.get_node("Key").text, "备注": 行.get_node("Note").text, "当前值": 行.get_node("Value").text})
	配置管理器.保存预设(); var 项 = 树状菜单.get_selected()
	if 项 and 项.get_metadata(0) == 当前选中ID: 项.set_text(0, 数据["名称"])
	_动态更新当前搜索()

func _自动保存当前文件夹():
	if _正在加载UI or 当前选中ID == "": return
	var 数据 = 配置管理器.树状数据.get(当前选中ID); if !数据 or 数据["类型"] != "文件夹": return
	数据["名称"] = 文件夹标题.text; 数据["描述"] = 文件夹描述.text; 配置管理器.保存预设()
	var 项 = 树状菜单.get_selected()
	if 项 and 项.get_metadata(0) == 当前选中ID: 项.set_text(0, 数据["名称"])
	_动态更新当前搜索()

func _get_drag_data_logic(_pos):
	var selected = _获取所有选中项(); if selected.is_empty(): return null
	var preview = Label.new(); preview.text = " 📦 多选移动中(" + str(selected.size()) + ")" if selected.size() > 1 else " 📦 " + selected[0].get_text(0)
	树状菜单.set_drag_preview(preview); return selected

func _can_drop_data_logic(_pos, data):
	return data is Array and !data.is_empty() and data[0] is TreeItem

func _drop_data_logic(pos, items):
	var drop_section = 树状菜单.get_drop_section_at_position(pos)
	var target = 树状菜单.get_item_at_position(pos)
	if !target: return
	
	var target_id = target.get_metadata(0)
	var 目标数据 = 配置管理器.树状数据.get(target_id)
	if !目标数据: return
	
	var 新父ID = ""
	var 插入索引 = -1
	
	if drop_section == 0: # 落在项正中间
		if 目标数据["类型"] == "文件夹":
			新父ID = target_id
			插入索引 = 0 # 移入文件夹头部
		else:
			新父ID = 目标数据.get("父节点", "")
			var 兄弟们 = 配置管理器.获取子节点(新父ID)
			for k in range(兄弟们.size()):
				if 兄弟们[k]["ID"] == target_id: 插入索引 = k; break
	else: # 落在项的上方或下方
		新父ID = 目标数据.get("父节点", "")
		var 兄弟们 = 配置管理器.获取子节点(新父ID)
		for k in range(兄弟们.size()):
			if 兄弟们[k]["ID"] == target_id:
				插入索引 = k if drop_section == -1 else k + 1
				break

	var 移动项ID集 = []
	for item in items:
		var id = item.get_metadata(0)
		if id == target_id: continue
		if 配置管理器.树状数据[id]["类型"] == "文件夹" and _检查是否为子孙(id, 新父ID): continue
		配置管理器.树状数据[id]["父节点"] = 新父ID
		移动项ID集.append(id)
	
	# 同步所有兄弟的排序权重
	var 原兄弟们 = 配置管理器.获取子节点(新父ID)
	var 新序列 = []
	for b in 原兄弟们:
		if b["ID"] not in 移动项ID集: 新序列.append(b["ID"])
	
	if 插入索引 == -1: 新序列.append_array(移动项ID集)
	else:
		for j in range(移动项ID集.size()):
			新序列.insert(插入索引 + j, 移动项ID集[j])
			
	配置管理器.更新排序(新序列)
	刷新树状菜单()
	# 恢复焦点与选中
	树状菜单.grab_focus()
	if 移动项ID集.size() > 0:
		_递归选中树项(树状菜单.get_root(), 移动项ID集[0])

func _检查是否为子孙(祖先ID: String, 目标ID: String) -> bool:
	if 目标ID == "": return false
	if 祖先ID == 目标ID: return true
	var cur = 目标ID
	while cur != "":
		var d = 配置管理器.树状数据.get(cur); if !d: break
		var p = d.get("父节点", ""); if p == 祖先ID: return true
		cur = p
	return false

func 更新预览():
	var 焦点 = get_viewport().gui_get_focus_owner()
	var prefix_cmd = _清洗文本(前缀命令输入.text)
	var base_cmd = _清洗文本(核心命令输入.text)
	var final_bb = ""
	
	# 前缀 (chcp 等) - 灰色显示
	var 连接符 = " && " if (Shell选择.selected == 0 or Shell选择.selected == 2) else " ; "
	if UTF8模式.button_pressed:
		final_bb += "[color=#666666]chcp 65001 > nul" + 连接符 + "[/color]"
	
	# 前缀命令
	if prefix_cmd != "":
		var is_prefix_focused = (焦点 == 前缀命令输入)
		if is_prefix_focused: final_bb += "[color=#00ff88]" + prefix_cmd + "[/color] "
		else: final_bb += "[color=#aaaaaa]" + prefix_cmd + "[/color] "
	
	# 核心命令
	var is_core_focused = (焦点 == 核心命令输入)
	if is_core_focused: final_bb += "[color=#00ff88]" + base_cmd + "[/color]"
	else: final_bb += "[color=#ffffff]" + base_cmd + "[/color]"
	
	for 行 in 参数容器.get_children():
		if 行.is_queued_for_deletion(): continue
		var 值 = 行.get_node("Value").text.strip_edges()
		var 显示文本 = 值 if 值 != "" else "[" + 行.get_node("Key").text + "]"
		var is_row_focused = (is_instance_valid(焦点) and 行.is_ancestor_of(焦点))
		
		final_bb += " "
		if is_row_focused:
			final_bb += "[color=#00ff88]" + 显示文本 + "[/color]"
		else:
			final_bb += "[color=#aaaaaa]" + 显示文本 + "[/color]"
	
	预览标签.text = final_bb

func _弹出参数右键菜单(目标行:HBoxContainer):
	var menu = PopupMenu.new(); add_child(menu)
	menu.add_item("复制 (Copy)", 200)
	menu.add_item("粘贴 (Paste)", 201)
	menu.add_separator()
	menu.add_item("向下合并单行 (Merge Down)", 100)
	menu.add_item("合并至焦点行 (范围合并) (Ctrl+G)", 104)
	menu.add_item("将后续所有行合并至此 (Merge All Below)", 102)
	menu.add_item("将所有参数合并入核心命令 (Merge All to Core)", 103)
	menu.add_separator()
	menu.add_item("在此处下方添加变量 (Ctrl+B)", 101)
	
	# 面向当前焦点的文字操作
	var 焦点 = get_viewport().gui_get_focus_owner()
	
	menu.id_pressed.connect(func(id):
		match id:
			200: if 焦点 is TextEdit: 焦点.copy()
			201: if 焦点 is TextEdit: 焦点.paste(); _自动保存当前预设(); 更新预览()
			100: _合并参数行(目标行)
			104: _合并范围参数行(目标行)
			102: _批量合并参数行(目标行, true)
			103: _全部参数合并入核心()
			101: 目标行.get_node("Value").grab_focus(); 创建参数行("", "", "")
		menu.queue_free()
	)
	menu.popup_on_parent(Rect2(get_viewport().get_mouse_position(), Vector2.ZERO))

func _合并参数行(当前行:HBoxContainer):
	var children = 参数容器.get_children()
	var idx = children.find(当前行)
	if idx != -1 and idx < children.size() - 1:
		var 下一行 = children[idx + 1]
		var 下一值 = 下一行.get_node("Value").text
		当前行.get_node("Value").text += " " + 下一值
		下一行.queue_free()
		get_tree().process_frame.connect(func(): _自动保存当前预设(); 更新预览(), CONNECT_ONE_SHOT)

func _批量合并参数行(起始行:HBoxContainer, _仅后续: bool):
	var children = 参数容器.get_children()
	var idx = children.find(起始行)
	if idx == -1: return
	
	var text_to_add = ""
	for i in range(idx + 1, children.size()):
		var line = children[i]
		if line.is_queued_for_deletion(): continue
		text_to_add += " " + line.get_node("Value").text
		line.queue_free()
	
	起始行.get_node("Value").text += text_to_add
	get_tree().process_frame.connect(func(): _自动保存当前预设(); 更新预览(), CONNECT_ONE_SHOT)

func _合并范围参数行(目标行:HBoxContainer):
	var 焦点 = get_viewport().gui_get_focus_owner()
	if !is_instance_valid(焦点): return
	
	var 列表 = 参数容器.get_children()
	var 目标索引 = 列表.find(目标行)
	var 焦点索引 = -1
	
	for i in range(列表.size()):
		if 列表[i].is_ancestor_of(焦点):
			焦点索引 = i; break
	
	if 焦点索引 == -1 or 焦点索引 == 目标索引:
		_合并参数行(目标行) # 退化为单行合并
		return
	
	var 起始 = min(焦点索引, 目标索引)
	var 结束 = max(焦点索引, 目标索引)
	var 头项 = 列表[起始]
	var 拼接文本 = ""
	
	for k in range(起始 + 1, 结束 + 1):
		var 项 = 列表[k]
		if 项.is_queued_for_deletion(): continue
		拼接文本 += " " + 项.get_node("Value").text
		项.queue_free()
	
	头项.get_node("Value").text += 拼接文本
	get_tree().process_frame.connect(func(): _自动保存当前预设(); 更新预览(), CONNECT_ONE_SHOT)

func _快捷范围合并():
	var mpos = get_viewport().get_mouse_position()
	var 目标行 = null
	for line in 参数容器.get_children():
		if is_instance_valid(line) and line.get_global_rect().has_point(mpos):
			目标行 = line; break
	if 目标行:_合并范围参数行(目标行)

func _全部参数合并入核心():
	var text_to_add = ""
	for line in 参数容器.get_children():
		if line.is_queued_for_deletion(): continue
		text_to_add += " " + line.get_node("Value").text
		line.queue_free()
	
	核心命令输入.text += text_to_add
	get_tree().process_frame.connect(func(): _自动保存当前预设(); 更新预览(), CONNECT_ONE_SHOT)

# --- 重构：信号命名方法 (消除 Lambda Freed 隐患) ---

func _on_tree_mouse_selected(_pos: Vector2, _btn_idx: int):
	_树项被选中()

func _on_search_config_toggled(pressed: bool, kind: String):
	配置管理器.全局配置[kind] = pressed
	配置管理器.保存全局配置()
	_搜索框内容改变(搜索框.text)

func _on_allow_multiple_toggled(pressed: bool):
	配置管理器.全局配置["允许多开"] = pressed
	配置管理器.保存全局配置()

func _on_copy_on_execute_toggled(pressed: bool):
	配置管理器.全局配置["执行时复制"] = pressed
	配置管理器.保存全局配置()

func _on_core_command_changed():
	_自动保存当前预设(); 更新预览()

func _on_executor_setting_changed(_i = 0):
	_自动保存当前预设(); 更新预览()

func _on_copy_command_pressed():
	# 从富文本中提取纯文本
	DisplayServer.clipboard_set(预览标签.get_parsed_text())
	预览标签.select_all()

func _on_layout_dragged(offset):
	配置管理器.全局配置["split_offset"] = offset
	配置管理器.保存全局配置()

func _on_panel_gui_input(e, p):
	if !is_instance_valid(p): return
	if e is InputEventMouseButton and e.pressed:
		var node_focus = get_viewport().gui_get_focus_owner()
		if is_instance_valid(node_focus): node_focus.release_focus()

func _点击执行():
	if 当前选中ID == "" or 预设面板.visible == false: return
	_自动保存当前预设()
	var 数据 = 配置管理器.树状数据[当前选中ID]
	
	var prefix = _清洗文本(数据.get("前缀命令", ""))
	var core_cmd = _清洗文本(数据.get("固定命令", ""))
	
	# 核心拼装
	var 完整命令 = core_cmd
	if prefix != "":
		完整命令 = prefix + " " + core_cmd
	
	# 拼装参数
	for 行 in 参数容器.get_children():
		if 行.is_queued_for_deletion(): continue
		var value = 行.get_node("Value").text.strip_edges()
		if value != "":
			完整命令 += " " + value
	
	# 自动复制
	if 执行时复制开关.button_pressed:
		DisplayServer.clipboard_set(完整命令)
	
	_拉起窗口(Shell选择.selected, 完整命令, 数据.get("UTF8模式", false))

func _拉起窗口(类型:int, 完整命令:String, 开启UTF8: bool = false):
	var 命令 = 完整命令
	var 是PS = (类型 == 1 or 类型 == 3)
	
	# --- 添加命令回显提示 ---
	var 基础路径 = ProjectSettings.globalize_path("res://").replace("/", "\\")
	if 基础路径.ends_with("\\"): 基础路径 = 基础路径.left(-1)
	
	if 是PS:
		# PS 使用 Write-Host 提供颜色高亮，单引号内两单引号表示转义
		var 安全串 = 完整命令.replace("'", "''")
		var 提示 = "Write-Host '[ShellQuicker | PowerShell]' -ForegroundColor DarkCyan ; "
		提示 += "Write-Host 'PS " + 基础路径 + "> ' -NoNewline ; "
		提示 += "Write-Host '" + 安全串 + "' -ForegroundColor White ; "
		命令 = 提示 + 完整命令
	else:
		# CMD 使用 echo，转义管道和逻辑符防截断
		var 安全串 = 完整命令.replace("&", "^&").replace("|", "^|").replace(">", "^>").replace("<", "^<")
		var 提示 = "echo [ShellQuicker ^| CMD] & echo " + 基础路径 + "^> " + 安全串 + " & "
		命令 = 提示 + 完整命令
	
	if 开启UTF8:
		if 是PS:
			命令 = "chcp 65001 > $null ; " + 命令
		else:
			命令 = "chcp 65001 > nul && " + 命令
	
	match 类型:
		0: OS.create_process("cmd", ["/c", "start", "cmd", "/k", 命令])
		1: OS.create_process("cmd", ["/c", "start", "powershell", "-noexit", "-command", 命令])
		2: 
			# WT 需要对分号进行转义，否则会被误认为 WT 自身的分隔符
			var wt_cmd = 命令.replace(";", "\\;")
			OS.create_process("wt", ["-d", ".", "cmd", "/k", wt_cmd])
		3: 
			var wt_cmd = 命令.replace(";", "\\;")
			OS.create_process("wt", ["-d", ".", "powershell", "-noexit", "-command", wt_cmd])

func _树上运行图标被点击(项:TreeItem, _c, _i, _idx):
	var node_id = 项.get_metadata(0); var 数据 = 配置管理器.树状数据.get(node_id)
	if 数据 and 数据["类型"] == "预设":
		if node_id == 当前选中ID:_自动保存当前预设()

		var prefix = _清洗文本(数据.get("前缀命令", ""))
		var core_cmd = 数据.get("固定命令", "")

		var 完整命令 = core_cmd
		if prefix != "":
			完整命令 = prefix + " " + core_cmd

		for p in 数据.get("参数列表", []):
			var val = p.get("当前值", "").strip_edges()
			if val != "":
				完整命令 += " " + val

		if 执行时复制开关.button_pressed:
			DisplayServer.clipboard_set(完整命令)

		_拉起窗口(数据.get("Shell类型", 0), 完整命令, 数据.get("UTF8模式", false))

func _触发重命名(项:TreeItem):
	if !项: return
	正在重命名状态 = true; 项.set_editable(0, true); 树状菜单.edit_selected()

func _树项编辑完成():
	正在重命名状态 = false; var 项 = 树状菜单.get_selected()
	if 项:
		var id = 项.get_metadata(0); var 新名 = 项.get_text(0)
		配置管理器.重命名节点(id, 新名)
		# 实时同步右侧详情页
		if id == 当前选中ID:
			if 预设面板.visible: 预设名输入.text = 新名
			elif 文件夹面板.visible: 文件夹标题.text = 新名
		项.set_editable(0, false)
		_动态更新当前搜索()

func _点击删除动作():
	var 选中 = _获取所有选中项(); if 选中.is_empty(): return
	for s in 选中: 配置管理器.删除节点(s.get_metadata(0))
	刷新树状菜单(); 预设面板.hide(); 文件夹面板.hide()

func _点击克隆动作():
	var 选中 = _获取所有选中项(); if 选中.size() != 1: return
	var sid = 选中[0].get_metadata(0)
	var 目标父ID = 配置管理器.树状数据[sid].get("父节点", "")
	var nid = _递归深度克隆(sid, 目标父ID)
	
	# 智能定位到下方
	var 兄弟们 = 配置管理器.获取子节点(目标父ID)
	var 序列 = []
	var 插入位置 = -1
	for k in range(兄弟们.size()):
		var id = 兄弟们[k]["ID"]
		if id == nid: continue
		序列.append(id)
		if id == sid: 插入位置 = 序列.size() # 在 sid 之后插入
	
	if 插入位置 != -1: 序列.insert(插入位置, nid)
	else : 序列.append(nid)
	
	配置管理器.更新排序(序列)
	刷新树状菜单(); _递归选中树项(树状菜单.get_root(), nid)

func _递归深度克隆(源ID: String, 新父ID: String) -> String:
	var 源数据 = 配置管理器.树状数据[源ID]; var 新ID = str(Time.get_ticks_msec()) + "_" + str(randi() % 1000); var 新数据 = 源数据.duplicate(true); 新数据["父节点"] = 新父ID
	if 新数据["名称"] == 源数据["名称"]: 新数据["名称"] += " (副本)"
	配置管理器.树状数据[新ID] = 新数据
	if 源数据["类型"] == "文件夹":
		var keys = 配置管理器.树状数据.keys()
		for k in keys:
			if 配置管理器.树状数据.has(k) and 配置管理器.树状数据[k].get("父节点") == 源ID:_递归深度克隆(k, 新ID)
	配置管理器.保存预设()
	return 新ID

func _更新右键菜单项状态():
	var 选中 = _获取所有选中项()
	右键菜单.set_item_disabled(0, 选中.size() > 1); 右键菜单.set_item_disabled(1, 选中.size() > 1)
	右键菜单.set_item_disabled(3, 选中.size() > 1); 右键菜单.set_item_disabled(5, 选中.size() > 1)

func _右键菜单项被按下(id: int):
	var 选中 = 树状菜单.get_selected()
	var 目标父ID = ""
	var 插入索引 = -1
	
	if 选中:
		var 选中ID = 选中.get_metadata(0)
		var 选中数据 = 配置管理器.树状数据.get(选中ID)
		if 选中数据:
			if 选中数据["类型"] == "文件夹":
				目标父ID = 选中ID
				插入索引 = 0 # 进入文件夹，放在第一个
			else:
				目标父ID = 选中数据.get("父节点", "")
				var 兄弟们 = 配置管理器.获取子节点(目标父ID)
				for k in range(兄弟们.size()):
					if 兄弟们[k]["ID"] == 选中ID:
						插入索引 = k + 1; break
	
	match id:
		0, 1:
			var nid = str(Time.get_ticks_msec())
			var 数据 = {}
			if id == 0:
				数据 = {"名称": "新模板", "类型": "预设", "父节点": 目标父ID,"固定命令": "", "参数列表": [], "Shell类型": 0, "order": 999}
			else:
				数据 = {"名称": "新分类", "类型": "文件夹", "父节点": 目标父ID,"描述": "", "order": 999}
			
			配置管理器.添加节点(nid, 数据)
			# 插入排序逻辑
			var 兄弟们 = 配置管理器.获取子节点(目标父ID)
			var 序列 = []
			for b in 兄弟们:
				if b["ID"] == nid: continue # 先排除自己
				序列.append(b["ID"])
			
			if 插入索引 == -1: 序列.append(nid)
			else : 序列.insert(插入索引, nid)
			
			配置管理器.更新排序(序列)
			刷新树状菜单(); _递归选中树项(树状菜单.get_root(), nid)
		3: _点击克隆动作()
		5: if 选中:_触发重命名(选中)
		4: _点击删除动作()

func _获取所有选中项() -> Array:
	var 结果 = []; var 项 = 树状菜单.get_next_selected(null)
	while 项: 结果.append(项); 项 = 树状菜单.get_next_selected(项)
	return 结果

func _递归选中树项(当前项:TreeItem, 目标ID: String) -> bool:
	var 子 = 当前项.get_first_child()
	while 子:
		if 子.get_metadata(0) == 目标ID: 树状菜单.deselect_all(); 子.select(0); 树状菜单.scroll_to_item(子); _树项被选中(); return true
		if _递归选中树项(子, 目标ID): return true
		子 = 子.get_next()
	return false

func _递归同步排序(项:TreeItem):
	var ids = []; var 子 = 项.get_first_child()
	while 子:ids.append(子.get_metadata(0)); _递归同步排序(子); 子 = 子.get_next()
	if ids.size() > 0: 配置管理器.更新排序(ids)

# --- 配置文件管理交互 ---

func _刷新配置列表UI():
	配置选择.clear()
	var list = 配置管理器.获取配置文件列表()
	var current = 配置管理器.配置文件别名
	for i in range(list.size()):
		配置选择.add_item(list[i])
		if list[i] == current: 配置选择.selected = i

func _切换配置文件(index: int):
	var profile_name = 配置选择.get_item_text(index)
	配置管理器.切换配置文件(profile_name)
	刷新树状菜单()
	预设面板.hide(); 文件夹面板.hide()

func _请求新建配置():
	var dialog = AcceptDialog.new(); dialog.title = "新建配置"; add_child(dialog)
	var input = LineEdit.new(); input.placeholder_text = "输入新配置文件名..."; dialog.add_child(input)
	dialog.get_ok_button().text = "创建"
	dialog.confirmed.connect(func():
		var n = input.text.strip_edges()
		if n != "" and 配置管理器.新建配置文件(n):
			_刷新配置列表UI(); 刷新树状菜单(); 预设面板.hide(); 文件夹面板.hide()
		dialog.queue_free()
	)
	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered(Vector2i(300, 100))

func _请求重命名配置():
	var dialog = AcceptDialog.new(); dialog.title = "重命名配置"; add_child(dialog)
	var input = LineEdit.new(); input.text = 配置管理器.配置文件别名;dialog.add_child(input)
	dialog.get_ok_button().text = "确定"
	dialog.confirmed.connect(func():
		var n = input.text.strip_edges()
		if n != "" and 配置管理器.重命名当前配置(n):
			_刷新配置列表UI()
		dialog.queue_free()
	)
	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered(Vector2i(300, 100))

func _请求删除配置():
	var dialog = ConfirmationDialog.new(); dialog.title = "删除确认"; dialog.dialog_text = "确定要删除当前配置文件吗？该操作不可撤销。"
	add_child(dialog)
	dialog.confirmed.connect(func():
		配置管理器.删除当前配置()
		_刷新配置列表UI(); 刷新树状菜单(); 预设面板.hide(); 文件夹面板.hide()
		dialog.queue_free()
	)
	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered()
