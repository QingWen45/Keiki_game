extends FSM_state

var idle_timer

func initialize():
	if obj.SCOUT:
		obj.dir_next = obj.SCOUT
	idle_timer = 3.0
	obj.anim_next = "idle"


func run(delta):
	if idle_timer > 0:
		idle_timer -= delta
	else:
		idle_timer = 3.0
		if obj.SCOUT:
			obj.dir_next = obj.SCOUT
		else:
			obj.dir_next = -obj.dir_cur
