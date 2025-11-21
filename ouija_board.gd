extends Node3D

## Binding class that handles the animation of responses.
## When given a phrase, it will handle the animation of the planchette upon the
## board by moving it to the proper positions in series.
## A signal will fire from the board when a spot is reached containing the
## symbol or phrase that has been indicated.
## Holds the board and planchette models.

signal moved(text: String)	# This signal will also output spaces in between words
signal shake_alert(intensity: float)

signal answer_complete			# Fired when the entire answer animation completes

@export var location_dict: Dictionary[String, Node3D]
@export var planchette: Node3D
@export var wiggle_length = 7.0
@export var base_move_time = 3.0
#@export var move_sfx: Array[AudioStreamWAV]
#@export var player: AudioStreamPlayer

var last_move: String = ""
var move_tween: Tween

var nonchar_phrases: Array[String] = [
	"YES", "NO", "MAYBE", "GOODBYE"
]

func animate_answer(answer: String, has_trauma: bool = false) -> void:
	answer = answer.to_upper()
	
	# determine if answer is preset phrase
	if answer in nonchar_phrases:
		move_planchette(answer, base_move_time, has_trauma)
		await moved
		answer_complete.emit()
		return
	
	# change animation time based on answer length
	var regex := RegEx.new()
	regex.compile("[^a-zA-Z0-9]")
	var cleaned_answer: String = regex.sub(answer, "", true)
	var move_time = base_move_time/cleaned_answer.length()
	move_time += move_time + 0.2
	
	# iterate through characters in response	
	for character in answer:
		#print("Character: ", character)
		move_planchette(character, move_time, has_trauma)
		if move_tween and move_tween.is_running():
			await moved
	
	answer_complete.emit()

func move_planchette(text: String, move_time: float = 1.0, has_trauma: bool = false, ) -> void:
	## Moves the planchette to a location on the board if it is in location_dict.
	## End gracefully if it does not exist (like with spaces and delimeters)
	
	if text in location_dict:
		# move planchette
		var destination: Vector3 = location_dict[text].position
		move_tween = create_tween()
		var rotate_distance = randf_range(-PI/6, PI/6)
		if text == last_move:
			# move out in a random direction to simulate doubling up
			move_time = move_time/2
			var wiggle_vector: Vector2 = Vector2.from_angle(randf_range(0.0, TAU)) * wiggle_length
			var wiggle_destination = destination + Vector3(wiggle_vector.x, 0, wiggle_vector.y)
			move_tween.tween_property(planchette, "position", wiggle_destination, move_time).set_ease(
				Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		
		#player.stream = move_sfx.pick_random()
		#player.play()
			
		move_tween.tween_property(planchette, "position", destination, move_time).set_ease(
			Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		move_tween.parallel().tween_property(planchette, "rotation", Vector3(0.0, rotate_distance, 0.0), 
				move_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
		await move_tween.finished
		last_move = text
		if has_trauma:
			shake_alert.emit(0.5)
	
	# emit moved signal upon success
	moved.emit(text)


func _on_answer_decided(answer: String, has_trauma: bool = false) -> void:
	#print(answer)
	animate_answer(answer, has_trauma)
	
