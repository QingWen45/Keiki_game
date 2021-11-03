extends FSM_state

var summon_timer
var is_summon_start

onready var gap = $gap_timer

func initialize():
	obj.visual_effect_start()
	summon_timer = 10.0

	obj.anim_next = "idle"
	obj.velo.x = 0
	obj.dir_next = -1

	obj.tween.interpolate_property(obj, "position", obj.position, obj.boss_pos.position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	obj.tween.start()
	yield(obj.tween, "tween_all_completed")
	gap.start()
	for i in obj.haniwas:
		i.initialize()
	is_summon_start = true


func run(delta):
	if summon_timer > 0 and is_summon_start:
		summon_timer -= delta
	elif is_summon_start:
		is_summon_start = false
		gap.stop()
		back_to_pos()

func back_to_pos():
	obj.tween.interpolate_property(obj, "position", obj.position, obj.boss_pos2.position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	obj.tween.start()
	yield(obj.tween, "tween_all_completed")
	fsm.state_next = fsm.states.idle

func terminate():
	obj.visual_effect_end()

func _on_gap_timer_timeout():
	obj.danmaku_create(8)
