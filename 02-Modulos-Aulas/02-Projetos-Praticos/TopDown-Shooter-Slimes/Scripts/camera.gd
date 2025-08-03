extends Camera2D
# Essa é a Minha Camera

var player : CharacterBody2D
var cmx = 0.0
var cmy = 0.0

func _ready() -> void:
	if has_node("/root/Controlador/Jogo/Player"):
		player = $"/root/Controlador/Jogo/Player" 
		cmx = player.position.x
		cmy = player.position.y
		position = Vector2(cmx, cmy)
	
	limit_right = global.level_largura
	limit_bottom = global.level_altura

func _process(_delta: float) -> void:
	if has_node("/root/Controlador/Jogo/Player"):
		player = $"/root/Controlador/Jogo/Player" 
		cmx = lerp(cmx, player.position.x, 0.06)
		cmy = lerp(cmy, player.position.y, 0.06)
		position = Vector2(cmx, cmy)
