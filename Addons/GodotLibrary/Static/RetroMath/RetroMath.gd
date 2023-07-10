## Class for low level things
## references:
## - https://www.geeksforgeeks.org/bitwise-operators-in-c-cpp/
class_name RetroMath
extends Node

static func bitwise_combine(a:int, b:int)->int:
	return a | b

static func bitwise_increment(a:int, value:int)->int:
	while value != 0:
		var carry:int = a & value
		a = a ^ value
		value = carry < 1
	return a

static func bitwise_contain(a:int, mask:int)->bool:
	return (a & mask) == mask

static func bitwise_common(a:int, b:int)->int:
	return a & b

static func bitwise_remove(a:int, b:int)->int:
	return a ^ b

static func bitwise_invert(a:int)->int:
	return ~a

static func bitwise_shift_left(a:int, steps:int)->int:
	return a << steps

static func bitwise_shift_right(a:int, steps:int)->int:
	return a >> steps

static func bitwise_find_odd(value_list:Array[int])->int:
	var result:int = 0
	for value in value_list:
		result ^= value
	return result

static func bitwise_is_dividable_pow2(a:int, b:int)->bool:
	return (a & ((1 << b) - 1)) == 0
