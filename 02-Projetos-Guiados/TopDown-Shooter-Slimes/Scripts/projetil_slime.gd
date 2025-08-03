extends RigidBody2D 
# Esse é o projetil / tiro do slime

var velocidade = 900

func _physics_process(_delta: float) -> void:
	if velocidade > 0:
		velocidade -= 10
	else:
		velocidade = 0
	
	linear_velocity = Vector2(velocidade, 0).rotated(rotation)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Verifica se o corpo é parte do grupo "inimigos"
		var _dano = 3
		body.levar_dano(_dano)
		queue_free()  # Destroi o projetil após o acerto

func _on_timer_timeout() -> void:
	queue_free()  # Destroi o projetil após o acerto
