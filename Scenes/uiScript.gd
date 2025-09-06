extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/SeleccionPersonaje.tscn")


func _on_salir_button_pressed() -> void:
	get_tree().quit()


func _on_coleccion_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ColeccionItems.tscn")


func _on_opciones_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Opciones.tscn")
