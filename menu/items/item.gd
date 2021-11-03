extends Control
class_name Item

onready var rect  = $rect
onready var image = $item_image

export(bool) var is_lock = true

var has_effected:bool

var item_no = 0
var item_name = "未知道具"
var description = "这个道具还没有被收集"

var lock_name = "未知道具"
var lock_description = "这个道具还没有被收集"

var unlocked: bool = false

func _ready():
	has_effected = false
	self.lock()

func get_name():
	if is_lock:
		return lock_name
	else:
		return item_name

func get_description():
	if is_lock:
		return lock_description
	else:
		return description

func effect():
	if has_effected:
		return
	has_effected = true
	item_effect()

func item_effect():
	pass

func lock():
	is_lock = true
	image.hide()

func unlock():
	is_lock = false
	image.show()

func select():
	rect.show()

func deselect():
	rect.hide()




