extends Node

const center = Vector2(0, 0)
const left = Vector2(-1, 0)
const right = Vector2(1,0)
const up = Vector2(0, -1)
const down = Vector2(0, 1)

func rand():
	var d = randi() % 8 + 1
	match d:
		1:
			return left
		2:
			return right
		3:
			return up
		4:
			return down
		5:
			return up + right
		6:
			return up + left
		7:
			return down + right
		8:
			return down + left

func toorand():
	var d = randi() % 2 + 1
	match d:
		1:
			return left
		2:
			return right