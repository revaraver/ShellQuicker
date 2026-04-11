extends Node

# 配置管理器 Pro++ (配置隔离与多配置管理版)
# 核心功能：settings.cfg 存储全局设置，*.json 存储具体内容

var 树状数据: Dictionary = {}
var 全局配置: Dictionary = {
	"上次选中ID": "",
	"字体大小": 20,
	"搜文件夹备注": true,
	"搜模板备注": true,
	"搜夹连带子项": true,
	"搜索保留": "",
	"当前配置文件": "presets",
	"split_offset": 350,
	"允许多开": false,
	"最小化唤出快捷键": "Ctrl+Shift+D",
	"执行时复制": false,
	"已折叠ID": []
}

var 配置文件别名: String = "presets"
var 基础目录: String = ""
var 全局配置路径: String = ""
var 当前数据路径: String = ""
var _单实例服务器: TCPServer

func _ready():
	if OS.has_feature("editor"):
		基础目录 = ProjectSettings.globalize_path("res://")
	else:
		基础目录 = OS.get_executable_path().get_base_dir()
	
	全局配置路径 = 基础目录.path_join("settings.cfg")
	加载全局配置()
	
	_单实例锁定初始化()
	
	配置文件别名 = 全局配置.get("当前配置文件", "presets")
	当前数据路径 = 基础目录.path_join(配置文件别名 + ".json")
	
	加载预设()
	if 树状数据.is_empty(): 初始化默认数据()

func _单实例锁定初始化():
	if 全局配置.get("允许多开", false): return
	
	_单实例服务器 = TCPServer.new()
	if _单实例服务器.listen(58123) != OK:
		OS.alert("ShellQuicker 已经在运行中！关闭多开许可时无法运行多个实例。", "多开限制")
		get_tree().quit()
		return

# --- 全局设置管理 (ConfigFile) ---

func 加载全局配置(指定别名: String = ""):
	var config = ConfigFile.new()
	if config.load(全局配置路径) == OK:
		# 1. 加载全局通用设置
		for key in ["当前配置文件", "字体大小", "允许多开", "split_offset", "最小化唤出快捷键"]:
			if 全局配置.has(key):
				全局配置[key] = config.get_value("Settings", key, 全局配置[key])
		
		# 如果手动指定了别名（用于切换时），则以指定的为准
		var 目标别名 = 指定别名 if 指定别名 != "" else 全局配置["当前配置文件"]
		
		# 2. 根据目标别名加载专属 Profile 设置
		var section = "Profile_" + 目标别名
		for key in ["上次选中ID", "搜文件夹备注", "搜模板备注", "搜夹连带子项", "搜索保留", "执行时复制"]:
			if 全局配置.has(key):
				全局配置[key] = config.get_value(section, key, 全局配置[key])
		
		# 加载折叠状态
		全局配置["已折叠ID"] = config.get_value(section, "已折叠ID", [])
	else:
		保存全局配置()

func 保存全局配置():
	var config = ConfigFile.new()
	config.load(全局配置路径) # 必须先 load 以保留其他 Profile 的数据
	
	# 1. 写入全局通用 (确保当前配置文件名被写入)
	for key in ["当前配置文件", "字体大小", "允许多开", "split_offset", "最小化唤出快捷键"]:
		config.set_value("Settings", key, 全局配置[key])
	
	# 2. 写入当前 Profile 专属
	var section = "Profile_" + 配置文件别名
	for key in ["上次选中ID", "搜文件夹备注", "搜模板备注", "搜夹连带子项", "搜索保留", "执行时复制"]:
		config.set_value(section, key, 全局配置[key])
	
	config.set_value(section, "已折叠ID", 全局配置.get("已折叠ID", []))
	
	config.save(全局配置路径)

# --- 数据预设管理 (JSON) ---

func 加载预设():
	if not FileAccess.file_exists(当前数据路径):
		树状数据 = {}
		return
	var 文件 = FileAccess.open(当前数据路径, FileAccess.READ)
	var json = JSON.new()
	if json.parse(文件.get_as_text()) == OK:
		var 全部数据 = json.data
		if 全部数据 is Dictionary:
			# 兼容旧版本：如果是旧带 _config 的文件，直接抹掉
			if 全部数据.has("_config"): 全部数据.erase("_config")
			# 核心补全逻辑
			for 键 in 全部数据:
				var 项 = 全部数据[键]
				if not 项 is Dictionary: continue
				if !项.has("父节点"): 项["父节点"] = ""
				if !项.has("类型"): 项["类型"] = "预设"
				if !项.has("名称"): 项["名称"] = 键
				if !项.has("order"): 项["order"] = 0
				if 项.get("类型", "预设") == "预设" and !项.has("启动目录"): 项["启动目录"] = ""
			树状数据 = 全部数据
		else:
			树状数据 = {}
	文件.close()

