extends Node2D

var dialog_1 = ["硅姬大人也是来吃蛋糕的吗？"]

var dialog_name = "埴轮守卫"
onready var dialog_box = $dialog_box
onready var e = $Sprite

var is_in_dialog

func _ready():
	is_in_dialog = false
	e.hide()
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("interact") and not is_in_dialog:
		is_in_dialog = true
		start_interact_dialog()

func start_interact_dialog():
	var is_end = false
	e.hide()
	for n in range(len(dialog_1)):
		var msg = dialog_1[n]
		if n == len(dialog_1) - 1:
			is_end = true
		dialog_box.show_message(dialog_name, msg, dialog_box.DIALOG_TYPE.PRESS, len(msg) * 0.1, is_end)
		yield(dialog_box, "dialog_finished")
		is_in_dialog = false
		e.show()

func _on_Area2D_body_entered(_body):
	e.show()
	set_process_input(true)

func _on_Area2D_body_exited(_body):
	dialog_box.dialog_break()
	e.hide()
	set_process_input(false)
