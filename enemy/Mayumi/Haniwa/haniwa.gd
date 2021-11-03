extends KinematicBody2D

var arrow = preload("res://enemy/Mayumi/Haniwa/arrow.tscn")
onready var timer = $attack_timer
onready var state_timer = $state_timer
onready var gap = $gap_timer
onready var anim = $anim

var life_timer

var is_idle
var attack_type = 0

func _ready():
	pass

func _physics_process(delta):
	if is_idle:
		if life_timer > 0:
			life_timer -= delta
		else:
			leave()
			is_idle = false

func initialize():
	show_up()
	is_idle = false

func show_up():
	show()
	anim.play("show")
	life_timer = 10

	state_timer.start(0.4)

	yield(state_timer, "timeout")
	state_timer.set_wait_time(0.4)
	anim.play("idle")
	timer.start()
	is_idle = true

func leave():
	anim.play("leave")
	timer.stop()
	state_timer.start()
	yield(state_timer, "timeout")
	hide()

func attack():
	var player_rela_pos = Game.player.global_position - self.global_position
	var attack_dir = player_rela_pos.normalized()
	match attack_type:
		0:
			# warning-ignore:unused_variable
			for i in range(5):
				for j in range(5):
					j -= 2
					var dir =  attack_dir.rotated(deg2rad(j*45))
					var a = arrow.instance()
					a.position = position
					a.rotate(dir.angle())
					a.dir = dir
					a.set_arrow_type(attack_type)
					get_parent().add_child(a)

				$fx.play()
				gap.start(0.05)
				yield(gap, "timeout")
			attack_type = 1
			timer.set_wait_time(1.5)
		1:
			# warning-ignore:unused_variable
			for i in range(5):
				for j in [-2,-1,1,2]:
					var dir =  attack_dir.rotated(deg2rad(j*30))
					var a = arrow.instance()
					a.position = position
					a.rotate(dir.angle())
					a.dir = dir
					a.set_arrow_type(attack_type)
					get_parent().add_child(a)

				$fx.play()
				gap.start(0.05)
				yield(gap, "timeout")
			attack_type = 0
			timer.set_wait_time(0.5)

func _on_attack_timer_timeout():
	attack()

func _on_Area2D_area_entered(_area):
	$fx2.play()
	leave()
