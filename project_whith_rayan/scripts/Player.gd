extends KinematicBody2D


export var speed : float = 200
export var jump : float = 400
export var gravity : float = 10
export var acc : float = 5

var x : float
var motion = Vector2()



func _process(delta) -> void:
	motion = move_and_slide(motion,Vector2.UP)
	x = Input.get_axis("ui_left","ui_right")
	pass


func _physics_process(delta) -> void:
	Movement(delta)
	Gravity()
	Jump()
	





func Movement(delta) -> void:
	print(motion)
	if (x):
		motion.x = move_toward(motion.x,x * speed,acc)
	else:
		motion.x = lerp(motion.x, 0, 5 * delta)



func Gravity() -> void:
	if !is_on_floor():
		motion.y += gravity
	pass



func Jump() -> void:
	pass



