extends RefCounted
class_name 配置切换管理器

var _宿主: Node = null
var _配置管理器 = null
var _配置选择: OptionButton = null
var _配置刷新按钮: Button = null
var _配置新建按钮: Button = null
var _配置重命名按钮: Button = null
var _配置删除按钮: Button = null
var _预设面板: Control = null
var _文件夹面板: Control = null

var _注入通用样式回调: Callable
var _切换前保存现场回调: Callable
var _完整状态恢复流程回调: Callable

var _新建配置弹窗: AcceptDialog = null
var _新建配置输入框: LineEdit = null
var _重命名配置弹窗: AcceptDialog = null
var _重命名配置输入框: LineEdit = null
var _删除配置弹窗: ConfirmationDialog = null

func 初始化(宿主: Node, 配置管理器对象, 配置选择: OptionButton, 配置刷新按钮: Button, 配置新建按钮: Button, 配置重命名按钮: Button, 配置删除按钮: Button, 预设面板: Control, 文件夹面板: Control, 注入通用样式回调: Callable, 切换前保存现场回调: Callable, 完整状态恢复流程回调: Callable):
	_宿主 = 宿主
	_配置管理器 = 配置管理器对象
	_配置选择 = 配置选择
	_配置刷新按钮 = 配置刷新按钮
	_配置新建按钮 = 配置新建按钮
	_配置重命名按钮 = 配置重命名按钮
	_配置删除按钮 = 配置删除按钮
	_预设面板 = 预设面板
	_文件夹面板 = 文件夹面板
	_注入通用样式回调 = 注入通用样式回调
	_切换前保存现场回调 = 切换前保存现场回调
	_完整状态恢复流程回调 = 完整状态恢复流程回调
	_连接信号()

func 刷新配置列表UI():
	if not is_instance_valid(_配置选择):
		return
	_配置选择.clear()
	var 列表 = _配置管理器.获取配置文件列表()
	var 当前别名 = _配置管理器.配置文件别名
	for i in range(列表.size()):
		_配置选择.add_item(列表[i])
		if 列表[i] == 当前别名:
			_配置选择.selected = i

func 切换配置文件(index: int):
	if not is_instance_valid(_配置选择):
		return
	if _切换前保存现场回调.is_valid():
		_切换前保存现场回调.call()
	var 配置名 = _配置选择.get_item_text(index)
	_配置管理器.切换配置文件(配置名)
	if _完整状态恢复流程回调.is_valid():
		_完整状态恢复流程回调.call()
	_隐藏详情面板()

func 请求新建配置():
	if not is_instance_valid(_宿主):
		return
	if is_instance_valid(_新建配置弹窗):
		return
	_新建配置弹窗 = AcceptDialog.new()
	_新建配置弹窗.title = "新建配置"
	_宿主.add_child(_新建配置弹窗)
	_新建配置输入框 = LineEdit.new()
	_新建配置输入框.placeholder_text = "输入新配置文件名..."
	_新建配置弹窗.add_child(_新建配置输入框)
	_新建配置弹窗.get_ok_button().text = "创建"
	if _注入通用样式回调.is_valid():
		_注入通用样式回调.call(_新建配置弹窗)
	_新建配置弹窗.confirmed.connect(_确认新建配置)
	_新建配置弹窗.canceled.connect(_关闭新建配置弹窗)
	_新建配置弹窗.popup_centered(Vector2i(300, 100))

func 请求重命名配置():
	if not is_instance_valid(_宿主):
		return
	if is_instance_valid(_重命名配置弹窗):
		return
	_重命名配置弹窗 = AcceptDialog.new()
	_重命名配置弹窗.title = "重命名配置"
	_宿主.add_child(_重命名配置弹窗)
	_重命名配置输入框 = LineEdit.new()
	_重命名配置输入框.text = _配置管理器.配置文件别名
	_重命名配置弹窗.add_child(_重命名配置输入框)
	_重命名配置弹窗.get_ok_button().text = "确定"
	if _注入通用样式回调.is_valid():
		_注入通用样式回调.call(_重命名配置弹窗)
	_重命名配置弹窗.confirmed.connect(_确认重命名配置)
	_重命名配置弹窗.canceled.connect(_关闭重命名配置弹窗)
	_重命名配置弹窗.popup_centered(Vector2i(300, 100))

