extends FSM_state

var dust_generate_gap

onready var timer = $Timer

func initialize():
	# create_step()
	timer.start(0.38)
	dust_generate_gap = 0.2
	obj.anim_next = "run"

func run(_delta):
	if Input.is_action_just_pressed("jump"):
		obj.jump()
		fsm.state_next = fsm.states.jump
		return

	dust_generate_gap -= _delta
	if dust_generate_gap <= 0:
		dust_generate_gap = 0.2
		obj.run_dust_generate()

	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")

	if abs(dir) > 0:
		dir = sign(dir)
		obj.velo = Vector2(obj.MAX_SPEED * dir, 0)
		obj.dir_next = dir
	else:
		fsm.state_next = fsm.states.idle
		return
	
	if not obj.is_on_floor():
		fsm.state_next = fsm.states.fall
		return

	if Input.is_action_just_pressed("attack") and obj.can_attack():
		obj.attack()
		fsm.state_next = fsm.states.attack
		return

func terminate():
	timer.stop()


func create_step():
	var pitch = rand_range(1, 1.2)
	obj.step_mp.pitch_scale = pitch
	obj.step_mp.play()

func _on_Timer_timeout():
	create_step()

