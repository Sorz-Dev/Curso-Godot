# Apostila 03: Sistema de Combate

**Nível de Dificuldade:** Básico a Avançado

**Pré-requisitos:** Conhecimento da Máquina de Estados (FSM) e `Area2D`.

---

## 1. A Filosofia: A Dança do Combate

Um bom sistema de combate é como uma conversa entre o jogador e o inimigo. Cada ação deve ter uma reação clara. O núcleo dessa conversa em Godot é a interação entre duas `Area2D`s: a **Hitbox** (o ataque) e a **Hurtbox** (a área vulnerável).

-   **Hitbox (Caixa de Ataque):** Representa a área de efeito de um ataque (o arco de uma espada, o projétil de uma flecha). Ela procura por Hurtboxes.
-   **Hurtbox (Caixa de Dano):** Representa as partes vulneráveis de um personagem. Ela é atingida por Hitboxes.

Para que essa comunicação funcione, usamos o sistema de **Camadas e Máscaras de Colisão**.
-   **Configuração Padrão:**
    -   **Hitbox:** Collision Layer = "hitbox", Collision Mask = "hurtbox".
    -   **Hurtbox:** Collision Layer = "hurtbox", Collision Mask = "hitbox".

Isso garante que Hitboxes só detectem Hurtboxes, e vice-versa, evitando interações indesejadas.

---

## 2. Níveis de Implementação

### Nível 1: Básico (Dano Direto)

Ideal para um protótipo ou game jam. A comunicação é direta e simples.

-   **Estrutura:**
    -   O `Player` tem uma `Area2D` chamada `Hitbox`.
    -   O `Enemy` tem uma `Area2D` chamada `Hurtbox`.
-   **Lógica:**
    1.  No script do `Enemy`, crie uma função `take_damage(amount: int)`.
    2.  No script do `Player`, conecte o sinal `body_entered` da `Hitbox` a uma função.
    3.  Nessa função, chame `body.get_parent().take_damage(10)`. (Assumindo que a Hurtbox é filha direta do Inimigo).
    4.  O ataque é ativado/desativado ligando e desligando o `CollisionShape2D` da Hitbox.
-   **Prós:** Extremamente rápido de implementar.
-   **Contras:** Pouco flexível. O dano é fixo (hard-coded), não há knockback, nem tipos de dano.

### Nível 2: Intermediário (Pacote de Dados Simples)

Introduzimos um dicionário para passar mais informações sobre o ataque.

-   **Estrutura:** A mesma do Nível 1.
-   **Lógica:**
    1.  A função `take_damage` do inimigo agora espera um dicionário: `take_damage(attack_data: Dictionary)`.
    2.  Ao atacar, o jogador constrói um dicionário:
        ```gdscript
        var attack_data = {
            "damage": 10,
            "knockback_force": 150.0,
            "source_position": global_position
        }
        body.get_parent().take_damage(attack_data)
        ```
    3.  A função `take_damage` agora pode ler esses valores para aplicar dano e calcular uma direção de knockback.
-   **Prós:** Muito mais flexível. Permite ataques com diferentes forças e efeitos.
-   **Contras:** Os dados do ataque ainda estão "presos" no código do atacante.

### Nível 3: Avançado (Recurso de Ataque)

A abordagem mais profissional, usando nossa arquitetura orientada a dados.

-   **Estrutura:**
    1.  Crie um novo `Resource` chamado `AttackData.gd`.
        ```gdscript
        class_name AttackData
        extends Resource
        @export var damage: int = 10
        @export var knockback_force: float = 100.0
        @export var damage_type: Enum("Physical", "Fire", "Ice")
        # Adicione outros efeitos: status, stun duration, etc.
        ```
    2.  A `Hitbox` (seja no jogador ou em um projétil) agora tem uma variável: `@export var attack: AttackData`.
    3.  A função `take_damage` agora espera esse recurso: `take_damage(attack: AttackData, source_position: Vector2)`.
