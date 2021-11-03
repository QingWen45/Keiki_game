extends Node2D

var sprites = []

var friend_count = 0
var friends_num = 4

func _ready():
	sprites = get_children()
	
func initialize(t, h, v):
	# warning-ignore: unused_variable
	for s in sprites:
		s.texture = t
		s.hframes = h
		s.vframes = v

func bang(f, s, pos:Vector2):
	sprites[friend_count].bang(f, s)
	sprites[friend_count].global_position = pos
	friend_count += 1
	if friend_count >= friends_num:
		friend_count -= friends_num


