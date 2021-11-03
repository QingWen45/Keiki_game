extends Node2D

export (bool) var show_machine = false

var can_save: = false
var save_gap: = true

onready var E = $E
onready var machine = $machine

func _ready():
	E.hide()
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("interact") and can_save and save_gap:
		save_gap = false
		$Timer.start(1.0)

		$AudioStreamPlayer.play()
		Gamestate.state.current_level = owner.filename
		Gamestate.state.current_pos = "savepoint"
		Gamestate.state.current_dir = 1
		Game.player.say("saved!")

		Gamestate.set_player_health(Gamestate.state.max_health)
		Gamestate.set_player_magicka(Gamestate.state.max_magicka)

		Gamestate.save_gamestate()

func _on_Timer_timeout():
	save_gap = true

func _on_Area2D_body_entered(_body):
	E.show()
	can_save = true
	set_process_input(true)

func _on_Area2D_body_exited(_body):
	E.hide()
	can_save = false
	set_process_input(false)