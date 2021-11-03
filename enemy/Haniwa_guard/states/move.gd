extends FSM_state

func initialize():
	obj.anim_next = "move"

func run(_delta):
	if obj.check_wall():
		fsm.state_next = fsm.states.idle
	obj.velo.x = obj.MOVE_SPEED * obj.dir_cur