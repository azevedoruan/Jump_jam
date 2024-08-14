extends Control
class_name BaseScreen

var fade_time: float = 0.5

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
	# destiva todos os botões dessa screen
	get_tree().call_group("buttons", "set_disable", true)


func appear() -> Tween:
	visible = true
	
	var tween_instance: Tween = get_tree().create_tween()
	tween_instance.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_instance.tween_property(self, "modulate:a", 1.0, fade_time)
	return tween_instance


func disappear() -> Tween:
	get_tree().call_group("buttons", "set_disable", true)
	
	var tween_instance: Tween = get_tree().create_tween()
	tween_instance.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_instance.tween_property(self, "modulate:a", 0.0, fade_time)
	return tween_instance
