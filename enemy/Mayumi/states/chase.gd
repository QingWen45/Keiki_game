extends FSM_state

var chase_timer: float

func initialize():
	chase_timer = 5.0
	obj.anim_next = "run"

func run(delta):
	var player_pos = obj.get_player_pos()
	var dir = sign(player_pos.x)
	obj.dir_next = dir
	obj.velo.x = obj.MOVE_SPEED * 1.5 * obj.dir_cur

	if chase_timer > 0:
		chase_timer -= delta
	else:
		fsm.state_next = fsm.states.attack2

	if abs(player_pos.x) < 100 and abs(player_pos.y) < 60:
		fsm.state_next = fsm.states.attack1
