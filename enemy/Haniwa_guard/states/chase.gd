extends FSM_state

func initialize():
	obj.anim_next = "move"

func run(_delta):
	var player_rela_pos = Game.player.global_position - obj.global_position
	var dir = sign(player_rela_pos.x)
	obj.dir_next = dir
	obj.velo.x = obj.MOVE_SPEED * 1.5  * obj.dir_cur

	if obj.check_wall():
		obj.velo.x = 0
		obj.anim_next = "idle"
	else:
		obj.anim_next = "move"

	if obj.can_player_be_attacked():
		fsm.state_next = fsm.states.attack
		return

	if not obj.is_player_detected:
		fsm.state_next = fsm.states.move


func terminate():
	obj.is_first_attack = false