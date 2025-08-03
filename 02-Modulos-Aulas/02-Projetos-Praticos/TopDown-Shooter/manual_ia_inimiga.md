# Manual de IA Inimiga (Inteligência Artificial)

Este documento descreve uma arquitetura para criar comportamentos de IA (Inteligência Artificial) para os inimigos do jogo, utilizando a Máquina de Estados (FSM) e os `Resource`s de dados que já definimos.

## 1. A Cena Base do Inimigo (`enemy_base.tscn`)

Em vez de criar cada inimigo do zero, criamos uma cena base que contém toda a lógica e nós compartilhados. Inimigos específicos serão variações desta cena.

- **Estrutura da Cena:**
  - `Enemy` (CharacterBody2D)
    - **Script:** `enemy.gd`
    - `AnimatedSprite2D`
    - `CollisionShape2D`
    - `StateMachine` (Node, com `StateMachine.gd`)
      - `Idle` (Node, com `enemy_idle_state.gd`)
      - `Patrol` (Node, com `enemy_patrol_state.gd`)
      - `Chase` (Node, com `enemy_chase_state.gd`)
      - `Attack` (Node, com `enemy_attack_state.gd`)
      - `Hurt` (Node, com `enemy_hurt_state.gd`)
    - `Hurtbox` (Area2D)
    - `PlayerDetector` (Area2D): Uma área grande que detecta quando o jogador entra no "raio de agro" do inimigo.
    - `AttackRange` (Area2D): Uma área menor que detecta quando o jogador está perto o suficiente para ser atacado.

## 2. O Script Principal do Inimigo (`enemy.gd`)

Este script é leve. Ele carrega os dados do `EnemyData` e delega todo o comportamento para a FSM.

- **Script (`enemy.gd`):**
  ```gdscript
  class_name Enemy
  extends CharacterBody2D

  @export var data: EnemyData # O Recurso que define este inimigo!
  
  var current_health: int
  var player_reference: Node2D = null # Referência ao jogador quando detectado

  func _ready():
      if not data: return
      
      current_health = data.max_health
      # Configura o sprite, colisão, etc., com base nos dados
      $AnimatedSprite2D.sprite_frames = load(data.sprite_sheet_path) # Exemplo
      
      # Conecta os sinais dos detectores
      $PlayerDetector.body_entered.connect(_on_player_detector_body_entered)
      $PlayerDetector.body_exited.connect(_on_player_detector_body_exited)

  func _physics_process(delta):
      move_and_slide()

  func take_damage(attack_data: Dictionary):
      # Lógica de dano como definida no manual de combate
      # ...
      if current_health <= 0:
          die()

  func die():
      # Lógica de morte (tocar animação, dropar loot, etc.)
      # LootSystem.drop_loot(data.loot_table, global_position)
      queue_free()

  func _on_player_detector_body_entered(body):
      if body.is_in_group("Player"):
          player_reference = body
          # Informa o estado atual que o jogador foi detectado
          $StateMachine.current_state.on_player_detected(body)

  func _on_player_detector_body_exited(body):
      if body == player_reference:
          player_reference = null
          # Informa o estado atual que o jogador saiu do alcance
          $StateMachine.current_state.on_player_lost()
  ```

## 3. Os Estados da IA

Aqui é onde a mágica acontece. Cada estado define um comportamento específico.

### 3.1. Estado de Patrulha (`enemy_patrol_state.gd`)
- **Herda de:** `State`
- **Lógica:**
  - `enter()`: Define um ponto de patrulha aleatório dentro de um raio ou pega o próximo ponto de um `Path2D`.
  - `process_physics(delta)`:
    - Move o inimigo em direção ao ponto de patrulha usando `owner.velocity`.
    - Se chegar ao ponto, espera um pouco (usando um `Timer`) e define um novo ponto.
  - `on_player_detected(player)`:
    - Transiciona para o estado de Perseguição: `state_machine.transition_to("Chase")`.

### 3.2. Estado de Perseguição (`enemy_chase_state.gd`)
- **Herda de:** `State`
- **Lógica:**
  - `process_physics(delta)`:
    - Se `owner.player_reference` não for nulo:
      - Calcula a direção até o jogador: `var direction = (owner.player_reference.global_position - owner.global_position).normalized()`.
      - Move-se nessa direção: `owner.velocity = direction * owner.data.move_speed`.
  - `on_player_lost()`:
    - Transiciona de volta para a Patrulha: `state_machine.transition_to("Patrol")`.
  - **Integração com `AttackRange`:**
    - Conecte os sinais `body_entered` e `body_exited` do `AttackRange` a este estado.
    - Se o jogador entrar no `AttackRange`, transicione para o estado de Ataque: `state_machine.transition_to("Attack")`.

### 3.3. Estado de Ataque (`enemy_attack_state.gd`)
- **Herda de:** `State`
- **Lógica:**
  - `enter()`:
    - Para o movimento: `owner.velocity = Vector2.ZERO`.
    - Toca a animação de ataque. A `AnimationPlayer` será responsável por ativar a `Hitbox` do inimigo no momento certo.
    - Inicia um `Timer` de "cooldown" do ataque.
  - `process(delta)`:
    - Não faz nada até o cooldown terminar.
  - `on_cooldown_timeout()`:
    - Verifica se o jogador ainda está no `AttackRange`.
    - Se sim, ataca novamente (chama `enter()` de novo ou uma função de ataque).
    - Se não, transiciona de volta para Perseguição: `state_machine.transition_to("Chase")`.

## 4. Criando Variações de Inimigos

Graças à abordagem orientada a dados, criar um novo inimigo é fácil:

1.  **Inimigo Estacionário (Torreta):**
    - Crie um `EnemyData` chamado `turret_data.tres`.
    - No estado `Patrol`, em vez de se mover, ele apenas gira.
    - No estado `Chase`, ele apenas mira no jogador, sem se mover.
    - O estado inicial na `StateMachine` pode ser `Idle` em vez de `Patrol`.

2.  **Inimigo Covarde:**
    - Crie um `EnemyData` chamado `coward_data.tres`.
    - Crie um novo estado `Flee.gd`.
    - Na função `take_damage` do `enemy.gd`, se a vida ficar abaixo de 25%, ele transiciona para o estado `Flee`, onde ele se move na direção *oposta* à do jogador.

3.  **Inimigo Mago:**
    - O estado `Attack` não ativa uma `Hitbox` corpo a corpo. Em vez disso, ele instancia uma cena de projétil mágico.

Esta arquitetura FSM + `Resource` permite criar uma variedade quase infinita de comportamentos de IA de forma limpa e organizada.
