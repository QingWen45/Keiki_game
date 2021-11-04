extends Node2D

var dialog_1 = ["硅姬大人也是来吃蛋糕的吗？"]

var dialog_name = "埴轮守卫"
onready var dialog_box = $dialog_box
onready var e = $Sprite

var player_nearby: bool
var is_chatting: bool

func _ready():
	e.hide()
	is_chatting = false
	player_nearby = false

func _process(_delta):
	if player_nearby:
		if Input.is_action_just_pressed("interact") and not is_chatting:
			is_chatting = true
			start_interact_dialog()

func start_interact_dialog():
	for n in range(len(dialog_1)):
		var msg = dialog_1[n]
		if n != len(dialog_1) - 1:
			dialog_box.show_message(dialog_name, msg, dialog_box.DIALOG_TYPE.PRESS, len(msg) * 0.1)
			yield(dialog_box, "dialog_finished")
		else:
			dialog_box.show_message(dialog_name, msg, dialog_box.DIALOG_TYPE.PRESS, len(msg) * 0.1, true)
			yield(dialog_box, "dialog_finished")
			is_chatting = false

func _on_Area2D_body_entered(_body):
	e.show()
	player_nearby = true

func _on_Area2D_body_exited(_body):
	dialog_box.dialog_break()
	e.hide()
	is_chatting = false
	player_nearby = false
