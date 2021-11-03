extends FSM_state

export (bool) var is_anim_end

func initialize():
	obj.anim_next = "attack"
	is_anim_end = false
 

func run(_delta):
	obj.velo = Vector2.ZERO

	if obj.can_move():
		if obj.is_on_floor():
			var dir = Input.get_action_strength("right") - Input.get_action_strength("left")
			if abs(dir):
				fsm.state_next = fsm.states.run
				return
	
			if not Input.is_action_pressed("down") and Input.is_action_just_pressed("jump"):
				obj.jump()
				fsm.state_next = fsm.states.jump
				return
	
		else:
			fsm.state_next = fsm.states.fall
	
	if obj.can_attack():
		if Input.is_action_just_pressed("attack"):
			obj.attack()
			obj.anim.stop(true)
			obj.anim.play()
			return

	if is_anim_end:
		fsm.state_next = fsm.states.idle
