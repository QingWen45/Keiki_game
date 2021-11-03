extends Item

func _ready():
	item_no = 2
	item_name = "白色的小花"
	description = "硅姬身上的一个小装饰，很可爱。\n\n现在获得擦弹的能力。"
	
func effect():
	Gamestate.state.can_graze = true