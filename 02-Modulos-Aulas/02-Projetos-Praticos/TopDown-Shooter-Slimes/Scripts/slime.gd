extends CharacterBody2D
# Esse é o meu Slime

@onready var estagio : String

@onready var collision_desenvolvendo: CollisionShape2D = $Collision_Desenvolvendo
@onready var collision_pequeno: CollisionShape2D = $Collision_Pequeno
@onready var collision_grande: CollisionShape2D = $Collision_Grande
@onready var animated: AnimatedSprite2D = $Animated

@onready var timer_tiro: Timer = $Timer_Tiro
@onready var timer_ataque: Timer = $Timer_Ataque
@onready var timer_dividir: Timer = $Timer_Dividir
@onready var timer_crescer: Timer = $Timer_Crescer
@onready var timer_direcao: Timer = $Timer_Direcao

@onready var area_pequena: Area2D = $Area_Pequena
@onready var area_grande: Area2D = $Area_Grande

const SUAVIZACAO_ROTACAO = 0.3
const TIRO_SCENE = preload("res://Cenas/projetil_slime.tscn")
const SLIME_SCENE = preload("res://Cenas/slime.tscn")

var tiro_speed : float = 900.0
var velocidade : float = 200.0
var vida : int = 1
var vida_nova : int = 3
var virar_grande : bool = false
var tempo_virar_grande : float = 0.0
var tempo_recarga : float = 2

var posso_tiro = true
var devo_tiro = false
var seguir = false
var posso_atacar = false
var tempo_ataque = true

var devo_dividir = false
var posso_dividir = false

var player : CharacterBody2D = null

var dir : Vector2
var dir_definido = false

func _ready() -> void:
	# Inicializar estagio e propriedades do slime
	if estagio == null:
		estagio = "desenvolvendo"
	
	# Chama a função de ajuste para o início
	ajustar_estagio()

	# Iniciar o timer para mudar a direção periodicamente
	timer_direcao.start(2.0)  # Muda a direção a cada 2 segundos (ajuste conforme necessário)

func ajustar_estagio():
	match estagio:
		"desenvolvendo":
			animated.play("desenvolvendo")
			call_deferred("_ajustar_colisoes", true, false, false)
			virar_grande = bool(randi() % 2)
			tempo_virar_grande = randf_range(2.0, 4.0)
			timer_dividir.wait_time = tempo_virar_grande
			timer_dividir.start(tempo_virar_grande)
		"pequeno":
			animated.play("pequeno")
			call_deferred("_ajustar_colisoes", false, true, false)
			vida = randi_range(1, 3)
			velocidade = randf_range(250.0, 300.0)
			var tamanho = 0.75 + ((vida - 1) * 0.25)
			animated.scale = Vector2(tamanho, tamanho)
		"grande":
			animated.play("grande")
			call_deferred("_ajustar_colisoes", false, false, true)
			vida = randi_range(4, 6)
			velocidade = randf_range(200.0, 250.0)
			var tamanho_grande = 0.60 + ((vida - 3) * 0.10)
			animated.scale = Vector2(tamanho_grande, tamanho_grande)

func _ajustar_colisoes(desenvolvendo, pequeno, grande):
	collision_desenvolvendo.disabled = !desenvolvendo
	collision_pequeno.disabled = !pequeno
	collision_grande.disabled = !grande

func _physics_process(_delta: float) -> void:
	if estagio == "desenvolvendo":
		await animated.animation_finished
		vida = 1
		velocidade = randf_range(200.0, 400.0)
		animated.play("pequeno")
		estagio = "pequeno"
		collision_desenvolvendo.disabled = true
		collision_pequeno.disabled = false
		collision_grande.disabled = true
	else:
		movimentar(_delta)
		atirar(_delta)

func movimentar(_delta: float) -> void:
	if player and seguir:
		# Se o jogador estiver perto, o slime deve seguir o jogador
		look_at(player.global_position)
		velocity = (player.global_position - global_position).normalized() * velocidade
	else:
		# Caso contrário, se a direção não foi definida, o slime se move aleatoriamente
		if not dir_definido:
			dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			dir_definido = true
		
		velocity = dir * velocidade
		look_at(global_position + dir)  # Faz o slime olhar na direção da movimentação
	
	move_and_slide()

func atirar(_delta: float) -> void:
	if devo_tiro and posso_tiro:
		posso_tiro = false
		tempo_recarga = randf_range(2.0, 5.0)
		timer_tiro.start(tempo_recarga)
		var tiro = TIRO_SCENE.instantiate()
		tiro.position = global_position
		tiro.rotation = rotation
		tiro.linear_velocity = Vector2(tiro_speed, 0).rotated(tiro.rotation)
		
		get_parent().get_parent().get_node("Projeteis").add_child(tiro, true)

func levar_dano(_dano: int) -> void:
	vida_nova = vida - _dano
	if vida > 3 and vida_nova <= 3:
		vida = vida_nova
		estagio = "pequeno"
		global.slimes_g_vivos -= 1
		global.slimes_p_vivos += 1
		ajustar_estagio()
	elif vida_nova <= 0:
		explodir()
	else:
		vida = vida_nova

func explodir() -> void:
	# Criação de partículas de explosão e dano ao player
	global.slimes_p_vivos -= 1
	global.slimes_mortos += 1
	queue_free()

func dividir() -> void:
	if posso_dividir and estagio == "grande":
		timer_dividir.start()
		posso_dividir = false
		var novo_slime = SLIME_SCENE.instantiate()
		novo_slime.estagio = "desenvolvendo"
		novo_slime.global_position = global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
		get_parent().add_child(novo_slime)

func _on_area_pequena_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		devo_tiro = true
	
	if body.is_in_group("Projetil_Player"):
		seguir = true

func _on_area_pequena_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		devo_tiro = false

func _on_area_grande_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		seguir = true

func _on_area_grande_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguir = false

func _on_area_ataque_fisico_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		posso_atacar = true
		ataque_fisico()

func _on_area_ataque_fisico_body_exited(_body: Node2D) -> void:
	posso_atacar = false

func ataque_fisico():
	if tempo_ataque and posso_atacar:
		var _dano = 3
		player.levar_dano(_dano)
		tempo_ataque = false
		timer_ataque.start()

func _on_timer_tiro_timeout() -> void:
	posso_tiro = true

func _on_timer_ataque_timeout() -> void:
	tempo_ataque = true
	ataque_fisico()

func _on_timer_dividir_timeout() -> void:
	posso_dividir = true

func _on_timer_crescer_timeout() -> void:
	if vida <= 3:
		vida = max(3, 5)  # Simula o crescimento
		estagio = "grande"
		ajustar_estagio()

func _on_timer_direcao_timeout() -> void:
	dir_definido = false  # Permite ao slime escolher uma nova direção
