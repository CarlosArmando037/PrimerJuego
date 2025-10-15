extends CanvasLayer

var opciones_scene = load("res://Scenes/Opciones.tscn")
var opciones_instance

func _ready():
	opciones_instance = opciones_scene.instantiate()
	add_child(opciones_instance)
	opciones_instance.hide()

func _physics_process(delta):
	if Input.is_action_just_pressed("pause_game"):
		get_tree().paused = not get_tree().paused
		$ColorRect. visible = not $ColorRect.visible


func _on_opciones_button_pressed() -> void:
	opciones_instance.popup_centered()
	opciones_instance.grab_focus()


func _on_continuar_button_pressed() -> void:
	get_tree().paused = not get_tree().paused
	$ColorRect. visible = not $ColorRect.visible


func _on_salir_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/ui.tscn")
