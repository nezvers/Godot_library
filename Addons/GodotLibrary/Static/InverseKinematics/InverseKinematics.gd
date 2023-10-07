class_name InverseKinematics
extends Node

static func fabric_2d(length_list:PackedFloat32Array, from:Vector2, to:Vector2, itterations:int = 10, error_margin:float = 0.1)->PackedVector2Array:
	# TODO: maybe need to take in PackedVector2Array
	var joint_count: = length_list.size()
	var point_list: = PackedVector2Array()
	point_list.resize(joint_count +1)
	var total_length: = GameMath.packed_float32_total(length_list)
	var target_distance: = to - from
	var normal: = target_distance.normalized()
	point_list[0] = from
	
	# position in a straight line
	# TODO: maybe do only if target is too far
	for i in joint_count:
		point_list[i+1] = point_list[i] + length_list[i] * normal
	if target_distance.length() >= total_length:
		return point_list
	
	var last_i: = joint_count +1
	for it in itterations:
		# backward reach
		point_list[last_i] = to
		for i in joint_count:
			var p1: = point_list[last_i -i]
			var p2: = point_list[last_i -i -1]
			var dir: = (p2 - p1).normalized()
			point_list[last_i -i -1] = point_list[last_i -i] + dir * length_list[last_i -i -1]
		# forward reach
		point_list[0] = from
		for i in joint_count:
			var p1: = point_list[i]
			var p2: = point_list[i + 1]
			var dir: = (p2 - p1).normalized()
			point_list[i + 1] = point_list[i] + length_list[i] * dir
		
		# check error_margin
		var tip_distance:float = (to -point_list[last_i]).length()
		if tip_distance <= error_margin:
			break
	return point_list
