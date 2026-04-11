extends RefCounted
class_name 命令执行管理器

var _宿主: Node = null
var _配置管理器 = null
var _参数容器: VBoxContainer = null
var _启动目录输入 = null
var _前缀命令输入 = null
var _核心命令输入 = null
var _预设面板: Control = null
var _执行目录预览 = null
var _预览标签 = null
var _Shell选择: OptionButton = null
var _UTF8模式: CheckBox = null
var _执行时复制开关: CheckBox = null

var _获取当前选中ID回调: Callable
var _计划保存当前预设回调: Callable
var _立即保存当前预设回调: Callable
var _清洗文本回调: Callable

func 初始化(宿主: Node, 配置管理器对象, 参数容器: VBoxContainer, 启动目录输入, 前缀命令输入, 核心命令输入, 预设面板: Control, 执行目录预览, 预览标签, Shell选择: OptionButton, UTF8模式: CheckBox, 执行时复制开关: CheckBox, 获取当前选中ID回调: Callable, 计划保存当前预设回调: Callable, 立即保存当前预设回调: Callable, 清洗文本回调: Callable):
	_宿主 = 宿主
	_配置管理器 = 配置管理器对象
	_参数容器 = 参数容器
	_启动目录输入 = 启动目录输入
	_前缀命令输入 = 前缀命令输入
	_核心命令输入 = 核心命令输入
	_预设面板 = 预设面板
	_执行目录预览 = 执行目录预览
	_预览标签 = 预览标签
	_Shell选择 = Shell选择
	_UTF8模式 = UTF8模式
	_执行时复制开关 = 执行时复制开关
	_获取当前选中ID回调 = 获取当前选中ID回调
	_计划保存当前预设回调 = 计划保存当前预设回调
	_立即保存当前预设回调 = 立即保存当前预设回调
	_清洗文本回调 = 清洗文本回调

func 获取真实执行目录() -> String:
	var 目录 = ""
	# 导出版下优先使用配置管理器初始化后的基础目录，避免 res:// 在打包环境中返回空字符串
	if _配置管理器 != null and _配置管理器.基础目录 != "":
		目录 = _配置管理器.基础目录
	else:
		目录 = ProjectSettings.globalize_path("res://")
		if 目录 == "":
			目录 = OS.get_executable_path().get_base_dir()
	目录 = 目录.replace("/", "\\")
	if 目录.ends_with("\\"):
		目录 = 目录.left(-1)
	return 目录

func 更新预览():
	var 目录 = 获取真实执行目录()
	var 目录_bb = "[color=#00d4ff]" + 目录 + "[/color]"
	var prefix_cmd = _前缀命令输入.text
	var base_cmd = _核心命令输入.text
	var final_bb = ""
	var 焦点 = null
	if is_instance_valid(_宿主):
		焦点 = _宿主.get_viewport().gui_get_focus_owner()
	# 前缀
	if prefix_cmd != "":
		var is_prefix_focused = (焦点 == _前缀命令输入)
		if is_prefix_focused:
			final_bb += "[color=#00ff88]" + prefix_cmd + "[/color]"
		else:
			final_bb += "[color=#aaaaaa]" + prefix_cmd + "[/color]"
	# 核心命令
	var is_core_focused = (焦点 == _核心命令输入)
	if is_core_focused:
		final_bb += "[color=#00ff88]" + base_cmd + "[/color]"
	else:
		final_bb += "[color=#ffffff]" + base_cmd + "[/color]"
	for 行 in _参数容器.get_children():
		if 行.is_queued_for_deletion():
			continue
		var 值 = 行.get_node("Value").text.strip_edges()
		var 显示文本 = 值 if 值 != "" else "[" + 行.get_node("Key").text + "]"
		var is_row_focused = (is_instance_valid(焦点) and 行.is_ancestor_of(焦点))
		final_bb += " "
		if is_row_focused:
			final_bb += "[color=#00ff88]" + 显示文本 + "[/color]"
		else:
			final_bb += "[color=#aaaaaa]" + 显示文本 + "[/color]"
	_执行目录预览.text = 目录_bb
	_预览标签.text = final_bb

func 核心命令已变更():
	if _计划保存当前预设回调.is_valid():
		_计划保存当前预设回调.call()
	更新预览()

func 执行器设置已变更(_值 = 0):
	if _计划保存当前预设回调.is_valid():
		_计划保存当前预设回调.call()
	更新预览()

func 复制完整命令():
	# 从富文本中提取纯文本
	DisplayServer.clipboard_set(_预览标签.get_parsed_text())
	_预览标签.select_all()

