class_name KinematicEquations
# Some formulas allowing calculating unknown value for kinematic movement

static func get_displacement(initialVelocity:float, finalVelocity, time:float)->float:	#get_distance
	return (initialVelocity+finalVelocity) / 2 * time

static func get_final_velocity(initialVelocity:float, acceleration:float, time:float)->float:
	return initialVelocity + acceleration*time

static func get_displacement_initial(initialVelocity:float, time:float, acceleration:float)->float:
	return initialVelocity*time + (acceleration*(time*time))/2

static func get_displacement_final(finalVelocity:float, time:float, acceleration:float)->float:
	return finalVelocity*time + (acceleration*(time*time))/2

static func get_initial_velocity(distance:float, acceleration:float, finalVelocity:float = 0.0)->float:	#get jump height
	return sqrt((finalVelocity*finalVelocity)-2 * acceleration * distance)
