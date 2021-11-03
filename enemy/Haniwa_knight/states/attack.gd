extends FSM_state

var ready_timer
var sound_timer
var sound_counter

func initialize():
	sound_timer = 1.0
	sound_counter = 0
	obj.velo = Vector2.ZERO
	ready_timer = 3.0
	obj.anim_next = "ready"

func run(_delta):
	var player_rela_pos = Game.player.global_position - obj.global_position
	var dir = sign(player_rela_pos.x)
	obj.dir_next = dir

	if sound_timer >= 0:
		sound_timer -= _delta

	if sound_counter < 3 and sound_timer < 0:
		sound_timer = 1.0
		sound_counter += 1
		obj.music1.play()

	if ready_timer > 0:
		ready_timer -= _delta
	else:
		fsm.state_next = fsm.states.charge

func terminate():
	pass
