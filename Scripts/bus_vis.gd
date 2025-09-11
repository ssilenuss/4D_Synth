extends ColorRect
@export var audio_bus_name: String = "Master"
@export var analyzer_index: int = 1 # Index of the SpectrumAnalyzer effect on the bus
@export var capture_index: int = 2 # Index of the SpectrumAnalyzer effect on the bus
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance
var ring_buffer : AudioEffectCapture
var waveform_points = []
var max_points: int = 1000 # Adjust as needed for desired history length
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the SpectrumAnalyzer instance
	var bus_idx = AudioServer.get_bus_index(audio_bus_name)
	if bus_idx != -1:
		spectrum_analyzer = AudioServer.get_bus_effect_instance(bus_idx, analyzer_index)
		ring_buffer = AudioServer.get_bus_effect(bus_idx, capture_index)
	else:
		print("Audio bus not found:", audio_bus_name)

func _process(_delta)->void:
	waveform_points = []
	var prev_length = ring_buffer.get_frames_available()
	
	for i in 512:
		waveform_points.push_back(ring_buffer.get_buffer(i))
	
	print(waveform_points)
	
	print(prev_length, ring_buffer.get_buffer_length_frames())
	#if spectrum_analyzer:
		## Get magnitude data (e.g., average magnitude across a range)
		#var magnitude = spectrum_analyzer.get_magnitude_for_frequency_range(20, 20000).length() # Example range
		## Add to waveform_points, keeping a limited history
		#waveform_points.push_back(Vector2(waveform_points.size(), magnitude * 1000)) # Scale as needed
		#if waveform_points.size() > max_points:
			#waveform_points.remove_at(0)
		#queue_redraw() # Request a redraw

func _draw():
	if not waveform_points.is_empty():
		# Draw the waveform as a series of lines
		for i in range(1, waveform_points.size()):
			var p1 = waveform_points[i-1]
			var p2 = waveform_points[i]
			# Adjust x-coordinates to fit the drawing area
			var x1 = lerp(0.0, size.x, float(i-1) / float(max_points - 1))
			var x2 = lerp(0.0, size.x, float(i) / float(max_points - 1))
			draw_line(Vector2(x1, size.y - p1.y), Vector2(x2, size.y  - p2.y), Color.WHITE, 2)
