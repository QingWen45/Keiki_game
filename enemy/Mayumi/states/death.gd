extends FSM_state

var death_timer = 5.0
var disappear_timer = 1.0
var is_anim_playing = false

func initialize():
	obj.disable_collider()
	obj.anim.play("defeated")
	obj.anim.queue("defeated_loop")

	obj.velo.x = 400 * -obj.dir_cur


func run(delta):
	if abs(obj.velo.x) > 0:
		obj.velo.x = max(abs(obj.velo.x) - 20, 0)
		obj.velo.x *= -obj.dir_cur

	if death_timer > 0:
		death_timer -= delta
	elif not is_anim_playing:
		is_anim_playing = true
		obj.anim_fx.play("disappear")
		
	if death_timer <= 0:
		if disappear_timer > 0:
			disappear_timer -= delta
		else:
			Game.cur_boss = null
			obj.queue_free()