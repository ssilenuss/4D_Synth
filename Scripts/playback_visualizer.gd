extends Control

var file : AudioStreamWAV

@export var texture_rect : TextureRect
@export var background_color : Color
@export var foreground_color : Color
@export var playhead_color : Color
@export var image_compression: float = 10.0 # How many samples in one pixel
@export var player : AudioStreamPlayer

var playback_position : float = 0
var end_position: float = 1.0

func _process(delta: float) -> void:
	if player.playing:
		playback_position = player.get_playback_position()
		queue_redraw()
	else:
		playback_position = 0.0
		

func update_preview() -> void:
	queue_redraw()
	
func convert_16WAV_toFloat()->PackedFloat32Array:
	var float_array : PackedFloat32Array = []
	var data : PackedByteArray = file.data
	var size: int = data.size()
	
	if size % 2 != 0:
		print("PackedByteArray is not even, invalid 16-bit PCM data")
		return float_array
	
	#step 2 because 16 bits uses 2 bytes, skip another 2 because stereo
	for i in range(0, size, 4):
		
		#wavs are signed, apparently
		var f : float = data.decode_s16(i)
		
		#normalize to -1, 1
		f = f/32768.0
		
		float_array.append(f)

	return float_array
	
func _draw()->void:
	draw_rect(Rect2(Vector2(0,0), size),background_color)
	
	if not file:
		return
		
	end_position= file.get_length()
	
	#draw waveform
	var float_array : PackedFloat32Array = convert_16WAV_toFloat()
	var float_array_size : int = float_array.size()
	if float_array_size >  0:
		var x_index:int = 0
		var draw_buffer : PackedVector2Array = []
		for i in float_array_size:
			var x : float = lerpf(0.0, size.x, x_index/float(float_array_size))
			var y : float = 0
			y = lerpf(1,size.y,  (-1.0*float_array[i]+1)/2.0)
			draw_buffer.append(Vector2(x,y))
			x_index+=1
		draw_polyline(draw_buffer, foreground_color)
		
	#draw playhead
	var playhead_x :float = lerpf(0.0, size.x, playback_position/end_position)
	var playhead_points : PackedVector2Array = [Vector2(playhead_x, 0.0), Vector2(playhead_x, size.y)]
	draw_polyline(playhead_points, playhead_color, 3.0)
		
	
	
	


func _on_playback_speed_slider_value_changed(value: float) -> void:
	player.pitch_scale = value
