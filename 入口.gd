extends Node

# 入口脚本 Pro++ (大师极简交互版 - 终极流畅版)
# 支持键盘流搜素、自适应备注、单实例锁定、混合导航、配置持久化
@export var 调试模式: bool = true

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
var _正在加载UI: bool = false
var 播放图标: Texture2D
var 当前字体大小: int = 20
var 预览片段索引表: Array = [] # 格式: { "start": 0, "end": 10, "node": Node }
var _窗口快捷键控制器 = preload("res://窗口快捷键控制器.gd").new()
var _配置切换管理器 = preload("res://配置切换管理器.gd").new()
var _树渲染搜索管理器 = preload("res://树渲染搜索管理器.gd").new()
var _命令执行管理器 = preload("res://命令执行管理器.gd").new()
var _树拖拽管理器 = preload("res://树拖拽管理器.gd").new()
var _参数编辑管理器 = preload("res://参数编辑管理器.gd").new()
var _树项操作管理器 = preload("res://树项操作管理器.gd").new()
var _是否已计划延迟保存: bool = false
var _待保存预设: bool = false
var _待保存文件夹: bool = false

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
	_初始化搜索穿透勾选框()
	_初始化树渲染搜索管理器()
	_初始化命令执行管理器()
	_初始化参数编辑管理器()
	_初始化树项操作管理器()
	树状菜单.select_mode = Tree.SELECT_MULTI
	树状菜单.allow_rmb_select = true
	树状菜单.set_script(load("res://树辅助.gd"))
	树状菜单.入口 = self
	_初始化树拖拽管理器()
	
	# --- 加载全局持久化配置 ---
	_同步状态到UI()
	
	_初始化UI()
	_初始化文件夹备注输入框()
	_初始化配置切换管理器()
	
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
	执行按钮.pressed.connect(_命令执行管理器.点击执行)
	右键菜单.id_pressed.connect(_右键菜单项被按下)
	
	快捷新建模板.pressed.connect(_右键菜单项被按下.bind(0))
	快捷新建文件夹.pressed.connect(_右键菜单项被按下.bind(1))
	
	预设名输入.text_changed.connect(_计划保存当前预设)
	预设名输入.text_changed.connect(更新预览)
	预设名输入.focus_entered.connect(更新预览); 预设名输入.focus_exited.connect(更新预览)
	预设说明输入.text_changed.connect(_计划保存当前预设)
	预设说明输入.text_changed.connect(更新预览)
	启动目录输入.text_changed.connect(_计划保存当前预设)
	启动目录输入.text_changed.connect(更新预览)
	启动目录输入.focus_entered.connect(更新预览); 启动目录输入.focus_exited.connect(更新预览)
	前缀命令输入.text_changed.connect(_计划保存当前预设)
	前缀命令输入.text_changed.connect(更新预览)
	前缀命令输入.focus_entered.connect(更新预览); 前缀命令输入.focus_exited.connect(更新预览)
	核心命令输入.text_changed.connect(_命令执行管理器.核心命令已变更)
	核心命令输入.focus_entered.connect(更新预览); 核心命令输入.focus_exited.connect(更新预览)
	智能解析按钮.pressed.connect(func(): _智能解析并覆盖参数(核心命令输入.text))
	Shell选择.item_selected.connect(_命令执行管理器.执行器设置已变更)
	UTF8模式.toggled.connect(_命令执行管理器.执行器设置已变更)
	执行时复制开关.toggled.connect(_on_copy_on_execute_toggled)
	复制指令按钮.pressed.connect(_命令执行管理器.复制完整命令)

	
	文件夹描述.text_changed.connect(_计划保存当前文件夹)
	文件夹标题.text_changed.connect(_计划保存当前文件夹)
	
	var 主体区域 = $布局容器 / 主体区域
	主体区域.split_offset = 配置管理器.全局配置.get("split_offset", 350)
	主体区域.dragged.connect(_on_layout_dragged)
	
	_配置切换管理器.刷新配置列表UI()
	_完整状态恢复流程()
	
	for p in [预设面板, 文件夹面板]:
		p.mouse_filter = Control.MOUSE_FILTER_PASS
		p.gui_input.connect(_on_panel_gui_input.bind(p))

