extends Resource
class_name DamageResource

signal received
signal given

@export_group("Giver")
@export var given_value:float
@export var strength:float

@export_group("Taker")
@export var resistance:float
@export var invulnerable_time:float = 0.5

@export_group("Event")
@export var direction:float
@export var position:Vector2
@export var received_value:float

