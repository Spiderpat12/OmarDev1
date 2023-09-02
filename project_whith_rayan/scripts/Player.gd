extends KinematicBody2D


export var speed : float = 300
export var jump : float = 200
export var gravity : float = 15
export var acc : float = 20

export var jump_height: float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

var x : float
var motion = Vector2()
var max_jump = 1
var jump_count = 0
var can_jump : bool = true

onready var chapters : int = 2
onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))* -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descent))* -1.0

var Anime;
var have_coyote = false
var bak;

func _ready() -> void:
	Anime = $AnimationTree.get("parameters/playback")

func _process(delta) -> void:
	motion = move_and_slide(motion,Vector2.UP)
	x = Input.get_axis("ui_left","ui_right")
	pass


func _physics_process(delta) -> void:
	bak = motion.x * 5/100;
	motion.y += get_gravity()*delta
	Movement(delta)
	Jump()
	chapters()
	flip()
	anime()
	Braking()


func Movement(delta) -> void:
	if (x):
		motion.x = move_toward(motion.x,x * speed,acc)
	else:
		motion.x = lerp(motion.x, 0, 9 * delta)

func flip() -> void:
	if motion.x < 0:
		$Squish/Sprite.scale.x = -1
	if motion.x > 0:
		$Squish/Sprite.scale.x = 1




func Jump() -> void:
	if !is_on_floor():
		motion.y += gravity
		if have_coyote:
			$CoyoteTimer.start()
			have_coyote = false
	if can_jump == true:
		if (is_on_floor() or !$CoyoteTimer.is_stopped()) && (Input.is_action_just_pressed("ui_up") or !$JumpBufferTimer.is_stopped()):
			motion.y = jump_velocity
			$CoyoteTimer.stop()
			$JumpBufferTimer.stop()
			JumpSquish()

func doubleJump() -> void:
	if jump_count < max_jump && can_jump == false:
		if Input.is_action_just_pressed("ui_up"):
			match chapters:
				2:
					motion.y = jump_velocity
					jump_count += 1
					JumpSquish()
				3:
					JumpSquish()
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



func anime() -> void:
	if(x) && motion.x != 0:
		Anime.travel("walk")
	else:
		Anime.travel("idle")
	if (motion.y > gravity) && !is_on_floor():
		Anime.travel("fall")
	if (motion.y < -gravity):
		Anime.travel("Jump")

	

func Braking():
	if is_on_floor() && motion.x > 0 && Input.is_action_pressed("ui_left"):
		motion.x = motion.x - bak
		Anime.travel("baking")
	elif is_on_floor() && motion.x < 0 && Input.is_action_pressed("ui_right"):
		motion.x = motion.x - bak
		Anime.travel("baking")

func JumpSquish():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Squish,"scale",Vector2(0.7,1.3),0.1)
	tween.tween_property($Squish,"scale",Vector2(1,1),0.1)
	pass

func LandSquish():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Squish,"scale",Vector2(1.3,0.7),0.05)
	tween.tween_property($Squish,"scale",Vector2(1,1),0.1)
	pass
