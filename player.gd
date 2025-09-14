extends CharacterBody2D

const GRAVITY : int = 2700
const JUMP_SPEED : int = -450
const DOUBLE_JUMP_SPEED : int = -715
const DASH_TIME : float = 0.25
const MAX_JUMPS : int = 2

# --- Nuevo: tiempo para reiniciar el contador ---
@export var DOWN_RESET_TIME: float = 0.4

var down_count : int = 0    
var jumps_left := MAX_JUMPS
var is_dashing := false
var dash_timer := 0.0
var down_timer: float = 0.0   # controla el tiempo de espera


func _physics_process(delta):
	# --- DASH ---
	if is_dashing:
		velocity.y = 0
		velocity.x = 0
		#$CollisionIdle.disabled = true
		$AnimatedSprite2D.play("dash")

		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			#$CollisionIdle.disabled = false

		move_and_slide()
		return

	# --- GRAVEDAD ---
	velocity.y += GRAVITY * delta
	velocity.x = 0

	# Resetear saltos en el suelo
	if is_on_floor():
		jumps_left = MAX_JUMPS

	# --- RESETEO DEL CONTADOR DE DOWN ---
	if down_count > 0:
		down_timer -= delta
		if down_timer <= 0:
			down_count = 0
			print("⏱️ Se reinició down_count a 0")

	# --- CONTROLES ---
	if not get_parent().game_running:
		$AnimatedSprite2D.play("Idle")
	else:
		$Collisionworld.disabled = false

		# Saltar o doble salto
		if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
			if jumps_left == MAX_JUMPS:
				velocity.y = JUMP_SPEED
				$Area2D/CollisionDuck.disabled = true
				$JumpSound.play()
				$AnimatedSprite2D.play("jump")
			else:
				velocity.y = DOUBLE_JUMP_SPEED
				$DoubleJumpSound.play()
				if $AnimatedSprite2D.sprite_frames.has_animation("double_jump"):
					$AnimatedSprite2D.play("double_jump")
				else:
					$AnimatedSprite2D.play("jump")
			jumps_left -= 1

		# Agacharse
		elif is_on_floor() and Input.is_action_just_pressed("ui_down"):
			$AnimatedSprite2D.play("duck")


			down_count += 1
			down_timer = DOWN_RESET_TIME   # reinicia el temporizador
			print("down_count =", down_count)

			# Si alcanzó 2 → atravesar piso
			if down_count == 2:
				set_collision_mask_value(8,false)
				await get_tree().create_timer(0.1).timeout
				set_collision_mask_value(8,true)
				down_count = 0   # reinicia el contador al usarlo

		# Dash
		elif is_on_floor() and Input.is_action_just_pressed("ui_right"):
			is_dashing = true
			dash_timer = DASH_TIME
			$AnimatedSprite2D.play("dash")
			return

		# Correr
		elif is_on_floor():
			$AnimatedSprite2D.play("run")
			#$Area2D/CollisionDuck.disabled = false

	# --- ANIMACIONES AÉREAS ---
	if not is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
	move_and_slide()
	

@export var knockback_speed: float = -200
@export var knockback_time: float = 0.3  # tiempo que retrocede e invulnerable

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemigos"):
		print("🔥 Detecté un enemigo con el Area2D")
		$AnimatedSprite2D.play("hit")
		$Area2D/CollisionIdle.set_deferred("disabled", true)
		$Area2D/CollisionDuck.set_deferred("disabled", true)
		##position.x -= 50
		
		var timer = knockback_time
		while timer > 0:
			position.x += knockback_speed * get_process_delta_time()
			timer -= get_process_delta_time()
			await  get_tree().process_frame
		
		$Area2D/CollisionIdle.set_deferred("disabled", false)
		$Area2D/CollisionDuck.set_deferred("disabled", false)
		pass # Replace with function body.

