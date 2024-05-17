extends AbstractItem


func activate(_player: Player) -> void:
	Events.bullet_size_multiplier.emit(10.0)
