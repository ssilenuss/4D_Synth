@tool
extends Node
class_name Fifth_Scalor

var gynth : Node

func _ready() -> void:
	randomize()
	gynth = get_parent()
	gynth.end.connect(_on_gynth_end)

	
func _on_gynth_end()->void:
	var r0 := randi() % 2
	var fifth :float = 3/2
	if r0 == 1:
		fifth = 1.0
	
	var r1 := randi() %2
	var halver : float = 0.5
	if r1 == 1:
		halver = 1.0
		
		
	var r2 : float = randf()
	var speed : float = 1.0
	if r2 < 0.5:
		speed *=0.5
	elif r2 < 0.8:
		speed *= 0.25
	elif r2<0.95:
		speed *= 0.125
	else:
		speed *= 2
	
	
		
	gynth.pitch_scale = randi_range(1,5)*fifth* halver
	gynth.speed = speed
	gynth.limiter = randf()*10
