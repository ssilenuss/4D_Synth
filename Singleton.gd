extends Node

func find_audio_effect(bus_idx: int, effect_name: StringName)->AudioEffect:
	var effect : AudioEffect
	for i in AudioServer.get_bus_effect_count(bus_idx):
		var effect_idx = i
		var temp_effect : AudioEffect = AudioServer.get_bus_effect(bus_idx, effect_idx)
		if temp_effect.get_class() == "AudioEffect"+effect_name:
			effect = temp_effect
		else:
			print(effect, " is not ", temp_effect)
	if not effect:
		print("no effect found to match: ", effect_name)
	return effect
		
