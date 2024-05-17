extends AbstractItem


func activate(_player: Player) -> void:
	Events.speed_multiplier.emit(15.0)
	Events.damage_multiplier.emit(15.0)
	Events.pierce_modifier.emit()
	Events.reload_speed_multiplier.emit(15.0)
	Events.range_multiplier.emit(15.0)
	Events.bullet_size_multiplier.emit(15.0)
