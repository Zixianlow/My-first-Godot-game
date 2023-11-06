class_name Left extends Area2D

@export var item_label = "Press A to move left"
@export var item_type = "none"
@export var item_value = "none"
@onready var sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	sprite_2d.play("default")
