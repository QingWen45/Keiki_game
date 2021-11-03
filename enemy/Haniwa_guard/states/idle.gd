extends FSM_state

var idle_timer

func initialize():
	idle_timer = 3.0
	obj.velo = Vector2.ZERO
	obj.anim_next = "idle"


func run(delta):
	if idle_timer > 0:
		idle_timer -= delta
	else:
		if fsm.state_last == fsm.states.move:
			obj.dir_next = -obj.dir_cur
		fsm.state_next = fsm.states.move
