# ShellQuicker 开发指南

## 项目结构

- **引擎**: Godot 4.6 (Forward Plus), `project.godot` 为项目配置
- **主场景**: `主界面.tscn`
- **入口脚本**: `入口.gd` (1000行，UI核心逻辑)
- **配置管理**: `配置管理器.gd` (Autoload 单例，uid: c5lcrcbkrkto7)
- **辅助脚本**: `树辅助.gd` (拖拽逻辑转发)

## 关键运行机制

### 单实例锁定
- 通过 TCP 端口 `58123` 实现 (`配置管理器.gd` 第36-43行)
- 可在 UI 底部勾选「允许多开」解除锁定

### 数据存储
- **全局设置**: `settings.cfg` (与 exe 同目录)
- **预设数据**: `presets.json` (默认) 或其他 `.json` 文件
- 配置管理器自动在 `基础目录` (exe 所在目录) 查找 JSON 文件

### 执行方式
支持 4 种 shell (`入口.gd` 第815-819行):
- `0`: CMD (原始终端) → `start cmd /k ...`
- `1`: PowerShell → `start powershell -noexit -command ...`
- `2`: Windows Terminal + CMD
- `3`: Windows Terminal + PowerShell

UTF-8 模式通过 `chcp 65001` 实现 (第809-813行)

## 重要快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+N` | 随时新建文件夹 |
| `Ctrl+A` | 新建模板 (非输入状态) |
| `Ctrl+D` | 克隆副本 |
| `Ctrl+B` | 在参数面板添加新行 |
| `Ctrl+G` | 合并预览区选中的参数 |
| `Ctrl+Enter` / `Shift+Enter` | 强制执行 |
| `F2` / 双击 | 重命名 |
| `Enter` | 执行当前选中项 |
| `Delete` | 删除 |

## 代码约定

- **全中文命名**: 类名、函数名、变量名、文件名均为中文
- **Autoload**: `配置管理器` 为全局单例，通过 `配置管理器.全局配置` / `配置管理器.树状数据` 访问
- **UI 构建**: 纯代码生成，无 UI 编辑器文件，主要在 `入口.gd` 的 `_ready()` 中通过 `Node.new()` 动态创建
- **样式注入**: `_注入通用样式()` 方法递归应用主题

## 开发注意事项

1. **修改 UI 锚点**: 禁止使用居中的 anchor presets，必须保留现有 `offset_left/top` 等偏移量
2. **信号连接**: 优先使用 `.connect()` 而非 lambda，避免内存泄漏
3. **中文注释**: 代码中已有大量中文注释，修改时保留
4. **调试输出**: 项目使用 `print()` 调试，可保留

## 运行与构建

- 直接用 Godot 4.6 打开项目目录即可运行
- 导出: `export_presets.cfg` 已配置 Windows 导出
- `.vscode/settings.json` 指定了 Godot 4.6.1.1 可执行文件路径