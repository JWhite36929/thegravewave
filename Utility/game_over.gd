extends Control


func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()