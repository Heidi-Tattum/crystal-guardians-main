extends Node2D

@onready var interactive_area: Area2D = $InteractiveArea
var player_nearby: bool = false

#var player: CharacterBody2D = null
#var is_retreating: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactive_area.body_entered.connect(
		_on_interactive_area_body_entered
	)
	interactive_area.body_exited.connect(
		_on_interactive_area_body_exited
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()
	pass

func interact() -> void:
	var dialogue_ui = get_tree().current_scene.get_node("DialogueUI")
	if dialogue_ui.is_open:
		return
	match QuestManager.quest_state:
		QuestManager.QuestState.NOT_STARTED:
				var mensajes: Array[String] = [
					"Guardian, I need your help!",
					"The enemies have scattered the three magic crystals around the city.",
					"Recover them quickly and bring them to me before they're lost."
				]
				dialogue_ui.show_dialogue(
					"Robbin Hood",
					mensajes
				)
				QuestManager.start_quest()
		QuestManager.QuestState.ACTIVE:
				var mensajes: Array[String] = [
					"There are still crystals missing.",
					"You've only found %d out of %d" % [
						QuestManager.collected_crystals,
						QuestManager.required_crystals
					]
				]
				dialogue_ui.show_dialogue(
					"Robbin Hood",
					mensajes
				)
		QuestManager.QuestState.READY_TO_DELIVER:
				var mensajes: Array[String] = [
					"Perfect! Thank you so much for helping me",
					"You’ve recovered all the crystals in time",
					"Now we can activate the portal."
				]
				dialogue_ui.show_dialogue(
				"Robbin Hood",
				mensajes
				)
				QuestManager.complete_quest()
		QuestManager.QuestState.COMPLETED:
				var mensajes: Array[String] = [
					"Thank you for your great help!",
					"The portal is ready to be used,",
					"Have a safe journey!"
				]
				dialogue_ui.show_dialogue(
					"Robbin Hood",
					mensajes
					)

func _on_interactive_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
			player_nearby = true
			
	pass # Replace with function body.


func _on_interactive_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
			player_nearby = false
	pass # Replace with function body.
