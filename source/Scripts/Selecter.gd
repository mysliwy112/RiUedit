extends TextureButton

func _ready():
	pass
func _on_Panel_pressed():
	var sel
	sel=int(get_local_mouse_pos().x/92)
	if sel>7:
		sel=7
	get_node("Select").set_pos(Vector2(sel*92,0))
	if get_local_mouse_pos().y>94.5:
		sel+=8
		get_node("Select").set_pos(Vector2(get_node("Select").get_pos().x,92))
		if sel>13:
			sel+=1
	get_node("../../Skala").enm=sel
