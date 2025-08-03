extends CharacterBody2D
# Esse é o código completo do Player

# Constantes
const VELOCIDADE = 380.0
const TIRO_SPEED = 1000.0
const DISTANCIA_MINIMA_MIRA = 60.0
const SUAVIZACAO_ROTACAO = 0.3 # Fator de suavização da rotação
const TIRO_SCENE = preload("res://Cenas/projetil.tscn")
const TEMPO_RECARGA = 2.0 # Tempo de recarga em segundos

# Referências para as partes do player
@onready var collision: CollisionShape2D = $Collision
@onready var pes : AnimatedSprite2D = $Pes
@onready var pistola: AnimatedSprite2D = $Pistola
@onready var espingarda: AnimatedSprite2D = $Espingarda
@onready var metralhadora: AnimatedSprite2D = $Metralhadora
@onready var mira: Marker2D = $Pistola/Mira
@onready var mira_arma: Sprite2D = $Pistola/Mira_Arma
@onready var arma_atual : AnimatedSprite2D = $Pistola
@onready var dlay: Timer = $Pistola/Dlay
@onready var timer_levar_dano: Timer = $Timer_Levar_Dano
@onready var timer_anim_dano: Timer = $Timer_Anim_Dano
@onready var timer_parar_dano: Timer = $Timer_Parar_Dano
@onready var reiniciar: Timer = $"../../Reiniciar"
# Variáveis de controle
var dispositivo = 0 # 0: Teclado e Mouse, 1: Controle, 2: Touch
var mira_ativa = true
var mira_visivel = false
var acertos = 0
var recarregando = false
var tempo_recarga_restante = 0.0
var posso_atirar = true
var quero_mudar = false
var posso_levar_dano = true
var anim_dano = false
var exibir_player = true

# Método de entrada, para detectar o dispositivo de entrada
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		dispositivo = 0
	elif event is InputEventJoypadMotion or event is InputEventJoypadButton:
		dispositivo = 1
	elif event is InputEventScreenTouch or event is InputEventScreenDrag:
		dispositivo = 2

# Configuração inicial das armas e dos sinais
func _ready() -> void:
	atualizar_arma()
	mira_arma.visible = mira_visivel

# Função de atualização de física, movimentação e mira
func _physics_process(_delta: float) -> void:
	movimentar_player(_delta)
	ajustar_mira(_delta)
	atirar(_delta)
	
	if Input.is_action_just_pressed("mudar_arma"):
		quero_mudar = true
	
	
	if Input.is_action_just_pressed("exibir_player"):
		exibir_player = not exibir_player
		arma_atual.visible = exibir_player

# Método para definir a arma atual
func atualizar_arma() -> void:
	if global.arma == "pistola":
		arma_atual = pistola
		mira = $Pistola/Mira
		mira_arma = $Pistola/Mira_Arma
		dlay = $Pistola/Dlay
		
		pistola.visible = true
		espingarda.visible = false
		metralhadora.visible = false
	
	elif global.arma == "espingarda":
		arma_atual = espingarda
		mira = $Espingarda/Mira
		mira_arma = $Espingarda/Mira_Arma
		dlay = $Espingarda/Dlay
		
		pistola.visible = false
		espingarda.visible = true
		metralhadora.visible = false
	
	elif global.arma == "metralhadora":
		arma_atual = metralhadora
		mira = $Metralhadora/Mira
		mira_arma = $Metralhadora/Mira_Arma
		dlay = $Metralhadora/Dlay
		
		pistola.visible = false
		espingarda.visible = false
		metralhadora.visible = true
	
	else:
		global.arma = "pistola"
		arma_atual = pistola
		mira = $Pistola/Mira
		mira_arma = $Pistola/Mira_Arma
		dlay = $Pistola/Dlay
		
		pistola.visible = true
		espingarda.visible = false
		metralhadora.visible = false
	
	mira_arma.visible = mira_visivel
	
	arma_atual.visible = exibir_player

# Função para movimentar o player
func movimentar_player(_delta: float) -> void:
	var direcao : Vector2
	direcao.x = Input.get_axis("left", "right")
	direcao.y = Input.get_axis("up", "down")

	# Normaliza a direção para garantir velocidade constante
	if direcao.length() > 0:
		direcao = direcao.normalized()

	# Aplica a velocidade ao movimento
	velocity = direcao * VELOCIDADE

	# Movimento
	move_and_slide()
	
	# Mudando animação do personagem
	if direcao:
		pes.animation = "andando"
	else:
		pes.animation = "parado"
	
	# Esperar a animação da arma terminar antes de mudar para a animação do personagem
	if not arma_atual.animation == "parado" and not arma_atual.animation == "andando":
		await arma_atual.animation_finished  # Espera a animação da arma terminar
		
		if arma_atual.animation == "recarregando":
			recarregando = false
			global.set(global.arma + "_municao", global.get(global.arma + "_municao_max"))
		
		arma_atual.play(pes.animation)
		
	elif arma_atual.animation != pes.animation:
		arma_atual.play(pes.animation)
	
	if arma_atual.animation == pes.animation and quero_mudar:
		var indice_arma_atual = global.armas.find(global.arma)
		indice_arma_atual = (indice_arma_atual + 1) % global.armas.size()
		global.arma = global.armas[indice_arma_atual]
		atualizar_arma()
		quero_mudar = false

