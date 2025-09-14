@tool
extends Control

func _on_pesonaje_pressed():
	get_tree().change_scene_to_file("res://Scenes/Niveles.tscn")
func _on_button_regresar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ui.tscn")
