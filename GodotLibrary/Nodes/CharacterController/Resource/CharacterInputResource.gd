## Resource for Character movement. Character will move depending on set values in it.
class_name CharacterInputResource
extends Resource

## Bypass variable manipulation
@export var enabled:bool = true
## Set direction to move
@export var move_direction:Vector2
## Characters responds with jumping functionality
@export var jump:bool
## Characters responds with dashing functionality
@export var dash:bool
## Characters responds with attack functionality
@export var attack:bool

