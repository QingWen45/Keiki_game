extends FSM_state

var key_down_timer
var min_jump_ratio = 0.5


func initialize():
	obj.anim_next = "jump"
	key_down_timer = 0.2
	if fsm.state_last != fsm.states.fall_attack: 
		obj.jump_dust_generate(21)


func run(delta):
	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)
	if key_down_timer > 0:
		key_down_timer -= delta
		if key_down_timer <= 0 or Input.is_action_just_released("jump"):
			key_down_timer = -1.0
			obj.velo.y *= min_jump_ratio
	
	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")

	if abs(dir):
		dir = sign(dir)
		obj.velo.x = lerp(obj.velo.x, obj.MAX_SPEED * dir, obj.AIR_ACCEL)
		obj.dir_next = dir
	else:
		obj.velo.x = lerp(obj.velo.x, 0, obj.AIR_ACCEL)

	if obj.is_on_floor():
		fsm.state_next = fsm.states.idle
	elif obj.is_on_ceiling():
		obj.velo.y = 0.0
		fsm.state_next = fsm.states.fall
	else:
		if obj.velo.y > 0:
			fsm.state_next = fsm.states.fall

	if Input.is_action_just_pressed("jump") and Gamestate.state.can_double_jump:
		fsm.state_next = fsm.states.double_jump
		return

	if Input.is_action_just_pressed("attack") and obj.can_attack():
		obj.attack()
		fsm.state_next = fsm.states.fall_attack
		return
 
