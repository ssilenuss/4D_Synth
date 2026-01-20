extends ColorRect

@export var playhead_color: Color = Color(0,0,1,1)
@export var envelope_color: Color = Color(1,1,0,1)
@export var osc_color : Color = Color(0,1,1,1)
@export var limiter_color:= Color(1,0,1,1)

#spectrum analyzer
@export var analyzer_idx : int
var vu_count: int = 16
var vu_scalor: float = 1
var freq_max: float = 20000
var min_db : float = 60
var animation_speed :float = 0.1
var spectrum: AudioEffectSpectrumAnalyzerInstance
var frequency_peaks : PackedFloat32Array = []
#var min_values : PackedFloat32Array = []
#var max_values : PackedFloat32Array = []

@export var gynth : AudioOsc2D

var env_points : PackedVector2Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_spectrum()

func init_spectrum()->void:

	var bus_idx :int = AudioServer.get_bus_index(gynth.bus)
	analyzer_idx = AudioServer.get_bus_effect_count(bus_idx)-1

	AudioServer.add_bus_effect(bus_idx, AudioEffectSpectrumAnalyzer.new())
	analyzer_idx = AudioServer.get_bus_effect_count(bus_idx)-1
	spectrum = AudioServer.get_bus_effect_instance(bus_idx, analyzer_idx, 0)
	vu_count = int(size.x/vu_scalor)
	frequency_peaks.resize(vu_count)
	frequency_peaks.fill(0.0)
	#min_values.resize(vu_count)
	#max_values.resize(vu_count)
	#min_values.fill(0.0)
	#max_values.fill(0.0)

func process_spectrum()->void:
	frequency_peaks = []
	var prev_hz : float = 0
	
	for i in range(1, vu_count +1):
		var hz : float = i*freq_max/float(vu_count)
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clampf((min_db + linear_to_db(magnitude)) / min_db, 0, 1)
		#var height : float = energy * size.y * height_scale
		var height : float = energy * size.y
		frequency_peaks.append(height)
		prev_hz = hz

		
	#for i in range(vu_count):
		#if data[i] > max_values[i]:
			#max_values[i] = data[i]
		#else:
			#max_values[i] = lerpf(max_values[i], data[i], animation_speed)
		#
		#if data[i]<= 0.0:
			#min_values[i] = lerpf(min_values[i], 0.0, animation_speed)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	if gynth.generating:
		process_spectrum()
		queue_redraw()


func draw_spectrum()->void:

	#var w : float = size.x/vu_count
	for i in range(vu_count):
		#var min_height : float = min_values[i]
		#var max_height : float = max_values[i]
		#var height = lerp(min_height, max_height, animation_speed)
		var height = frequency_peaks[i]

		var x : float = i*vu_scalor
		var c : Color = Color.from_hsv(float(i*0.5/vu_count), 0.5, 0.75)
		draw_line(Vector2(x, size.y),Vector2(x, size.y-height), c,vu_scalor)
		

func _on_resized() -> void:
	init_spectrum()
	queue_redraw()


		
func _draw() -> void:
	if gynth:
		if gynth.generating:
			draw_spectrum()
		
			#draw playhead
			var playhead_x : float = lerp(0.0, size.x, gynth.time/gynth.speed)
			draw_line(Vector2(playhead_x, 0.1),Vector2(playhead_x, size.y),playhead_color, 3.0)
			
			#draw waveform
			var buffer_limit : float = gynth.mix_rate/gynth.frequency*gynth.pitch_scale*4.0#*10.0
			var _draw_waveform : = false
			if gynth.osc_type == gynth.NOISE:
				_draw_waveform = true
			var last_frame :float= 1
			var x_index : int = 0
			
			var gynth_buffer_size :int = gynth.buffer.size()
			
			
			var buffer :PackedVector2Array= []
			for i in gynth_buffer_size:
				if _draw_waveform:
					if buffer.size()<=buffer_limit:
				
						var x : float = lerpf(0.0, size.x, x_index/buffer_limit)
						var y : float = 0
						if gynth.env_enabled:
							var a : float = gynth.envelope.sample_baked(x_index/buffer_limit)*gynth.limiter
							y = lerpf(size.y-1,1,  ((gynth.buffer[i].x*a)/2.5)+0.5)
						else:
							y = lerpf(size.y-1,1,  ((gynth.buffer[i].x*(gynth.limiter))/2.5)+0.5)
						buffer.append(Vector2(x,y))
						x_index+=1
				else:
				
					if last_frame <= 0.0 and gynth.buffer[i].x>0.0:
						_draw_waveform=true
						last_frame = gynth.buffer[i].x
					else:
						last_frame = gynth.buffer[i].x
			
			
			if buffer.size() > 5:
				draw_polyline(buffer, osc_color)
			
			#draw envelope
			if gynth.env_enabled:
				var env_pos : Vector2 = Vector2.ZERO
				for i in 100:
					env_pos.y = lerpf(size.y, 0.0, gynth.envelope.sample_baked(i/100.0))
					env_pos.x = lerpf(0.0, size.x, i/100.0)
					env_points.append(env_pos)
				
				draw_polyline(env_points, envelope_color)
				env_points = []

			#draw limiter line
			var lim_y : float = lerpf(size.y,0.0, gynth.limiter)
			draw_line(Vector2(0.0,lim_y), Vector2(size.x, lim_y),limiter_color)
			
