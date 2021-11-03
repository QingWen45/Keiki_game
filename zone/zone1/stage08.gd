extends Level

func _ready():
	pass # Replace with function body.

func _on_begin_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage07.tscn"
	Gamestate.state.current_pos = "end_position2"
	Gamestate.state.current_dir = 1
	Game.main.load_save()
