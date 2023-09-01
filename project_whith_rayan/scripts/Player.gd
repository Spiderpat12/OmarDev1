extends KinematicBody2D


export var speed : float = 200
export var jump : float = 400
export var gravity : float = 10
export var acc : float = 5

var x : float
var motion = Vector2()
var chapters : int = 1
var max_jump = 2
var jump_count = 0


func _ready():
	chapters = 1
	pass


func _process(delta) -> void:
	motion = move_and_slide(motion,Vector2.UP)
	x = Input.get_axis("ui_left","ui_right")
	pass


func _physics_process(delta) -> void:
	Movement(delta)
	Gravity()
	Jump()
	chapters()
	doubleJump()


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
	if is_on_floor() && Input.is_action_just_pressed("ui_up") && chapters != 2:
		motion.y = -jump

func doubleJump() -> void:
	if jump_count < max_jump && chapters == 2 or 3:
		if Input.is_action_just_pressed("ui_up"):
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
			pass
		3:
			pass





