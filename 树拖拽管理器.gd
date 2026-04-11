extends RefCounted
class_name 树拖拽管理器

var _配置管理器 = null
var _树状菜单: Tree = null
var _树渲染搜索管理器 = null
var _获取当前选中ID回调: Callable
var _获取所有选中项回调: Callable
var _递归选中树项回调: Callable

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

func 初始化(配置管理器对象, 树状菜单: Tree, 树渲染搜索管理器对象, 获取当前选中ID回调: Callable, 获取所有选中项回调: Callable, 递归选中树项回调: Callable):
	_配置管理器 = 配置管理器对象
	_树状菜单 = 树状菜单
	_树渲染搜索管理器 = 树渲染搜索管理器对象
	_获取当前选中ID回调 = 获取当前选中ID回调
	_获取所有选中项回调 = 获取所有选中项回调
	_递归选中树项回调 = 递归选中树项回调

func 获取用于渲染的子节点(父ID: String) -> Array:
	if !_拖拽预览已启用:
		return _配置管理器.获取子节点(父ID)
	var 子节点列表: Array = []
	for 节点ID in _配置管理器.树状数据.keys():
		var 数据 = _配置管理器.树状数据.get(节点ID)
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

func get_drag_data_logic(_pos):
	var selected: Array = []
	if _获取所有选中项回调.is_valid():
		selected = _获取所有选中项回调.call()
	if selected.is_empty():
		return null
	var preview = Label.new()
	preview.text = " ?? 多选移动中(" + str(selected.size()) + ")" if selected.size() > 1 else " ?? " + selected[0].get_text(0)
	var 拖拽ID集: Array = []
	for 项 in selected:
		if !(项 is TreeItem):
			continue
		var 节点ID = str(项.get_metadata(0))
		if 节点ID != "":
			拖拽ID集.append(节点ID)
	_清理拖拽落点标识()
	_拖拽最后有效落点.clear()
	_拖拽最后签名 = ""
	_是否正在拖拽 = true
	_拖拽起始父ID = ""
	if !拖拽ID集.is_empty():
		_拖拽起始父ID = str(_配置管理器.树状数据.get(str(拖拽ID集[0]), {}).get("父节点", ""))
	_树状菜单.set_drag_preview(preview)
	return {"拖拽ID集": 拖拽ID集}

func can_drop_data_logic(鼠标位置, 拖拽数据):
	var 拖拽签名 = _生成拖拽签名(拖拽数据)
	var 落点信息 = _计算拖拽落点(鼠标位置, 拖拽数据)
	if 落点信息.get("是否有效", false):
		更新拖拽落点标识(落点信息)
		_拖拽最后有效落点 = 落点信息.duplicate(true)
		_拖拽最后签名 = 拖拽签名
		_应用拖拽实时预览(落点信息, 拖拽数据, 鼠标位置)
		return true
	if _拖拽最后签名 == 拖拽签名 and _拖拽最后有效落点.get("是否有效", false):
		更新拖拽落点标识(_拖拽最后有效落点)
		return true
	else:
		更新拖拽落点标识(落点信息)
		_拖拽最后有效落点.clear()
		_拖拽最后签名 = ""
		_清理拖拽实时预览()
	return false

func drop_data_logic(鼠标位置, 拖拽项):
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
		_刷新树(false)
		return
	var 新父ID = 落点信息.get("新父ID", "")
	var 插入索引 = _计算真实插入索引(新父ID, str(落点信息.get("目标ID", "")), int(落点信息.get("落点段", 0)), bool(落点信息.get("是否子级落点", false)))
	if 插入索引 < 0:
		_刷新树(false)
		return
	var 目标ID = 落点信息.get("目标ID", "")
	var 移动项ID集 = _提取可移动项ID集(拖拽项, 目标ID, 新父ID)
	if 移动项ID集.is_empty():
		return
	var 原父节点表: Dictionary = {}
	for 节点ID in 移动项ID集:
		原父节点表[节点ID] = str(_配置管理器.树状数据.get(节点ID, {}).get("父节点", ""))
	for 节点ID in 移动项ID集:
		_配置管理器.树状数据[节点ID]["父节点"] = 新父ID
	var 原兄弟们 = _配置管理器.获取子节点(新父ID)
	var 原兄弟ID序列: Array = []
	for b in 原兄弟们:
		原兄弟ID序列.append(b["ID"])
	var 新序列 = []
	for 兄弟ID in 原兄弟ID序列:
		if 兄弟ID not in 移动项ID集:
			新序列.append(兄弟ID)
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
	_配置管理器.更新排序(新序列)
	_刷新树(true)
	_树状菜单.grab_focus()
	if 移动项ID集.size() > 0 and _递归选中树项回调.is_valid():
		_递归选中树项回调.call(_树状菜单.get_root(), 移动项ID集[0])

