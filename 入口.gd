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
@onready var 启动目录输入 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 启动目录栏 / 启动目录输入
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
@onready var 执行目录预览 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 预览面板 / M / 预览布局 / 执行目录行 / 执行目录预览
@onready var 预览标签 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 预览面板 / M / 预览布局 / 命令预览行 / 详情预览
@onready var 复制指令按钮 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 预览面板 / M / 预览布局 / 命令预览行 / 复制指令按钮
@onready var 智能解析按钮 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 属性栏 / 智能解析按钮
@onready var 执行按钮 = $布局容器 / 主体区域 / 右侧内容栈 / 预设详情面板 / 底部动作 / 执行预设按钮

# 文件夹详情
@onready var 文件夹标题 = $布局容器 / 主体区域 / 右侧内容栈 / 文件夹详情面板 / 文件夹描述容器 / 文件夹名称标题
@onready var 文件夹描述 = $布局容器 / 主体区域 / 右侧内容栈 / 文件夹详情面板 / 文件夹描述输入

var 当前选中ID: String = ""
var _已折叠ID集合: Dictionary = {}
var 正在重命名状态: bool = false
var _正在加载UI: bool = false
var 播放图标: Texture2D
var 当前字体大小: int = 20
var 预览片段索引表: Array = [] # 格式: { "start": 0, "end": 10, "node": Node }
var _树重命名输入框: LineEdit = null
var _树重命名绑定尝试次数: int = 0
var _拖拽上侧横线: ColorRect = null
var _拖拽下侧横线: ColorRect = null
var _拖拽子级高亮: ColorRect = null
var _拖拽占位块: ColorRect = null
var _拖拽预览已启用: bool = false
var _拖拽预览父节点覆盖: Dictionary = {}
var _拖拽预览排序覆盖: Dictionary = {}
var _拖拽预览签名: String = ""
var _拖拽最后有效落点: Dictionary = {}
var _拖拽最后签名: String = ""
var _是否正在拖拽: bool = false
var _拖拽标识动画表: Dictionary = {}
var _拖拽起始父ID: String = ""
var _窗口快捷键控制器 = preload("res://窗口快捷键控制器.gd").new()

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
	_初始化拖拽落点标识()
	
	# --- 加载全局持久化配置 ---
	_同步状态到UI()
	
	_初始化UI()
	_初始化文件夹备注输入框()
	
	# 信号连接
	树状菜单.item_selected.connect(_树项被选中)
	树状菜单.item_mouse_selected.connect(_on_tree_mouse_selected)
	树状菜单.item_collapsed.connect(_树项折叠状态改变)
	树状菜单.item_edited.connect(_树项编辑完成)
	树状菜单.item_activated.connect(_执行双击改名)
	树状菜单.button_clicked.connect(_树上运行图标被点击)
	树状菜单.gui_input.connect(_树状菜单输入)
	
	搜索框.text_changed.connect(_搜索框内容改变)
	搜索框.gui_input.connect(_搜索框内按键处理)
	
	搜文件夹备注勾选.toggled.connect(_on_search_config_toggled.bind("搜文件夹备注"))
	搜模板备注勾选.toggled.connect(_on_search_config_toggled.bind("搜模板备注"))
	if 搜夹连带子项勾选:
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
	预设名输入.text_changed.connect(更新预览)
	预设名输入.focus_entered.connect(更新预览); 预设名输入.focus_exited.connect(更新预览)
	预设说明输入.text_changed.connect(_自动保存当前预设)
	预设说明输入.text_changed.connect(更新预览)
	启动目录输入.text_changed.connect(_自动保存当前预设)
	启动目录输入.text_changed.connect(更新预览)
	启动目录输入.focus_entered.connect(更新预览); 启动目录输入.focus_exited.connect(更新预览)
	前缀命令输入.text_changed.connect(_自动保存当前预设)
	前缀命令输入.text_changed.connect(更新预览)
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
	
	_刷新配置列表UI()
	_完整状态恢复流程()
	
	for p in [预设面板, 文件夹面板]:
		p.mouse_filter = Control.MOUSE_FILTER_PASS
		p.gui_input.connect(_on_panel_gui_input.bind(p))

func _完整状态恢复流程():
	# 1. 物理同步 UI 组件值
	_同步状态到UI()
	
	# 2. 重建树（会基于 _已折叠ID集合 恢复折叠）
	# 关键修复：这里是“读取配置并恢复现场”，不能先反向记录旧树折叠状态
	刷新树状菜单(false)
	
	# 3. 延迟一帧执行高阶定位逻辑（确保树渲染完毕）
	get_tree().process_frame.connect(func():
		var 上次ID = 配置管理器.全局配置.get("上次选中ID", "")
		树状菜单.deselect_all()
		
		if 上次ID != "" and 配置管理器.树状数据.has(上次ID):
			_递归选中树项(树状菜单.get_root(), 上次ID)
		elif 树状菜单.get_root() and 树状菜单.get_root().get_first_child():
			树状菜单.get_root().get_first_child().select(0)
			_树项被选中()
			
		# 4. 恢复搜索视觉状态（如果在 _同步状态到UI 中已设置 text，这里触发逻辑）
		var 历史搜索 = 配置管理器.全局配置.get("搜索保留", "")
		if 历史搜索 != "":
			_搜索框内容改变(历史搜索)
		elif 搜夹连带子项勾选:
			搜夹连带子项勾选.disabled = true
			搜夹连带子项勾选.visible = false
	, CONNECT_ONE_SHOT)

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
	
	_初始化窗口快捷键控制器()
	
	_注入通用样式(self )

func _初始化文件夹备注输入框():
	if not is_instance_valid(文件夹描述):
		return
	# 文件夹备注作为记事本时，固定可视高度，超出内容使用内部滚动，不再挤压左右布局。
	文件夹描述.scroll_fit_content_height = false
	文件夹描述.custom_minimum_size = Vector2(0, 260)
	文件夹描述.size_flags_vertical = Control.SIZE_EXPAND_FILL

func _初始化窗口快捷键控制器():
	var 工具栏 = $布局容器 / 顶部导航 / MarginContainer / 工具栏
	_窗口快捷键控制器.初始化(
		self,
		工具栏,
		配置管理器,
		Callable(self, "_注入通用样式"),
		Callable(self, "_切换窗口最小化唤出")
	)

func _切换窗口最小化唤出():
	var 主窗口 = get_window()
	if 主窗口 == null:
		return
	if 主窗口.mode == Window.MODE_MINIMIZED:
		主窗口.mode = Window.MODE_WINDOWED
		DisplayServer.window_move_to_foreground()
	else:
		主窗口.mode = Window.MODE_MINIMIZED

