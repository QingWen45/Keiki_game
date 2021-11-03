extends Area2D

var is_boss_avtivate: = false


func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(_area):
	if not is_boss_avtivate:
		is_boss_avtivate = true
		Game.cur_boss.activate()
		Gamestate.set_boss()
