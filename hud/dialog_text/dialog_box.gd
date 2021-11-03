extends Control

# warning-ignore: unused_signal
signal dialog_finished

onready var speaker = $VBoxContainer/HBoxContainer/Label
onready var dialog = $VBoxContainer/Label2
onready var tween = $Tween
onready var timer = $Timer
onready var arrow = $arrow
onready var anim = $anim

var is_dialog_finished: bool
var dialog_type
var last_line: bool


func _ready():
	modulate.a = 0.0
	set_process_input(false)
	arrow.set_visible(false)
	is_dialog_finished = false
	last_line = false

	
func _input(_event):
	if dialog_type == DIALOG_TYPE.PRESS:
		# accel the dialog to end
		if Input.is_action_just_pressed("interact") and not is_dialog_finished:
			tween.seek(tween.get_runtime() - 0.01)

		# continue to the next line
		if Input.is_action_just_pressed("interact") and is_dialog_finished:
			$AudioStreamPlayer.play()
			arrow.set_visible(false)
			anim.stop(true)

			if last_line:
				last_line = false
				end_message()
			else:
				emit_signal("dialog_finished")


enum DIALOG_TYPE {
	PRESS = 0,
	TIMER = 1
}

func show_message(onwer: String, msg: String, type = DIALOG_TYPE.TIMER, duration = 1.0, ends = false):
	speaker.text = onwer + "："
	dialog.text = msg

	is_dialog_finished = false
	# typer effect
	tween.interpolate_property(dialog, "percent_visible", 0.0, 1.0, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	# revail the box
	if modulate.a == 0.0:
		tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	tween.start()

	if type == DIALOG_TYPE.PRESS:
		set_process_input(true)
		if ends: 
			last_line = true
		dialog_type = DIALOG_TYPE.PRESS
		# last will be handled in _input function

	elif type == DIALOG_TYPE.TIMER:
		yield(tween, "tween_all_completed")

		timer.start(duration * 2)
		yield(timer, "timeout")

		emit_signal("dialog_finished")

		if ends:
			end_message()


func end_message():
	set_process_input(false)
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("dialog_finished")


# breaks the dialog immediately
func dialog_break():
	tween.stop_all()
	tween.interpolate_property(self, "modulate:a", modulate.a, 0.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	is_dialog_finished = false
	last_line = false

	set_process_input(false)
	arrow.set_visible(false)
	anim.stop(true)
	

func _on_Tween_tween_completed(_object, key):
	if str(key) == ":percent_visible":
		if dialog_type == DIALOG_TYPE.PRESS:
			arrow.set_visible(true)
			anim.play("arrow")
		is_dialog_finished = true