func _exit_tree():
	_窗口快捷键控制器.释放资源()

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
				var 回调 = Callable(self, "_TextEdit组件输入").bind(节点)
				if not 节点.gui_input.is_connected(回调):
					节点.gui_input.connect(回调)
		
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
			# 文件夹备注支持 Tab/Shift+Tab 缩进，作为轻量记事本使用
			if 节点 == 文件夹描述:
				get_viewport().set_input_as_handled()
				if event.shift_pressed:
					_文本框反缩进(节点)
				else:
					_文本框缩进(节点)
			else:
				get_viewport().set_input_as_handled()
				if event.shift_pressed:
					var prev = 节点.find_prev_valid_focus()
					if prev: prev.grab_focus()
				else:
					var next = 节点.find_next_valid_focus()
					if next: next.grab_focus()
		
		if (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER) and 节点 == 文件夹描述 and not event.ctrl_pressed:
			get_viewport().set_input_as_handled()
			_文本框保持缩进换行(节点)
			return
		
		# 名称框特殊逻辑：回车即清洗并确认
		if (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER) and not event.ctrl_pressed:
			if 节点 == 预设名输入 or 节点 == 文件夹标题:
				节点.text = _清洗文本(节点.text)
				节点.release_focus()
				get_viewport().set_input_as_handled()

func _文本框缩进(节点: TextEdit):
	if !is_instance_valid(节点):
		return
	if 节点.has_selection():
		var 起始行 = mini(节点.get_selection_from_line(), 节点.get_selection_to_line())
		var 结束行 = maxi(节点.get_selection_from_line(), 节点.get_selection_to_line())
		for 行号 in range(起始行, 结束行 + 1):
			节点.set_line(行号, "\t" + 节点.get_line(行号))
	else:
		节点.insert_text_at_caret("\t")

func _文本框反缩进(节点: TextEdit):
	if !is_instance_valid(节点):
		return
	var 起始行 = 节点.get_caret_line()
	var 结束行 = 节点.get_caret_line()
	if 节点.has_selection():
		起始行 = mini(节点.get_selection_from_line(), 节点.get_selection_to_line())
		结束行 = maxi(节点.get_selection_from_line(), 节点.get_selection_to_line())
	for 行号 in range(起始行, 结束行 + 1):
		var 原文 = 节点.get_line(行号)
		if 原文.begins_with("\t"):
			节点.set_line(行号, 原文.substr(1))
		elif 原文.begins_with("    "):
			节点.set_line(行号, 原文.substr(4))

func _文本框保持缩进换行(节点: TextEdit):
	if !is_instance_valid(节点):
		return
	var 行号 = 节点.get_caret_line()
	var 列号 = 节点.get_caret_column()
	var 当前行文本 = 节点.get_line(行号)
	var 缩进前缀 = ""
	var 扫描上限 = mini(列号, 当前行文本.length())
	for i in range(扫描上限):
		var 字符 = 当前行文本.substr(i, 1)
		if 字符 == "\t" or 字符 == " ":
			缩进前缀 += 字符
		else:
			break
	if 节点.has_selection():
		节点.delete_selection()
	节点.insert_text_at_caret("\n" + 缩进前缀)

func _清洗文本(文本:String) -> String:
	var 规范文本 = 文本
	var 续行正则 = RegEx.new()
	续行正则.compile("\\s*[\\^\\\\]\\s*\\n")
	规范文本 = 续行正则.sub(规范文本, " ", true)
	规范文本 = 规范文本.replace("\r", " ").replace("\n", " ")
	return 规范文本.strip_edges()

func _input(event):
	_处理点击空白区域失去焦点(event)
	if event is InputEventKey and event.pressed:
		_处理键盘输入(event)

func _处理点击空白区域失去焦点(event: InputEvent):
	# 点击空白区域失去焦点 (不包含滚动条和按钮点击)
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner and not focus_owner.get_global_rect().has_point(event.global_position):
		# 如果是名称输入框，点击空白时也要清洗
		if focus_owner == 预设名输入 or focus_owner == 文件夹标题:
			focus_owner.text = _清洗文本(focus_owner.text)
		get_tree().process_frame.connect(func():
			var new_focus = get_viewport().gui_get_focus_owner()
			if new_focus == null:
				if is_instance_valid(focus_owner):
					focus_owner.release_focus()
		, CONNECT_ONE_SHOT)

func _处理键盘输入(event: InputEventKey):
	if _窗口快捷键控制器.处理最小化唤出快捷键(event):
		return
	var 焦点 = get_viewport().gui_get_focus_owner()
	if _处理全局命令快捷键(event, 焦点):
		return
	if _处理控制组合快捷键(event, 焦点):
		return
	var 选中 = 树状菜单.get_selected()
	if not 选中 or 正在重命名状态:
		return
	_处理树焦点快捷键(event, 焦点, 选中)

func _处理全局命令快捷键(event: InputEventKey, 焦点: Control) -> bool:
	# --- 强制/全局运行快捷键 ---
	if event.ctrl_pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
		_点击执行()
		get_viewport().set_input_as_handled()
		return true
	# --- Shift + Enter 智能解析 (输入状态下也有效) ---
	if event.shift_pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
		_智能解析并覆盖参数(核心命令输入.text)
		get_viewport().set_input_as_handled()
		return true
	# --- 核心 Ctrl + N 特权：随时新建文件夹 ---
	if event.ctrl_pressed and event.keycode == KEY_N:
		_右键菜单项被按下.call_deferred(1)
		get_viewport().set_input_as_handled()
		return true
	# --- Ctrl + G 范围合并快捷键 (焦点到鼠标位置) ---
	if event.ctrl_pressed and event.keycode == KEY_G:
		_快捷范围合并()
		get_viewport().set_input_as_handled()
		return true
	# --- Ctrl + Shift + C 全局复制完整命令（输入状态也生效） ---
	if event.ctrl_pressed and event.shift_pressed and event.keycode == KEY_C:
		_on_copy_command_pressed()
		get_viewport().set_input_as_handled()
		return true
	# --- Ctrl + C 复制快捷键 (非输入状态) ---
	# Ctrl+C：若预览有选中文本则复制选中，否则复制完整命令
	# Ctrl+Shift+C：见上方全局分支
	if event.ctrl_pressed and event.keycode == KEY_C:
		var 是否在输入 = (焦点 is LineEdit or 焦点 is TextEdit)
		if not 是否在输入:
			_复制预览选中或完整命令()
			get_viewport().set_input_as_handled()
			return true
	if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
		if not (焦点 is TextEdit):
			_点击执行()
			get_viewport().set_input_as_handled()
			return true
	return false

func _处理控制组合快捷键(event: InputEventKey, 焦点: Control) -> bool:
	if not event.ctrl_pressed:
		return false
	# --- 非焦点状态快捷键 (即非输入状态) ---
	var 是否在输入 = (焦点 is LineEdit or 焦点 is TextEdit)
	if not 是否在输入:
		if event.keycode == KEY_A:
			_右键菜单项被按下(0) # 新建模板
			return true
		if event.keycode == KEY_D:
			_右键菜单项被按下(3) # 克隆副本
			return true
	# 全局生效快捷键 (Ctrl+F 搜索 / Ctrl+B 添加参数)
	if event.keycode == KEY_F:
		搜索框.grab_focus()
		搜索框.select_all()
		get_viewport().set_input_as_handled()
		return true
	if event.keycode == KEY_B and 预设面板.visible:
		创建参数行("", "", "")
		return true
	return false

