extends Label

func _ready():
	modulate.a = 0.0

func show_dialog(msg, start_pos, duration = 1.0):
	text = msg

	$Tween.interpolate_property(self, "rect_position", start_pos,
			start_pos - Vector2(0, 50), duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	$Tween.start()
