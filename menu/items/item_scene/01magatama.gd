extends Item

func _ready():
	item_no = 1
	item_name = "造形神的勾玉"
	description = "咱偶尔会忘记画的勾玉项链。\n\n获得两段跳跃的能力"

func effect():
	Gamestate.state.can_double_jump = true
