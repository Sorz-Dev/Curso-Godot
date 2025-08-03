# Apostila 03: Fundamentos - Combate Simples e Colisões

**Nível de Dificuldade:** Fundamental

**Pré-requisitos:** Apostilas 01 e 02.

---

## 1. A Filosofia: Hitbox vs. Hurtbox

O combate em jogos 2D se resume a uma pergunta: "A área do meu ataque tocou a área vulnerável do meu inimigo?". Em Godot, traduzimos isso para:

-   **Hitbox (Caixa de Ataque):** Uma `Area2D` que representa o seu ataque. Pense nela como a lâmina da espada ou a energia de um soco.
-   **Hurtbox (Caixa de Dano):** Uma `Area2D` que representa o corpo do personagem que pode sofrer dano.

Quando uma Hitbox detecta uma Hurtbox, o dano acontece. Para garantir que elas só detectem umas às outras, usamos o sistema de **Camadas e Máscaras de Colisão**.

### Configuração Essencial

1.  Vá em `Projeto -> Configurações do Projeto -> Nomes das Camadas -> Física 2D`.
2.  Renomeie as primeiras camadas para algo claro:
    -   Camada 1: `world` (para o cenário, paredes, chão)
    -   Camada 2: `player`
    -   Camada 3: `enemy`
    -   Camada 4: `player_hitbox`
    -   Camada 5: `enemy_hurtbox`
    -   Camada 6: `enemy_hitbox`
    -   Camada 7: `player_hurtbox`

3.  **Para a Hitbox do Jogador:**
    -   Collision **Layer**: Marque apenas `player_hitbox`.
    -   Collision **Mask**: Marque apenas `enemy_hurtbox`.

4.  **Para a Hurtbox do Inimigo:**
    -   Collision **Layer**: Marque apenas `enemy_hurtbox`.
    -   Collision **Mask**: Marque apenas `player_hitbox`.

(Faça o inverso para o ataque do inimigo e a hurtbox do jogador).

---

## 2. Implementação: Um Ataque de Espada Simples

Vamos criar um ataque básico para o jogador.

### 2.1. Na Cena do Jogador (`player.tscn`)

1.  Adicione uma `Area2D` chamada `Hitbox` como filha do `Player`.
2.  Adicione uma `CollisionShape2D` como filha da `Hitbox`. Dê a ela uma forma (ex: `RectangleShape2D` ou `CapsuleShape2D`) e posicione-a onde o ataque deve acontecer.
3.  No Inspector da `Hitbox`, configure suas camadas e máscaras como descrito acima.
4.  **Importante:** Desative a `CollisionShape2D` da `Hitbox` por padrão (clicando no ícone de escudo riscado ao lado do nome do nó). Nós só a ativaremos durante o ataque.

### 2.2. Na Cena do Inimigo (`enemy.tscn`)

1.  Adicione uma `Area2D` chamada `Hurtbox` como filha do `Enemy`.
2.  Adicione uma `CollisionShape2D` que cubra o corpo do inimigo.
3.  Configure suas camadas e máscaras.

### 2.3. A Lógica do Ataque

-   **No script do Jogador (`player.gd`):**
    ```gdscript
    @onready var hitbox_collision = $Hitbox/CollisionShape2D

    func _input(event: InputEvent):
        if event.is_action_just_pressed("attack"):
            attack()

    func attack():
        # Ativa a hitbox
        hitbox_collision.disabled = false

        # Toca a animação de ataque
        $AnimatedSprite2D.play("attack")

        # Espera a animação terminar para desativar a hitbox
        # O sinal 'animation_finished' é emitido pelo AnimatedSprite2D
        await $AnimatedSprite2D.animation_finished
        hitbox_collision.disabled = true
    ```

-   **No script do Inimigo (`enemy.gd`):**
    ```gdscript
    func take_damage(amount: int):
        print("Levei dano! Vida restante: ", current_health)
        # Lógica para reduzir a vida, tocar animação de dor, etc.
    ```

-   **No script da Hitbox do Jogador (`hitbox.gd`):**
    -   Anexe um novo script à `Area2D` da `Hitbox`.
    ```gdscript
    extends Area2D

    # Conecte o sinal 'area_entered' da Hitbox a esta função no editor
    func _on_area_entered(area: Area2D):
        # A 'area' que entrou é a Hurtbox do inimigo.
        # O 'owner' de uma área é o nó pai dela (o Inimigo).
        if area.owner.has_method("take_damage"):
            # Chamamos a função no script do inimigo
            area.owner.take_damage(10) # Dano fixo de 10
    ```

---

## 3. O Fluxo Completo

1.  O jogador aperta o botão de `attack`.
2.  A função `attack()` no `player.gd` é chamada.
3.  A `CollisionShape2D` da `Hitbox` é ativada.
4.  A `Hitbox` agora pode detectar áreas.
5.  Se a `Hitbox` se sobrepõe à `Hurtbox` de um inimigo, o sinal `area_entered` da `Hitbox` é emitido.
6.  A função `_on_area_entered` no `hitbox.gd` é executada.
7.  Ela pega a `area` (a `Hurtbox`) e chama a função `take_damage` no seu `owner` (o `Enemy`).
8.  O inimigo recebe o dano.
9.  A animação de ataque do jogador termina, o sinal `animation_finished` é emitido, e a `CollisionShape2D` da `Hitbox` é desativada novamente, pronta para o próximo ataque.

Este é o ciclo fundamental de combate em Godot. As apostilas intermediárias expandirão este conceito com pacotes de dados, diferentes tipos de ataque e IA para que os inimigos possam revidar.
