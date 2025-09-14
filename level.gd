extends Node2D
#---------------------precargar las ecenas de obstaculos
var spikes_scene = preload("res://spikes.tscn")
var turtle_scene = preload("res://turtle.tscn")
var bird_scene = preload("res://blue_bird.tscn")
var rino_scene = preload("res://rino.tscn")

var obstacles_type := [spikes_scene, rino_scene]
var obstacles : Array
var bird_heights := [200, 390]
var turtle_heights := [200, 390]

#----------------GAME VARIABLES
const player_start_pos := Vector2i(-260,300)
const cam_start_pos := Vector2i(0,180)

var score : int 
const Score_modifier : int = 30

var SPEED : float

#----------Velocidad inicial 
const START_SPEED : float = 5.0
const MAX_SPEED : int = 25
const Speed_modifier : int = 5000
var screen_size : Vector2i

var ground_height : int
var game_running : bool

var last_obs

func _ready():
	screen_size = get_window().size
	
	ground_height = $ground_down.position.y
	new_game()

func new_game():
	score = 0
	show_Score()
	game_running = false
	
	$jugador.position = player_start_pos
	$jugador.velocity = Vector2i(0, 0)
	$Camera2D.position = cam_start_pos
	$ground_top.position = Vector2i(0, 125)
	$ground_down.position = Vector2i(0, 350)
	$ground_mid.position = Vector2i(0, 235)
	
	$HUD.get_node("ScoreLabel").show()
	
func _process(delta):
	if game_running:
		SPEED = START_SPEED + score / Speed_modifier
		#if SPEED > MAX_SPEED:0
			#SPEED = MAX_SPEED
			
		#generar obstaculos funcion
		generate_obs()
		
		$jugador.position.x += SPEED
		$Camera2D.position.x += SPEED
		
		score += SPEED
		show_Score()
		
		#actualizacion de suelos
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
			
func  generate_obs():
	if obstacles.is_empty() or last_obs. position.x < score + randi_range(300, 500):
		var obs_type = obstacles_type[randi() % obstacles_type.size()]
		var obs
		obs = obs_type.instantiate()
		var obs_height = obs.get_node("Sprite2D").texture.get_height()
		var obs_scale = obs.get_node("Sprite2D").scale
		var obs_x : int = screen_size.x + score + 300
		var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 350
		last_obs = obs
		add_obs(obs, obs_x, obs_y)
		
func add_obs(obs, x, y):
		obs.position = Vector2i(x, y)
		add_child(obs)
		obstacles.append(obs)
		
func show_Score():
	#con el get node podemos conseguir los nodos dentre de la ecena de HUD
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / Score_modifier)
