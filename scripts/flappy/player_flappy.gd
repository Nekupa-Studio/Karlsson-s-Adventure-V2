extends CharacterBody2D
class_name FlappyPlayer

const FALL_ROTATION = PI/5
const FALL_PERCENT = 0.25
const FADE_TIME = 0.1

signal game_started
signal score_updated(score)
signal player_died

@onready var sprite = $sprite
@onready var death_particle = $death_particle
@onready var anim = $skill_anims

@export_enum("blink", "smollification") var skill_name: String
@export var jump_force: int = -150
@export var gravity: float = 5

var started: bool = false
var time: float = 0
var score: int = 0
var skill_data: Dictionary

func _ready():
	skill_data = SkillSystem.get_skill_data(skill_name)

func _physics_process(delta):
	
	if started:
		time += delta
		update_score()
		
		velocity.y += gravity
	
	if Input.is_action_just_pressed("skill"):
		use_skill()
	
	# Karlsson stays afloat before first jump
	if Input.is_action_just_pressed("jump"):
		
		if not started:
			started = true
			emit_signal("game_started")
			
		velocity.y = jump_force
	
	# Interpolation of rotation depending on velocity
	var target_rot = sign(velocity.y) * FALL_ROTATION
	var rot_percent = FALL_PERCENT if velocity.y > 0 else 1-FALL_PERCENT
	rotation = lerp(rotation, target_rot, rot_percent)
	
	move_and_slide()

# Detect if hit
func _on_hitbox_area_entered(area):
	var col = area.get_parent()
	# If colision is enemy then karlsson dies
	if col.is_in_group("enemy"):
		anim.stop()
		# fades sprite then when done spawns particles
		var tween = create_tween().set_ease(Tween.EASE_OUT)
		tween.tween_property(sprite, "modulate:a", 0, FADE_TIME)
		set_physics_process(false)
		await tween.finished
		death_particle.emitting = true
		
func use_skill():
	if anim.is_playing(): return
	
	match skill_data["type"]:
		
		"use_number":			
			if skill_data["use_number"] <= 0:
				return
				
			anim.play(skill_data["anim"])
			skill_data["use_number"] -= 1
			
		"cooldown":
			if not skill_data["skill_ready"]:
				return
				
			skill_data["skill_ready"] = false
			anim.play(skill_data["anim"])
			await anim.animation_finished
			var timer = get_tree().create_timer(skill_data["cooldown"])
			await timer.timeout
			skill_data["skill_ready"] = true
	
func update_score():
	if time < 1: return
	time = 0
	score += 1
	emit_signal("score_updated", score)
