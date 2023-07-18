@tool
extends Button

@export_file var next_scene_path: = ""


func _get_configuration_warning() -> String:
	return "next_scene_path must be set for button to work" if next_scene_path == "" else ""


func _on_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(next_scene_path)
