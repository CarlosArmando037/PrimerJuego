extends Node2D
#const player_start_pos := Vector2i(150, 485)
const player_start_pos := Vector2i(300, 324)
const cam_start_pos := Vector2i(576, 324)

var score : int 

var SPEED : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var screen_size : Vector2i

func _ready():
	screen_size = get_window().size
	new_game()
	
func new_game():
	score = 0
	
	
	$jugador.position = player_start_pos
	$jugador.velocity = Vector2i(0, 0)
	$Camera2D.position = cam_start_pos
	$ground.position = Vector2i(0, 0)

func _process(delta):
	SPEED = START_SPEED
	
	$jugador.position.x += SPEED
	$Camera2D.position.x += SPEED
	
	score += SPEED
	print(score)
	
	if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
		$ground.position.x += screen_size.x
