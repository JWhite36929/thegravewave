extends Node

var starting_weapon: String = ""

func set_starting_weapon(weapon: String) -> void:
	starting_weapon = weapon

func get_starting_weapon() -> String:
	return starting_weapon

func clear_starting_weapon() -> void:
	starting_weapon = ""
