extends ColorRect
@export var audio_bus_name: String = "Buffer"
@export var analyzer_index: int = 1 # Index of the SpectrumAnalyzer effect on the bus
@export var capture_index: int = 2 # Index of the SpectrumAnalyzer effect on the bus
@export var osc_color : Color
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance
var ring_buffer : AudioEffectCapture
var waveform_points = []
var max_points: int = 1000 # Adjust as needed for desired history length
var trigger_level: float = 0
var trigger: bool = false
var triggering: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the SpectrumAnalyzer instance
	var bus_idx = AudioServer.get_bus_index(audio_bus_name)

	if bus_idx != -1:
		#spectrum_analyzer = AudioServer.get_bus_effect_instance(bus_idx, analyzer_index)
		ring_buffer = AudioServer.get_bus_effect(bus_idx, capture_index)
		print(bus_idx, ring_buffer)
	else:
		print("Audio bus not found:", audio_bus_name)

func _process(_delta)->void:
	var frames = ring_buffer.get_frames_available()


	if frames > 0:
		var temp_buffer = ring_buffer.get_buffer(frames)

		for t in temp_buffer.size():
			if trigger or not triggering:
				waveform_points.append(temp_buffer[t].x)
			else:
				if t==0:
					pass
				elif temp_buffer[t-1].x<trigger_level and temp_buffer[t].x>=trigger_level:
					trigger = true
					waveform_points.append(temp_buffer[t].x)
			if waveform_points.size() >= max_points:
				queue_redraw()
	
	
	
	#print(waveform_points.size(), ", ", ring_buffer.get_frames_available(), ", ", frames)
		
		
	#print(frames,", ", ring_buffer.get_frames_available())
	#if spectrum_analyzer:
		## Get magnitude data (e.g., average magnitude across a range)
		#var magnitude = spectrum_analyzer.get_magnitude_for_frequency_range(20, 20000).length() # Example range
		## Add to waveform_points, keeping a limited history
		#waveform_points.push_back(Vector2(waveform_points.size(), magnitude * 1000)) # Scale as needed
		#if waveform_points.size() > max_points:
			#waveform_points.remove_at(0)
		#queue_redraw() # Request a redraw

func _draw():
	print(waveform_points.size())
	if not waveform_points.is_empty():
		var x_index:int = 0
		var draw_buffer : PackedVector2Array = []
		for i in waveform_points.size():
			var x : float = lerpf(0.0, size.x, x_index/float(max_points))
			var y : float = 0
			y = lerpf(1,size.y,  (-1.0*waveform_points[i]+1)/2.0)
			draw_buffer.append(Vector2(x,y))
			x_index+=1
		draw_polyline(draw_buffer, osc_color)
		
		trigger = false
		waveform_points = []


func _on_osc_slider_value_changed(value: float) -> void:
	max_points = int(value)


func _on_osc_hscale_slider_value_changed(value: float) -> void:
	max_points = int(value)


func _on_osc_trigger_slider_value_changed(value: float) -> void:
	trigger_level = value


func _on_trigger_toggled(toggled_on: bool) -> void:
	triggering = toggled_on
