extends RigidBody2D

var done=true
var wait=false
func _ready():
	set_fixed_process(true)
func _fixed_process(delta):
	if done==false:
		var bodies = get_colliding_bodies()
		for body in bodies:
			body.queue_free()
		get_node("../Skala").core_create()
		done=true
	if wait==true:
		wait=false
		done=false
	
func destr(pos):
	set_pos(Vector2(pos*149+74.5,400))
	wait=true
