extends CharacterBody2D

const GRAVITY : int = 2700
const JUMP_SPEED : int = -450
const DOUBLE_JUMP_SPEED : int = -715   # más fuerte que el primero
const DASH_TIME : float = 0.25
const MAX_JUMPS : int = 2              # 1 salto normal + 1 doble salto

var down_count : int = 0    
var jumps_left := MAX_JUMPS
var is_dashing := false
var dash_timer := 0.0

var dowm_timer: float = 0.0


func _physics_process(delta):
	
	#--------------funcion que sirve para tiempos------
		
	# --- DASH ---
	if is_dashing:
		velocity.y = 0
		velocity.x = 0
		$CollisionIdle.disabled = true
		$AnimatedSprite2D.play("dash")

		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			$CollisionIdle.disabled = false

		move_and_slide()
		return

	# --- GRAVEDAD ---
	velocity.y += GRAVITY * delta
	velocity.x = 0

	# Resetear saltos en el suelo
	if is_on_floor():
		jumps_left = MAX_JUMPS

	# --- CONTROLES ---
	if not get_parent().game_running:
		$AnimatedSprite2D.play("Idle")

	else:
		$CollisionIdle.disabled = false

		# Saltar o doble salto
		if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
			if jumps_left == MAX_JUMPS:  # primer salto
				velocity.y = JUMP_SPEED
				$JumpSound.play()
				$AnimatedSprite2D.play("jump")  # animación normal
			else:  # segundo salto
				velocity.y = DOUBLE_JUMP_SPEED
				$DoubleJumpSound.play()   # sonido distinto
				if $AnimatedSprite2D.sprite_frames.has_animation("double_jump"):
					$AnimatedSprite2D.play("double_jump") # si existe animación propia
				else:
					$AnimatedSprite2D.play("jump") # usa la misma si no hay otra
			jumps_left -= 1

		# Agacharse (solo en suelo)
		elif is_on_floor() and Input.is_action_just_pressed("ui_down"):
			$AnimatedSprite2D.play("duck")
			$CollisionIdle.disabled = true
			
			#down_count = down_count + 1
			down_count += 1
			print(down_count)
			
			if Input.is_action_just_pressed("ui_down") and down_count == 2:
				set_collision_mask_value(8,false)
				await get_tree().create_timer(0.1).timeout
				set_collision_mask_value(8,true)
				down_count = 0
				
		# Dash (solo con derecha)
		elif  is_on_floor() and Input.is_action_just_pressed("ui_right"):
			is_dashing = true
			dash_timer = DASH_TIME
			$AnimatedSprite2D.play("dash")
			return

		# Correr normal (solo en suelo)
		elif is_on_floor():
			$AnimatedSprite2D.play("run")
			

	# --- ANIMACIONES AÉREAS ---
	if not is_on_floor():
		if velocity.y < 0:  # subiendo
			$AnimatedSprite2D.play("jump")
		else:               # bajando
			$AnimatedSprite2D.play("fall")

	move_and_slide()
