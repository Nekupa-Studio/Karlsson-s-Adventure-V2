extends CharacterBody2D
class_name FlappyFireball

# TODO: REFACTOR DIS SHIT

const CULL_DISTANCE = -300

@onready var particles = $root_particle
@onready var hitbox = $hitbox
@onready var face = $face

var movement_types = [
	"cos_movement", 
	"linear_movement", 
	"triangle_movement",
	 "fall_movement"
	]
var movement: String

@export var speed: int = 120

var amp: int = 50
var puls: int = 5
var wave_time: float = 1.6
var phase: float
var scale_: float

var time: float = 0

func _ready():
	generate_properties()
	propagate_scale()
	setup_particles()
	
	# TODO: NOT HARDCODE THIS AND DO BETTER
	if movement == "fall_movement":
		velocity.y = -60


func _process(delta):
	"""
	Procedurally make the fireball look where it's going
	"""
	particles.direction = velocity.normalized()
	for particle in particles.get_children():
		particle.direction = particles.direction
		
	face.look_at(position + velocity)

func _physics_process(delta):
	"""
	Move the fireball according to its random movement pattern.
	"""
	time += delta
	velocity.x = -speed
	
	call(movement)
	
	move_and_slide()
	fireball_culling()

""" -------------------------[Setup Functions]------------------------------ """

func generate_properties():
	"""
	Initialise the fireball's property randomly.
	"""
	movement = movement_types.pick_random()
	
	phase = randf_range(0,2)
	amp = randi_range(50,120)
	puls = randi_range(2,8)
	wave_time = randf_range(1.2,2)
	
	scale_ = randf_range(1,1.75)

func propagate_scale():
	"""
	Make the fireball faster the smaller it is.
	Also spread the scale to each particles.
	"""
	
	# Bigger the scale slower the fireball
	speed *= 1/scale_

	# Apply scale to every particles
	particles.scale_amount_min = scale_
	particles.scale_amount_max = scale_
	for particle in particles.get_children():
		particle.scale_amount_min = scale_
		particle.scale_amount_max = scale_
	hitbox.scale = Vector2(scale_, scale_)
	
func setup_particles():
	"""
	Increase the number of particles of the fireball according to its speed.
	"""
	particles.amount = int(speed / 10)
	for particle in particles.get_children():
		particle.amount = particles.amount

""" -------------------------[Culling Function]----------------------------- """

func fireball_culling():
	"""
	When out of bound, remove the fireball from tree.
	"""
	if position.x >= CULL_DISTANCE and position.y <= -CULL_DISTANCE: return
	
	queue_free()

""" ------------------------[Movement Functions]---------------------------- """

func cos_movement():
	"""
	Moves the fireball in the style of a cosine graph.
	"""
	time = fmod(time, PI*2)
	velocity.y = cos((time + phase) * puls) * amp

func linear_movement():
	pass

func triangle_movement():
	"""
	Moves the fireball in the style of a triangle wave graph.
	"""
	time = fmod(time, wave_time)
	velocity.y = sign(time - wave_time/2) * amp

func fall_movement():
	"""
	Moves the fireball like a free fall.
	"""
	# TODO: same, do not hardcode this and do better
	velocity.y += 0.7
	