func _处理树焦点快捷键(event: InputEventKey, 焦点: Control, 选中: TreeItem):
	if 焦点 != 树状菜单:
		return
	match event.keycode:
		KEY_F2:
			_触发重命名(选中)
		KEY_DELETE:
			_点击删除动作()
		KEY_ENTER:
			_点击执行()
		KEY_D:
			if event.ctrl_pressed:
				_点击克隆动作()

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
	
	var 备注输入 = TextEdit.new(); 备注输入.text = 备注; 备注输入.name = "Note"; 备注输入.placeholder_text = "参数说明..."; 备注输入.custom_minimum_size = Vector2(200, 0)
	备注输入.size_flags_horizontal = Control.SIZE_EXPAND_FILL; 备注输入.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY; 备注输入.scroll_fit_content_height = true
	备注输入.context_menu_enabled = false # 关闭系统菜单
	备注输入.text_changed.connect(func(): _自动保存当前预设(); 更新预览())
	备注输入.focus_entered.connect(更新预览); 备注输入.focus_exited.connect(更新预览)
	
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
	预设名输入.text = 数据["名称"]; 预设说明输入.text = 数据.get("描述", "")
	var 启动目录值 = _清洗文本(数据.get("启动目录", ""))
	# 启动目录输入框保持空值，默认执行目录通过 placeholder 告知用户
	启动目录输入.text = 启动目录值
	启动目录输入.placeholder_text = _获取真实执行目录()
	前缀命令输入.text = 数据.get("前缀命令", ""); 核心命令输入.text = 数据["固定命令"]; Shell选择.selected = 数据.get("Shell类型", 0)
	UTF8模式.button_pressed = 数据.get("UTF8模式", false)
	for 子 in 参数容器.get_children(): 子.queue_free()
	for 项 in 数据.get("参数列表", []): 创建参数行(项["键"], 项["备注"], 项.get("当前值", ""))
	更新预览()

# 真实执行目录（用于默认启动目录）
func _获取真实执行目录() -> String:
	var 目录 = ""
	# 导出版下优先使用配置管理器初始化后的基础目录，避免 res:// 在打包环境中返回空字符串
	if has_node("/root/配置管理器") and 配置管理器.基础目录 != "":
		目录 = 配置管理器.基础目录
	else:
		目录 = ProjectSettings.globalize_path("res://")
		if 目录 == "":
			目录 = OS.get_executable_path().get_base_dir()
	目录 = 目录.replace("/", "\\")
	if 目录.ends_with("\\"): 目录 = 目录.left(-1)
	return 目录

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

func _同步状态到UI():
	# 从配置管理器加载新 Profile 的数据到 UI
	_加载折叠到内存()
	_窗口快捷键控制器.从配置加载并应用()
	当前字体大小 = 配置管理器.全局配置.get("字体大小", 20)
	搜文件夹备注勾选.button_pressed = 配置管理器.全局配置.get("搜文件夹备注", true)
	搜模板备注勾选.button_pressed = 配置管理器.全局配置.get("搜模板备注", true)
	执行时复制开关.button_pressed = 配置管理器.全局配置.get("执行时复制", false)
	搜索框.text = 配置管理器.全局配置.get("搜索保留", "")
	if 搜夹连带子项勾选:
		搜夹连带子项勾选.button_pressed = 配置管理器.全局配置.get("搜夹连带子项", true)

func _加载折叠到内存():
	var 存档折叠 = 配置管理器.全局配置.get("已折叠ID", [])
	_已折叠ID集合.clear()
	for id in 存档折叠: _已折叠ID集合[id] = true

func _保存折叠到全局():
	配置管理器.全局配置["已折叠ID"] = _已折叠ID集合.keys()
	配置管理器.保存全局配置()

func 刷新树状菜单(记录折叠: bool = true):
	# 仅在需要且未搜索时记录折叠状态
	if 记录折叠 and is_instance_valid(搜索框) and 搜索框.text == "":
		var 根 = 树状菜单.get_root()
		# 关键修复：只有当树中存在子节点（非空）时才允许覆盖内存记录
		# 这样启动时刷新操作就不会抹掉刚才从配置里读出来的历史数据
		if 根 and 根.get_first_child():
			_已折叠ID集合.clear()
			_递归记录折叠状态(根)
			_保存折叠到全局()
	
	树状菜单.clear()
	var 根2 = 树状菜单.create_item()
	填充树递归("", 根2)
	_动态更新当前搜索()
	if 当前选中ID != "": _递归选中树项(树状菜单.get_root(), 当前选中ID)

func _树项折叠状态改变(项:TreeItem):
	if _正在加载UI: return
	# 搜索期间的操作不记录到持久化
	if is_instance_valid(搜索框) and 搜索框.text != "": return
	
	var id = 项.get_metadata(0); if !id: return
	if 项.collapsed: _已折叠ID集合[id] = true
	else: _已折叠ID集合.erase(id)
	_保存折叠到全局()

func _递归记录折叠状态(项:TreeItem):
	var id = 项.get_metadata(0)
	if 项.collapsed and id: _已折叠ID集合[id] = true
	var 子 = 项.get_first_child()
	while 子: _递归记录折叠状态(子); 子 = 子.get_next()

func _动态更新当前搜索():
	if is_instance_valid(搜索框) and 搜索框.text != "":
		var 根 = 树状菜单.get_root(); if 根:_搜索递归增强(根, 搜索框.text.to_lower(), false)

func 填充树递归(pid: String, parent_item: TreeItem):
	var nodes = _获取用于渲染的子节点(pid)
	for n in nodes:
		var item = 树状菜单.create_item(parent_item); item.set_text(0, n["名称"]); item.set_metadata(0, n["ID"])
		if n["类型"] == "文件夹": 
			item.set_custom_color(0, Color.GOLDENROD)
			if _已折叠ID集合.has(n["ID"]): item.collapsed = true
		else: item.add_button(0, 播放图标, 0, false, "立即执行")
		填充树递归(n["ID"], item)

func _获取用于渲染的子节点(父ID: String) -> Array:
	if !_拖拽预览已启用:
		return 配置管理器.获取子节点(父ID)
	var 子节点列表: Array = []
	for 节点ID in 配置管理器.树状数据.keys():
		var 数据 = 配置管理器.树状数据.get(节点ID)
		if !(数据 is Dictionary):
			continue
		var 显示父ID = str(_拖拽预览父节点覆盖.get(节点ID, 数据.get("父节点", "")))
		if 显示父ID != 父ID:
			continue
		var 项 = 数据.duplicate()
		项["ID"] = 节点ID
		子节点列表.append(项)
	
	var 排序序列 = _拖拽预览排序覆盖.get(父ID, [])
	if 排序序列 is Array and !排序序列.is_empty():
		var 序号表: Dictionary = {}
		for i in range(排序序列.size()):
			序号表[str(排序序列[i])] = i
		子节点列表.sort_custom(func(a, b):
			var aID = str(a.get("ID", ""))
			var bID = str(b.get("ID", ""))
			var a序 = int(序号表.get(aID, 2147483647))
			var b序 = int(序号表.get(bID, 2147483647))
			if a序 == b序:
				return a.get("order", 0) < b.get("order", 0)
			return a序 < b序
		)
	else:
		子节点列表.sort_custom(func(a, b): return a.get("order", 0) < b.get("order", 0))
	return 子节点列表

