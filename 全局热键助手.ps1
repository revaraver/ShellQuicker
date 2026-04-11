
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
