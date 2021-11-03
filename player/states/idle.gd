extends FSM_state


func initialize():
	obj.anim_next = "idle"


func run(_delta):
	obj.velo = Vector2.ZERO

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
		return

	if Input.is_action_just_pressed("attack") and obj.can_attack():
		obj.attack()
		fsm.state_next = fsm.states.attack
		return
