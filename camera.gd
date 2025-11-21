extends Camera3D


@export var shake_noise: FastNoiseLite
@export var noise_speed: float = 300.0
@export var trauma_decay: float = 1.0
@export var sway_intensity: float = 3.0
@export var sway_rotation_intensity: float = PI/24
@export var sway_noise_speed: float = 4.0

var shake_trauma: float = 0.0
var time: float = 0.0

@onready var init_transform: Transform3D = global_transform
@onready var init_rotation: Vector3 = rotation


func _process(delta: float) -> void:
	time += delta
	shake_trauma = max(shake_trauma - delta * trauma_decay, 0.0)
	
	var shake_rot_x = PI/4 * get_shake_intensity() * get_noise_from_seed(0)
	var shake_rot_y = PI/4 * get_shake_intensity() * get_noise_from_seed(1)
	var shake_rot_z = PI/8 * get_shake_intensity() * get_noise_from_seed(2)
	
	var sway_translate_x = get_noise_from_seed(3, sway_noise_speed) * sway_intensity
	var sway_translate_y = get_noise_from_seed(4, sway_noise_speed) * sway_intensity
	
	var sway_rotate_x = get_noise_from_seed(5, sway_noise_speed) * sway_rotation_intensity * 0.4
	var sway_rotate_y = get_noise_from_seed(6, sway_noise_speed) * sway_rotation_intensity * 0.4
	var sway_rotate_z = get_noise_from_seed(7, sway_noise_speed) * sway_rotation_intensity * 0.4
	
	# Apply changes
	rotation.x = init_rotation.x + shake_rot_x + sway_rotate_x
	rotation.y = init_rotation.y + shake_rot_y + sway_rotate_y
	rotation.z = init_rotation.z + shake_rot_z + sway_rotate_z
	#global_transform.origin.x = init_transform.origin.x + sway_translate_x
	#global_transform.origin.y = init_transform.origin.y + sway_translate_y
	
	h_offset = 10 * get_shake_intensity() * randf_range(-1, 1) + sway_translate_x
	v_offset = 10 * get_shake_intensity() * randf_range(-1, 1) + sway_translate_y


func shake_cam(intensity: float) -> void:
	shake_trauma = clamp(shake_trauma + intensity, 0.0, 0.5)


func get_shake_intensity() -> float:
	return shake_trauma * shake_trauma


func get_noise_from_seed(_seed: int, speed: float = noise_speed) -> float:
	shake_noise.seed = _seed
	return shake_noise.get_noise_1d(time * speed)


func _on_ouija_board_shake_alert(intensity: float) -> void:
	shake_cam(intensity)