func _搜索框内容改变(新文本:String):
	var 旧文本 = 配置管理器.全局配置.get("搜索保留", "")
	配置管理器.全局配置["搜索保留"] = 新文本
	配置管理器.保存全局配置()
	
	if is_instance_valid(搜夹连带子项勾选):
		搜夹连带子项勾选.disabled = (新文本.strip_edges() == "")
		搜夹连带子项勾选.visible = !(新文本.strip_edges() == "")
		
	# 如果是从无到有的搜索，先记录下当前的折叠状态，以便清空后恢复
	if 旧文本 == "" and 新文本 != "":
		var 根 = 树状菜单.get_root()
		if 根: 
			_已折叠ID集合.clear()
			_递归记录折叠状态(根)
			_保存折叠到全局()

	if 新文本 == "": 刷新树状菜单(false); return
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
	数据["名称"] = 预设名输入.text; 数据["描述"] = 预设说明输入.text; 数据["启动目录"] = 启动目录输入.text; 数据["前缀命令"] = 前缀命令输入.text; 数据["固定命令"] = 核心命令输入.text; 数据["Shell类型"] = Shell选择.selected
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
	var preview = Label.new(); preview.text = " ?? 多选移动中(" + str(selected.size()) + ")" if selected.size() > 1 else " ?? " + selected[0].get_text(0)
	var 拖拽ID集: Array = []
	for 项 in selected:
		if !(项 is TreeItem): continue
		var 节点ID = str(项.get_metadata(0))
		if 节点ID != "":
			拖拽ID集.append(节点ID)
	_清理拖拽落点标识()
	_拖拽最后有效落点.clear()
	_拖拽最后签名 = ""
	_是否正在拖拽 = true
	_拖拽起始父ID = ""
	if !拖拽ID集.is_empty():
		_拖拽起始父ID = str(配置管理器.树状数据.get(str(拖拽ID集[0]), {}).get("父节点", ""))
	树状菜单.set_drag_preview(preview)
	return {"拖拽ID集": 拖拽ID集}

func _can_drop_data_logic(鼠标位置, 拖拽数据):
	var 拖拽签名 = _生成拖拽签名(拖拽数据)
	var 落点信息 = _计算拖拽落点(鼠标位置, 拖拽数据)
	if 落点信息.get("是否有效", false):
		_更新拖拽落点标识(落点信息)
		_拖拽最后有效落点 = 落点信息.duplicate(true)
		_拖拽最后签名 = 拖拽签名
		_应用拖拽实时预览(落点信息, 拖拽数据, 鼠标位置)
		return true
	
	# 实时重排后，鼠标可能短暂压在“已移动的自身条目”上，导致当前帧无效。
	# 这里保留上一帧有效落点，避免同级下方拖拽被瞬间打断。
	if _拖拽最后签名 == 拖拽签名 and _拖拽最后有效落点.get("是否有效", false):
		_更新拖拽落点标识(_拖拽最后有效落点)
		return true
	else:
		_更新拖拽落点标识(落点信息)
		_拖拽最后有效落点.clear()
		_拖拽最后签名 = ""
		_清理拖拽实时预览()
	return false

func _drop_data_logic(鼠标位置, 拖拽项):
	var 拖拽签名 = _生成拖拽签名(拖拽项)
	var 落点信息 = {}
	if _拖拽最后签名 == 拖拽签名 and _拖拽最后有效落点.get("是否有效", false):
		落点信息 = _拖拽最后有效落点.duplicate(true)
	else:
		落点信息 = _计算拖拽落点(鼠标位置, 拖拽项)
	_拖拽最后有效落点.clear()
	_拖拽最后签名 = ""
	_清理拖拽落点标识()
	_清理拖拽实时预览(false)
	if !落点信息.get("是否有效", false):
		刷新树状菜单(false)
		return
	
	var 新父ID = 落点信息.get("新父ID", "")
	var 插入索引 = _计算真实插入索引(新父ID, str(落点信息.get("目标ID", "")), int(落点信息.get("落点段", 0)), bool(落点信息.get("是否子级落点", false)))
	if 插入索引 < 0:
		刷新树状菜单(false)
		return
	var 目标ID = 落点信息.get("目标ID", "")
	var 移动项ID集 = _提取可移动项ID集(拖拽项, 目标ID, 新父ID)
	if 移动项ID集.is_empty(): return
	var 原父节点表: Dictionary = {}
	for 节点ID in 移动项ID集:
		原父节点表[节点ID] = str(配置管理器.树状数据.get(节点ID, {}).get("父节点", ""))

	for 节点ID in 移动项ID集:
		配置管理器.树状数据[节点ID]["父节点"] = 新父ID
	
	# 同步所有兄弟的排序权重
	var 原兄弟们 = 配置管理器.获取子节点(新父ID)
	var 原兄弟ID序列: Array = []
	for b in 原兄弟们:
		原兄弟ID序列.append(b["ID"])
	var 新序列 = []
	for 兄弟ID in 原兄弟ID序列:
		if 兄弟ID not in 移动项ID集: 新序列.append(兄弟ID)
	
	var 最终插入索引 = 插入索引
	if 最终插入索引 == -1:
		最终插入索引 = 新序列.size()
	else:
		# 同父节点拖拽时先剔除移动项会导致索引左移，这里按剔除数量修正并钳制，避免越界
		var 前置被剔除数量 = 0
		var 扫描上限 = mini(插入索引, 原兄弟ID序列.size())
		for i in range(扫描上限):
			var 候选ID = 原兄弟ID序列[i]
			if 候选ID in 移动项ID集 and str(原父节点表.get(候选ID, "")) == 新父ID:
				前置被剔除数量 += 1
		最终插入索引 -= 前置被剔除数量
		最终插入索引 = maxi(0, mini(最终插入索引, 新序列.size()))
	
	for j in range(移动项ID集.size()):
		新序列.insert(最终插入索引 + j, 移动项ID集[j])
			
	配置管理器.更新排序(新序列)
	刷新树状菜单()
	# 恢复焦点与选中
	树状菜单.grab_focus()
	if 移动项ID集.size() > 0:
		_递归选中树项(树状菜单.get_root(), 移动项ID集[0])

func _初始化拖拽落点标识():
	if is_instance_valid(_拖拽上侧横线): return
	
	_拖拽上侧横线 = ColorRect.new()
	_拖拽上侧横线.name = "拖拽上侧横线"
	_拖拽上侧横线.color = Color(0.20, 0.82, 1.0, 0.95)
	_拖拽上侧横线.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_拖拽上侧横线.visible = false
	树状菜单.add_child(_拖拽上侧横线)
	
	_拖拽下侧横线 = ColorRect.new()
	_拖拽下侧横线.name = "拖拽下侧横线"
	_拖拽下侧横线.color = Color(0.20, 0.82, 1.0, 0.95)
	_拖拽下侧横线.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_拖拽下侧横线.visible = false
	树状菜单.add_child(_拖拽下侧横线)
	
	_拖拽子级高亮 = ColorRect.new()
	_拖拽子级高亮.name = "拖拽子级高亮"
	_拖拽子级高亮.color = Color(0.20, 0.82, 1.0, 0.18)
	_拖拽子级高亮.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_拖拽子级高亮.visible = false
	树状菜单.add_child(_拖拽子级高亮)
	
	_拖拽占位块 = ColorRect.new()
	_拖拽占位块.name = "拖拽占位块"
	_拖拽占位块.color = Color(0.20, 0.82, 1.0, 0.14)
	_拖拽占位块.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_拖拽占位块.visible = false
	树状菜单.add_child(_拖拽占位块)

