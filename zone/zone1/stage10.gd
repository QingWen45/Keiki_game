extends Level

onready var trap_floor = $trap_door/floor


func _on_begin_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage09.tscn"
	Gamestate.state.current_pos = "end_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()

func _on_end_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage03.tscn"
	Gamestate.state.current_pos = "return_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()

func fall_floor():
	trap_floor.disabled = true

func _on_item_body_entered(_body):
	call_deferred("fall_floor")
	$break.play()
	Game.player.set_process_input(false)
	$trap_door.hide()
