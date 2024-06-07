extends CharacterBody2D

@onready var sprite = $sprite

@export var speed: int = 200

var direction: Vector2

func _process(delta):
	if direction.x:
		sprite.flip_h = direction.x < 0

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	move_and_slide()
	
