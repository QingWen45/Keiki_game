extends Area2D

var dir = 1
var bullet_type
var damage

# 0 for triangle, 1 for circle and 2 for square

export (float) var BULLET_SPEED = 400
export (float) var ROTATE_SPEED = 360 # in degree

onready var bullet = $Sprite
var particle = preload("res://player/bullets/particle.tscn")


var spread_vector = Vector2()
var spread_angle

func _ready():
	bullet_type = randi() % 3
	bullet.set_frame(bullet_type)
	$Timer.start(Gamestate.state.bullet_live_time)
	damage = Gamestate.state.bullet_damage


func _physics_process(delta):
	position.x += BULLET_SPEED * delta * dir
	rotate(deg2rad(ROTATE_SPEED) * delta)


func _on_Timer_timeout():
	particle_spawn(randi() % 3 + 2, bullet_type, Vector2(dir, 0))
	queue_free()


func particle_spawn(num, type, spread_vec = Vector2()):
	# warning-ignore: unused_variable
	for i in range(num):
		spread_angle = deg2rad(randi() % 120 - 60)
		var p = particle.instance()
		p.position = position
		p.velo = spread_vec.rotated(spread_angle)
		p.type = type
		get_parent().add_child(p)


func _on_Bullet_body_entered(_body: Node):
	particle_spawn(randi() % 3 + 2, bullet_type, Vector2(dir, 0))
	
	queue_free()

func _on_Bullet_area_entered(area):
	particle_spawn(randi() % 3 + 2, bullet_type, Vector2(dir, 0))
	area.emit_signal("hurt", self, damage)
	queue_free()
