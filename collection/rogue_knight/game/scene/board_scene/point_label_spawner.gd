extends Node3D

@export var point_label: PackedScene
@export var sfx_score_added: AudioStream
var audio_player: AudioStreamPlayer

func _ready() -> void:
	init_audio()

func spawn_point(score, location):
	var point = point_label.instantiate()
	point.text = "+" + str(score)
	point.global_position = location
	util.root.data_instance.score_added.emit(score)
	audio_player.play()
	self.add_child.call_deferred(point)
	
	await get_tree().create_timer(0.51).timeout
	point.queue_free()

func init_audio():
	audio_player = AudioStreamPlayer.new()
	audio_player.max_polyphony = 128
	audio_player.pitch_scale = 2.0
	var random_audio = AudioStreamRandomizer.new()
	audio_player.stream = random_audio

	random_audio.add_stream(0, sfx_score_added, 1.0)
	random_audio.playback_mode = AudioStreamRandomizer.PLAYBACK_SEQUENTIAL
	random_audio.random_pitch = 1.5
	self.add_child(audio_player)	