func 复制预览选中或完整命令():
	# 优先复制预览区选中文字（命令预览/执行目录），若无选中则回退到完整命令
	var 焦点 = null
	if is_instance_valid(_宿主):
		焦点 = _宿主.get_viewport().gui_get_focus_owner()
	var 目录选中 = _执行目录预览.get_selected_text()
	var 命令选中 = _预览标签.get_selected_text()
	if 焦点 == _执行目录预览 and 目录选中 != "":
		DisplayServer.clipboard_set(目录选中)
	elif 焦点 == _预览标签 and 命令选中 != "":
		DisplayServer.clipboard_set(命令选中)
	elif 目录选中 != "":
		DisplayServer.clipboard_set(目录选中)
	elif 命令选中 != "":
		DisplayServer.clipboard_set(命令选中)
	else:
		复制完整命令()

func 点击执行():
	if not _获取当前选中ID回调.is_valid():
		return
	var 当前选中ID = str(_获取当前选中ID回调.call())
	if 当前选中ID == "" or _预设面板.visible == false:
		return
	if _立即保存当前预设回调.is_valid():
		_立即保存当前预设回调.call()
	var 数据 = _配置管理器.树状数据[当前选中ID]
	var 启动目录 = _调用清洗文本(数据.get("启动目录", ""))
	var prefix = _调用清洗文本(数据.get("前缀命令", ""))
	var core_cmd = _调用清洗文本(数据.get("固定命令", ""))
	# 核心拼装
	var 完整命令 = core_cmd
	if prefix != "":
		完整命令 = prefix + core_cmd
	# 拼装参数
	for 行 in _参数容器.get_children():
		if 行.is_queued_for_deletion():
			continue
		var value = 行.get_node("Value").text.strip_edges()
		if value != "":
			完整命令 += " " + value
	# 自动复制
	if _执行时复制开关.button_pressed:
		DisplayServer.clipboard_set(完整命令)
	拉起窗口(_Shell选择.selected, 完整命令, 数据.get("UTF8模式", false), 启动目录)

func 拉起窗口(类型: int, 完整命令: String, 开启UTF8: bool = false, 启动目录: String = ""):
	var 命令 = 完整命令
	var 是PS = (类型 == 1 or 类型 == 3)
	var 工作目录 = 启动目录
	if 工作目录 == "":
		工作目录 = 获取真实执行目录()
	# --- 添加命令回显提示 ---
	var 显示目录 = 工作目录.replace("/", "\\")
	if 显示目录.ends_with("\\"):
		显示目录 = 显示目录.left(-1)
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
		var 提示2 = "cd /d \"" + 安全目录 + "\" & echo [ShellQuicker ^| CMD] & echo " + CMD显示目录 + "^>" + 安全串 + " & "
		命令 = 提示2 + 完整命令
	if 开启UTF8:
		if 是PS:
			命令 = "chcp 65001 > $null ; " + 命令
		else:
			命令 = "chcp 65001 > nul && " + 命令
	match 类型:
		0:
			OS.create_process("cmd", ["/c", "start", "cmd", "/k", 命令])
		1:
			OS.create_process("cmd", ["/c", "start", "powershell", "-noexit", "-command", 命令])
		2:
			# WT 需要对分号进行转义，否则会被误认为 WT 自身的分隔符
			var wt_cmd1 = 命令.replace(";", "\\;")
			OS.create_process("wt", ["-d", 工作目录, "cmd", "/k", wt_cmd1])
		3:
			var wt_cmd2 = 命令.replace(";", "\\;")
			OS.create_process("wt", ["-d", 工作目录, "powershell", "-noexit", "-command", wt_cmd2])

func 树上运行图标被点击(项: TreeItem):
	if not _获取当前选中ID回调.is_valid():
		return
	var node_id = 项.get_metadata(0)
	var 数据 = _配置管理器.树状数据.get(node_id)
	if 数据 and 数据["类型"] == "预设":
		var 当前选中ID = str(_获取当前选中ID回调.call())
		if node_id == 当前选中ID and _立即保存当前预设回调.is_valid():
			_立即保存当前预设回调.call()
		var 启动目录 = _调用清洗文本(数据.get("启动目录", ""))
		var prefix = _调用清洗文本(数据.get("前缀命令", ""))
		var core_cmd = 数据.get("固定命令", "")
		var 完整命令 = core_cmd
		if prefix != "":
			完整命令 = prefix + core_cmd
		for p in 数据.get("参数列表", []):
			var val = p.get("当前值", "").strip_edges()
			if val != "":
				完整命令 += " " + val
		if _执行时复制开关.button_pressed:
			DisplayServer.clipboard_set(完整命令)
		拉起窗口(数据.get("Shell类型", 0), 完整命令, 数据.get("UTF8模式", false), 启动目录)

func _调用清洗文本(文本: String) -> String:
	if _清洗文本回调.is_valid():
		return str(_清洗文本回调.call(文本))
	return 文本.strip_edges()
