extends Area2D

@export var experience = 5

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShap2D


func _ready() -> void:
	add_to_group("loot")

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta #times delta to divide speed by the framerate
		
func collect():
	queue_free()
	return experience
