# Apostila 02: Máquina de Estados (FSM)

**Nível de Dificuldade:** Intermediário

**Pré-requisitos:** Conhecimento de GDScript, sinais e a estrutura de árvore de nós.

---

## 1. A Filosofia: Organizando o Comportamento

**O Problema:** Imagine o script de um personagem. No `_process` ou `_physics_process`, você começa a ter uma cascata de `if`s:

```gdscript
func _physics_process(delta):
    if is_attacking:
        # não pode se mover
    elif is_jumping:
        # aplica gravidade
    elif is_dashing:
        # move rápido por um instante
    elif is_moving:
        # move normalmente
    else:
        # está parado
```
Isso é o que chamamos de "código espaguete". É frágil, difícil de ler e quase impossível de expandir. Adicionar um novo comportamento, como "agachar", exigiria modificar toda essa estrutura.

**A Solução (Máquina de Estados Finitos - FSM):** A FSM é um padrão de design que resolve esse problema. A ideia é simples:
1.  Um personagem só pode estar em **um estado** de cada vez (parado, correndo, pulando, etc.).
2.  Cada **estado** é seu próprio "mini-programa". Ele contém toda a lógica para aquele comportamento específico.
3.  A lógica de **transição** (mudar de um estado para outro) é claramente definida dentro de cada estado.

**Vantagens:**
-   **Organização:** O código do personagem principal fica limpo. Ele apenas delega a lógica para o estado atual.
-   **Escalabilidade:** Para adicionar um novo comportamento (um novo estado), você cria um novo script de estado e ajusta a lógica de transição nos estados relevantes, sem tocar no código dos outros.
-   **Depuração Fácil:** Se há um bug no pulo, você sabe que o problema está no `jump_state.gd`, e não perdido em um `if` dentro de um `_process` de 500 linhas.

---

## 2. Níveis de Implementação de FSM

### Nível 1: Básico (Enum e `match`)

Uma FSM simples pode ser implementada em um único script usando um `enum` para os estados e uma declaração `match` (similar ao `switch`) no `_process`.

-   **Implementação:**
    ```gdscript
    extends CharacterBody2D

    enum State { IDLE, MOVE, JUMP }
    var current_state = State.IDLE

    func _physics_process(delta):
        match current_state:
            State.IDLE:
                state_logic_idle(delta)
            State.MOVE:
                state_logic_move(delta)
            State.JUMP:
                state_logic_jump(delta)
    
    func state_logic_idle(delta):
        # Lógica de transição
        if Input.is_action_pressed("move_right"):
            current_state = State.MOVE
    
    # ... outras funções de lógica de estado ...
    ```
-   **Prós:** Simples de entender e implementar para IAs ou personagens com 2 ou 3 estados.
-   **Contras:** Não escala bem. Com mais estados, o script principal volta a ficar grande e confuso.

### Nível 2: Avançado (Arquitetura Baseada em Nós)

Esta é a abordagem robusta e escalável que usaremos no curso. Cada estado é seu próprio nó e script.

-   **Implementação:**
    1.  **`StateMachine.gd`:** Um nó que gerencia os estados.
    2.  **`State.gd`:** Uma classe base da qual todos os estados herdam.
    3.  **`IdleState.gd`, `MoveState.gd`, etc.:** Scripts que herdam de `State.gd` e contêm a lógica específica.

---

## 3. Guia de Implementação: FSM com Nós

### 3.1. A Classe Base do Estado (`State.gd`)

Este script é o "contrato" que todos os estados devem seguir.

1.  **Crie o Script:** Em `scripts/core/` ou `scripts/fsm/`, crie `state.gd`.
2.  **Código:**
    ```gdscript
    # state.gd
    class_name State
    extends Node

    # Referência para a máquina de estados, para podermos chamar transition_to()
    var state_machine: StateMachine

    # Referência para o "dono" da FSM (o Player, o Inimigo, etc.)
    # @onready garante que o nó pai (StateMachine) já exista quando isso for chamado.
    @onready var owner = get_parent().get_parent()

    # Funções virtuais. Elas são projetadas para serem sobrescritas.
    # O 'payload' é um dicionário que pode passar dados entre estados.
    func enter(payload: Dictionary = {}):
        pass

    func exit():
        pass

    # Para lógica que não envolve física (ex: timers, input de UI)
    func process_logic(delta: float):
        pass

    # Para lógica de movimento e colisões
    func process_physics(delta: float):
        pass
        
    # Para inputs de ação
    func process_input(event: InputEvent):
        pass
    ```

