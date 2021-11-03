extends Sprite

var type
var velo
var bullet_speed

func _ready():
	$Timer.start()
	set_frame(type + 3)
	rotate(deg2rad(randi() % 60))
	bullet_speed = 200

func _physics_process(delta):
	position += velo * bullet_speed * delta
	if bullet_speed >= 50:
		bullet_speed -= 10

func _on_Timer_timeout():
	queue_free()