func 请求删除配置():
	if not is_instance_valid(_宿主):
		return
	if is_instance_valid(_删除配置弹窗):
		return
	_删除配置弹窗 = ConfirmationDialog.new()
	_删除配置弹窗.title = "删除确认"
	_删除配置弹窗.dialog_text = "确定要删除当前配置文件吗？该操作不可撤销。"
	_宿主.add_child(_删除配置弹窗)
	if _注入通用样式回调.is_valid():
		_注入通用样式回调.call(_删除配置弹窗)
	_删除配置弹窗.confirmed.connect(_确认删除配置)
	_删除配置弹窗.canceled.connect(_关闭删除配置弹窗)
	_删除配置弹窗.popup_centered()

func _连接信号():
	var 切换回调 = Callable(self, "切换配置文件")
	var 刷新回调 = Callable(self, "刷新配置列表UI")
	var 新建回调 = Callable(self, "请求新建配置")
	var 重命名回调 = Callable(self, "请求重命名配置")
	var 删除回调 = Callable(self, "请求删除配置")
	if is_instance_valid(_配置选择) and not _配置选择.item_selected.is_connected(切换回调):
		_配置选择.item_selected.connect(切换回调)
	if is_instance_valid(_配置刷新按钮) and not _配置刷新按钮.pressed.is_connected(刷新回调):
		_配置刷新按钮.pressed.connect(刷新回调)
	if is_instance_valid(_配置新建按钮) and not _配置新建按钮.pressed.is_connected(新建回调):
		_配置新建按钮.pressed.connect(新建回调)
	if is_instance_valid(_配置重命名按钮) and not _配置重命名按钮.pressed.is_connected(重命名回调):
		_配置重命名按钮.pressed.connect(重命名回调)
	if is_instance_valid(_配置删除按钮) and not _配置删除按钮.pressed.is_connected(删除回调):
		_配置删除按钮.pressed.connect(删除回调)

func _确认新建配置():
	if not is_instance_valid(_新建配置输入框):
		关闭新建配置弹窗()
		return
	var 名称 = _新建配置输入框.text.strip_edges()
	if 名称 != "" and _配置管理器.新建配置文件(名称):
		if _完整状态恢复流程回调.is_valid():
			_完整状态恢复流程回调.call()
		刷新配置列表UI()
		_隐藏详情面板()
	关闭新建配置弹窗()

func _关闭新建配置弹窗():
	关闭新建配置弹窗()

func 关闭新建配置弹窗():
	if is_instance_valid(_新建配置弹窗):
		_新建配置弹窗.queue_free()
	_新建配置弹窗 = null
	_新建配置输入框 = null

func _确认重命名配置():
	if not is_instance_valid(_重命名配置输入框):
		关闭重命名配置弹窗()
		return
	var 名称 = _重命名配置输入框.text.strip_edges()
	if 名称 != "" and _配置管理器.重命名当前配置(名称):
		刷新配置列表UI()
	关闭重命名配置弹窗()

func _关闭重命名配置弹窗():
	关闭重命名配置弹窗()

func 关闭重命名配置弹窗():
	if is_instance_valid(_重命名配置弹窗):
		_重命名配置弹窗.queue_free()
	_重命名配置弹窗 = null
	_重命名配置输入框 = null

func _确认删除配置():
	_配置管理器.删除当前配置()
	if _完整状态恢复流程回调.is_valid():
		_完整状态恢复流程回调.call()
	刷新配置列表UI()
	_隐藏详情面板()
	关闭删除配置弹窗()

func _关闭删除配置弹窗():
	关闭删除配置弹窗()

func 关闭删除配置弹窗():
	if is_instance_valid(_删除配置弹窗):
		_删除配置弹窗.queue_free()
	_删除配置弹窗 = null

func _隐藏详情面板():
	if is_instance_valid(_预设面板):
		_预设面板.hide()
	if is_instance_valid(_文件夹面板):
		_文件夹面板.hide()
