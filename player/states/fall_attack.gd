extends FSM_state


export (bool) var is_anim_end

func initialize():
	obj.anim_next = "fall_attack"
	is_anim_end = false
 

func run(delta):
	obj.velo.y = min(obj.MAX_FALL_SPEED * 0.8, obj.velo.y + obj.GRAVITY * delta)
	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")

	if obj.can_move():
		if abs(dir):
			fsm.state_next = fsm.states.fall
		else:
			obj.velo.x = lerp(obj.velo.x, 0, obj.AIR_ACCEL * 0.8)

		if obj.is_on_floor():
			if not Input.is_action_pressed("down") and Input.is_action_just_pressed("jump"):
				obj.jump()
				fsm.state_next = fsm.states.jump
				return

			if abs(dir):
				fsm.state_next = fsm.states.run
				return
			
			else:
				fsm.state_next = fsm.states.idle
				return
	else:
		obj.velo.x = lerp(obj.velo.x, 0, obj.AIR_ACCEL * 0.2)
	
	if obj.can_attack():
		if Input.is_action_just_pressed("attack"):
			obj.attack()
			obj.anim.stop(true)
			obj.anim.play()
			return

	if obj.is_on_floor():
		if abs(dir):
			fsm.state_next = fsm.states.run
			return
		
		else:
			fsm.state_next = fsm.states.idle
			return

	if is_anim_end:
		fsm.state_next = fsm.state_last
