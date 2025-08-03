extends RigidBody2D 
# Esse é o projetil / tiro do player

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Inimigos"):  # Verifica se o corpo é parte do grupo "inimigos"
		var _dano = global.get(global.arma + "_dano")
		body.levar_dano(_dano)
		queue_free()  # Destroi o projetil após o acerto

func _on_timer_timeout() -> void:
	queue_free()
