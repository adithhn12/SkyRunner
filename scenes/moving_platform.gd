extends AnimatableBody2D

@export var distance = 300.0
@export var speed = 100.0
@export var direction = 1.0

var start_position: Vector2


func _ready():
	start_position = position


func _physics_process(delta):
	position.x = start_position.x + sin(Time.get_ticks_msec() / 1000.0 * speed / 100.0) * distance * direction
