# Apostila 04: Inteligência Artificial Inimiga

**Nível de Dificuldade:** Intermediário a Avançado

**Pré-requisitos:** Arquitetura de Dados com `Resource` (Apostila 01), Máquina de Estados (Apostila 02), Sistema de Combate (Apostila 03).

---

## 1. A Filosofia: Comportamento Emergente e Organizado

A "Inteligência" de uma IA não vem de algoritmos complexos, mas da combinação de **regras simples** e da **capacidade de reagir ao ambiente**. Nossa arquitetura combina os três pilares que já aprendemos:

1.  **Dados (`EnemyData.tres`):** Define **O QUE** é o inimigo (vida, velocidade, dano, loot).
2.  **Máquina de Estados (FSM):** Define **COMO** o inimigo se comporta (parado, patrulhando, perseguindo, atacando).
3.  **Detecção (Area2D):** Define **QUANDO** o inimigo reage (ao ver ou perder o jogador).

O resultado é um sistema onde podemos criar uma vasta gama de inimigos com comportamentos únicos, reutilizando a maior parte da lógica.

---

## 2. A Cena Base do Inimigo (`enemy_base.tscn`)

Criamos uma cena "molde" que contém todos os nós e a lógica compartilhada. Inimigos específicos (Goblin, Slime, Esqueleto) serão **cenas herdadas** desta base.

-   **Estrutura da Cena:**
    -   `Enemy` (CharacterBody2D)
        -   **Script:** `enemy.gd` (script principal, leve)
        -   `AnimatedSprite2D`: Para as animações.
        -   `CollisionShape2D`: Colisão com o mundo.
        -   `StateMachine` (Node, com `state_machine.gd`): O cérebro da IA.
            -   `Idle` (Node, com `enemy_idle_state.gd`)
            -   `Patrol` (Node, com `enemy_patrol_state.gd`)
            -   `Chase` (Node, com `enemy_chase_state.gd`)
            -   `Attack` (Node, com `enemy_attack_state.gd`)
            -   `Hurt` (Node, com `enemy_hurt_state.gd`)
            -   `Death` (Node, com `enemy_death_state.gd`)
        -   `Hurtbox` (Area2D): Para receber dano (ver Apostila 03).
        -   `PlayerDetector` (Area2D): Uma área grande que detecta quando o jogador entra no "raio de agro".
        -   `AttackRange` (Area2D): Uma área menor que detecta quando o jogador está perto o suficiente para ser atacado.
        -   `Hitbox` (Area2D): Para causar dano (ver Apostila 03).

---

## 3. O Script Principal (`enemy.gd`)

Este script é o "corpo" do inimigo. Ele não toma decisões, apenas gerencia os dados e delega o comportamento para a FSM.

```gdscript
# enemy.gd
class_name Enemy
extends CharacterBody2D

# Arraste o arquivo .tres do inimigo aqui no Inspector
@export var data: EnemyData 

var current_health: int
var player_reference: Node2D = null

@onready var state_machine = $StateMachine

func _ready():
    if not data: 
        print("ERRO: Inimigo sem EnemyData!")
        queue_free()
        return
    
    current_health = data.max_health
    # Você pode usar os dados para configurar outros nós, como o sprite
    # $AnimatedSprite2D.sprite_frames = load(data.sprite_sheet_path)

func _physics_process(delta):
    # Delega todo o movimento e lógica para o estado atual
    state_machine.process_physics(delta)
    move_and_slide()

# A Hurtbox chama esta função
func take_damage(attack: AttackData, source_position: Vector2):
    # ... (lógica de dano, como na Apostila 03) ...
    current_health -= attack.damage
    if current_health <= 0:
        state_machine.transition_to("Death")
    else:
        # Passa a direção do knockback como payload para o estado Hurt
        var knockback_dir = (global_position - source_position).normalized()
        state_machine.transition_to("Hurt", {"knockback_dir": knockback_dir})

# Sinais dos detectores
func _on_player_detector_body_entered(body):
    if body.is_in_group("Player"):
        player_reference = body
        # Avisa o estado atual que o jogador foi detectado
        if state_machine.current_state.has_method("on_player_detected"):
            state_machine.current_state.on_player_detected(body)

func _on_player_detector_body_exited(body):
    if body == player_reference:
        player_reference = null
        if state_machine.current_state.has_method("on_player_lost"):
            state_machine.current_state.on_player_lost()
```

