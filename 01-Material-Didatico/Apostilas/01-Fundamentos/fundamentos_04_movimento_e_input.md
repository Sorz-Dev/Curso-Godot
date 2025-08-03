# Apostila 01: Fundamentos - Movimento e Input

**Nível de Dificuldade:** Fundamental

**Pré-requisitos:** Nenhum.

---

## 1. A Filosofia: Ações, não Teclas

O erro mais comum de um iniciante é pensar em teclas. "Como eu faço o personagem andar com a tecla W?". A forma correta de pensar em Godot é através de **Ações**.

Uma **Ação** é um nome abstrato para uma intenção do jogador, como `mover_para_frente`, `pular` ou `atacar`. No **Input Map** (`Projeto -> Configurações do Projeto -> Mapa de Entrada`), você associa uma ou mais teclas, botões de mouse ou botões de controle a essa ação.

**Por que isso é crucial?**
-   **Flexibilidade:** O jogador pode remapear os controles no menu de opções sem que você precise mudar uma linha de código.
-   **Multiplataforma:** A mesma ação `pular` pode ser a `Barra de Espaço` no teclado, o botão `A` em um controle de Xbox e um botão virtual na tela de um celular.

---

## 2. Movimentação Top-Down (8 Direções)

Ideal para RPGs, twin-stick shooters e jogos de aventura.

-   **Nó Principal:** `CharacterBody2D`
-   **Input Map:**
    -   Crie 4 ações: `move_left`, `move_right`, `move_up`, `move_down`.
    -   Associe as teclas `A`, `D`, `W`, `S` a elas, respectivamente.
-   **Lógica (`player.gd`):**
    ```gdscript
    extends CharacterBody2D

    const SPEED = 300.0

    func _physics_process(delta):
        # Input.get_vector() combina 4 ações em um vetor de direção normalizado.
        # Isso garante que o movimento na diagonal não seja mais rápido.
        var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
        
        # Define a velocidade com base na direção e na velocidade definida.
        velocity = direction * SPEED

        # move_and_slide() é a função mágica do CharacterBody2D.
        # Ela move o corpo e o faz colidir e deslizar em outros corpos.
        move_and_slide()
    ```

---

## 3. Movimentação de Plataforma (Esquerda/Direita e Pulo)

Ideal para jogos de plataforma 2D clássicos.

-   **Nó Principal:** `CharacterBody2D`
-   **Input Map:**
    -   Ações: `move_left`, `move_right`, `jump`.
-   **Lógica (`player.gd`):**
    ```gdscript
    extends CharacterBody2D

    const SPEED = 300.0
    const JUMP_VELOCITY = -400.0

    # A gravidade é um valor global do projeto, acessado aqui.
    var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

    func _physics_process(delta):
        # Adiciona a força da gravidade.
        if not is_on_floor():
            velocity.y += gravity * delta

        # Lida com o pulo.
        if Input.is_action_just_pressed("jump") and is_on_floor():
            velocity.y = JUMP_VELOCITY

        # Lida com o movimento lateral.
        var direction = Input.get_axis("move_left", "move_right")
        velocity.x = direction * SPEED

        move_and_slide()
    ```
    -   **`Input.get_axis()`:** É uma função de conveniência que retorna -1 para a ação negativa (esquerda), +1 para a positiva (direita) e 0 se nenhuma ou ambas estiverem pressionadas. Perfeito para movimento lateral.
    -   **`is_on_floor()`:** Uma função helper do `CharacterBody2D` que retorna `true` se o corpo estiver tocando o chão. Essencial para evitar pulos no ar.

---

## 4. Animação Simples de Movimento

Vamos fazer o personagem virar para a esquerda ou direita.

-   **Nós:** O `Player` precisa de um `AnimatedSprite2D` como filho.
-   **Lógica (adicionar ao `_physics_process` do jogo de plataforma):**
    ```gdscript
    @onready var animated_sprite = $AnimatedSprite2D

    # ... dentro de _physics_process ...
    var direction = Input.get_axis("move_left", "move_right")

    # Atualiza a animação e a direção do sprite
    if direction > 0:
        animated_sprite.flip_h = false
    elif direction < 0:
        animated_sprite.flip_h = true

    if is_on_floor():
        if direction == 0:
            animated_sprite.play("idle")
        else:
            animated_sprite.play("run")
    else:
        animated_sprite.play("jump")

    velocity.x = direction * SPEED
    move_and_slide()
    ```
    -   **`flip_h`:** Uma propriedade do `Sprite2D` (e `AnimatedSprite2D`) que espelha a imagem horizontalmente. Isso permite usar a mesma animação de corrida para a esquerda e para a direita, economizando trabalho de arte.

Dominar estas bases de input e movimento é o primeiro passo para criar qualquer tipo de jogo. A partir daqui, você pode construir sistemas de combate, interação e muito mais.
