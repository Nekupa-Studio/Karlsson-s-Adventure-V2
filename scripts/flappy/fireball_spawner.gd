extends ReferenceRect
class_name FireballSpawner

const fireball_scene = preload("res://assets/flappy/fireball.tscn")

@export var spawn_time: float = 0.5
@export var num_spawn: int = 2

# TODO: change spawn system so as it is not random but in patterns
# Big maybe here idk too lazy

var timer: Timer

# Create the spawn timer when player first jump happened
func _on_game_start():
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = spawn_time
	timer.connect("timeout", spawn)
	add_child(timer)

# Every time the timer runs out, spawn [num_spawn] fireballs
func spawn():
	for i in range(num_spawn):
		var x = randi_range(position.x, position.x + size.x)
		var y = randi_range(position.y, position.y + size.y)
		
		var fireball = fireball_scene.instantiate()
		fireball.position = Vector2(x, y)
		get_tree().root.add_child(fireball)


