extends Node2D

# 0 blue 1 red
var arrow_type:int = 1
var arrow_max_speed = 300
var damage = 10
var dir
var accel = 0


func _physics_process(delta):
	accel += 10
	accel = min(accel, arrow_max_speed)
	position += accel * delta * dir

func set_arrow_type(type = 0):
	$arrow/Sprite.set_frame(type)

func _on_arrow_area_entered(area):
	area.emit_signal("hurt", self, damage)
	if area.name == "hurtbox":
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
