extends Node
class_name GameMath

static func get_hit_position_2D(from_pos:Vector2, to_pos:Vector2, t_velocity:Vector2, projectile_speed:float)->Vector2:
	var q: = to_pos - from_pos
	q.y = 0.0
	t_velocity.y = 0.0
	
	var a:float = t_velocity.dot(t_velocity) - (projectile_speed * projectile_speed)
	var b:float = 2 * t_velocity.dot(q)
	var  c:float = q.dot(q) # Dot is basicly (q.x * q.x) + (q.y * q.y)
	var d = sqrt((b*b) - 4 * a * c)
	var t1:float = (-b + d) / (2 * a)
	var t2:float = (-b - d) / (2 * a)
	
	var time:float = max(t1, t2)
	var result:Vector2 = to_pos + time * t_velocity
	return result

static func dist_to_line_2d(pos:Vector2, line_start:Vector2, line_end:Vector2)->float:
	var ab: = line_end - line_start
	var ac: = pos - line_start
	if ac.dot(ab) <= 0.0:
		return ac.length()
	var bv: = pos - line_end
	if bv.dot(ab) >= 0.0:
		return bv.length()
	return ab.cross(ac) / ab.length()

static func dist_to_line_3d(pos:Vector3, line_start:Vector3, line_end:Vector3)->float:
	var ab: = line_end - line_start
	var ac: = pos - line_start
	if ac.dot(ab) <= 0.0:
		return ac.length()
	var bv: = pos - line_end
	if bv.dot(ab) >= 0.0:
		return bv.length()
	return ab.cross(ac).length() / ab.length()
