extends Node2D
#const player_start_pos := Vector2i(150, 485)
const player_start_pos := Vector2i(-250,300)
const cam_start_pos := Vector2i(0,180)
#const cam_start_pos := Vector2i(576

var score : int 
const Score_modifier : int = 30
var SPEED : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var screen_size : Vector2i

var game_running : bool

func _ready():
	screen_size = get_window().size
	new_game()
	
func new_game():
	score = 0
	show_Score()
	game_running = false
	
	$jugador.position = player_start_pos
	$jugador.velocity = Vector2i(0, 0)
	$Camera2D.position = cam_start_pos
	#$ground_top.position = Vector2i(0, 0)
	$ground_down.position = Vector2i(0, 0)
	#$ground_mid.position = Vector2i(0, 0)
	
	$HUD.get_node("ScoreLabel").show()
	
func _process(delta):
	if game_running:
		SPEED = START_SPEED
		
		$jugador.position.x += SPEED
		$Camera2D.position.x += SPEED
		
		score += SPEED
		show_Score()
		
		if $Camera2D.position.x - $ground_down.position.x > screen_size.x * 1.5:
			$ground_down.position.x += screen_size.x
		elif $Camera2D.position.x - $ground_top.position.x > screen_size.x * 1.5:
			$ground_top.position.x += screen_size.x
		elif $Camera2D.position.x - $ground_mid.position.x > screen_size.x * 1.5:
			$ground_mid.position.x += screen_size.x
	else: 
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
func show_Score():
	#con el get node podemos conseguir los nodos dentre de la ecena de HUD
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / Score_modifier)