func 初始化拖拽落点标识():
	if is_instance_valid(_拖拽上侧横线):
		return
	_拖拽上侧横线 = ColorRect.new()
	_拖拽上侧横线.name = "拖拽上侧横线"
	_拖拽上侧横线.color = Color(0.20, 0.82, 1.0, 0.95)
	_拖拽上侧横线.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_拖拽上侧横线.visible = false
	_树状菜单.add_child(_拖拽上侧横线)
	_拖拽下侧横线 = ColorRect.new()
	_拖拽下侧横线.name = "拖拽下侧横线"
	_拖拽下侧横线.color = Color(0.20, 0.82, 1.0, 0.95)
	_拖拽下侧横线.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_拖拽下侧横线.visible = false
	_树状菜单.add_child(_拖拽下侧横线)
	_拖拽子级高亮 = ColorRect.new()
	_拖拽子级高亮.name = "拖拽子级高亮"
	_拖拽子级高亮.color = Color(0.20, 0.82, 1.0, 0.18)
	_拖拽子级高亮.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_拖拽子级高亮.visible = false
	_树状菜单.add_child(_拖拽子级高亮)
	_拖拽占位块 = ColorRect.new()
	_拖拽占位块.name = "拖拽占位块"
	_拖拽占位块.color = Color(0.20, 0.82, 1.0, 0.14)
	_拖拽占位块.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_拖拽占位块.visible = false
	_树状菜单.add_child(_拖拽占位块)

func 更新拖拽落点标识(落点信息: Dictionary):
	if !is_instance_valid(_拖拽上侧横线):
		return
	_清理拖拽落点标识()
	if !落点信息.get("是否有效", false):
		return
	var 目标项 = 落点信息.get("目标项", null)
	if 目标项 == null:
		return
	var 落点段 = 落点信息.get("落点段", 0)
	var 是否子级落点 = 落点信息.get("是否子级落点", false)
	var 可视锚点项 = _获取拖拽可视锚点项(目标项, 落点段, 是否子级落点)
	if 可视锚点项 == null:
		return
	var 行区域 = _树状菜单.get_item_area_rect(可视锚点项, 0)
	if 行区域.size.y <= 0.0:
		return
	var 横线左侧 = 6.0
	var 横线宽度 = max(_树状菜单.size.x - 12.0, 4.0)
	var 横线厚度 = 2.0
	var 移动可视行数 = maxi(1, int(落点信息.get("移动可视行数", 1)))
	var 占位高度 = 行区域.size.y * 移动可视行数
	if 是否子级落点:
		_更新拖拽标识动画(_拖拽子级高亮, Vector2(2.0, 行区域.position.y), Vector2(max(_树状菜单.size.x - 4.0, 4.0), 行区域.size.y))
		_更新拖拽标识动画(_拖拽占位块, Vector2(2.0, 行区域.position.y + 行区域.size.y), Vector2(max(_树状菜单.size.x - 4.0, 4.0), 占位高度))
		_更新拖拽标识动画(_拖拽下侧横线, Vector2(横线左侧, 行区域.position.y + 行区域.size.y - 横线厚度), Vector2(横线宽度, 横线厚度))
		return
	if 落点段 <= 0:
		_更新拖拽标识动画(_拖拽上侧横线, Vector2(横线左侧, 行区域.position.y), Vector2(横线宽度, 横线厚度))
		_更新拖拽标识动画(_拖拽占位块, Vector2(2.0, 行区域.position.y), Vector2(max(_树状菜单.size.x - 4.0, 4.0), 占位高度))
	else:
		_更新拖拽标识动画(_拖拽下侧横线, Vector2(横线左侧, 行区域.position.y + 行区域.size.y - 横线厚度), Vector2(横线宽度, 横线厚度))
		_更新拖拽标识动画(_拖拽占位块, Vector2(2.0, 行区域.position.y + 行区域.size.y), Vector2(max(_树状菜单.size.x - 4.0, 4.0), 占位高度))

func 拖拽结束清理标识():
	_是否正在拖拽 = false
	_拖拽起始父ID = ""
	_清理拖拽落点标识()
	_清理拖拽实时预览()
	_拖拽最后有效落点.clear()
	_拖拽最后签名 = ""

