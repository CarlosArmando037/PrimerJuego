extends Area2D


@export var push_value: float = 150  # cada ítem tiene su propio valor



func _on_body_entered(body):
	if body.is_in_group("jugador") and body.has_method("mover_a_la_derecha"):
		body.mover_a_la_derecha(push_value)
		queue_free()
