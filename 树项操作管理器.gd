extends RefCounted
class_name 树项操作管理器

var _宿主: Node = null
var _配置管理器 = null
var _树状菜单: Tree = null
var _右键菜单: PopupMenu = null
var _预设面板: Control = null
var _文件夹面板: Control = null
var _预设名输入 = null
var _文件夹标题 = null

var _获取当前选中ID回调: Callable
var _设置当前选中ID回调: Callable
var _树项被选中回调: Callable
var _刷新树状菜单回调: Callable
var _动态更新当前搜索回调: Callable
var _自动保存当前预设回调: Callable

var _正在重命名状态: bool = false
var _树重命名输入框: LineEdit = null
var _树重命名绑定尝试次数: int = 0

func 初始化(宿主: Node, 配置管理器对象, 树状菜单: Tree, 右键菜单: PopupMenu, 预设面板: Control, 文件夹面板: Control, 预设名输入, 文件夹标题, 获取当前选中ID回调: Callable, 设置当前选中ID回调: Callable, 树项被选中回调: Callable, 刷新树状菜单回调: Callable, 动态更新当前搜索回调: Callable, 自动保存当前预设回调: Callable):
	_宿主 = 宿主
	_配置管理器 = 配置管理器对象
	_树状菜单 = 树状菜单
	_右键菜单 = 右键菜单
	_预设面板 = 预设面板
	_文件夹面板 = 文件夹面板
	_预设名输入 = 预设名输入
	_文件夹标题 = 文件夹标题
	_获取当前选中ID回调 = 获取当前选中ID回调
	_设置当前选中ID回调 = 设置当前选中ID回调
	_树项被选中回调 = 树项被选中回调
	_刷新树状菜单回调 = 刷新树状菜单回调
	_动态更新当前搜索回调 = 动态更新当前搜索回调
	_自动保存当前预设回调 = 自动保存当前预设回调

func 触发重命名(项: TreeItem):
	if !项:
		return
	_正在重命名状态 = true
	_树状菜单.grab_focus()
	项.set_editable(0, true)
	_树状菜单.edit_selected()
	_树重命名绑定尝试次数 = 0
	_树重命名输入框 = null
	_宿主.get_tree().process_frame.connect(_绑定树重命名实时同步, CONNECT_ONE_SHOT)

func 树项编辑完成():
	if is_instance_valid(_树重命名输入框):
		var 回调 = Callable(self, "_树重命名进行中")
		if _树重命名输入框.text_changed.is_connected(回调):
			_树重命名输入框.text_changed.disconnect(回调)
	_树重命名输入框 = null
	_树重命名绑定尝试次数 = 0
	_正在重命名状态 = false
	var 项 = _树状菜单.get_selected()
	if 项:
		var id = 项.get_metadata(0)
		var 新名 = 项.get_text(0)
		_配置管理器.重命名节点(id, 新名)
		var 当前选中ID = _当前选中ID()
		if id == 当前选中ID:
			if _预设面板.visible:
				_预设名输入.text = 新名
			elif _文件夹面板.visible:
				_文件夹标题.text = 新名
		项.set_editable(0, false)

func 点击删除动作():
	var 选中 = 获取所有选中项()
	for s in 选中:
		_配置管理器.删除节点(s.get_metadata(0))
	_刷新树(true)
	_预设面板.hide()
	_文件夹面板.hide()

func 点击克隆动作():
	var 选中 = 获取所有选中项()
	if 选中.size() != 1:
		return
	var s = 选中[0]
	var sid = s.get_metadata(0)
	var 目标父ID = _配置管理器.树状数据[sid].get("父节点", "")
	var nid = _递归深度克隆(sid, 目标父ID)
	var 兄弟们 = _配置管理器.获取子节点(目标父ID)
	var 序列 = []
	for b in 兄弟们:
		序列.append(b["ID"])
	var 插入索引 = -1
	for i in range(序列.size()):
		if 序列[i] == sid:
			插入索引 = i + 1
			break
	if 插入索引 != -1:
		序列.erase(nid)
		序列.insert(min(插入索引, 序列.size()), nid)
	_配置管理器.更新排序(序列)
	_刷新树(true)
	递归选中树项(_树状菜单.get_root(), nid)

func 更新右键菜单项状态():
	var 选中数 = 获取所有选中项().size()
	_右键菜单.set_item_disabled(2, 选中数 != 1)
	_右键菜单.set_item_disabled(3, 选中数 != 1)