func _更新拖拽落点标识(落点信息: Dictionary):
	if !is_instance_valid(_拖拽上侧横线): return
	_清理拖拽落点标识()
	if !落点信息.get("是否有效", false): return
	var 目标项 = 落点信息.get("目标项", null)
	if 目标项 == null: return
	var 落点段 = 落点信息.get("落点段", 0)
	var 是否子级落点 = 落点信息.get("是否子级落点", false)
	var 可视锚点项 = _获取拖拽可视锚点项(目标项, 落点段, 是否子级落点)
	if 可视锚点项 == null: return
	
	var 行区域 = 树状菜单.get_item_area_rect(可视锚点项, 0)
	if 行区域.size.y <= 0.0: return
	
	var 横线左侧 = 6.0
	var 横线宽度 = max(树状菜单.size.x - 12.0, 4.0)
	var 横线厚度 = 2.0
	var 移动可视行数 = maxi(1, int(落点信息.get("移动可视行数", 1)))
	var 占位高度 = 行区域.size.y * 移动可视行数
	
	if 是否子级落点:
		_更新拖拽标识动画(_拖拽子级高亮, Vector2(2.0, 行区域.position.y), Vector2(max(树状菜单.size.x - 4.0, 4.0), 行区域.size.y))
		_更新拖拽标识动画(_拖拽占位块, Vector2(2.0, 行区域.position.y + 行区域.size.y), Vector2(max(树状菜单.size.x - 4.0, 4.0), 占位高度))
		_更新拖拽标识动画(_拖拽下侧横线, Vector2(横线左侧, 行区域.position.y + 行区域.size.y - 横线厚度), Vector2(横线宽度, 横线厚度))
		return
	
	if 落点段 <= 0:
		_更新拖拽标识动画(_拖拽上侧横线, Vector2(横线左侧, 行区域.position.y), Vector2(横线宽度, 横线厚度))
		_更新拖拽标识动画(_拖拽占位块, Vector2(2.0, 行区域.position.y), Vector2(max(树状菜单.size.x - 4.0, 4.0), 占位高度))
	else:
		_更新拖拽标识动画(_拖拽下侧横线, Vector2(横线左侧, 行区域.position.y + 行区域.size.y - 横线厚度), Vector2(横线宽度, 横线厚度))
		_更新拖拽标识动画(_拖拽占位块, Vector2(2.0, 行区域.position.y + 行区域.size.y), Vector2(max(树状菜单.size.x - 4.0, 4.0), 占位高度))

func _获取拖拽可视锚点项(目标项: TreeItem, 落点段: int, 是否子级落点: bool) -> TreeItem:
	if 是否子级落点 or 落点段 <= 0:
		return 目标项
	var 目标ID = str(目标项.get_metadata(0))
	var 目标数据 = 配置管理器.树状数据.get(目标ID)
	if !目标数据 or 目标数据.get("类型", "") != "文件夹":
		return 目标项
	return _获取最后可见子孙项(目标项)

func _获取最后可见子孙项(根项: TreeItem) -> TreeItem:
	var 当前项 = 根项
	while 当前项 and !当前项.is_collapsed():
		var 子项 = 当前项.get_first_child()
		var 最后可见子项: TreeItem = null
		while 子项:
			if 子项.visible:
				最后可见子项 = 子项
			子项 = 子项.get_next()
		if 最后可见子项 == null:
			break
		当前项 = 最后可见子项
	return 当前项

func _清理拖拽落点标识():
	_停止拖拽标识动画()
	if is_instance_valid(_拖拽上侧横线): _拖拽上侧横线.visible = false
	if is_instance_valid(_拖拽下侧横线): _拖拽下侧横线.visible = false
	if is_instance_valid(_拖拽子级高亮): _拖拽子级高亮.visible = false
	if is_instance_valid(_拖拽占位块): _拖拽占位块.visible = false

func _更新拖拽标识动画(标识节点: Control, 目标位置: Vector2, 目标尺寸: Vector2):
	if !is_instance_valid(标识节点):
		return
	标识节点.visible = true
	标识节点.modulate = Color(1, 1, 1, 1)
	标识节点.position = 目标位置
	标识节点.size = 目标尺寸

func _停止拖拽标识动画():
	for 动画键 in _拖拽标识动画表.keys():
		var 动画对象 = _拖拽标识动画表.get(动画键, null)
		if 动画对象 is Tween:
			(动画对象 as Tween).kill()
	_拖拽标识动画表.clear()

func _提取可移动项ID集(拖拽数据, 目标ID: String, 新父ID: String) -> Array:
	var 结果: Array = []
	var 拖拽ID集 = _提取拖拽ID集(拖拽数据)
	for 节点ID in 拖拽ID集:
		if 节点ID == "" or 节点ID == 目标ID: continue
		if !配置管理器.树状数据.has(节点ID): continue
		if 配置管理器.树状数据[节点ID]["类型"] == "文件夹" and _检查是否为子孙(节点ID, 新父ID): continue
		结果.append(节点ID)
	return 结果

func _提取拖拽ID集(拖拽数据) -> Array:
	var 结果: Array = []
	if 拖拽数据 is Dictionary:
		for 值 in 拖拽数据.get("拖拽ID集", []):
			var 节点ID = str(值)
			if 节点ID != "":
				结果.append(节点ID)
	elif 拖拽数据 is Array:
		for 项 in 拖拽数据:
			if !(项 is TreeItem): continue
			var 节点ID = str(项.get_metadata(0))
			if 节点ID != "":
				结果.append(节点ID)
	return 结果

func _生成拖拽签名(拖拽数据) -> String:
	var 拖拽ID集 = _提取拖拽ID集(拖拽数据)
	if 拖拽ID集.is_empty():
		return ""
	var 签名数组 = PackedStringArray()
	for 节点ID in 拖拽ID集:
		签名数组.append(str(节点ID))
	签名数组.sort()
	return ",".join(签名数组)

func _计算落点段(目标项: TreeItem, 鼠标位置, 是否目标文件夹: bool) -> int:
	var 行区域 = 树状菜单.get_item_area_rect(目标项, 0)
	if 行区域.size.y <= 0.0:
		return 0
	var 相对Y = clampf(鼠标位置.y - 行区域.position.y, 0.0, 行区域.size.y)
	var 比例 = 相对Y / 行区域.size.y
	if 是否目标文件夹:
		# 缩小“子级落点”死区：中间 20% 为子级，其余优先同级上下
		if 比例 < 0.40:
			return -1
		if 比例 > 0.60:
			return 1
		return 0
	return -1 if 比例 < 0.5 else 1

func _获取树最后可见项() -> TreeItem:
	var 根项 = 树状菜单.get_root()
	if 根项 == null:
		return null
	var 当前项 = 根项.get_first_child()
	if 当前项 == null:
		return null
	var 最后可见项: TreeItem = null
	while 当前项:
		if 当前项.visible:
			最后可见项 = 当前项
		当前项 = 当前项.get_next()
	if 最后可见项 == null:
		return null
	return _获取最后可见子孙项(最后可见项)

