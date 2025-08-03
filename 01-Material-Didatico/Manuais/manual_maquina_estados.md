# Manual da Máquina de Estados (FSM)

Este documento detalha uma arquitetura robusta e reutilizável para uma Máquina de Estados Finitos (Finite State Machine - FSM), essencial para controlar o comportamento do jogador e da IA.

## 1. A Lógica da Máquina de Estados

A FSM tem dois componentes principais:
1.  **A Máquina (`StateMachine.gd`):** Um nó que gerencia o estado atual e as transições.
2.  **Os Estados (`State.gd` e seus filhos):** Nós individuais, cada um representando um comportamento específico (ex: `Idle`, `Run`, `Attack`).

## 2. O Gerenciador: `StateMachine.gd`

Este script é adicionado a um nó (`Node` ou `Node2D`) que será o gerenciador dos estados.

- **Nó:** `StateMachine` (Node)
- **Script (`StateMachine.gd`):**
  ```gdscript
  class_name StateMachine
  extends Node

  # O estado inicial a ser ativado. Definido no Inspector.
  @export var initial_state: State
  
  var current_state: State
  var states: Dictionary = {} # Armazena os estados filhos por nome

  func _ready():
      # Mapeia todos os nós de estado filhos para acesso rápido
      for child in get_children():
          if child is State:
              states[child.name.to_lower()] = child
              child.state_machine = self # Fornece uma referência da máquina para o estado
      
      # Inicia no estado inicial
      if initial_state:
          current_state = initial_state
          current_state.enter()

  func _process(delta):
      if current_state:
          current_state.process(delta)

  func _physics_process(delta):
      if current_state:
          current_state.process_physics(delta)

  func handle_input(event: InputEvent):
      if current_state:
          current_state.handle_input(event)

  func transition_to(state_name: String, payload: Dictionary = {}):
      var new_state_name = state_name.to_lower()
      if not states.has(new_state_name) or states[new_state_name] == current_state:
          return

      if current_state:
          current_state.exit()

      current_state = states[new_state_name]
      current_state.enter(payload) # Passa dados opcionais para o novo estado
  ```

## 3. A Classe Base do Estado: `State.gd`

Este é o script mais importante. Todos os outros estados (`Idle.gd`, `Run.gd`, etc.) herdarão dele. Ele define a "interface" que todo estado deve ter.

- **Criação:** Crie um script `State.gd` que herda de `Node`.
- **Script (`State.gd`):**
  ```gdscript
  class_name State
  extends Node

  var state_machine: StateMachine
  
  # Acessa o "dono" do estado (o jogador, o inimigo, etc.)
  # Assumimos que a StateMachine é sempre filha do personagem.
  @onready var owner = get_parent().get_parent()

  # Funções virtuais. Elas são feitas para serem sobrescritas pelos estados filhos.
  
  # Chamado quando o estado é ativado.
  # 'payload' é um dicionário opcional para passar dados na transição.
  func enter(payload: Dictionary = {}):
      pass

  # Chamado a cada frame de processo.
  func process(delta: float):
      pass

  # Chamado a cada frame de física.
  func process_physics(delta: float):
      pass
      
  # Chamado para processar input.
  func handle_input(event: InputEvent):
      pass

  # Chamado quando o estado é desativado.
  func exit():
      pass
  ```

## 4. Exemplo de Estado: `Run.gd`

- **Criação:** Crie um script `Run.gd` que herda de `State`.
- **Script (`Run.gd`):**
  ```gdscript
  class_name RunState
  extends State

  func enter(payload: Dictionary = {}):
      # Toca a animação de corrida
      owner.get_node("AnimatedSprite2D").play("run")

  func process_physics(delta: float):
      # Lógica de movimento
      var direction = Input.get_axis("move_left", "move_right")
      owner.velocity.x = direction * owner.stats.move_speed
      
      # Lógica de transição
      if direction == 0:
          state_machine.transition_to("Idle")
      if Input.is_action_just_pressed("jump"):
          state_machine.transition_to("Jump")

  func exit():
      # Pode ser usado para parar um som de passo, por exemplo
      pass
  ```

## 5. Estrutura de Nós na Cena do Personagem

```
- Player (CharacterBody2D, com player.gd)
  - AnimatedSprite2D
  - CollisionShape2D
  - StateMachine (Node, com StateMachine.gd)
    - Idle (Node, com Idle.gd)
    - Run (Node, com Run.gd)
    - Jump (Node, com Jump.gd)
    - Hurt (Node, com Hurt.gd)
    - ...etc
```

Com esta estrutura, a lógica do seu personagem fica extremamente organizada. O script principal (`player.gd`) apenas gerencia dados (vida, stats), enquanto todo o comportamento é delegado para o estado apropriado.
