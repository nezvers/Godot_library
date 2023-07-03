## Stores Character movement state
class_name Character2DStateResource
extends Resource

## Velocity gets manipulated in Character movement logic, but also can be influenced externally.
@export var velocity:Vector2
## Reflects characters grounded state
@export var is_grounded:bool
## Reflects character jumping state
@export var is_jumping:bool
## stores last time when dash has been triggered.
var dash_time:float

