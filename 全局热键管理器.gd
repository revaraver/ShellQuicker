extends RefCounted
class_name 全局热键管理器

const 内置助手脚本文本 := """
param(
  [Parameter(Mandatory = $true)][int]$TargetProcessId,
  [string]$Hotkey = 'Ctrl+Shift+D',
  [string]$LogPath = ''
)
function Write-Log([string]$message) {
  if ([string]::IsNullOrWhiteSpace($LogPath)) { return }
  try {
    $time = [DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss.fff')
    Add-Content -LiteralPath $LogPath -Value "$time $message" -Encoding UTF8
  } catch {}
}
try {
  Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
} catch {
  Write-Log "程序集加载失败(System.Windows.Forms): $($_.Exception.Message)"
  exit 4
}
$interopCode = @'
using System;
using System.IO;
using System.Windows.Forms;
using System.Runtime.InteropServices;
public class HotkeyInteropWindow : Form {
  [StructLayout(LayoutKind.Sequential)]
  public struct Msg {
    public IntPtr hwnd;
    public uint message;
    public IntPtr wParam;
    public IntPtr lParam;
    public uint time;
    public int pt_x;
    public int pt_y;
  }
  public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
  [DllImport("user32.dll", SetLastError=true)]
  public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);
  [DllImport("user32.dll", SetLastError=true)]
  public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
  [DllImport("user32.dll")]
  public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
  [DllImport("user32.dll")]
  public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")]
  public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")]
  public static extern bool IsIconic(IntPtr hWnd);
  [DllImport("user32.dll")]
  public static extern bool IsWindowVisible(IntPtr hWnd);
  [DllImport("user32.dll")]
  public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
  [DllImport("user32.dll")]
  public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
  public static IntPtr FindProcessWindow(int processId) {
    IntPtr result = IntPtr.Zero;
    EnumWindows(delegate (IntPtr hWnd, IntPtr lParam) {
      uint pid;
      GetWindowThreadProcessId(hWnd, out pid);
      if (pid == (uint)processId && (IsWindowVisible(hWnd) || IsIconic(hWnd))) {
        result = hWnd;
        return false;
      }
      return true;
    }, IntPtr.Zero);
    return result;
  }
  public bool Registered = false;
  private int _targetProcessId;
  private uint _mods;
  private uint _vk;
  private string _logPath;
  private Timer _timer;
  public HotkeyInteropWindow(int targetProcessId, uint mods, uint vk, string logPath) {
    _targetProcessId = targetProcessId;
    _mods = mods;
    _vk = vk;
    _logPath = logPath ?? "";
    ShowInTaskbar = false;
    FormBorderStyle = FormBorderStyle.None;
    WindowState = FormWindowState.Minimized;
    Opacity = 0;
    Width = 0;
    Height = 0;
    _timer = new Timer();
    _timer.Interval = 250;
    _timer.Tick += (s, e) => {
      try {
        var p = System.Diagnostics.Process.GetProcessById(_targetProcessId);
      } catch {
        WriteLog("目标进程已退出");
        _timer.Stop();
        Close();
      }
    };
  }
  protected override void OnHandleCreated(EventArgs e) {
    base.OnHandleCreated(e);
    Registered = RegisterHotKey(this.Handle, 1, _mods, _vk);
    if (!Registered) {
      WriteLog("RegisterHotKey失败 LastError=" + Marshal.GetLastWin32Error());
      return;
    }
    WriteLog("RegisterHotKey成功 modifiers=" + _mods + " key=" + _vk);
    _timer.Start();
  }
  protected override void OnFormClosed(FormClosedEventArgs e) {
    if (Registered) {
      UnregisterHotKey(this.Handle, 1);
      WriteLog("注销热键并退出");
    }
    base.OnFormClosed(e);
  }
  protected override void WndProc(ref Message m) {
    const int WM_HOTKEY = 0x0312;
    if (m.Msg == WM_HOTKEY) {
      WriteLog("收到WM_HOTKEY");
      var hwnd = FindProcessWindow(_targetProcessId);
      if (hwnd == IntPtr.Zero) {
        WriteLog("未找到目标窗口句柄");
      } else if (IsIconic(hwnd)) {
        ShowWindowAsync(hwnd, 9);
        SetForegroundWindow(hwnd);
        WriteLog("执行恢复窗口 SW_RESTORE");
      } else if (GetForegroundWindow() != hwnd) {
        ShowWindowAsync(hwnd, 9);
        SetForegroundWindow(hwnd);
        WriteLog("执行激活窗口 SET_FOREGROUND");
      } else {
        ShowWindowAsync(hwnd, 6);
        WriteLog("执行最小化窗口 SW_MINIMIZE");
      }
    }
    base.WndProc(ref m);
  }
  private void WriteLog(string message) {
    if (string.IsNullOrWhiteSpace(_logPath)) return;
    try {
      File.AppendAllText(_logPath, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") + " " + message + Environment.NewLine);
    } catch {}
  }
}
'@
try {
  Add-Type -TypeDefinition $interopCode -Language CSharp -ReferencedAssemblies @("System.Windows.Forms", "System.Drawing") -ErrorAction Stop | Out-Null
  Write-Log "互操作类型编译成功"
} catch {
  Write-Log "互操作类型编译失败: $($_.Exception.Message)"
  exit 5
}
function Parse-Hotkey([string]$text) {
  $mods = 0
  $vk = 0
  foreach ($part in $text.Split('+')) {
    $token = $part.Trim().ToLower()
    switch ($token) {
      'alt' { $mods = $mods -bor 0x0001; continue }
      'ctrl' { $mods = $mods -bor 0x0002; continue }
      'control' { $mods = $mods -bor 0x0002; continue }
      'shift' { $mods = $mods -bor 0x0004; continue }
      'meta' { $mods = $mods -bor 0x0008; continue }
      'win' { $mods = $mods -bor 0x0008; continue }
      'cmd' { $mods = $mods -bor 0x0008; continue }
      default {
        try {
          $vk = [int][System.Enum]::Parse([System.Windows.Forms.Keys], $part.Trim(), $true)
        } catch {
          $vk = 0
        }
      }
    }
  }
  if ($vk -eq 0) { $vk = [int][System.Windows.Forms.Keys]::D }
  return @([uint32]$mods, [uint32]$vk)
}
Write-Log "助手启动 TargetProcessId=$TargetProcessId Hotkey=$Hotkey"
$parsed = Parse-Hotkey $Hotkey
Write-Log "热键解析 modifiers=$($parsed[0]) key=$($parsed[1])"
try {
  [System.Windows.Forms.Application]::EnableVisualStyles()
  $window = New-Object HotkeyInteropWindow($TargetProcessId, [uint32]$parsed[0], [uint32]$parsed[1], $LogPath)
  $window.Show()
  $null = $window.Handle
  Write-Log "助手窗口句柄已创建 Handle=$($window.Handle)"
  for ($i = 0; $i -lt 20 -and -not $window.Registered; $i++) {
    [System.Windows.Forms.Application]::DoEvents()
    Start-Sleep -Milliseconds 50
  }
  if (-not $window.Registered) {
    Write-Log "热键注册失败，助手退出"
    exit 2
  }
  Write-Log "助手进入消息循环"
  [System.Windows.Forms.Application]::Run($window)
} catch {
  Write-Log "助手异常: $($_.Exception.Message)"
  exit 3
}
"""

