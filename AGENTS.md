# Repository Guidelines

## 项目结构与模块组织
- 根目录核心脚本：`入口.gd`（主 UI 与交互逻辑）、`配置管理器.gd`（Autoload 配置与数据持久化）、`树辅助.gd`（树拖拽转发）。
- 主场景为 `主界面.tscn`，项目配置在 `project.godot`，导出配置在 `export_presets.cfg`。
- 数据文件：`presets.json`（默认预设库）、`settings.cfg`（界面与运行设置）。
- 资源文件集中在根目录（`icon.png`、`icon.svg` 等）；`.godot/` 为引擎生成目录，不手工维护。

## 构建、测试与开发命令
- 本项目使用 Godot 4.6，建议在仓库根目录执行：
- `godot4 --path .`：启动编辑器并运行当前项目。
- `godot4 --path . --headless --quit`：无界面快速校验项目是否可加载（适合 CI 基础检查）。
- `godot4 --path . --export-release "Windows Desktop" ShellQuicker.exe`：按 `export_presets.cfg` 导出 Windows 版本。
- 当前仓库未配置独立测试框架；提交前至少执行一次可启动性检查与关键流程手测。

## 代码风格与命名规范
- 全中文命名：类/节点/文件/函数/变量/信号/常量均使用中文；布尔变量使用“是否/能否/已”前缀。
- 缩进与 GDScript 默认风格保持一致（Tab 缩进）；避免无关格式化。
- UI 必须由代码创建，遵循左上角锚点工作流；不要改已有 `anchor_*`/`anchors_preset`，仅调整 `offset_*`。
- 保留现有中文注释与 `print()` 调试输出，除非关联逻辑一并移除。

## 测试指南
- 重点回归：树节点增删改查、拖拽层级、参数预览拼装、四种 shell 执行方式、UTF-8 模式、配置文件切换。
- 手测命名建议：`用例_模块_行为`，如 `用例_配置切换_保留上次选中`。
- 修改路径处理逻辑时，仅替换稳定路径文本，忽略 Godot 动态 uid。

## 提交与合并请求规范
- 历史提交同时存在中文短句与 Conventional Commits（如 `feat:`、`refactor:`）；建议统一为：`type: 简短中文说明`。
- 推荐 `type`：`feat`、`fix`、`refactor`、`docs`、`chore`。
- PR 需包含：变更目的、影响模块、手测清单、必要截图/录屏（涉及 UI 必附）、是否影响 `settings.cfg`/`*.json` 兼容性。

## 配置与安全提示
- 单实例端口为 `58123`；改动多开逻辑时需验证端口占用与异常退出恢复。
- 禁止提交本地临时数据或敏感路径；提交前检查 `settings.cfg` 与示例 JSON 是否含个人环境信息。
