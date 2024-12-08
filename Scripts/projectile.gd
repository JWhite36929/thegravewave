extends Area2D

var direction = Vector2.ZERO
var speed = 55
var damage = 8

func _ready():   
	add_to_group("attack")
	

func _physics_process(delta):
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()
