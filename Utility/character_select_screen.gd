extends Control

const MAIN_SCENE = "res://Scenes/main.tscn"

func _on_button_1_pressed() -> void:
	GameStateManager.set_starting_weapon("sword1")
	get_tree().change_scene_to_file(MAIN_SCENE)

func _on_button_2_pressed() -> void:
	GameStateManager.set_starting_weapon("axe1")
	get_tree().change_scene_to_file(MAIN_SCENE)

func _on_button_3_pressed() -> void:
	GameStateManager.set_starting_weapon("shield1")
	get_tree().change_scene_to_file(MAIN_SCENE)
