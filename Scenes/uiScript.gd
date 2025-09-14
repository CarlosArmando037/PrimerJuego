extends Control

var opciones_scene = load("res://Scenes/Opciones.tscn")
var opciones_instance

func _ready():
	opciones_instance = opciones_scene.instantiate()
	add_child(opciones_instance)
	opciones_instance.hide()

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
	opciones_instance.popup_centered()
	opciones_instance.grab_focus()
