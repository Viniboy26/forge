extends Resource
class_name Cooldown


var last_usage: int = -1

func get_cooldown_percentage(cooldown_time: float):
	if last_usage == -1:
		return 0
	return max(cooldown_time * 1000 - (Time.get_ticks_msec() - last_usage), 0) / (cooldown_time * 1000)
	

func trigger():
	last_usage = Time.get_ticks_msec()