func _是否命中树底末尾区(鼠标位置, 最后可见项: TreeItem) -> bool:
	if 最后可见项 == null:
		return false
	var 最后行区域 = 树状菜单.get_item_area_rect(最后可见项, 0)
	if 最后行区域.size.y <= 0.0:
		return false
	return 鼠标位置.y >= (最后行区域.position.y + 最后行区域.size.y - 1.0)

func _是否命中树底热区(鼠标位置) -> bool:
	# 固定热区：拖拽进入树底部后，始终允许落到当前层级末尾，避免被子级吸附卡住。
	var 热区高度 = 44.0
	var 树高度 = maxf(树状菜单.size.y, 0.0)
	if 树高度 <= 0.0:
		return false
	return 鼠标位置.y >= (树高度 - 热区高度)

func _构建树底末尾同级落点(最后可见项: TreeItem, 拖拽数据) -> Dictionary:
	var 默认结果 = {
		"是否有效": false,
		"目标项": null,
		"目标ID": "",
		"新父ID": "",
		"插入索引": -1,
		"落点段": 0,
		"是否子级落点": false
	}
	if 最后可见项 == null:
		return 默认结果
	var 末尾目标ID = str(最后可见项.get_metadata(0))
	var 末尾目标数据 = 配置管理器.树状数据.get(末尾目标ID, {})
	if 末尾目标ID == "" or 末尾目标数据.is_empty():
		return 默认结果
	var 末尾新父ID = str(末尾目标数据.get("父节点", ""))
	var 末尾插入索引 = _计算真实插入索引(末尾新父ID, 末尾目标ID, 1, false)
	var 末尾可移动项ID集 = _提取可移动项ID集(拖拽数据, 末尾目标ID, 末尾新父ID)
	if 末尾可移动项ID集.is_empty() or 末尾插入索引 < 0:
		return 默认结果
	return {
		"是否有效": true,
		"目标项": 最后可见项,
		"目标ID": 末尾目标ID,
		"新父ID": 末尾新父ID,
		"插入索引": 末尾插入索引,
		"落点段": 1,
		"是否子级落点": false,
		"移动可视行数": _统计拖拽可视行数(拖拽数据)
	}

func _构建指定父级末尾同级落点(目标父ID: String, 拖拽数据) -> Dictionary:
	var 默认结果 = {
		"是否有效": false,
		"目标项": null,
		"目标ID": "",
		"新父ID": "",
		"插入索引": -1,
		"落点段": 0,
		"是否子级落点": false
	}
	var 目标父标识 = str(目标父ID)
	if 目标父标识 == "":
		return 默认结果
	var 同级列表 = 配置管理器.获取子节点(目标父标识)
	if 同级列表.is_empty():
		return 默认结果
	var 末尾目标ID = str(同级列表[同级列表.size() - 1].get("ID", ""))
	if 末尾目标ID == "":
		return 默认结果
	var 末尾目标项 = _根据ID寻找树项(树状菜单.get_root(), 末尾目标ID)
	if 末尾目标项 == null:
		return 默认结果
	var 末尾插入索引 = _计算真实插入索引(目标父标识, 末尾目标ID, 1, false)
	var 可移动项ID集 = _提取可移动项ID集(拖拽数据, 末尾目标ID, 目标父标识)
	if 可移动项ID集.is_empty() or 末尾插入索引 < 0:
		return 默认结果
	return {
		"是否有效": true,
		"目标项": 末尾目标项,
		"目标ID": 末尾目标ID,
		"新父ID": 目标父标识,
		"插入索引": 末尾插入索引,
		"落点段": 1,
		"是否子级落点": false,
		"移动可视行数": _统计拖拽可视行数(拖拽数据)
	}

func _计算拖拽落点(鼠标位置, 拖拽数据) -> Dictionary:
	var 默认结果 = {
		"是否有效": false,
		"目标项": null,
		"目标ID": "",
		"新父ID": "",
		"插入索引": -1,
		"落点段": 0,
		"是否子级落点": false
	}
	var 拖拽ID集 = _提取拖拽ID集(拖拽数据)
	if 拖拽ID集.is_empty():
		return 默认结果
	var 最后可见项 = _获取树最后可见项()
	if _是否命中树底热区(鼠标位置) or _是否命中树底末尾区(鼠标位置, 最后可见项):
		var 起始父级末尾落点 = _构建指定父级末尾同级落点(_拖拽起始父ID, 拖拽数据)
		if 起始父级末尾落点.get("是否有效", false):
			return 起始父级末尾落点
		return _构建树底末尾同级落点(最后可见项, 拖拽数据)
	
	var 目标项 = 树状菜单.get_item_at_position(鼠标位置)
	if !目标项:
		return 默认结果
	
	var 目标ID = str(目标项.get_metadata(0))
	if 目标ID == "":
		return 默认结果
	var 目标数据 = 配置管理器.树状数据.get(目标ID)
	if !目标数据:
		return 默认结果
	var 落点段 = _计算落点段(目标项, 鼠标位置, 目标数据.get("类型", "") == "文件夹")
	
	var 新父ID = ""
	var 是否子级落点 = false
	
	if 落点段 == 0 and 目标数据["类型"] == "文件夹":
		新父ID = 目标ID
		是否子级落点 = true
	else:
		新父ID = 目标数据.get("父节点", "")
	var 插入索引 = _计算真实插入索引(新父ID, 目标ID, 落点段, 是否子级落点)
	
	var 可移动项ID集 = _提取可移动项ID集(拖拽数据, 目标ID, 新父ID)
	if 可移动项ID集.is_empty():
		return 默认结果
	
	return {
		"是否有效": 插入索引 >= 0,
		"目标项": 目标项,
		"目标ID": 目标ID,
		"新父ID": 新父ID,
		"插入索引": 插入索引,
		"落点段": 落点段,
		"是否子级落点": 是否子级落点,
		"移动可视行数": _统计拖拽可视行数(拖拽数据)
	}

func _计算真实插入索引(新父ID: String, 目标ID: String, 落点段: int, 是否子级落点: bool) -> int:
	if 是否子级落点:
		return 0
	var 兄弟们 = 配置管理器.获取子节点(新父ID)
	for k in range(兄弟们.size()):
		if str(兄弟们[k].get("ID", "")) == 目标ID:
			return k if 落点段 <= 0 else k + 1
	return -1

