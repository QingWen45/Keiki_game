extends FSM_state

var charge_timer

func initialize():
	charge_timer = 3.0
	obj.anim_next = "attack"

func run(_delta):
	if charge_timer > 0:
		charge_timer -= _delta
		obj.velo.x = obj.MOVE_SPEED * 10
	else:
		after_charge()

	if obj.check_wall():
		after_charge()

func terminate():
	obj.dir_next = -obj.dir_cur

func after_charge():
	fsm.state_next = fsm.states.idle
	obj.spear.position = Vector2.ZERO
	obj.hit_box.disabled = true
