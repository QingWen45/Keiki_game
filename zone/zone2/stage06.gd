extends Level

onready var entry = $cutscene_entry/entry_collider
onready var trap_door = $trap_door
onready var door1_collider = $trap_door/door1/collider1
onready var door2_collider = $trap_door/door2/collider2

onready var yachie = $yachie
onready var mayumi = $mayumi
onready var tween = $Tween
onready var timer = $Timer

onready var dialog_box = $dialog_box

var dialog_name_1 = "吉吊"
var msg1 = [
	"不错...十分顺利的作战\n",
	"即便是你这样忠诚的部下也可以暂且控制住\n",
	"这样的话，一面倒的局势终于可以迎来逆转了\n",
	"呵，真是凑巧\n",
	"虽然正面作战不是我们的风格...\n",
	"让我看看那位造形神的造物到底有何本领吧\n"
]

var dialog_name_2 = "磨弓"
var msg2 = []

var cutscene_played = false
var boss_defeated = false
	
func _ready():
	yachie.hide()
	mayumi.hide()
	Game.main.bgm_change(10)
	call_deferred("disable_door")
	var _res = $mayumi2.connect("boss_defeated", self, "on_boss_defeat")
	if Gamestate.state.events.zone02_stage06_cutscene_over:
		cutscene_played = true
	if Gamestate.state.events.zone02_stage06_boss_defeat:
		boss_defeated = true
		
func _on_begin_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone2/stage05.tscn"
	Gamestate.state.current_pos = "end_position"
	Gamestate.state.current_dir = -1
	Game.main.load_save()

func _on_end_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone2/stage07.tscn"
	Gamestate.state.current_pos = "initial_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()

func enable_door():
	trap_door.show()
	door1_collider.disabled = false
	door2_collider.disabled = false


func disable_door():
	trap_door.hide()
	door1_collider.disabled = true
	door2_collider.disabled = true
	call_deferred("_set_camera")

func start_cutscene():
	yachie.show()
	mayumi.show()
	var color_rect = Game.main.black_layer
	cutscene_played = false
	var camera = Game.camera
	timer.start(1)
	yield(timer, "timeout")

	# start dialog

	tween.interpolate_property(camera, "global_position:x", camera.global_position.x, 208, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")

	dialog_box.show_message(dialog_name_1, msg1[0], dialog_box.DIALOG_TYPE.PRESS, 2.0)
	yield(dialog_box, "dialog_finished")

	dialog_box.show_message(dialog_name_1, msg1[1], dialog_box.DIALOG_TYPE.PRESS, 2.5)
	yield(dialog_box, "dialog_finished")

	dialog_box.show_message(dialog_name_1, msg1[2], dialog_box.DIALOG_TYPE.PRESS, 2.5, true)
	yield(dialog_box, "dialog_finished")

	# turn to the player

	timer.start(0.5)
	yield(timer, "timeout")
	yachie.scale.x = -1
	timer.start(0.5)
	yield(timer, "timeout")

	dialog_box.show_message(dialog_name_1, msg1[3], dialog_box.DIALOG_TYPE.PRESS, 2.0)
	yield(dialog_box, "dialog_finished")

	dialog_box.show_message(dialog_name_1, msg1[4], dialog_box.DIALOG_TYPE.PRESS, 2.5)
	yield(dialog_box, "dialog_finished")

	dialog_box.show_message(dialog_name_1, msg1[5], dialog_box.DIALOG_TYPE.PRESS, 2.5, true)
	yield(dialog_box, "dialog_finished")

	Gamestate.state.events.zone02_stage06_cutscene_over = true

	# finish dialog

	# yachie walks(flies?) away

	timer.start(0.5)
	yield(timer, "timeout")
	yachie.scale.x = 1

	tween.interpolate_property(yachie, "global_position:x", yachie.global_position.x, yachie.global_position.x + 150, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	timer.start(0.5)
	yield(timer, "timeout")

	# black in

	tween.interpolate_property(color_rect, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")

	# do sth during the black

	camera.position = Vector2.ZERO
	enable_door()
	yachie.queue_free()
	mayumi.queue_free()

	timer.start(0.5)
	yield(timer, "timeout")

	# start the fight

	tween.interpolate_property(color_rect, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	yield(tween, "tween_all_completed")

	Gamestate.set_boss()
	Game.main.bgm_change(11)
	timer.start(1.0)

	yield(timer, "timeout")
	Game.cur_boss.activate()
	Game.player.fsm.state_next = Game.player.fsm.states.idle
	

func boss_release():
	Game.player.fsm.state_next = Game.player.fsm.states.cutscene
	yachie.queue_free()
	mayumi.queue_free()
	enable_door()
	Gamestate.set_boss()
	Game.main.bgm_change(11)
	timer.start(1.0)

	yield(timer, "timeout")
	Game.cur_boss.activate()
	Game.player.fsm.state_next = Game.player.fsm.states.idle

func on_boss_defeat():
	boss_defeated = true
	call_deferred("disable_door")
	Gamestate.clear_boss()
	Game.main.bgm_change(0)
	Gamestate.state.events.zone02_stage06_boss_defeat = true
	Game.player.fsm.state_next = Game.player.fsm.states.cutscene

	# timer.start(1.0)
	# yield(timer, "timeout")
	# dialog_box.show_message(dialog_name_2, msg2[0], dialog_box.DIALOG_TYPE.TIMER, 2.0, true)
	# yield(dialog_box, "dialog_finished")

	timer.start(2.0)
	yield(timer, "timeout")

	Game.player.fsm.state_next = Game.player.fsm.states.idle

var door_touched = false

func _on_cutscene_entry_entered(_body):
	if not door_touched:
		if not cutscene_played:
			Game.player.fsm.state_next = Game.player.fsm.states.cutscene
			start_cutscene()
		elif not boss_defeated:
			boss_release()
	door_touched = true
	
