extends KinematicBody2D


export var speed : float = 300
export var jump : float = 200
export var gravity : float = 15
export var acc : float = 50

export var jump_height: float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

var x : float
var motion = Vector2()
var max_jump = 1
var jump_count = 0
var can_jump : bool = true

onready var chapters : int = 3
onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))* -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descent))* -1.0

func _process(delta) -> void:
	motion = move_and_slide(motion,Vector2.UP)
	x = Input.get_axis("ui_left","ui_right")
	pass


func _physics_process(delta) -> void:
	motion.y += get_gravity()*delta
	Movement(delta)
	Gravity()
	Jump()
	chapters()
	flip()


func Movement(delta) -> void:
	print(motion)
	print(jump_count)
	if (x):
		motion.x = move_toward(motion.x,x * speed,acc)
	else:
		motion.x = lerp(motion.x, 0, 8 * delta)


func Gravity() -> void:
	if !is_on_floor():
		motion.y += gravity
	pass


func Jump() -> void:
	if can_jump == true:
		if is_on_floor() && Input.is_action_just_pressed("ui_up"):
			motion.y = jump_velocity

func doubleJump() -> void:
	if jump_count < max_jump && can_jump == false:
		if Input.is_action_just_pressed("ui_up"):
			match chapters:
				2:
					motion.y = jump_velocity
					jump_count += 1
				3:
					motion.y = jump_velocity
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
			can_jump = false
			doubleJump()
			pass
		3:
			can_jump = false
			doubleJump()
			pass



func get_gravity() -> float:
	return jump_gravity if motion.y < 0.0 else fall_gravity


func flip() -> void:
	if motion.x < 0:
		$Sprite.scale.x = -1
	if motion.x > 0:
		$Sprite.scale.x = 1

