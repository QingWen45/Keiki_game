extends FSM_state

var attack_dir

func initialize():
	obj.visual_effect_start()
	obj.velo = Vector2.ZERO
	obj.anim_next = "attack2"
	attack_dir = obj.dir_cur

func run(_delta):
	if abs(obj.velo.x) > 0:
		obj.velo.x = max(abs(obj.velo.x) - 20, 0) * attack_dir
	var player_pos = obj.get_player_pos()
	var dir = sign(player_pos.x)
	obj.dir_next = dir


func terminate():
	obj.visual_effect_end()