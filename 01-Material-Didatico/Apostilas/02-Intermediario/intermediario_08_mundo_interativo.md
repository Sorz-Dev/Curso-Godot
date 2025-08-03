# Apostila 08: Mundo Interativo

**Nível de Dificuldade:** Intermediário

**Pré-requisitos:** Sinais, `Area2D`, `AnimationPlayer`.

---

## 1. A Filosofia: Desacoplamento e Reutilização

Um mundo de jogo parece vivo quando o jogador pode interagir com ele. No entanto, programar cada interação individualmente (um script para baús, um para NPCs, um para portas) leva a código repetido.

A nossa arquitetura visa criar um **componente de interação genérico** que pode ser adicionado a qualquer objeto no mundo, tornando-o "interagível" com uma única ação do jogador.

-   **O Jogador:** Não sabe *o que* ele está interagindo. Ele apenas sabe que há um objeto interativo próximo e envia um sinal de "interagir".
-   **O Objeto:** É responsável por sua própria lógica. Um baú sabe como se abrir, um NPC sabe como iniciar um diálogo.

---

## 2. O Componente `Interactable`

Esta é a cena reutilizável que torna qualquer objeto interativo.

-   **Cena:** `interactable.tscn`
-   **Estrutura:**
    -   `Interactable` (Area2D)
        -   **Script:** `interactable.gd`
        -   **Collision:** Layer "interactable", Mask "player_detector".
        -   `CollisionShape2D`: Define o alcance da interação.
        -   `InteractionPrompt` (Sprite2D ou Label): Um ícone ("!") ou texto ("E") que aparece para o jogador. Fica invisível por padrão.
-   **Script (`interactable.gd`):**
    ```gdscript
    class_name Interactable
    extends Area2D

    # O objeto pai (o baú, o NPC) se conectará a este sinal.
    signal interacted

    # Esta função é chamada pelo jogador.
    func do_interaction():
        emit_signal("interacted")
        # Opcional: esconder o prompt para evitar interações repetidas
        $InteractionPrompt.hide()

    # Nota: A lógica de mostrar/esconder o prompt é gerenciada pelo jogador
    # para evitar que múltiplos prompts apareçam ao mesmo tempo.
    func show_prompt():
        $InteractionPrompt.show()

    func hide_prompt():
        $InteractionPrompt.hide()
    ```

---

## 3. A Lógica do Jogador

O jogador precisa de um script para detectar o `Interactable` mais próximo e decidir qual prompt mostrar.

-   **Na cena do `Player`:**
    -   Adicione uma `Area2D` chamada `InteractionRange`.
    -   **Collision:** Layer "player_detector", Mask "interactable".
-   **Script (`player.gd`):**
    ```gdscript
    # player.gd
    var interactables_in_range: Array[Interactable] = []
    var closest_interactable: Interactable = null

    func _ready():
        $InteractionRange.area_entered.connect(_on_interactable_entered)
        $InteractionRange.area_exited.connect(_on_interactable_exited)

    func _process(delta):
        update_closest_interactable()

    func _input(event: InputEvent):
        if event.is_action_just_pressed("interact") and closest_interactable:
            closest_interactable.do_interaction()

    func _on_interactable_entered(area: Area2D):
        if area is Interactable and not interactables_in_range.has(area):
            interactables_in_range.append(area)

    func _on_interactable_exited(area: Area2D):
        if area in interactables_in_range:
            area.hide_prompt()
            interactables_in_range.erase(area)

    func update_closest_interactable():
        var old_closest = closest_interactable
        closest_interactable = null
        var min_dist_sq = INF

        if interactables_in_range.is_empty():
            if old_closest: old_closest.hide_prompt()
            return

        for interactable in interactables_in_range:
            var dist_sq = self.global_position.distance_squared_to(interactable.global_position)
            if dist_sq < min_dist_sq:
                min_dist_sq = dist_sq
                closest_interactable = interactable
        
        if old_closest != closest_interactable:
            if old_closest: old_closest.hide_prompt()
            if closest_interactable: closest_interactable.show_prompt()
    ```

---

## 4. Criando Objetos Interativos

### 4.1. Baú (`chest.tscn`)

1.  Crie a cena do baú (`StaticBody2D` com `Sprite2D`).
2.  **Instancie `interactable.tscn` como filho do baú.**
3.  No script `chest.gd`:
    ```gdscript
    extends StaticBody2D
    
    @onready var interactable_component = $Interactable
    var is_open = false

    func _ready():
        interactable_component.interacted.connect(on_interacted)

    func on_interacted():
        if is_open: return
        is_open = true
        $AnimatedSprite2D.play("open")
        LootSystem.drop_loot(...)
        # Desativa futuras interações
        interactable_component.queue_free() 
    ```

### 4.2. NPC (`npc.tscn`)

1.  Crie a cena do NPC (`CharacterBody2D`).
2.  **Instancie `interactable.tscn` como filho do NPC.**
3.  No script `npc.gd`:
    ```gdscript
    extends CharacterBody2D

    @export var dialogue_resource: DialogueResource
    @onready var interactable_component = $Interactable

    func _ready():
        interactable_component.interacted.connect(on_interacted)

    func on_interacted():
        # Inicia o diálogo usando o sistema de diálogo
        DialogueManager.start_dialogue(dialogue_resource)
    ```

---

## 5. Cutscenes Simples com `AnimationPlayer`

Para eventos mais complexos, como a introdução de um chefe, o `AnimationPlayer` é a ferramenta perfeita.

-   **Filosofia:** Use um `AnimationPlayer` na cena do nível para atuar como um "diretor de cinema".
-   **Implementação:**
    1.  Crie um `AnimationPlayer` na sua cena de nível.
    2.  Crie uma nova animação (ex: `boss_intro`).
    3.  **Anime Propriedades:** Você pode adicionar trilhas para animar quase qualquer coisa:
        -   A `position` de uma `Camera2D` para criar um movimento de câmera.
        -   A `visible` de um nó para fazê-lo aparecer.
        -   A `animation` de um `AnimatedSprite2D` para forçar um personagem a tocar uma animação específica.
    4.  **Use a "Call Method Track":** Esta é a ferramenta mais poderosa. Você pode adicionar uma trilha que chama uma função de qualquer script em um momento exato.
        -   **Exemplo de Fluxo:**
            -   **0.0s:** Chama `player.set_input_enabled(false)` para tirar o controle do jogador.
            -   **0.5s - 2.0s:** Anima a câmera para focar no chefe.
            -   **2.5s:** Chama `boss.play("emerge_from_ground")`.
            -   **3.5s:** Chama `DialogueManager.start_dialogue(boss_dialogue)`.
    5.  **Gatilho:** A cutscene é iniciada quando o jogador entra em uma `Area2D` de gatilho, que simplesmente chama `$AnimationPlayer.play("boss_intro")`.
    6.  **Fim:** Conecte o sinal `animation_finished` do `AnimationPlayer` a uma função que devolve o controle ao jogador (`player.set_input_enabled(true)`).