func _应用拖拽实时预览(落点信息: Dictionary, 拖拽数据, 鼠标位置):
	var 新父ID = 落点信息.get("新父ID", "")
	var 插入索引 = 落点信息.get("插入索引", -1)
	var 目标ID = 落点信息.get("目标ID", "")
	var 移动项ID集 = _提取可移动项ID集(拖拽数据, 目标ID, 新父ID)
	if 移动项ID集.is_empty():
		_清理拖拽实时预览()
		return
	var 原父节点表: Dictionary = {}
	for 节点ID in 移动项ID集:
		原父节点表[节点ID] = str(配置管理器.树状数据.get(节点ID, {}).get("父节点", ""))
	var 新签名 = 新父ID + "|" + str(插入索引) + "|" + ",".join(PackedStringArray(移动项ID集))
	if _拖拽预览已启用 and _拖拽预览签名 == 新签名:
		return
	
	_拖拽预览父节点覆盖.clear()
	_拖拽预览排序覆盖.clear()
	for 节点ID in 移动项ID集:
		_拖拽预览父节点覆盖[节点ID] = 新父ID
	
	var 涉及父节点: Dictionary = {}
	涉及父节点[新父ID] = true
	for 原父ID in 原父节点表.values():
		涉及父节点[str(原父ID)] = true
	
	for 父ID in 涉及父节点.keys():
		var 原兄弟们 = 配置管理器.获取子节点(str(父ID))
		var 原兄弟ID序列: Array = []
		for 项 in 原兄弟们:
			原兄弟ID序列.append(项["ID"])
		var 新序列: Array = []
		for 兄弟ID in 原兄弟ID序列:
			if 兄弟ID not in 移动项ID集:
				新序列.append(兄弟ID)
		if str(父ID) == 新父ID:
			var 最终插入索引 = 插入索引
			if 最终插入索引 == -1:
				最终插入索引 = 新序列.size()
			else:
				var 前置被剔除数量 = 0
				var 扫描上限 = mini(插入索引, 原兄弟ID序列.size())
				for i in range(扫描上限):
					var 候选ID = 原兄弟ID序列[i]
					if 候选ID in 移动项ID集 and str(原父节点表.get(候选ID, "")) == 新父ID:
						前置被剔除数量 += 1
				最终插入索引 -= 前置被剔除数量
				最终插入索引 = maxi(0, mini(最终插入索引, 新序列.size()))
			for j in range(移动项ID集.size()):
				新序列.insert(最终插入索引 + j, 移动项ID集[j])
		_拖拽预览排序覆盖[str(父ID)] = 新序列
	
	_拖拽预览已启用 = true
	_拖拽预览签名 = 新签名
	刷新树状菜单(false)
	_清理拖拽落点标识()
	var 新落点信息 = _计算拖拽落点(鼠标位置, 拖拽数据)
	_更新拖拽落点标识(新落点信息)

func _清理拖拽实时预览(是否刷新树: bool = true):
	if !_拖拽预览已启用:
		return
	_拖拽预览已启用 = false
	_拖拽预览签名 = ""
	_拖拽预览父节点覆盖.clear()
	_拖拽预览排序覆盖.clear()
	if 是否刷新树:
		刷新树状菜单(false)

func _统计拖拽可视行数(拖拽数据) -> int:
	var 拖拽ID集 = _提取拖拽ID集(拖拽数据)
	if 拖拽ID集.is_empty():
		return 1
	var 根项列表: Array = []
	var 选中ID表: Dictionary = {}
	for 节点ID in 拖拽ID集:
		选中ID表[节点ID] = true
	for 节点ID in 拖拽ID集:
		var 项 = _根据ID寻找树项(树状菜单.get_root(), 节点ID)
		if 项 == null:
			continue
		if _树项祖先是否已选中(项, 选中ID表): continue
		根项列表.append(项)
	var 合计 = 0
	for 根项 in 根项列表:
		合计 += _统计可视子树行数(根项)
	return maxi(合计, 1)

func _根据ID寻找树项(当前项: TreeItem, 目标ID: String) -> TreeItem:
	if 当前项 == null:
		return null
	if str(当前项.get_metadata(0)) == 目标ID:
		return 当前项
	var 子项 = 当前项.get_first_child()
	while 子项:
		var 命中项 = _根据ID寻找树项(子项, 目标ID)
		if 命中项:
			return 命中项
		子项 = 子项.get_next()
	return null

func _树项祖先是否已选中(项: TreeItem, 选中ID表: Dictionary) -> bool:
	var 父项 = 项.get_parent()
	while 父项:
		var 父ID = str(父项.get_metadata(0))
		if 父ID != "" and 选中ID表.has(父ID):
			return true
		父项 = 父项.get_parent()
	return false

func _统计可视子树行数(根项: TreeItem) -> int:
	if 根项 == null or !根项.visible:
		return 0
	var 合计 = 1
	if 根项.is_collapsed():
		return 合计
	var 子项 = 根项.get_first_child()
	while 子项:
		合计 += _统计可视子树行数(子项)
		子项 = 子项.get_next()
	return 合计

func _拖拽结束清理标识():
	_是否正在拖拽 = false
	_拖拽起始父ID = ""
	_清理拖拽落点标识()
	_清理拖拽实时预览()
	_拖拽最后有效落点.clear()
	_拖拽最后签名 = ""
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
	var 启动目录 = _清洗文本(启动目录输入.text)
	var prefix_cmd = _清洗文本(前缀命令输入.text)
	var base_cmd = _清洗文本(核心命令输入.text)
	var final_bb = ""
	var 目录_bb = ""
	var 真实执行目录 = _获取真实执行目录()
	var 显示执行目录 = 启动目录 if 启动目录 != "" else 真实执行目录
	var 目录是否聚焦 = (焦点 == 启动目录输入)
	if 目录是否聚焦:
		目录_bb = "[color=#00ff88]" + 显示执行目录 + "[/color]"
	else:
		目录_bb = "[color=#aaaaaa]" + 显示执行目录 + "[/color]"
	
	# 前缀 (chcp 等) - 灰色显示
	var 连接符 = " && " if (Shell选择.selected == 0 or Shell选择.selected == 2) else " ; "
	if UTF8模式.button_pressed:
		final_bb += "[color=#666666]chcp 65001 > nul" + 连接符 + "[/color]"
	
	# 前缀命令
	if prefix_cmd != "":
		var is_prefix_focused = (焦点 == 前缀命令输入)
		if is_prefix_focused: final_bb += "[color=#00ff88]" + prefix_cmd + "[/color]"
		else: final_bb += "[color=#aaaaaa]" + prefix_cmd + "[/color]"
	
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
	
	执行目录预览.text = 目录_bb
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

func _复制预览选中或完整命令():
	# 优先复制预览区选中文字（命令预览/执行目录），若无选中则回退到完整命令
	var 焦点 = get_viewport().gui_get_focus_owner()
	var 目录选中 = 执行目录预览.get_selected_text()
	var 命令选中 = 预览标签.get_selected_text()
	if 焦点 == 执行目录预览 and 目录选中 != "":
		DisplayServer.clipboard_set(目录选中)
	elif 焦点 == 预览标签 and 命令选中 != "":
		DisplayServer.clipboard_set(命令选中)
	elif 目录选中 != "":
		DisplayServer.clipboard_set(目录选中)
	elif 命令选中 != "":
		DisplayServer.clipboard_set(命令选中)
	else:
		_on_copy_command_pressed()

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
	
	var 启动目录 = _清洗文本(数据.get("启动目录", ""))
	var prefix = _清洗文本(数据.get("前缀命令", ""))
	var core_cmd = _清洗文本(数据.get("固定命令", ""))
	
	# 核心拼装
	var 完整命令 = core_cmd
	if prefix != "":
		完整命令 = prefix + core_cmd
	
	# 拼装参数
	for 行 in 参数容器.get_children():
		if 行.is_queued_for_deletion(): continue
		var value = 行.get_node("Value").text.strip_edges()
		if value != "":
			完整命令 += " " + value
	
	# 自动复制
	if 执行时复制开关.button_pressed:
		DisplayServer.clipboard_set(完整命令)
	
	_拉起窗口(Shell选择.selected, 完整命令, 数据.get("UTF8模式", false), 启动目录)

