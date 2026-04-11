extends RefCounted
class_name 窗口快捷键控制器

const 默认最小化唤出快捷键文本 := "Ctrl+Shift+D"

var _宿主: Node = null
var _配置管理器 = null
var _注入通用样式回调: Callable
var _切换窗口最小化唤出回调: Callable

var _最小化唤出快捷键按钮: Button = null
var _最小化唤出快捷键: InputEventKey = null
var _快捷键设置弹窗: AcceptDialog = null
var _快捷键采集输入框: LineEdit = null
var _快捷键待应用: InputEventKey = null

var _全局热键管理器 = preload("res://全局热键管理器.gd").new()
var _快捷键工具 = preload("res://快捷键工具.gd").new()
var _已启动全局热键文本: String = ""

func 初始化(宿主: Node, 工具栏: Node, 配置管理器对象, 注入通用样式回调: Callable, 切换窗口最小化唤出回调: Callable):
	_宿主 = 宿主
	_配置管理器 = 配置管理器对象
	_注入通用样式回调 = 注入通用样式回调
	_切换窗口最小化唤出回调 = 切换窗口最小化唤出回调
	if not is_instance_valid(工具栏):
		return
	if is_instance_valid(_最小化唤出快捷键按钮):
		return
	_最小化唤出快捷键按钮 = Button.new()
	_最小化唤出快捷键按钮.name = "最小化唤出快捷键按钮"
	_最小化唤出快捷键按钮.focus_mode = Control.FOCUS_CLICK
	_最小化唤出快捷键按钮.tooltip_text = "设置最小化/唤出窗口快捷键"
	_最小化唤出快捷键按钮.pressed.connect(_打开最小化快捷键设置)
	工具栏.add_child(_最小化唤出快捷键按钮)
	_更新最小化唤出快捷键按钮文本()

func 从配置加载并应用():
	if _配置管理器 == null:
		return
	var 快捷键文本 = str(_配置管理器.全局配置.get("最小化唤出快捷键", 默认最小化唤出快捷键文本))
	var 解析结果 = _快捷键工具.文本转快捷键对象(快捷键文本)
	if 解析结果 == null:
		解析结果 = _快捷键工具.文本转快捷键对象(默认最小化唤出快捷键文本)
		_配置管理器.全局配置["最小化唤出快捷键"] = 默认最小化唤出快捷键文本
		_配置管理器.保存全局配置()
	_最小化唤出快捷键 = 解析结果
	_更新最小化唤出快捷键按钮文本()
	_重启全局热键助手()

func 处理最小化唤出快捷键(event: InputEventKey) -> bool:
	var 已启用全局热键助手 = OS.get_name() == "Windows" and _全局热键管理器.助手是否在线()
	if 已启用全局热键助手:
		return false
	if is_instance_valid(_快捷键设置弹窗):
		return false
	if not _快捷键工具.快捷键事件是否匹配(event, _最小化唤出快捷键):
		return false
	if _切换窗口最小化唤出回调.is_valid():
		_切换窗口最小化唤出回调.call()
	if is_instance_valid(_宿主):
		_宿主.get_viewport().set_input_as_handled()
	return true

func 释放资源():
	_停止全局热键助手()
	_关闭最小化快捷键设置弹窗()

func _更新最小化唤出快捷键按钮文本():
	if not is_instance_valid(_最小化唤出快捷键按钮):
		return
	var 显示文本 = _快捷键工具.快捷键对象转文本(_最小化唤出快捷键)
	if 显示文本 == "":
		显示文本 = 默认最小化唤出快捷键文本
	_最小化唤出快捷键按钮.text = "窗口快捷键: " + 显示文本

