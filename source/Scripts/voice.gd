extends SamplePlayer


onready var effect=get_node("/root/Editor/Control/Sound/Effect")
func _ready():
	pass


func _on_Exit_mouse_enter():
	effect.play("on")
	play("nar_wyjscie")


func _on_Help_mouse_enter():
	effect.play("on")
	play("nar_pomoc")


func _on_Save_mouse_enter():
	effect.play("on")
	play("nar_zapisz")

func _on_Load_mouse_enter():
	effect.play("on")
	play("nar_wczytaj")

func _on_Clear_mouse_enter():
	effect.play("on")
	play("nar_wyczysc")
