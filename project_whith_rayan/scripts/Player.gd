extends KinematicBody2D


export var speed : float = 300
export var jump : float = 200
export var gravity : float = 15
export var acc : float = 35

var x : float
var motion = Vector2()
var max_jump = 1
var jump_count = 0
var can_jump : bool = true

onready var chapters : int = 1


func _process(delta) -> void:
	motion = move_and_slide(motion,Vector2.UP)
	x = Input.get_axis("ui_left","ui_right")
	pass


func _physics_process(delta) -> void:
	Movement(delta)
	Gravity()
	Jump()
	chapters()


func Movement(delta) -> void:
	print(motion)
	print(jump_count)
	if (x):
		motion.x = move_toward(motion.x,x * speed,acc)
	else:
		motion.x = lerp(motion.x, 0, 5 * delta)


func Gravity() -> void:
	if !is_on_floor():
		motion.y += gravity
	pass


func Jump() -> void:
	if can_jump == true:
		if is_on_floor() && Input.is_action_just_pressed("ui_up"):
			motion.y = -jump

func doubleJump() -> void:
	if jump_count < max_jump && can_jump == false:
		if Input.is_action_just_pressed("ui_up") && chapters == 2:
			motion.y = -jump
			jump_count += 1
	if is_on_floor() && jump_count != 0:
		jump_count = 0



func chapters() -> void:
	match chapters:
		1:
			#roll_func
			pass
		2:
			#roll_func
			doubleJump()
			can_jump = false
			pass
		3:
			pass





