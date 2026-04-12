extends RefCounted
class_name 树渲染搜索管理器

var _配置管理器 = null
var _树状菜单: Tree = null
var _搜索框: LineEdit = null
var _搜文件夹备注勾选: CheckBox = null
var _搜模板备注勾选: CheckBox = null
var _搜夹连带子项勾选: CheckBox = null
var _播放图标: Texture2D = null

var _已折叠ID集合: Dictionary = {}

var _递归选中树项回调: Callable
var _获取用于渲染子节点回调: Callable

func 初始化(配置管理器对象, 树状菜单: Tree, 搜索框: LineEdit, 搜文件夹备注勾选: CheckBox, 搜模板备注勾选: CheckBox, 搜夹连带子项勾选: CheckBox, 播放图标: Texture2D, 递归选中树项回调: Callable, 获取用于渲染子节点回调: Callable):
	_配置管理器 = 配置管理器对象
	_树状菜单 = 树状菜单
	_搜索框 = 搜索框
	_搜文件夹备注勾选 = 搜文件夹备注勾选
	_搜模板备注勾选 = 搜模板备注勾选
	_搜夹连带子项勾选 = 搜夹连带子项勾选
	_播放图标 = 播放图标
	_递归选中树项回调 = 递归选中树项回调
	_获取用于渲染子节点回调 = 获取用于渲染子节点回调

func 切换配置前保存折叠状态():
	if not is_instance_valid(_树状菜单):
		return
	if _树状菜单.get_root():
		_已折叠ID集合.clear()
		_递归记录折叠状态(_树状菜单.get_root())
		保存折叠到全局()

func 加载折叠到内存():
	if _配置管理器 == null:
		return
	var 存档折叠 = _配置管理器.全局配置.get("已折叠ID", [])
	_已折叠ID集合.clear()
	for id in 存档折叠:
		_已折叠ID集合[id] = true

func 保存折叠到全局():
	if _配置管理器 == null:
		return
	_配置管理器.全局配置["已折叠ID"] = _已折叠ID集合.keys()
	_配置管理器.保存全局配置()

func 刷新树状菜单(当前选中ID: String, 记录折叠: bool = true):
	if not is_instance_valid(_树状菜单):
		return
	if 记录折叠 and is_instance_valid(_搜索框) and _搜索框.text == "":
		var 根 = _树状菜单.get_root()
		# 关键修复：只有当树中存在子节点（非空）时才允许覆盖内存记录
		# 这样启动时刷新操作就不会抹掉刚才从配置里读出来的历史数据
		if 根 and 根.get_first_child():
			_已折叠ID集合.clear()
			_递归记录折叠状态(根)
			保存折叠到全局()

	_树状菜单.clear()
	var 根2 = _树状菜单.create_item()
	填充树递归("", 根2)
	动态更新当前搜索()
	if 当前选中ID != "" and _递归选中树项回调.is_valid():
		_递归选中树项回调.call(_树状菜单.get_root(), 当前选中ID)

func 树项折叠状态改变(项: TreeItem, 是否正在加载UI: bool):
	if 是否正在加载UI:
		return
	# 搜索期间的操作不记录到持久化
	if is_instance_valid(_搜索框) and _搜索框.text != "":
		return
	var id = 项.get_metadata(0)
	if not id:
		return
	if 项.collapsed:
		_已折叠ID集合[id] = true
	else:
		_已折叠ID集合.erase(id)
	保存折叠到全局()

func 动态更新当前搜索():
	if is_instance_valid(_搜索框) and _搜索框.text != "":
		var 根 = _树状菜单.get_root()
		if 根:
			_搜索递归增强(根, _搜索框.text.to_lower(), false)

func 搜索框内容改变(新文本: String, 当前选中ID: String):
	if _配置管理器 == null:
		return
	var 旧文本 = _配置管理器.全局配置.get("搜索保留", "")
	_配置管理器.全局配置["搜索保留"] = 新文本
	_配置管理器.保存全局配置()

	if is_instance_valid(_搜夹连带子项勾选):
		_搜夹连带子项勾选.disabled = (新文本.strip_edges() == "")
		_搜夹连带子项勾选.visible = !(新文本.strip_edges() == "")

	# 如果是从无到有的搜索，先记录下当前的折叠状态，以便清空后恢复
	if 旧文本 == "" and 新文本 != "":
		var 根 = _树状菜单.get_root()
		if 根:
			_已折叠ID集合.clear()
			_递归记录折叠状态(根)
			保存折叠到全局()

	if 新文本 == "":
		刷新树状菜单(当前选中ID, false)
		return
	var 根 = _树状菜单.get_root()
	if 根:
		_搜索递归增强(根, 新文本.to_lower(), false)

func 填充树递归(pid: String, parent_item: TreeItem):
	var 节点列表: Array = []
	if _获取用于渲染子节点回调.is_valid():
		节点列表 = _获取用于渲染子节点回调.call(pid)
	for n in 节点列表:
		var item = _树状菜单.create_item(parent_item)
		item.set_text(0, n["名称"])
		item.set_metadata(0, n["ID"])
		if n["类型"] == "文件夹":
			item.set_custom_color(0, Color.GOLDENROD)
			if _已折叠ID集合.has(n["ID"]):
				item.collapsed = true
		else:
			item.add_button(0, _播放图标, 0, false, "立即执行")
		填充树递归(n["ID"], item)

func _递归记录折叠状态(项: TreeItem):
	var id = 项.get_metadata(0)
	if 项.collapsed and id:
		_已折叠ID集合[id] = true
	var 子 = 项.get_first_child()
	while 子:
		_递归记录折叠状态(子)
		子 = 子.get_next()

func _搜索递归增强(项: TreeItem, 文本: String, 祖先强行显示: bool = false) -> bool:
	var id = 项.get_metadata(0)
	var 数据 = _配置管理器.树状数据.get(id)
	var 是否搜文件夹备注 = bool(_配置管理器.全局配置.get("搜文件夹备注", true))
	var 是否搜模板备注 = bool(_配置管理器.全局配置.get("搜模板备注", true))
	var 匹配名称 = 文本 in 项.get_text(0).to_lower()
	var 匹配备注 = false
	if 数据:
		if 数据["类型"] == "文件夹" and 是否搜文件夹备注:
			var 备注1 = 数据.get("描述", "").to_lower()
			if 文本 in 备注1:
				匹配备注 = true
		elif 数据["类型"] == "预设" and 是否搜模板备注:
			var 备注2 = 数据.get("描述", "").to_lower()
			if 文本 in 备注2:
				匹配备注 = true
	var 自己匹配 = 匹配名称 or 匹配备注 or 祖先强行显示

	var 作为连带触发点 = false
	if 数据 and 数据["类型"] == "文件夹" and is_instance_valid(_搜夹连带子项勾选) and _搜夹连带子项勾选.button_pressed and (匹配名称 or 匹配备注):
		作为连带触发点 = true

	var 子项匹配 = false
	var 子 = 项.get_first_child()
	while 子:
		if _搜索递归增强(子, 文本, 祖先强行显示 or 作为连带触发点):
			子项匹配 = true
		子 = 子.get_next()
	项.visible = 自己匹配 or 子项匹配
	return 项.visible
