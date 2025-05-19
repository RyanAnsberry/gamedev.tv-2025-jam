extends Node2D

@onready var right_position = $RightPosition
@onready var right_down_position = $RightDownPosition
@onready var left_down_position = $LeftDownPosition
@onready var up_position = $UpPosition
@onready var left_position = $LeftPosition
@onready var right_up_position = $RightUpPosition
@onready var left_up_position = $LeftUpPosition
@onready var down_position = $DownPosition


@onready var bullet_scene = preload("res://Scenes/Player/bullet.tscn")

var is_facing_left: bool = false
var can_jump_fire = true
var current_spawn_marker: Marker2D = right_position

func _ready() -> void:
	current_spawn_marker = right_position

func _process(delta: float) -> void:
	handle_aim_input()

func handle_aim_input():
	var aim_input = Input.get_vector("move_left", "move_right", "aim_up", "aim_down")
	
	if aim_input.x > 0:
		is_facing_left = false
	elif aim_input.x < 0:
		is_facing_left = true
	
	if aim_input == Vector2.UP:
		current_spawn_marker = up_position
	elif aim_input == Vector2.RIGHT:
		current_spawn_marker = right_position
	elif aim_input == Vector2.LEFT:
		current_spawn_marker = left_position
	elif aim_input.x > 0 and aim_input.y < 0:
		current_spawn_marker = right_up_position
	elif aim_input.x < 0 and aim_input.y < 0:
		current_spawn_marker = left_up_position
	elif aim_input.x > 0 and aim_input.y > 0:
		current_spawn_marker = right_down_position
	elif aim_input.x < 0 and aim_input.y > 0:
		current_spawn_marker = left_down_position
	elif aim_input == Vector2.DOWN:
		current_spawn_marker = down_position
	elif aim_input == Vector2.ZERO and is_facing_left:
		current_spawn_marker = left_position
	elif aim_input == Vector2.ZERO and not is_facing_left:
		current_spawn_marker = right_position



func fire():
	var bullet = bullet_scene.instantiate()
	current_spawn_marker.add_child(bullet)


func jump_fire():
	if can_jump_fire:
		var spawn_positions: Array[Marker2D] = [right_position, right_down_position, down_position, left_down_position, left_position, left_up_position, up_position, right_up_position]
		start_jumpfire_cooldown()
		for position in spawn_positions:
			current_spawn_marker = position
			var bullet = bullet_scene.instantiate()
			current_spawn_marker.add_child(bullet)
			await get_tree().create_timer(0.1).timeout

func start_jumpfire_cooldown():
	can_jump_fire = false
	await get_tree().create_timer(0.9).timeout
	can_jump_fire = true
