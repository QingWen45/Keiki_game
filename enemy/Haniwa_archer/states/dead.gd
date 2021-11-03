extends FSM_state

var death_timer = 1.0
var disappear_timer = 1.0
var is_anim_playing = false

func initialize():
	obj.disable_collider()
	obj.anim_next = "death"

func run(delta):
	if death_timer > 0:
		death_timer -= delta
	elif not is_anim_playing:
		is_anim_playing = true
		obj.anim_fx.play("disappear")
		
	if death_timer <= 0:
		if disappear_timer > 0:
			disappear_timer -= delta
		else:
			obj.queue_free()
