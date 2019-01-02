extends Control

var time=0
var ss

func _ready():
	set_fixed_process(true)
func _fixed_process(delta):
	var scr=get_node("ScrollBar").get_value()
	set_pos(Vector2(scr,0))


func _on_Exit_pressed():
	get_tree().quit()


func _on_Help_pressed():
	pass # replace with function body