func _拉起窗口(类型:int, 完整命令:String, 开启UTF8: bool = false, 启动目录:String = ""):
	var 命令 = 完整命令
	var 是PS = (类型 == 1 or 类型 == 3)
	var 工作目录 = 启动目录
	if 工作目录 == "":
		工作目录 = _获取真实执行目录()
	
	# --- 添加命令回显提示 ---
	var 基础路径 = ProjectSettings.globalize_path("res://").replace("/", "\\")
	if 基础路径.ends_with("\\"): 基础路径 = 基础路径.left(-1)
	var 显示目录 = 工作目录.replace("/", "\\")
	if 显示目录.ends_with("\\"): 显示目录 = 显示目录.left(-1)
	var CMD显示目录 = 显示目录.replace("^", "^^").replace("&", "^&").replace("|", "^|").replace(">", "^>").replace("<", "^<")
	
	if 是PS:
		# PS 使用 Write-Host 提供颜色高亮，单引号内两单引号表示转义
		var 安全串 = 完整命令.replace("'", "''")
		var 提示 = "Write-Host '[ShellQuicker | PowerShell]' -ForegroundColor DarkCyan ; "
		提示 += "Set-Location -LiteralPath '" + 工作目录.replace("'", "''") + "' ; "
		提示 += "Write-Host 'PS " + 显示目录.replace("'", "''") + "> ' -NoNewline ; "
		提示 += "Write-Host '" + 安全串 + "' -ForegroundColor White ; "
		命令 = 提示 + 完整命令
	else:
		# CMD 使用 echo，转义管道和逻辑符防截断
		var 安全串 = 完整命令.replace("&", "^&").replace("|", "^|").replace(">", "^>").replace("<", "^<")
		var 安全目录 = 工作目录.replace("^", "^^").replace("&", "^&").replace("|", "^|").replace(">", "^>").replace("<", "^<")
		var 提示 = "cd /d \"" + 安全目录 + "\" & echo [ShellQuicker ^| CMD] & echo " + CMD显示目录 + "^>" + 安全串 + " & "
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
			OS.create_process("wt", ["-d", 工作目录, "cmd", "/k", wt_cmd])
		3: 
			var wt_cmd = 命令.replace(";", "\\;")
			OS.create_process("wt", ["-d", 工作目录, "powershell", "-noexit", "-command", wt_cmd])

func _树上运行图标被点击(项:TreeItem, _c, _i, _idx):
	var node_id = 项.get_metadata(0); var 数据 = 配置管理器.树状数据.get(node_id)
	if 数据 and 数据["类型"] == "预设":
		if node_id == 当前选中ID:_自动保存当前预设()

		var 启动目录 = _清洗文本(数据.get("启动目录", ""))
		var prefix = _清洗文本(数据.get("前缀命令", ""))
		var core_cmd = 数据.get("固定命令", "")

		var 完整命令 = core_cmd
		if prefix != "":
			完整命令 = prefix + core_cmd

		for p in 数据.get("参数列表", []):
			var val = p.get("当前值", "").strip_edges()
			if val != "":
				完整命令 += " " + val

		if 执行时复制开关.button_pressed:
			DisplayServer.clipboard_set(完整命令)

		_拉起窗口(数据.get("Shell类型", 0), 完整命令, 数据.get("UTF8模式", false), 启动目录)

func _触发重命名(项:TreeItem):
	if !项: return
	正在重命名状态 = true
	树状菜单.grab_focus()
	项.set_editable(0, true)
	树状菜单.edit_selected()
	# Tree 内联编辑器创建可能晚于一帧，改为重试绑定避免漏连
	_树重命名绑定尝试次数 = 0
	_树重命名输入框 = null
	get_tree().process_frame.connect(_绑定树重命名实时同步, CONNECT_ONE_SHOT)

func _绑定树重命名实时同步():
	if not 正在重命名状态: return
	var 焦点 = get_viewport().gui_get_focus_owner()
	if 焦点 is LineEdit and 树状菜单.is_ancestor_of(焦点):
		_树重命名输入框 = 焦点
		var 回调 = Callable(self, "_树重命名进行中")
		if not _树重命名输入框.text_changed.is_connected(回调):
			_树重命名输入框.text_changed.connect(回调)
		_树重命名进行中(_树重命名输入框.text)
		return

	# 未取到 Tree 内联 LineEdit 时，继续尝试若干帧
	_树重命名绑定尝试次数 += 1
	if _树重命名绑定尝试次数 < 24:
		get_tree().process_frame.connect(_绑定树重命名实时同步, CONNECT_ONE_SHOT)

func _树重命名进行中(新名:String):
	if not 正在重命名状态: return
	var 项 = 树状菜单.get_selected()
	if !项: return
	var id = 项.get_metadata(0)
	if id != 当前选中ID: return
	if 预设面板.visible:
		if 预设名输入.text != 新名: 预设名输入.text = 新名
	elif 文件夹面板.visible:
		if 文件夹标题.text != 新名: 文件夹标题.text = 新名

func _树项编辑完成():
	# 清理实时同步连接，避免悬挂连接
	if is_instance_valid(_树重命名输入框):
		var 回调 = Callable(self, "_树重命名进行中")
		if _树重命名输入框.text_changed.is_connected(回调):
			_树重命名输入框.text_changed.disconnect(回调)
	_树重命名输入框 = null
	_树重命名绑定尝试次数 = 0

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
				数据 = {"名称": "新模板", "类型": "预设", "父节点": 目标父ID,"启动目录": "", "固定命令": "", "参数列表": [], "Shell类型": 0, "order": 999}
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
	# 切换前强制同步当前状态到旧 Profile 的存档
	if 树状菜单.get_root():
		_已折叠ID集合.clear()
		_递归记录折叠状态(树状菜单.get_root())
		_保存折叠到全局()
	
	var profile_name = 配置选择.get_item_text(index)
	配置管理器.切换配置文件(profile_name)
	_完整状态恢复流程() 
	预设面板.hide(); 文件夹面板.hide()

func _请求新建配置():
	var dialog = AcceptDialog.new(); dialog.title = "新建配置"; add_child(dialog)
	var input = LineEdit.new(); input.placeholder_text = "输入新配置文件名..."; dialog.add_child(input)
	dialog.get_ok_button().text = "创建"
	_注入通用样式(dialog)
	dialog.confirmed.connect(func():
		var n = input.text.strip_edges()
		if n != "" and 配置管理器.新建配置文件(n):
			_完整状态恢复流程() 
			_刷新配置列表UI(); 预设面板.hide(); 文件夹面板.hide()
		dialog.queue_free()
	)
	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered(Vector2i(300, 100))

func _请求重命名配置():
	var dialog = AcceptDialog.new(); dialog.title = "重命名配置"; add_child(dialog)
	var input = LineEdit.new(); input.text = 配置管理器.配置文件别名;dialog.add_child(input)
	dialog.get_ok_button().text = "确定"
	_注入通用样式(dialog)
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
	_注入通用样式(dialog)
	dialog.confirmed.connect(func():
		配置管理器.删除当前配置()
		_完整状态恢复流程() 
		_刷新配置列表UI(); 预设面板.hide(); 文件夹面板.hide()
		dialog.queue_free()
	)
	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered()
