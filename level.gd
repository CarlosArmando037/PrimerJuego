extends Node2D
#---------------------precargar las ecenas de obstaculos
var spikes_scene = preload("res://spikes.tscn")
var turtle_scene = preload("res://turtle.tscn")
var bird_scene = preload("res://blue_bird.tscn")
var rino_scene = preload("res://rino.tscn")

var obstacles_type := [spikes_scene, rino_scene]
var obstacles : Array

# ---------------- Carriles disponibles (Y)
var lanes = [95, 206, 320]   # Ajusta estas posiciones según tu nivel

#aparicion de obstaculos
@export var min_gap : int = 300
@export var max_gap : int = 600
#----------------GAME VARIABLES
#const player_start_pos := Vector2i(-260,300)
#const cam_start_pos := Vector2i(0,180)

var score : int 
const Score_modifier : int = 30

var SPEED : float

#----------Velocidad inicial 
@export var START_SPEED : float = 5.0
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
	
	#$jugador.position = player_start_pos
	$jugador.velocity = Vector2i(0, 0)
	#$Camera2D.position = cam_start_pos
	#$ground_top.position = Vector2i(0, 125)
	#$ground_down.position = Vector2i(0, 350)
	#$ground_mid.position = Vector2i(0, 235)
	
	$HUD.get_node("ScoreLabel").show()
	
func _process(delta):
	if game_running:
		
		SPEED = START_SPEED
		
		#-------------------------------------------------aumento de velocidad del nivel
		#SPEED = START_SPEED + score / Speed_modifier
		#if SPEED > MAX_SPEED:
			#SPEED = MAX_SPEED
			
		#generar obstaculos funcion
		generate_obs()
		
		$jugador.position.x += SPEED
		$Camera2D.position.x += SPEED
		$wall_die.position.x += SPEED
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
			
			
@export var max_spawn : int = 3   
@export var max_obstacles : int = 12
func generate_obs():
	if last_obs == null or last_obs.position.x < score + randi_range(min_gap, max_gap):
		# Cuántos obstáculos generar en grupo
		
		var count = randi_range(1, max_spawn)
		
		var obs_x_base : int = screen_size.x + score + min_gap
		
		for i in range(count):
			var obs_type = obstacles_type[randi() % obstacles_type.size()]
			var obs = obs_type.instantiate()
			
			# --- La posición en X se separa con un offset ---
			var obs_x = obs_x_base + (i * (min_gap + 50))  # <- cada obstáculo se separa del otro
			var obs_y = lanes[randi() % lanes.size()]
			
			last_obs = obs
			add_obs(obs, obs_x, obs_y)

		
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)
		
func show_Score():
	#con el get node podemos conseguir los nodos dentre de la ecena de HUD
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / Score_modifier)
