extends RefCounted
class_name 全局热键管理器

var _助手进程ID: int = -1
var _助手脚本路径: String = ""
var _助手日志路径: String = ""

func 获取日志路径() -> String:
	return _助手日志路径

func 重启助手(基础目录: String, 快捷键文本: String) -> bool:
	停止助手()
	if OS.get_name() != "Windows":
		return false
	_清理残留助手进程()
	if 快捷键文本.strip_edges() == "":
		return false
	if not _确保助手脚本(基础目录):
		return false
	if _助手日志路径 != "":
		var 日志文件 = FileAccess.open(_助手日志路径, FileAccess.WRITE)
		if 日志文件:
			日志文件.store_string("=== 全局热键助手启动 ===\n")
			日志文件.store_string("主进程ID=" + str(OS.get_process_id()) + "\n")
			日志文件.store_string("快捷键=" + 快捷键文本 + "\n")
			日志文件.close()
	var 参数: PackedStringArray = [
		"-NoProfile",
		"-Sta",
		"-ExecutionPolicy", "Bypass",
		"-WindowStyle", "Hidden",
		"-File", _助手脚本路径,
		"-TargetProcessId", str(OS.get_process_id()),
		"-Hotkey", 快捷键文本,
		"-LogPath", _助手日志路径
	]
	var 进程ID = OS.create_process("powershell.exe", 参数, false)
	if 进程ID > 0:
		_助手进程ID = 进程ID
		return true
	_助手进程ID = -1
	return false

func 停止助手():
	if _助手进程ID <= 0:
		return
	OS.kill(_助手进程ID)
	_助手进程ID = -1

func 助手是否在线() -> bool:
	if _助手进程ID <= 0:
		return false
	if OS.has_method("is_process_running") and not OS.is_process_running(_助手进程ID):
		_助手进程ID = -1
		return false
	return true

func _确保助手脚本(基础目录: String) -> bool:
	if 基础目录 == "":
		return false
	_助手脚本路径 = 基础目录.path_join("全局热键助手.ps1")
	_助手日志路径 = 基础目录.path_join("全局热键助手.log")
	var 脚本文本 = _获取助手脚本文本()
	if 脚本文本.strip_edges() == "":
		return false
	var 文件 = FileAccess.open(_助手脚本路径, FileAccess.WRITE)
	if 文件 == null:
		_助手脚本路径 = ""
		return false
	var 带BOM缓冲 = PackedByteArray([0xEF, 0xBB, 0xBF])
	带BOM缓冲.append_array(脚本文本.to_utf8_buffer())
	文件.store_buffer(带BOM缓冲)
	文件.close()
	return true

func _获取助手脚本文本() -> String:
	var 模板文件 = FileAccess.open("res://全局热键助手.ps1", FileAccess.READ)
	if 模板文件 == null:
		return ""
	var 文本 = 模板文件.get_as_text()
	模板文件.close()
	return 文本

func _清理残留助手进程():
	var 脚本名 = "全局热键助手.ps1"
	var 清理命令 = "Get-CimInstance Win32_Process | Where-Object { $_.Name -eq 'powershell.exe' -and $_.CommandLine -like '*" + 脚本名 + "*' } | ForEach-Object { try { Stop-Process -Id $_.ProcessId -Force -ErrorAction Stop } catch {} }"
	var 输出: Array = []
	OS.execute("powershell.exe", PackedStringArray([
		"-NoProfile",
		"-ExecutionPolicy", "Bypass",
		"-WindowStyle", "Hidden",
		"-Command", 清理命令
	]), 输出, true, false)
