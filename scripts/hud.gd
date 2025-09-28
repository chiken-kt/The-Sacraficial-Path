extends CanvasLayer

var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$coincount.text = "Coins: " + str(coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_coin_1_body_entered(body: Node2D) -> void:
	coins += 1
	$coincount.text = "Coins: " + str(coins)


func _on_texture_button_pressed() -> void:
	if coins >= 150:
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	elif coins < 150:
		get_tree().change_scene_to_file("res://scenes/bad_ending.tscn")
