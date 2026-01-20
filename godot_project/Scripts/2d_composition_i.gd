@tool
extends Control


@export var debug := false
@export var control_scene : PackedScene

func _ready() -> void:
	for i in $Gynths.get_child_count():
		
		var gynth_controller: Gynth_Controller = $Gynths.get_child(i)

		gynth_controller.gynth.frequency = 110 * (i+1)
		gynth_controller.attack_slider.value = randf()#*(randi()%10)
		gynth_controller.decay_slider.value = randf()#*(randi()%10)
		gynth_controller.release_slider.value = randf()#*(randi()%10)
		gynth_controller.sustain_slider.value = randf()
		gynth_controller.speed_slider.value = randf()
		
		
		
		
		#c.gynth.frequency = 110 * i
	#c.gynth.attack = randf()*(randi()%10)
	#c.gynth.decay = randf()*(randi()%10)
	#c.gynth.release = randf()*(randi()%10)
	#c.gynth.sustain = randf()*(randi()%10)
	#c.gynth.speed = c.gynth.speed * randi_range(1,5)
	#c.gynth.set_generating(true)
		
func random_on_sphere(radius : float) -> Vector3:
	var theta = 2 * PI * randf()
	var phi = PI * randf()
	var x = sin(phi) * cos(theta) * radius
	var y = sin(phi) * sin(theta) * radius	
	var z = cos(phi) * radius
	return Vector3(x,y,z)

#
#func _on_timer_timeout() -> void:
	#$Timer.wait_time = randf()*10
	#$Gynths.get_child(0).queue_free()
	#spawn_gynth(randi()%oscs+1)
	#$Timer.start()
	#print($Timer.wait_time)
	#pass # Replace with function body.


func _on_timer_timeout() -> void:
	for i in get_tree().get_nodes_in_group("AudioOsc2D"):
		if (i as AudioOsc2D).generating:
			pass
		else:
			(i as AudioOsc2D).set_generating(true)
			print(i.generating)
			return
	pass # Replace with function body.
