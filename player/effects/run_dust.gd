extends Sprite

var random_offset
var dust_type
var up_speed
var h_speed

func _ready():
	dust_type = randi() % 2
	set_frame(dust_type)

	random_offset = randi() % 10 - 5
	position.x += random_offset

	# random integer from 20 to 40
	up_speed = randi() % 20 + 20
	# -2 to 2
	h_speed = randi() % 4 - 2
	
func _physics_process(delta):
	position += Vector2(h_speed, -1 * up_speed * delta)


func _on_Timer_timeout():
	queue_free()
	