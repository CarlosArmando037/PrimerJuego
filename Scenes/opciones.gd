extends Popup

func _ready():
	hide()  # Ocultamos al inicio

func _on_button_regresar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ui.tscn")

func _on_atras_button_pressed() -> void:
	hide()  # Solo ocultamos el Popup, no instanciamos nada
