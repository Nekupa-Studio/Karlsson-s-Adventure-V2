extends CanvasLayer
class_name FlappyUI

const MAX_WIDTH = 1080

@export var journey_duration: int = 50

@onready var progress_bar = $main_ui_container/progress_bar

func _on_player_flappy_score_updated(score):
	progress_bar.size.x = MAX_WIDTH * score/journey_duration
