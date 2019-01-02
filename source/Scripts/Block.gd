extends Sprite

func _ready():
	pass

func _on_Area2D_input_event( viewport, event, shape_idx ):
	if event.type==InputEvent.MOUSE_BUTTON:
		get_node("/root/Editor/Skala").name=get_position_in_parent()
