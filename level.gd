extends Node2D

#--------------------- Precargar las escenas de obstáculos
var spikes_scene = preload("res://enemigos/spikes.tscn")
var turtle_scene = preload("res://enemigos/turtle.tscn")
var bird_scene = preload("res://enemigos/blue_bird.tscn")
var rino_scene = preload("res://enemigos/rino.tscn")
var bat_scene = preload("res://enemigos/bat.tscn")
var bad_pig = preload("res://enemigos/bad_pig.tscn")
var lane_lower = preload("res://ground_down.tscn")
var lane_middle = preload("res://ground_mid.tscn")
var lane_upper = preload("res://ground_top.tscn")

#-------------------- Precargar las escenas de items
var item1 = preload("res://items/item_1.tscn")

var lanes = {
	"lower": 320,   # Carril inferior (cueva)
	"middle": 206,  # Carril intermedio
	"upper": 95     # Carril superior (cielo)
}
var items_scenes = [item1]
var obstacles_by_lane = {
	"lower": {
		"ground": [spikes_scene, rino_scene],
		"air": [bat_scene]
	},
	"middle": {
		"ground": [spikes_scene, bad_pig],
		"air": [bat_scene, bird_scene]
	},
	"upper": {
		"ground": [spikes_scene],
		"air": [bird_scene]
	}
}

#----------------- ProgressBAR
@export var level_Lenght : int = 2000
var progress : float = 0.0

#---------------- Carriles disponibles (Y)
var top_lane := [95]
var mid_lane := [206]
var bot_lane := [320]

# Aparición de obstáculos
@export var min_gap : int = 150
@export var max_gap : int = 300

@export var item_time = 25.0

#---------------- GAME VARIABLES
var score : int 
const Score_modifier : int = 30
var SPEED : float

# Velocidad inicial 
@export var START_SPEED : float = 5.0
const MAX_SPEED : int = 25
const Speed_modifier : int = 5000

var screen_size : Vector2i
var ground_height : int
var game_running : bool

var spawn_enemigos = true 
var last_obs
var obstacles : Array = []

#----------------- READY
func _ready():
	screen_size = get_window().size
	ground_height = $ground_down.position.y
	new_game()

func new_game():
	game_running = false
	$jugador.velocity = Vector2i(0, 0)

var items_spawned = false

#----------------- PROCESS
func _process(delta):
	if game_running:
		SPEED = START_SPEED
		progress += SPEED * delta
		$HUD.get_node("ProgressBar").value = progress
		print(progress)
		
		if progress >= item_time and not items_spawned:
			# Si quieres, puedes generar los items más lejos del jugador
			print("agarre un item")
			spawn_enemigos = false
			spawn_items_for_all_lanes()
			items_spawned = true
		# Mover jugador, cámara y pared de muerte
		$jugador.position.x += SPEED
		$Camera2D.position.x += SPEED
		$wall_die.position.x += SPEED		
		# Generar obstáculos
		generate_obs()
		
		# Actualización de suelos
		var ground_down_segments = [$ground_down, $ground_down2]
		var ground_mid_segments = [$ground_mid, $ground_mid2]
		var ground_top_segments = [$ground_top, $ground_top2]

		for seg in ground_down_segments:
			if $Camera2D.position.x - seg.position.x > screen_size.x * 1.5:
				seg.position.x += screen_size.x * 2

		for seg in ground_mid_segments:
			if $Camera2D.position.x - seg.position.x > screen_size.x * 1.5:
				seg.position.x += screen_size.x * 2

		for seg in ground_top_segments:
			if $Camera2D.position.x - seg.position.x > screen_size.x * 1.5:
				seg.position.x += screen_size.x * 2

	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

#----------------- Obstáculos
@export var max_spawn : int = 10
@export var max_obstacles : int = 12

func enemies_on_screen() -> bool:
	for obs in obstacles:
		if obs.is_inside_tree():  # sigue en escena
			return true
	return false
	
func spawn_items_for_all_lanes():
	var lane_keys = ["lower", "middle", "upper"]
	
	for lane_name in lane_keys:
		# Elegir item al azar
		var item_scene = items_scenes[randi() % items_scenes.size()]
		var item = item_scene.instantiate()
		var lane_y = lanes[lane_name]
		
		# Generar el item más lejos del jugador
		var item_x = $Camera2D.position.x + screen_size.x + 500
		item.position = Vector2(item_x, lane_y)
		
		add_child(item)
		
func generate_obs():
	if spawn_enemigos == true:
		if last_obs == null or last_obs.position.x < $Camera2D.position.x + randi_range(min_gap, max_gap):
			var count = randi_range(1, max_spawn)
			var obs_x_base : int = screen_size.x + $Camera2D.position.x + min_gap
			
			for i in range(count):
				# Elegir carril al azar
				var lane_keys = ["lower", "middle", "upper"]
				var lane_name = lane_keys[randi() % lane_keys.size()]
				var lane_y = lanes[lane_name]
				
				# Elegir tipo de obstáculo
				var type = "air" if randf() < 0.4 else "ground"
				if obstacles_by_lane[lane_name][type].size() == 0:
					type = "air"
				
				# Instanciar obstáculo
				var obs_type = obstacles_by_lane[lane_name][type][randi() % obstacles_by_lane[lane_name][type].size()]
				var obs = obs_type.instantiate()
				var obs_y = lane_y - 40 if type == "air" else lane_y
				var obs_x = obs_x_base + (i * (min_gap + 50))
				
				last_obs = obs
				add_obs(obs, obs_x, obs_y)
	else:
		pass

#----------------- Agregar obstáculo a la escena
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)
	if obstacles.size() > max_obstacles:
		var old = obstacles.pop_front()
		old.queue_free()