### 3.2. O Gerenciador (`StateMachine.gd`)

Este script é o "cérebro" que orquestra as transições.

1.  **Crie o Script:** Na mesma pasta, crie `state_machine.gd`.
2.  **Código:**
    ```gdscript
    # state_machine.gd
    class_name StateMachine
    extends Node

    @export var initial_state: State
    
    var current_state: State
    var states: Dictionary = {} # Mapeia nomes de estado para os nós

    func _ready():
        # Mapeia todos os nós de estado filhos para acesso rápido pelo nome
        for child in get_children():
            if child is State:
                states[child.name.to_lower()] = child
                child.state_machine = self # Dá ao estado uma referência a si mesmo
        
        if initial_state:
            current_state = initial_state
            current_state.enter()

    func _process(delta):
        if current_state:
            current_state.process_logic(delta)

    func _physics_process(delta):
        if current_state:
            current_state.process_physics(delta)

    func _unhandled_input(event: InputEvent):
        if current_state:
            current_state.process_input(event)

    func transition_to(state_name: String, payload: Dictionary = {}):
        var new_state_name = state_name.to_lower()
        if not states.has(new_state_name) or states[new_state_name] == current_state:
            return

        if current_state:
            current_state.exit()

        current_state = states[new_state_name]
        current_state.enter(payload)
    ```

### 3.3. Estrutura de Nós e Exemplo de Estado (`MoveState.gd`)

1.  **Na Cena do seu Personagem (`player.tscn`):**
    ```
    - Player (CharacterBody2D, com player.gd)
      - ... (outros nós como Sprite, CollisionShape)
      - StateMachine (Node, com state_machine.gd)
        - Idle (Node, com idle_state.gd)
        - Move (Node, com move_state.gd)
        - Jump (Node, com jump_state.gd)
    ```
2.  **No Inspector do nó `StateMachine`**, arraste o nó `Idle` para a propriedade `Initial State`.

3.  **Exemplo de `MoveState.gd`:**
    ```gdscript
    # move_state.gd
    extends State

    func enter(payload: Dictionary = {}):
        # owner é o Player. Acessamos seu AnimatedSprite2D para tocar a animação.
        owner.get_node("AnimatedSprite2D").play("move")

    func process_physics(delta: float):
        # 1. Lógica do Estado: mover o personagem
        var direction = Input.get_axis("move_left", "move_right")
        owner.velocity.x = direction * owner.stats.move_speed
        owner.move_and_slide()

        # 2. Lógica de Transição: decidir para qual estado ir
        if direction == 0:
            state_machine.transition_to("Idle")
        
        if Input.is_action_just_pressed("jump"):
            state_machine.transition_to("Jump")
    ```

---

## 4. Integração e Fluxo

1.  O script principal (`player.gd`) fica muito simples. Ele não precisa mais de uma função `_physics_process` com lógica de movimento. Ele apenas segura os dados (como a variável `stats`) e delega todo o processamento para a FSM.
2.  Quando o jogo começa, `StateMachine` entra no `initial_state` (`Idle`).
3.  O `IdleState` fica verificando o input. Quando o jogador aperta para o lado, ele chama `state_machine.transition_to("Move")`.
4.  A `StateMachine` chama `Idle.exit()`, troca `current_state` para o nó `Move`, e chama `Move.enter()`.
5.  Agora, a cada frame, a `StateMachine` chama `Move.process_physics()`, que move o jogador e verifica as condições para transicionar para `Idle` ou `Jump`.

Esta arquitetura modular é a base para criar personagens e IAs complexas de forma limpa e profissional.
