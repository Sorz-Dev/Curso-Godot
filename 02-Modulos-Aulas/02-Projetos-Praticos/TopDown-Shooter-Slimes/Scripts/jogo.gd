extends Node2D
# Esse daqui é o meu jogo, ele recebe um sinal caso o player ou os inimigos saiam do mapa

func _on_limite_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	pass
	#print(_body, _body.position)