func _初始化搜索穿透勾选框():
	if is_instance_valid(搜夹连带子项勾选):
		return
	var 左侧布局 = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局
	if not is_instance_valid(左侧布局):
		return
	搜夹连带子项勾选 = CheckBox.new()
	搜夹连带子项勾选.name = "搜夹连带子项"
	搜夹连带子项勾选.focus_mode = Control.FOCUS_CLICK
	搜夹连带子项勾选.text = "文件夹穿透"
	搜夹连带子项勾选.tooltip_text = "命中文件夹时连带显示其子项"
	搜夹连带子项勾选.visible = false
	搜夹连带子项勾选.disabled = true
	左侧布局.add_child(搜夹连带子项勾选)
	var 树快捷操作 = $布局容器 / 主体区域 / 左侧树容器 / 左侧布局 / 树快捷操作
	if is_instance_valid(树快捷操作):
		左侧布局.move_child(搜夹连带子项勾选, 树快捷操作.get_index())

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

func _初始化树渲染搜索管理器():
	_树渲染搜索管理器.初始化(
		配置管理器,
		树状菜单,
		搜索框,
		搜文件夹备注勾选,
		搜模板备注勾选,
		搜夹连带子项勾选,
		播放图标,
		Callable(self, "_递归选中树项"),
		Callable(self, "_获取用于渲染的子节点")
	)

func _初始化命令执行管理器():
	_命令执行管理器.初始化(
		self,
		配置管理器,
		参数容器,
		启动目录输入,
		前缀命令输入,
		核心命令输入,
		预设面板,
		执行目录预览,
		预览标签,
		Shell选择,
		UTF8模式,
		Callable(self, "_获取当前选中ID"),
		Callable(self, "_计划保存当前预设"),
		Callable(self, "_自动保存当前预设"),
		Callable(self, "_清洗文本")
	)

func _获取当前选中ID() -> String:
	return 当前选中ID

func _设置当前选中ID(值: String):
	当前选中ID = 值

func _初始化参数编辑管理器():
	_参数编辑管理器.初始化(
		self,
		参数容器,
		核心命令输入,
		预设名输入,
		Callable(self, "_获取正在加载UI"),
		Callable(self, "_设置正在加载UI"),
		Callable(self, "_计划保存当前预设"),
		Callable(self, "更新预览"),
		Callable(self, "_注入通用样式"),
		Callable(self, "_清洗文本")
	)

func _获取正在加载UI() -> bool:
	return _正在加载UI

func _设置正在加载UI(值: bool):
	_正在加载UI = 值

func _初始化树项操作管理器():
	_树项操作管理器.初始化(
		self,
		配置管理器,
		树状菜单,
		右键菜单,
		预设面板,
		文件夹面板,
		预设名输入,
		文件夹标题,
		Callable(self, "_获取当前选中ID"),
		Callable(self, "_设置当前选中ID"),
		Callable(self, "_树项被选中"),
		Callable(self, "刷新树状菜单"),
		Callable(self, "_动态更新当前搜索"),
		Callable(self, "_自动保存当前预设")
	)

func _初始化树拖拽管理器():
	_树拖拽管理器.初始化(
		配置管理器,
		树状菜单,
		_树渲染搜索管理器,
		Callable(self, "_获取当前选中ID"),
		Callable(self, "_获取所有选中项"),
		Callable(self, "_递归选中树项")
	)
	_树拖拽管理器.初始化拖拽落点标识()

func _初始化配置切换管理器():
	_配置切换管理器.初始化(
		self,
		配置管理器,
		配置选择,
		配置刷新按钮,
		配置新建按钮,
		配置重命名按钮,
		配置删除按钮,
		预设面板,
		文件夹面板,
		Callable(self, "_注入通用样式"),
		Callable(self, "_切换配置前保存折叠状态"),
		Callable(self, "_完整状态恢复流程")
	)

func _切换配置前保存折叠状态():
	_树渲染搜索管理器.切换配置前保存折叠状态()