func _打开最小化快捷键设置():
	if not is_instance_valid(_宿主):
		return
	if is_instance_valid(_快捷键设置弹窗):
		return
	_快捷键待应用 = _最小化唤出快捷键
	_快捷键设置弹窗 = AcceptDialog.new()
	_快捷键设置弹窗.title = "设置窗口快捷键"
	_快捷键设置弹窗.get_ok_button().text = "保存"
	_快捷键设置弹窗.canceled.connect(_关闭最小化快捷键设置弹窗)
	_快捷键设置弹窗.confirmed.connect(_确认最小化快捷键设置)
	_快捷键设置弹窗.custom_action.connect(_快捷键设置弹窗自定义动作)
	_宿主.add_child(_快捷键设置弹窗)

	var 说明文本 = Label.new()
	说明文本.text = "点击输入框后按下快捷键，默认 " + 默认最小化唤出快捷键文本
	_快捷键设置弹窗.add_child(说明文本)

	_快捷键采集输入框 = LineEdit.new()
	_快捷键采集输入框.placeholder_text = "按下新的快捷键组合"
	_快捷键采集输入框.text = _快捷键工具.快捷键对象转文本(_快捷键待应用)
	_快捷键采集输入框.gui_input.connect(_捕获最小化快捷键输入)
	_快捷键设置弹窗.add_child(_快捷键采集输入框)

	_快捷键设置弹窗.add_button("恢复默认", true, "恢复默认")
	if _注入通用样式回调.is_valid():
		_注入通用样式回调.call(_快捷键设置弹窗)
	_快捷键设置弹窗.popup_centered(Vector2i(420, 150))
	_快捷键采集输入框.grab_focus()

func _捕获最小化快捷键输入(event: InputEvent):
	if not (event is InputEventKey):
		return
	var 键盘事件 = event as InputEventKey
	if not 键盘事件.pressed or 键盘事件.echo:
		return
	var 新快捷键 = _快捷键工具.按键事件转快捷键对象(键盘事件)
	if 新快捷键 == null:
		if is_instance_valid(_宿主):
			_宿主.get_viewport().set_input_as_handled()
		return
	_快捷键待应用 = 新快捷键
	if is_instance_valid(_快捷键采集输入框):
		_快捷键采集输入框.text = _快捷键工具.快捷键对象转文本(_快捷键待应用)
	if is_instance_valid(_宿主):
		_宿主.get_viewport().set_input_as_handled()

func _快捷键设置弹窗自定义动作(动作名: String):
	if 动作名 != "恢复默认":
		return
	_快捷键待应用 = _快捷键工具.文本转快捷键对象(默认最小化唤出快捷键文本)
	if is_instance_valid(_快捷键采集输入框):
		_快捷键采集输入框.text = 默认最小化唤出快捷键文本

func _确认最小化快捷键设置():
	if _快捷键待应用 == null:
		return
	if _配置管理器 == null:
		return
	_最小化唤出快捷键 = _快捷键待应用
	_配置管理器.全局配置["最小化唤出快捷键"] = _快捷键工具.快捷键对象转文本(_最小化唤出快捷键)
	_配置管理器.保存全局配置()
	_更新最小化唤出快捷键按钮文本()
	_重启全局热键助手()
	_关闭最小化快捷键设置弹窗()

func _关闭最小化快捷键设置弹窗():
	if is_instance_valid(_快捷键设置弹窗):
		_快捷键设置弹窗.queue_free()
	_快捷键设置弹窗 = null
	_快捷键采集输入框 = null
	_快捷键待应用 = null

func _重启全局热键助手():
	if _配置管理器 == null:
		return
	if OS.get_name() != "Windows":
		return
	if _最小化唤出快捷键 == null:
		return
	var 新快捷键文本 = _快捷键工具.快捷键对象转文本(_最小化唤出快捷键)
	if 新快捷键文本 == "":
		return
	if _全局热键管理器.助手是否在线() and _已启动全局热键文本 == 新快捷键文本:
		return
	var 是否成功 = _全局热键管理器.重启助手(_配置管理器.基础目录, 新快捷键文本)
	if 是否成功:
		_已启动全局热键文本 = 新快捷键文本
		var 日志路径 = _全局热键管理器.获取日志路径()
		if 日志路径 != "":
			print("全局热键日志: " + 日志路径)
	else:
		_已启动全局热键文本 = ""
		print("全局热键助手启动失败，已回退为窗口内快捷键。")

func _停止全局热键助手():
	_全局热键管理器.停止助手()
	_已启动全局热键文本 = ""
