extends Area2D

signal collected

var was_collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if was_collected:
		return

	# Solo se recolecta si colisiona con el jugador Y la misión está activa
	if body.is_in_group("player") and QuestManager.quest_state == QuestManager.QuestState.ACTIVE:
		was_collected = true
		collected.emit()
		queue_free()
