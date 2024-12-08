extends Area2D

@export var damage = 2
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitBoxTimer


func _ready() -> void:
	add_to_group("attack")

func tempdisable():
	collision.call_deferred("set","disabled",true)
	disableTimer.start()


func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set","disabled",false)
