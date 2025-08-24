extends Node2D

func _process(_delta: float) -> void:
	var selected_carousel_node = $CarouselContainer.position_offset_node.get_child($CarouselContainer.selected_index)
	
	

func _on_izquierda_button_pressed() -> void:
	$CarouselContainer._left()



func _on_derecha_button_pressed() -> void:
	$CarouselContainer._right()