func _获取拖拽可视锚点项(目标项: TreeItem, 落点段: int, 是否子级落点: bool) -> TreeItem:
	if 是否子级落点 or 落点段 <= 0:
		return 目标项
	var 目标ID = str(目标项.get_metadata(0))
	var 目标数据 = _配置管理器.树状数据.get(目标ID)
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
		if !_配置管理器.树状数据.has(节点ID): continue
		if _配置管理器.树状数据[节点ID]["类型"] == "文件夹" and _检查是否为子孙(节点ID, 新父ID): continue
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
	var 行区域 = _树状菜单.get_item_area_rect(目标项, 0)
	if 行区域.size.y <= 0.0:
		return 0
	var 相对Y = clampf(鼠标位置.y - 行区域.position.y, 0.0, 行区域.size.y)
	var 比例 = 相对Y / 行区域.size.y
	if 是否目标文件夹:
		if 比例 < 0.40: return -1
		if 比例 > 0.60: return 1
		return 0
	return -1 if 比例 < 0.5 else 1

func _获取树最后可见项() -> TreeItem:
	var 根项 = _树状菜单.get_root()
	if 根项 == null: return null
	var 当前项 = 根项.get_first_child()
	if 当前项 == null: return null
	var 最后可见项: TreeItem = null
	while 当前项:
		if 当前项.visible:
			最后可见项 = 当前项
		当前项 = 当前项.get_next()
	if 最后可见项 == null: return null
	return _获取最后可见子孙项(最后可见项)

func _是否命中树底末尾区(鼠标位置, 最后可见项: TreeItem) -> bool:
	if 最后可见项 == null: return false
	var 最后行区域 = _树状菜单.get_item_area_rect(最后可见项, 0)
	if 最后行区域.size.y <= 0.0: return false
	return 鼠标位置.y >= (最后行区域.position.y + 最后行区域.size.y - 1.0)

func _是否命中树底热区(鼠标位置) -> bool:
	var 热区高度 = 44.0
	var 树高度 = maxf(_树状菜单.size.y, 0.0)
	if 树高度 <= 0.0: return false
	return 鼠标位置.y >= (树高度 - 热区高度)

func _构建树底末尾同级落点(最后可见项: TreeItem, 拖拽数据) -> Dictionary:
	var 默认结果 = {"是否有效": false, "目标项": null, "目标ID": "", "新父ID": "", "插入索引": -1, "落点段": 0, "是否子级落点": false}
	if 最后可见项 == null: return 默认结果
	var 末尾目标ID = str(最后可见项.get_metadata(0))
	var 末尾目标数据 = _配置管理器.树状数据.get(末尾目标ID, {})
	if 末尾目标ID == "" or 末尾目标数据.is_empty(): return 默认结果
	var 末尾新父ID = str(末尾目标数据.get("父节点", ""))
	var 末尾插入索引 = _计算真实插入索引(末尾新父ID, 末尾目标ID, 1, false)
	var 末尾可移动项ID集 = _提取可移动项ID集(拖拽数据, 末尾目标ID, 末尾新父ID)
	if 末尾可移动项ID集.is_empty() or 末尾插入索引 < 0: return 默认结果
	return {"是否有效": true, "目标项": 最后可见项, "目标ID": 末尾目标ID, "新父ID": 末尾新父ID, "插入索引": 末尾插入索引, "落点段": 1, "是否子级落点": false, "移动可视行数": _统计拖拽可视行数(拖拽数据)}

func _构建指定父级末尾同级落点(目标父ID: String, 拖拽数据) -> Dictionary:
	var 默认结果 = {"是否有效": false, "目标项": null, "目标ID": "", "新父ID": "", "插入索引": -1, "落点段": 0, "是否子级落点": false}
	var 目标父标识 = str(目标父ID)
	if 目标父标识 == "": return 默认结果
	var 同级列表 = _配置管理器.获取子节点(目标父标识)
	if 同级列表.is_empty(): return 默认结果
	var 末尾目标ID = str(同级列表[同级列表.size() - 1].get("ID", ""))
	if 末尾目标ID == "": return 默认结果
	var 末尾目标项 = _根据ID寻找树项(_树状菜单.get_root(), 末尾目标ID)
	if 末尾目标项 == null: return 默认结果
	var 末尾插入索引 = _计算真实插入索引(目标父标识, 末尾目标ID, 1, false)
	var 可移动项ID集 = _提取可移动项ID集(拖拽数据, 末尾目标ID, 目标父标识)
	if 可移动项ID集.is_empty() or 末尾插入索引 < 0: return 默认结果
	return {"是否有效": true, "目标项": 末尾目标项, "目标ID": 末尾目标ID, "新父ID": 目标父标识, "插入索引": 末尾插入索引, "落点段": 1, "是否子级落点": false, "移动可视行数": _统计拖拽可视行数(拖拽数据)}

