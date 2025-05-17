extends CharacterBody2D

@export var move_speed: float = 100
@export var jump_force: float = 300

@onready var animated_sprite = $AnimatedSprite2D

const GRAVITY := 9.8

var aim: float = 0

func _physics_process(delta: float) -> void:
	movement_input()
	aim_input()
	
	if Input.is_action_just_pressed("jump"):
		jump(jump_force)
	
	animate()
	move_and_slide()

func movement_input():
	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_input * move_speed
	
	if not is_on_floor():
		velocity.y += GRAVITY
	
	flip_player()

func aim_input():
	var aim_input = Input.get_axis("aim_up", "aim_down")
	aim = aim_input

func flip_player():
	if velocity == Vector2.ZERO:
		return
	
	var is_facing_left: bool = velocity.x < 0
	animated_sprite.flip_h = is_facing_left

func jump(force: float):
	velocity.y = -force

func animate():
	if is_on_floor():
		if aim == 0:
			if velocity.x == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run_neutral")
		elif aim < 0:
			if velocity.x == 0:
				animated_sprite.play("aim_up")
			else:
				animated_sprite.play("run_aim_up")
		elif aim > 0:
			if velocity.x == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run_aim_down")
	else:
		animated_sprite.play("jump")
