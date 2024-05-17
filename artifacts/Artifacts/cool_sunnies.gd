extends AbstractItem


func activate(_player: Player) -> void:
	Events.cool_reload.emit()
