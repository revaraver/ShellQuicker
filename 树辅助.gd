extends Tree

# 树辅助脚本，用于处理拖拽逻辑并转发给主入口
var 入口 = null

func _get_drag_data(at_position):
	if 入口: return 入口._get_drag_data_logic(at_position)
	return null

func _can_drop_data(at_position, data):
	if 入口: return 入口._can_drop_data_logic(at_position, data)
	return false

func _drop_data(at_position, data):
	if 入口: 入口._drop_data_logic(at_position, data)