---

## 4. Os Estados da IA (O Cérebro)

Cada estado é um script que herda de `State.gd` e define um comportamento.

### `PatrolState.gd`
-   **`enter()`:** Define um ponto de patrulha aleatório dentro de um raio ou pega o próximo ponto de um `Path2D`.
-   **`process_physics(delta)`:** Move o `owner` (o inimigo) em direção ao ponto de patrulha usando `owner.velocity`. Se chegar, espera um pouco e define um novo ponto.
-   **`on_player_detected(player)`:** Função customizada (não está na classe `State` base) que é chamada pelo `enemy.gd`. Sua única função é transicionar: `state_machine.transition_to("Chase")`.

### `ChaseState.gd`
-   **`enter()`:** Toca a animação de "correr".
-   **`process_physics(delta)`:**
    -   Verifica se `owner.player_reference` é válido.
    -   Calcula a direção até o jogador: `var direction = (owner.player_reference.global_position - owner.global_position).normalized()`.
    -   Define a velocidade: `owner.velocity = direction * owner.data.move_speed`.
-   **`on_player_lost()`:** Transiciona de volta para Patrulha: `state_machine.transition_to("Patrol")`.
-   **Integração com `AttackRange`:** O `ChaseState` também pode ouvir os sinais do `AttackRange`. Se o jogador entrar, ele transiciona para `Attack`.

### `AttackState.gd`
-   **`enter()`:**
    -   Para o movimento: `owner.velocity = Vector2.ZERO`.
    -   Toca a animação de ataque. A `AnimationPlayer` do inimigo é configurada para chamar a função `activate()` da `Hitbox` nos frames corretos.
    -   Inicia um `Timer` de "cooldown" do ataque.
-   **`process_logic(delta)`:**
    -   Não faz nada até o cooldown terminar.
-   **`on_cooldown_timeout()` (chamado pelo Timer):**
    -   Verifica se o jogador ainda está no `AttackRange`.
    -   Se sim, ataca novamente (reproduz a animação de ataque).
    -   Se não, transiciona de volta para `Chase`.

### `HurtState.gd`
-   **`enter(payload)`:**
    -   Toca a animação "hurt".
    -   Aplica o knockback: `owner.velocity = payload.get("knockback_dir", Vector2.ZERO) * owner.data.knockback_resistance_modifier`.
    -   Inicia um `Timer` para a duração do "stun".
-   **`on_stun_timeout()`:** Transiciona de volta para `Chase` (se o jogador ainda estiver perto) ou `Idle`.

### `DeathState.gd`
-   **`enter()`:**
    -   Desativa as colisões para que o corpo não bloqueie mais o caminho.
    -   Toca a animação de morte.
    -   Na `AnimationPlayer`, no final da animação de morte, adicione uma **Call Method Track** que chama a função `queue_free()` no nó do inimigo.
    -   Chama o `LootSystem` para dropar itens com base no `owner.data.loot_table`.

---

## 5. Criando Variações de Inimigos (O Poder da Arquitetura)

Agora, criar um novo tipo de inimigo é um trabalho de **design**, não de programação.

1.  **Crie um `GoblinArqueiroData.tres`:**
    -   Clique com o botão direito na pasta de dados -> Novo Recurso -> `EnemyData`.
    -   Ajuste os stats: menos vida, mais velocidade.
    -   Atribua uma tabela de loot diferente.
2.  **Crie a Cena `goblin_arqueiro.tscn`:**
    -   Clique com o botão direito em `enemy_base.tscn` -> `Nova Cena Herdada`.
    -   **Modifique o estado de Ataque:** Abra o script `enemy_attack_state.gd` deste novo inimigo. Em vez de tocar uma animação que ativa uma `Hitbox` corpo a corpo, a função `enter()` agora instancia uma cena de flecha (`arrow.tscn`).
    -   **Arraste `GoblinArqueiroData.tres`** para o campo "Data" do Inspector do Goblin Arqueiro.

Pronto. Você tem um novo inimigo com comportamento de ataque diferente, sem modificar a base do sistema.