func _计算拖拽落点(鼠标位置, 拖拽数据) -> Dictionary:
	var 默认结果 = {"是否有效": false, "目标项": null, "目标ID": "", "新父ID": "", "插入索引": -1, "落点段": 0, "是否子级落点": false}
	var 拖拽ID集 = _提取拖拽ID集(拖拽数据)
	if 拖拽ID集.is_empty(): return 默认结果
	var 最后可见项 = _获取树最后可见项()
	if _是否命中树底热区(鼠标位置) or _是否命中树底末尾区(鼠标位置, 最后可见项):
		var 起始父级末尾落点 = _构建指定父级末尾同级落点(_拖拽起始父ID, 拖拽数据)
		if 起始父级末尾落点.get("是否有效", false): return 起始父级末尾落点
		return _构建树底末尾同级落点(最后可见项, 拖拽数据)
	var 目标项 = _树状菜单.get_item_at_position(鼠标位置)
	if !目标项: return 默认结果
	var 目标ID = str(目标项.get_metadata(0))
	if 目标ID == "": return 默认结果
	var 目标数据 = _配置管理器.树状数据.get(目标ID)
	if !目标数据: return 默认结果
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
	if 可移动项ID集.is_empty(): return 默认结果
	return {"是否有效": 插入索引 >= 0, "目标项": 目标项, "目标ID": 目标ID, "新父ID": 新父ID, "插入索引": 插入索引, "落点段": 落点段, "是否子级落点": 是否子级落点, "移动可视行数": _统计拖拽可视行数(拖拽数据)}

func _计算真实插入索引(新父ID: String, 目标ID: String, 落点段: int, 是否子级落点: bool) -> int:
	if 是否子级落点:
		return 0
	var 兄弟们 = _配置管理器.获取子节点(新父ID)
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
		原父节点表[节点ID] = str(_配置管理器.树状数据.get(节点ID, {}).get("父节点", ""))
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
		var 原兄弟们 = _配置管理器.获取子节点(str(父ID))
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
	_刷新树(false)
	_清理拖拽落点标识()
	var 新落点信息 = _计算拖拽落点(鼠标位置, 拖拽数据)
	更新拖拽落点标识(新落点信息)

func _清理拖拽实时预览(是否刷新树: bool = true):
	if !_拖拽预览已启用: return
	_拖拽预览已启用 = false
	_拖拽预览签名 = ""
	_拖拽预览父节点覆盖.clear()
	_拖拽预览排序覆盖.clear()
	if 是否刷新树:
		_刷新树(false)

func _统计拖拽可视行数(拖拽数据) -> int:
	var 拖拽ID集 = _提取拖拽ID集(拖拽数据)
	if 拖拽ID集.is_empty(): return 1
	var 根项列表: Array = []
	var 选中ID表: Dictionary = {}
	for 节点ID in 拖拽ID集:
		选中ID表[节点ID] = true
	for 节点ID in 拖拽ID集:
		var 项 = _根据ID寻找树项(_树状菜单.get_root(), 节点ID)
		if 项 == null: continue
		if _树项祖先是否已选中(项, 选中ID表): continue
		根项列表.append(项)
	var 合计 = 0
	for 根项 in 根项列表:
		合计 += _统计可视子树行数(根项)
	return maxi(合计, 1)

func _根据ID寻找树项(当前项: TreeItem, 目标ID: String) -> TreeItem:
	if 当前项 == null: return null
	if str(当前项.get_metadata(0)) == 目标ID: return 当前项
	var 子项 = 当前项.get_first_child()
	while 子项:
		var 命中项 = _根据ID寻找树项(子项, 目标ID)
		if 命中项: return 命中项
		子项 = 子项.get_next()
	return null

func _树项祖先是否已选中(项: TreeItem, 选中ID表: Dictionary) -> bool:
	var 父项 = 项.get_parent()
	while 父项:
		var 父ID = str(父项.get_metadata(0))
		if 父ID != "" and 选中ID表.has(父ID): return true
		父项 = 父项.get_parent()
	return false

func _统计可视子树行数(根项: TreeItem) -> int:
	if 根项 == null or !根项.visible: return 0
	var 合计 = 1
	if 根项.is_collapsed(): return 合计
	var 子项 = 根项.get_first_child()
	while 子项:
		合计 += _统计可视子树行数(子项)
		子项 = 子项.get_next()
	return 合计

func _检查是否为子孙(祖先ID: String, 目标ID: String) -> bool:
	if 目标ID == "": return false
	if 祖先ID == 目标ID: return true
	var cur = 目标ID
	while cur != "":
		var d = _配置管理器.树状数据.get(cur)
		if !d: break
		var p = d.get("父节点", "")
		if p == 祖先ID: return true
		cur = p
	return false

func _刷新树(记录折叠: bool):
	if _树渲染搜索管理器 == null:
		return
	var 当前选中ID = ""
	if _获取当前选中ID回调.is_valid():
		当前选中ID = str(_获取当前选中ID回调.call())
	_树渲染搜索管理器.刷新树状菜单(当前选中ID, 记录折叠)
