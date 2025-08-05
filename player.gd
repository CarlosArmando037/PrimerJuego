extends CharacterBody2D

const GRAVITY : int = 3200
const JUMP_SPEED : int =-600

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		$CollisionIdle.disabled = false
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_SPEED
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("duck")
			$CollisionIdle.disabled = true
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
	move_and_slide()
