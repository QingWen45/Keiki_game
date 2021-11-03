extends Level

const dialog_name = "磨弓"
var dialog_1 = [
	"硅姬大人，出现了紧急状况\n",
	"失控的埴轮们现在正在城市中作乱\n",
	"我先去查看一下情况，硅姬大人也马上行动起来吧\n"
]

onready var dialog_box = $dialog_box

func _ready():
	if not Gamestate.state.events.zone01_stage01_cutscene_over:
		Game.player.anim.play("idle")
		Game.player.set_physics_process(false)
		Game.main.hud.hide()
		$anim.play("intro")
	else:
		$ColorRect.hide()
		$player/MainCamera.make_current()

func start_interact_dialog():
	var is_end = false
	for n in range(len(dialog_1)):
		var msg = dialog_1[n]
		if n == len(dialog_1) - 1:
			is_end = true
		dialog_box.show_message(dialog_name, msg, dialog_box.DIALOG_TYPE.PRESS, len(msg) * 0.12, is_end)
		yield(dialog_box, "dialog_finished")
	start_second_animation()

func start_second_animation():
	$anim.play("second")

func start_game():
	Game.main.hud.show()
	Game.player.set_physics_process(true)
	Gamestate.state.events.zone01_stage01_cutscene_over = true

func _on_end_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage02.tscn"
	Gamestate.state.current_pos = "initial_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()
