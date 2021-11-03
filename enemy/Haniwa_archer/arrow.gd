extends Node2D

# 0 blue 1 red
var arrow_type:int = 1
var arrow_max_speed = 300
var dir = 1
var damage = 10

onready var arrow = $arrow/Sprite

func _ready():
	scale.x = dir

func _physics_process(delta):
	position.x += arrow_max_speed * delta * dir

func set_arrow_type(type = 1):
	arrow.set_frame(type)

func _on_arrow_area_entered(area):
	area.emit_signal("hurt", self, damage)
	if area.name == "hurtbox":
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
