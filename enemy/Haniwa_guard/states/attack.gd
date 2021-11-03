extends FSM_state

func initialize():
	obj.velo.x = 0
	obj.anim_next = "attack"

func run(_delta):
	var player_pos = Game.player.global_position - obj.global_position
	var dir = sign(player_pos.x)
	obj.dir_next = dir

func _on_attack_end():
	fsm.state_next = fsm.states.chase