-   **Lógica:**
    1.  Crie diferentes arquivos `.tres` para cada tipo de ataque: `ataque_fraco.tres`, `ataque_forte.tres`, `bola_de_fogo.tres`.
    2.  Arraste o recurso de ataque apropriado para o campo "Attack" da sua Hitbox no Inspector.
    3.  Ao detectar uma colisão, a Hitbox simplesmente passa seu próprio recurso de ataque para a vítima: `body.get_parent().take_damage(attack, global_position)`.
-   **Prós:** Totalmente desacoplado. Designers podem criar e balancear ataques sem tocar no código. O sistema é infinitamente escalável.

---

## 3. Guia de Implementação: O Fluxo de Dano Completo

Vamos detalhar a implementação do **Nível 3**.

### 3.1. A Hurtbox

-   **Cena:** Qualquer personagem (jogador ou inimigo).
-   **Nós:** Adicione uma `Area2D` chamada `Hurtbox` com seu `CollisionShape2D`.
-   **Script (no personagem, ex: `enemy.gd`):**
    ```gdscript
    # Conecte o sinal 'area_entered' da Hurtbox a esta função
    func _on_hurtbox_area_entered(hitbox_area: Area2D):
        # Verifica se a área tem um recurso de ataque e um método para causar dano
        if hitbox_area.has_method("deal_damage"):
            hitbox_area.deal_damage(self)

    func take_damage(attack: AttackData, source_position: Vector2):
        # Lógica de invencibilidade
        if is_invincible: return

        # Lógica de dano
        var final_damage = max(1, attack.damage - stats.defense)
        current_health -= final_damage
        
        # Feedback visual e sonoro
        FloatingTextManager.show_damage_text(final_damage, global_position)
        AudioManager.play_sfx(load("res://sfx/hit.wav"))

        # Lógica de Knockback
        var direction = (global_position - source_position).normalized()
        velocity = direction * attack.knockback_force
        
        # Transição para o estado de "Hurt" e verificação de morte
        state_machine.transition_to("Hurt")
        if current_health <= 0:
            state_machine.transition_to("Death")
    ```

### 3.2. A Hitbox

-   **Cena:** Geralmente parte de um ataque (ex: filho de uma cena `SwordSlash.tscn` ou `Fireball.tscn`).
-   **Nós:** `Area2D` chamada `Hitbox` com seu `CollisionShape2D`.
-   **Script (`hitbox.gd`):**
    ```gdscript
    class_name Hitbox
    extends Area2D

    @export var attack_data: AttackData

    # Lista para garantir que um ataque não acerte o mesmo alvo múltiplas vezes
    var hit_targets = []

    func _ready():
        # Conecta o sinal a si mesmo para processar a lógica
        body_entered.connect(_on_body_entered)

    func _on_body_entered(body: Node2D):
        if body in hit_targets:
            return # Já atingiu este alvo

        if body.has_method("take_damage"):
            hit_targets.append(body)
            body.take_damage(attack_data, global_position)

    # Limpa a lista de alvos quando a hitbox é ativada novamente
    func activate():
        hit_targets.clear()
        monitoring = true
        monitorable = true

    func deactivate():
        monitoring = false
        monitorable = false
    ```

### 3.3. Ativando o Ataque (via `AnimationPlayer`)

A maneira mais precisa de controlar o combate é usar um `AnimationPlayer`.

1.  Crie uma animação de ataque para o seu personagem.
2.  **Adicione uma Trilha de Chamada de Método** para o nó da `Hitbox`.
3.  No frame exato em que o ataque deve começar a causar dano, insira uma chave que chame a função `activate()` da Hitbox.
4.  No frame em que o ataque termina, insira outra chave que chame `deactivate()`.

Este fluxo garante que o combate seja preciso, reativo e, o mais importante, fácil de ajustar e balancear.
