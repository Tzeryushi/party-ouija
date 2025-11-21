class_name Letter
extends Label


var mirror_label: Label = null : set = set_mirror
var move_tween: Tween


func _process(delta) -> void:
	hover(delta)


func update_text(new_text: String) -> void:
	text = new_text
	if text == " ":
		text = "  "
	pivot_offset = size/2.0


func set_mirror(label_node: Label) -> void:
	mirror_label = label_node


func fade_to_destination(time: float = 1.0) -> void:
	if move_tween and move_tween.is_running():
		move_tween.kill()
	move_tween = create_tween()
	#move_tween.tween_property(self, "global_position", mirror_label.global_position, time).set_ease(
	#	Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	move_tween.tween_property(self, "modulate:a", 1.0, time).set_ease(
		Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func fade_to_free(time: float = 1.0) -> void:
	if move_tween and move_tween.is_running():
		move_tween.kill()
	move_tween = create_tween()
	move_tween.tween_property(self, "modulate:a", 0.0, time).set_ease(
		Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await move_tween.finished
	queue_free()


func hover(delta) -> void:
	if mirror_label:
		global_position = global_position.lerp(mirror_label.global_position, delta * 3.0)