func _初始化窗口快捷键控制器():
	var 工具栏 = $布局容器 / 顶部导航 / MarginContainer / 工具栏
	_窗口快捷键控制器.初始化(
		self,
		工具栏,
		配置管理器,
		调试模式,
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
			var 系统右键菜单 = 节点.get_menu()
			if is_instance_valid(系统右键菜单):
				_注入通用样式(系统右键菜单)
			
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
	if not 选中 or _树项操作管理器.是否正在重命名():
		return
	_处理树焦点快捷键(event, 焦点, 选中)

func _处理全局命令快捷键(event: InputEventKey, 焦点: Control) -> bool:
	# --- 强制/全局运行快捷键 ---
	if event.ctrl_pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
		_命令执行管理器.点击执行()
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
		_命令执行管理器.复制完整命令()
		get_viewport().set_input_as_handled()
		return true
	# --- Ctrl + C 复制快捷键 (非输入状态) ---
	# Ctrl+C：若预览有选中文本则复制选中，否则复制完整命令
	# Ctrl+Shift+C：见上方全局分支
	if event.ctrl_pressed and event.keycode == KEY_C:
		var 是否在输入 = (焦点 is LineEdit or 焦点 is TextEdit)
		if not 是否在输入:
			_命令执行管理器.复制预览选中或完整命令()
			get_viewport().set_input_as_handled()
			return true
	if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
		if not (焦点 is TextEdit):
			_命令执行管理器.点击执行()
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
			_命令执行管理器.点击执行()
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
	_参数编辑管理器.创建参数行(键, 备注, 当前值)

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
	启动目录输入.placeholder_text = _命令执行管理器.获取真实执行目录()
	前缀命令输入.text = 数据.get("前缀命令", ""); 核心命令输入.text = 数据["固定命令"]; Shell选择.selected = 数据.get("Shell类型", 0)
	UTF8模式.button_pressed = 数据.get("UTF8模式", false)
	for 子 in 参数容器.get_children(): 子.queue_free()
	for 项 in 数据.get("参数列表", []): 创建参数行(项["键"], 项["备注"], 项.get("当前值", ""))
	更新预览()

func _智能解析并覆盖参数(文本:String):
	_参数编辑管理器.智能解析并覆盖参数(文本)

func _同步状态到UI():
	# 从配置管理器加载新 Profile 的数据到 UI
	_树渲染搜索管理器.加载折叠到内存()
	_窗口快捷键控制器.从配置加载并应用()
	当前字体大小 = 配置管理器.全局配置.get("字体大小", 20)
	搜文件夹备注勾选.button_pressed = 配置管理器.全局配置.get("搜文件夹备注", true)
	搜模板备注勾选.button_pressed = 配置管理器.全局配置.get("搜模板备注", true)
	执行时复制开关.button_pressed = 配置管理器.全局配置.get("执行时复制", false)
	搜索框.text = 配置管理器.全局配置.get("搜索保留", "")
	if 搜夹连带子项勾选:
		搜夹连带子项勾选.button_pressed = 配置管理器.全局配置.get("搜夹连带子项", true)

func 刷新树状菜单(记录折叠: bool = true):
	_树渲染搜索管理器.刷新树状菜单(当前选中ID, 记录折叠)

func _树项折叠状态改变(项:TreeItem):
	_树渲染搜索管理器.树项折叠状态改变(项, _正在加载UI)

func _动态更新当前搜索():
	_树渲染搜索管理器.动态更新当前搜索()

func 填充树递归(pid: String, parent_item: TreeItem):
	_树渲染搜索管理器.填充树递归(pid, parent_item)

func _获取用于渲染的子节点(父ID: String) -> Array:
	return _树拖拽管理器.获取用于渲染的子节点(父ID)

func _搜索框内容改变(新文本:String):
	_树渲染搜索管理器.搜索框内容改变(新文本, 当前选中ID)

func _计划保存当前预设():
	if _正在加载UI or 当前选中ID == "":
		return
	_待保存预设 = true
	_计划延迟保存()

func _计划保存当前文件夹():
	if _正在加载UI or 当前选中ID == "":
		return
	_待保存文件夹 = true
	_计划延迟保存()

func _计划延迟保存():
	if _是否已计划延迟保存:
		return
	_是否已计划延迟保存 = true
	get_tree().create_timer(0.12).timeout.connect(_执行延迟保存, CONNECT_ONE_SHOT)

func _执行延迟保存():
	_是否已计划延迟保存 = false
	if _待保存预设:
		_待保存预设 = false
		_自动保存当前预设()
	if _待保存文件夹:
		_待保存文件夹 = false
		_自动保存当前文件夹()

func _自动保存当前预设():
	_待保存预设 = false
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
	_待保存文件夹 = false
	if _正在加载UI or 当前选中ID == "": return
	var 数据 = 配置管理器.树状数据.get(当前选中ID); if !数据 or 数据["类型"] != "文件夹": return
	数据["名称"] = 文件夹标题.text; 数据["描述"] = 文件夹描述.text; 配置管理器.保存预设()
	var 项 = 树状菜单.get_selected()
	if 项 and 项.get_metadata(0) == 当前选中ID: 项.set_text(0, 数据["名称"])
	_动态更新当前搜索()

func _get_drag_data_logic(_pos):
	return _树拖拽管理器.get_drag_data_logic(_pos)

func _can_drop_data_logic(鼠标位置, 拖拽数据):
	return _树拖拽管理器.can_drop_data_logic(鼠标位置, 拖拽数据)

func _drop_data_logic(鼠标位置, 拖拽项):
	_树拖拽管理器.drop_data_logic(鼠标位置, 拖拽项)

func _初始化拖拽落点标识():
	_树拖拽管理器.初始化拖拽落点标识()

func _更新拖拽落点标识(落点信息: Dictionary):
	_树拖拽管理器.更新拖拽落点标识(落点信息)


func _拖拽结束清理标识():
	_树拖拽管理器.拖拽结束清理标识()

func 更新预览():
	_命令执行管理器.更新预览()

func _弹出参数右键菜单(目标行:HBoxContainer):
	_参数编辑管理器.弹出参数右键菜单(目标行)

func _合并参数行(当前行:HBoxContainer):
	_参数编辑管理器.合并参数行(当前行)

func _批量合并参数行(起始行:HBoxContainer, _仅后续: bool):
	_参数编辑管理器.批量合并参数行(起始行, _仅后续)

func _合并范围参数行(目标行:HBoxContainer):
	_参数编辑管理器.合并范围参数行(目标行)

func _快捷范围合并():
	_参数编辑管理器.快捷范围合并()

func _全部参数合并入核心():
	_参数编辑管理器.全部参数合并入核心()

# --- 重构：信号命名方法 (消除 Lambda Freed 隐患) ---

func _on_tree_mouse_selected(_pos: Vector2, _btn_idx: int):
	_树项被选中()

func _on_search_config_toggled(pressed: bool, kind: String):
	配置管理器.全局配置[kind] = pressed
	配置管理器.保存全局配置()
	刷新树状菜单(false)
	_搜索框内容改变(搜索框.text)

func _on_layout_dragged(offset):
	配置管理器.全局配置["split_offset"] = offset
	配置管理器.保存全局配置()

func _on_copy_on_execute_toggled(pressed: bool):
	配置管理器.全局配置["执行时复制"] = pressed
	配置管理器.保存全局配置()

func _on_panel_gui_input(e, p):
	if !is_instance_valid(p): return
	if e is InputEventMouseButton and e.pressed:
		var node_focus = get_viewport().gui_get_focus_owner()
		if is_instance_valid(node_focus): node_focus.release_focus()

func _树上运行图标被点击(项:TreeItem, _c, _i, _idx):
	_命令执行管理器.树上运行图标被点击(项)

func _触发重命名(项:TreeItem):
	_树项操作管理器.触发重命名(项)

func _树项编辑完成():
	_树项操作管理器.树项编辑完成()

func _点击删除动作():
	_树项操作管理器.点击删除动作()

func _点击克隆动作():
	_树项操作管理器.点击克隆动作()

func _更新右键菜单项状态():
	_树项操作管理器.更新右键菜单项状态()

func _右键菜单项被按下(id: int):
	_树项操作管理器.右键菜单项被按下(id)

func _获取所有选中项() -> Array:
	return _树项操作管理器.获取所有选中项()

func _递归选中树项(当前项:TreeItem, 目标ID: String) -> bool:
	return _树项操作管理器.递归选中树项(当前项, 目标ID)

func _递归同步排序(项:TreeItem):
	_树项操作管理器.递归同步排序(项)
