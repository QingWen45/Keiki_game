extends FSM_state

func initialize():
	obj.anim_next = "attack"

func run(_delta):
	var player_rela_pos = Game.player.global_position - obj.global_position
	var dir = sign(player_rela_pos.x)
	obj.dir_next = dir

	if not obj.is_player_detected and not obj.anim.is_playing():
		fsm.state_next = fsm.states.idle
		return
	elif obj.is_player_detected and not obj.anim.is_playing():
		obj.anim.play()
