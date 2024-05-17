extends AbstractItem


func activate(_player: Player) -> void:
	Events.damage_multiplier.emit(-5.0)
	Events.reload_speed_multiplier.emit(5.0)