func 保存预设():
	var 文件 = FileAccess.open(当前数据路径, FileAccess.WRITE)
	文件.store_string(JSON.stringify(树状数据, "\t"))
	文件.close()

func 初始化默认数据():
	树状数据 = {
		"f_root": {"类型": "文件夹", "名称": "我的工具", "父节点": "", "描述": "存放我的常用命令", "order": 0},
		"p_sample": {
			"类型": "预设",
			"名称": "查看当前目录 (示例)",
			"父节点": "f_root",
			"启动目录": "",
			"固定命令": "dir",
			"描述": "这是一个示例命令，点击上方运行图标或按回车执行",
			"order": 0,
			"Shell类型": 0,
			"UTF8模式": false,
			"参数列表": []
		}
	}
	保存预设()

# --- 多配置文件维护逻辑 ---

func 获取配置文件列表() -> Array:
	var list = []
	var dir = DirAccess.open(基础目录)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".json"):
				list.append(file_name.get_basename())
			file_name = dir.get_next()
	return list

func 切换配置文件(别名: String):
	if 别名 == 配置文件别名: return
	
	# 1. 切换前，保存当前旧 Profile 的完整状态到它自己的 Section
	保存全局配置()
	
	# 2. 正式切换指向
	var 旧别名 = 配置文件别名
	配置文件别名 = 别名
	当前数据路径 = 基础目录.path_join(别名 + ".json")
	全局配置["当前配置文件"] = 别名
	
	# 3. 核心修复：仅手术级更新 [Settings] 段中的当前文件名，绝对不要调用 保存全局配置()
	# 否则会把旧内存里的状态刷进新 Section 导致覆盖。
	var config = ConfigFile.new()
	config.load(全局配置路径)
	config.set_value("Settings", "当前配置文件", 别名)
	config.save(全局配置路径)
	
	# 4. 立即加载目标 Profile 的专属设置到内存
	加载全局配置(别名)
	
	# 5. 加载新业务数据
	加载预设()
	if 树状数据.is_empty(): 初始化默认数据()

func 新建配置文件(别名: String):
	var target = 基础目录.path_join(别名 + ".json")
	if FileAccess.file_exists(target): return false
	
	当前数据路径 = target
	初始化默认数据()
	切换配置文件(别名)
	return true

func 重命名当前配置(新别名: String):
	if 新别名 == 配置文件别名 or 新别名 == "": return false
	var new_path = 基础目录.path_join(新别名 + ".json")
	if FileAccess.file_exists(new_path): return false
	
	var dir = DirAccess.open(基础目录)
	dir.rename(当前数据路径, new_path)
	
	配置文件别名 = 新别名
	当前数据路径 = new_path
	全局配置["当前配置文件"] = 新别名
	保存全局配置()
	return true

func 删除当前配置():
	if 获取配置文件列表().size() <= 1: return # 至少保留一个
	var dir = DirAccess.open(基础目录)
	dir.remove(当前数据路径)
	
	var list = 获取配置文件列表()
	切换配置文件(list[0])

# --- 节点操作 (透传) ---

func 添加节点(ID: String, 数据:Dictionary):
	树状数据[ID] = 数据; 保存预设()

func 删除节点(ID: String):
	var 待删除 = [ID]; var 已检查 = 0
	while 已检查 < 待删除.size():
		var 当前ID = 待删除[已检查]
		for 键 in 树状数据:
			if 树状数据[键].get("父节点") == 当前ID: 待删除.append(键)
		已检查 += 1
	for d in 待删除: 树状数据.erase(d)
	保存预设()

func 获取子节点(父ID:String) -> Array:
	var 结果 = []
	for 键 in 树状数据:
		if 树状数据[键].get("父节点") == 父ID:
			var 项 = 树状数据[键].duplicate(); 项["ID"] = 键; 结果.append(项)
	结果.sort_custom(func(a, b): return a.get("order", 0) < b.get("order", 0))
	return 结果

func 更新排序(ID_列表: Array):
	for i in range(ID_列表.size()):
		var id = ID_列表[i]
		if 树状数据.has(id): 树状数据[id]["order"] = i
	保存预设()

func 重命名节点(ID: String, 新名称:String):
	if 树状数据.has(ID): 树状数据[ID]["名称"] = 新名称; 保存预设()
