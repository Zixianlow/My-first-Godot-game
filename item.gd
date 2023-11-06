class_name Trophy extends Area2D

@export var item_label = "Press E to interact"
@export var item_type = "none"
@export var item_value = "none"
@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	sprite_2d.play("default")