# Função para ajustar a mira do player
func ajustar_mira(_delta: float) -> void:
	if dispositivo == 0: # Mouse e Teclado
		var mouse_pos = get_global_mouse_position()
		var pos_arma = mira_arma.global_position
		var distancia = position.distance_to(mouse_pos)
		var angulo_mira = atan2(mouse_pos.y - pos_arma.y, mouse_pos.x - pos_arma.x)
		var angulo_player = atan2(mouse_pos.y - position.y, mouse_pos.x - position.x)
		
		# Suavizar rotação
		if distancia > DISTANCIA_MINIMA_MIRA and mira_ativa:
			rotation = lerp_angle(rotation, angulo_mira, SUAVIZACAO_ROTACAO)
		else:
			rotation = lerp_angle(rotation, angulo_player, SUAVIZACAO_ROTACAO)

		mira_arma.look_at(mouse_pos)

		# Alternar mira ativa
		if Input.is_action_just_pressed("mira"):
			mira_ativa = not mira_ativa

		# Alternar visibilidade da mira
		if Input.is_action_just_pressed("mira_visivel"):
			mira_visivel = not mira_visivel
			mira_arma.visible = mira_visivel

	elif dispositivo == 1: # Controle
		var dir_x = Input.get_axis("left_mira", "right_mira")
		var dir_y = Input.get_axis("up_mira", "down_mira")
		var direcao = Vector2(dir_x, dir_y)

		# Ajusta a rotação da mira com base na entrada do controle
		if direcao.length() != 0:
			look_at(global_position + direcao.normalized() * mira.position)
		else:
			# Movimento do player ajusta a rotação
			var dir_player_x = Input.get_axis("left", "right")
			var dir_player_y = Input.get_axis("up", "down")
			var direcao_player = Vector2(dir_player_x, dir_player_y)

			if direcao_player.length() != 0:
				look_at(global_position + direcao_player.normalized() * mira.position)

# Função para atirar
func atirar(_delta: float) -> void:
	if global.get(global.arma + "_municao") == null or global.get(global.arma + "_municao") < 0:
		global.set(global.arma + "_municao", 0)
	
	if (recarregando == false and global.get(global.arma + "_municao") == 0) or Input.is_action_just_pressed("recaregar"):
		recarregando = true
		arma_atual.play("recarregando")

	# Verifica se a munição está disponível e o player pode atirar
	if Input.is_action_pressed("atirar") and global.get(global.arma + "_municao") > 0 and posso_atirar and not recarregando:
		posso_atirar = false
		arma_atual.play("atirando")
		global.set(global.arma + "_municao", global.get(global.arma + "_municao") - 1)
		
		var tiro_instance = TIRO_SCENE.instantiate()
		tiro_instance.global_position = mira_arma.global_position
		tiro_instance.rotation = rotation
		tiro_instance.linear_velocity = Vector2(TIRO_SPEED, 0).rotated(tiro_instance.rotation)
		
		get_parent().get_node("Projeteis").add_child(tiro_instance, true)
		
		dlay.start()

# Função para levar dano
func levar_dano(_dano: int) -> void: 
	if posso_levar_dano:
		global.vida -= _dano
		posso_levar_dano = false
		timer_levar_dano.start()
		timer_anim_dano.start()
		
		pes.self_modulate.g = 0
		arma_atual.self_modulate.g = 0
		
		pes.self_modulate.b = 0
		arma_atual.self_modulate.b = 0
		
		anim_dano = true
		alterar_cor_piscar()  # Inicia o efeito de piscada
		
		timer_parar_dano.start()

# Função para alterar a cor de piscada
func alterar_cor_piscar() -> void:
	if anim_dano:
		pes.self_modulate = Color(1, 0, 0)
		arma_atual.self_modulate = Color(1, 0, 0)
	else:
		pes.self_modulate = Color(1, 1, 1)
		arma_atual.self_modulate = Color(1, 1, 1)

# Função chamada quando o delay do tiro termina
func _on_dlay_timeout() -> void:
	posso_atirar = true

# Função chamada quando o timer de invulnerabilidade (levar dano) expira
func _on_timer_levar_dano_timeout() -> void:
	posso_levar_dano = true

# Função chamada quando o timer de animação de dano expira
func _on_timer_anim_dano_timeout() -> void:
	anim_dano = not anim_dano
	alterar_cor_piscar()

func _on_timer_parar_dano_timeout() -> void:
	timer_anim_dano.stop()
	anim_dano = false 
	alterar_cor_piscar()
