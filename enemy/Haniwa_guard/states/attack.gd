extends FSM_state

func initialize():
	obj.velo.x = 0
	obj.anim_next = "attack"

func run(_delta):
	pass

func _on_attack_end():
	fsm.state_next = fsm.states.chase