var _助手进程ID: int = -1
var _助手脚本路径: String = ""
var _助手日志路径: String = ""

func 获取日志路径() -> String:
	return _助手日志路径

func 重启助手(基础目录: String, 快捷键文本: String, 是否写日志: bool = true) -> bool:
	停止助手()
	if OS.get_name() != "Windows":
		return false
	_清理残留助手进程()
	if 快捷键文本.strip_edges() == "":
		return false
	if not _确保助手脚本(基础目录, 是否写日志, 快捷键文本):
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
		"-Hotkey", 快捷键文本
	]
	if _助手日志路径 != "":
		参数.append("-LogPath")
		参数.append(_助手日志路径)
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

func _确保助手脚本(基础目录: String, 是否写日志: bool, 快捷键文本: String) -> bool:
	if 基础目录 == "":
		return false
	_助手脚本路径 = 基础目录.path_join("全局热键助手.ps1")
	_助手日志路径 = 基础目录.path_join("全局热键助手.log") if 是否写日志 else ""
	var 脚本文本 = _构建带注释助手脚本(快捷键文本)
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

func _构建带注释助手脚本(快捷键文本: String) -> String:
	var 原始脚本文本 = _获取助手脚本文本()
	if 原始脚本文本.strip_edges() == "":
		return ""
	原始脚本文本 = _移除旧注释头(原始脚本文本)
	var 注释头 = "# ShellQuicker 全局热键助手脚本：用于让软件支持全局最小化/唤出（当前快捷键：" + 快捷键文本 + "）\n"
	return 注释头 + 原始脚本文本

func _移除旧注释头(脚本文本: String) -> String:
	var 行列表 = 脚本文本.split("\n", false)
	while 行列表.size() > 0:
		var 首行 = String(行列表[0]).strip_edges()
		if 首行.begins_with("# ShellQuicker 全局热键助手脚本："):
			行列表.remove_at(0)
			continue
		break
	return "\n".join(行列表)

func _获取助手脚本文本() -> String:
	var 模板文件 = FileAccess.open("res://全局热键助手.ps1", FileAccess.READ)
	if 模板文件 != null:
		var 文本 = 模板文件.get_as_text()
		模板文件.close()
		if 文本.strip_edges() != "":
			return 文本
	return 内置助手脚本文本

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
