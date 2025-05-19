extends Area2D

@export var speed = 500

@onready var visible_notifier = $VisibleNotifier

func _ready() -> void:
	# connect signal through code
	visible_notifier.connect("screen_exited", _on_screen_exited)

func _physics_process(delta: float) -> void:
	position.x += speed * delta

func _on_screen_exited():
	queue_free() # Delete node and all it's children