func 右键菜单项被按下(id: int):
	var 选中 = _树状菜单.get_selected()
	var 目标父ID = ""
	var 插入索引 = -1
	if not _正在重命名状态:
		var 选中ID = ""
		if 选中:
			选中ID = str(选中.get_metadata(0))
		var 选中数据 = _配置管理器.树状数据.get(选中ID)
		if 选中数据:
			if 选中数据["类型"] == "文件夹":
				目标父ID = 选中ID
				插入索引 = 0
			else:
				目标父ID = 选中数据.get("父节点", "")
				var 兄弟们 = _配置管理器.获取子节点(目标父ID)
				for k in range(兄弟们.size()):
					if 兄弟们[k]["ID"] == 选中ID:
						插入索引 = k + 1
						break
	match id:
		0, 1:
			var nid = str(Time.get_ticks_msec())
			var 数据 = {}
			if id == 0:
				数据 = {"名称": "新模板", "类型": "预设", "父节点": 目标父ID, "启动目录": "", "固定命令": "", "参数列表": [], "Shell类型": 0, "order": 999}
			else:
				数据 = {"名称": "新分类", "类型": "文件夹", "父节点": 目标父ID, "描述": "", "order": 999}
			_配置管理器.添加节点(nid, 数据)
			var 兄弟们2 = _配置管理器.获取子节点(目标父ID)
			var 序列 = []
			for b in 兄弟们2:
				if b["ID"] == nid:
					continue
				序列.append(b["ID"])
			if 插入索引 == -1:
				序列.append(nid)
			else:
				序列.insert(插入索引, nid)
			_配置管理器.更新排序(序列)
			_刷新树(true)
			递归选中树项(_树状菜单.get_root(), nid)
		3:
			点击克隆动作()
		5:
			if 选中:
				触发重命名(选中)
		4:
			点击删除动作()

func 获取所有选中项() -> Array:
	var 结果 = []
	var 项 = _树状菜单.get_next_selected(null)
	while 项:
		结果.append(项)
		项 = _树状菜单.get_next_selected(项)
	return 结果

func 递归选中树项(当前项: TreeItem, 目标ID: String) -> bool:
	var 子 = 当前项.get_first_child()
	while 子:
		if 子.get_metadata(0) == 目标ID:
			_树状菜单.deselect_all()
			子.select(0)
			_树状菜单.scroll_to_item(子)
			if _树项被选中回调.is_valid():
				_树项被选中回调.call()
			return true
		if 递归选中树项(子, 目标ID):
			return true
		子 = 子.get_next()
	return false

func 递归同步排序(项: TreeItem):
	var ids = []
	var 子 = 项.get_first_child()
	while 子:
		ids.append(子.get_metadata(0))
		递归同步排序(子)
		子 = 子.get_next()
	if ids.size() > 0:
		_配置管理器.更新排序(ids)

func 是否正在重命名() -> bool:
	return _正在重命名状态

func _绑定树重命名实时同步():
	if not _正在重命名状态:
		return
	var 焦点 = _宿主.get_viewport().gui_get_focus_owner()
	if 焦点 is LineEdit and _树状菜单.is_ancestor_of(焦点):
		_树重命名输入框 = 焦点
		var 回调 = Callable(self, "_树重命名进行中")
		if not _树重命名输入框.text_changed.is_connected(回调):
			_树重命名输入框.text_changed.connect(回调)
		_树重命名进行中(_树重命名输入框.text)
		return
	_树重命名绑定尝试次数 += 1
	if _树重命名绑定尝试次数 < 24:
		_宿主.get_tree().process_frame.connect(_绑定树重命名实时同步, CONNECT_ONE_SHOT)

func _树重命名进行中(新名: String):
	if not _正在重命名状态:
		return
	var 项 = _树状菜单.get_selected()
	if !项:
		return
	var id = 项.get_metadata(0)
	if id != _当前选中ID():
		return
	if _预设面板.visible:
		if _预设名输入.text != 新名:
			_预设名输入.text = 新名
	elif _文件夹面板.visible:
		if _文件夹标题.text != 新名:
			_文件夹标题.text = 新名

func _递归深度克隆(源ID: String, 新父ID: String) -> String:
	var 源数据 = _配置管理器.树状数据[源ID]
	var 新ID = str(Time.get_ticks_msec()) + "_" + str(randi() % 1000)
	var 新数据 = 源数据.duplicate(true)
	新数据["父节点"] = 新父ID
	# 每次克隆都追加一次“(副本)”，满足连续克隆的可见层级
	新数据["名称"] += " (副本)"
	_配置管理器.树状数据[新ID] = 新数据
	if 新数据["类型"] == "文件夹":
		var keys = _配置管理器.树状数据.keys()
		for k in keys:
			if _配置管理器.树状数据.has(k) and _配置管理器.树状数据[k].get("父节点") == 源ID:
				_递归深度克隆(k, 新ID)
	_配置管理器.保存预设()
	return 新ID

func _当前选中ID() -> String:
	if _获取当前选中ID回调.is_valid():
		return str(_获取当前选中ID回调.call())
	return ""

func _刷新树(记录折叠: bool):
	if _刷新树状菜单回调.is_valid():
		_刷新树状菜单回调.call(记录折叠)
