# Apostila: Construindo um Top-Down Shooter em Godot

## Aula 1: Estrutura do Projeto e Movimentação do Jogador

**Objetivo:** Configurar o projeto, criar a cena do jogador e implementar a movimentação básica da nave.

1.  **Configuração Inicial:**
    *   Crie um novo projeto Godot.
    *   Configure as ações de input em `Project > Project Settings > Input Map` para `move_left`, `move_right`, `move_up`, `move_down`.
    *   Crie a estrutura de pastas inicial (`scenes`, `scripts`, `assets`).

2.  **Cena do Jogador (`player.tscn`):**
    *   Crie uma nova cena com um `CharacterBody2D` como raiz.
    *   Adicione `AnimatedSprite2D` (com um sprite temporário), `CollisionShape2D` e `Camera2D`.
    *   Crie o script `player.gd` e anexe-o ao nó raiz.

3.  **Script de Movimentação (`player.gd`):**
    *   Crie uma variável `move_speed`.
    *   No `_physics_process(delta)`, use `Input.get_vector()` para obter a direção.
    *   Defina a `velocity` multiplicando a direção pela velocidade.
    *   Chame `move_and_slide()`.

## Aula 2: Atirando Projéteis

**Objetivo:** Fazer a nave disparar projéteis.

1.  **Cena do Projétil (`projectile.tscn`):**
    *   Crie uma cena com `Area2D` como raiz.
    *   Adicione `Sprite2D` e `CollisionShape2D`.
    *   Crie o script `projectile.gd`.
    *   No script, adicione `speed` e `direction`. No `_process(delta)`, mova o projétil (`position += direction * speed * delta`).

2.  **Lógica de Tiro no Jogador:**
    *   Adicione um `Marker2D` chamado `Muzzle` à cena do jogador para indicar de onde o projétil sai.
    *   No `_process(delta)` do `player.gd`, verifique se a ação "shoot" foi pressionada.
    *   Se sim, instancie a cena `projectile.tscn`, defina sua `global_position` para a do `Muzzle` e adicione-a à cena principal.

## Aula 3: Inimigos e Colisões

**Objetivo:** Criar um inimigo que se move e pode ser destruído.

1.  **Sistema de Dano (Hitbox/Hurtbox):**
    *   Configure as camadas de física em `Project > Project Settings > 2D Physics`. Crie "player" e "enemy".
    *   Adicione uma `Area2D` (`Hurtbox`) ao jogador. Configure sua layer e mask para detectar `Hitbox`es de inimigos.
    *   Adicione uma `Hitbox` ao projétil para detectar `Hurtbox`es de inimigos.

2.  **Cena do Inimigo (`enemy.tscn`):**
    *   Crie uma cena `CharacterBody2D` para o inimigo, similar à do jogador.
    *   Adicione uma `Hurtbox`. Conecte seu sinal `area_entered` a uma função `_on_hurtbox_area_entered`.
    *   Nessa função, se a área for uma `Hitbox` de jogador, o inimigo deve tomar dano e, eventualmente, ser destruído (`queue_free()`).

## Aula 4: HUD e Feedback

**Objetivo:** Criar uma interface básica e adicionar feedback de dano.

1.  **Cena da HUD (`game_hud.tscn`):**
    *   Crie uma cena `CanvasLayer`.
    *   Adicione um `Label` para a pontuação ou vida do jogador.
    *   Use sinais para comunicar do jogador para a HUD (ex: `player.health_changed.connect(hud.update_health)`).

2.  **Texto de Dano Flutuante:**
    *   Crie a cena `FloatingText.tscn` (`Node2D` com `Label` e `Tween`).
    *   Crie o autoload `FloatingTextManager.gd`.
    *   Na função `take_damage` do inimigo, chame o manager para mostrar o número do dano.

## Aula 5: Polimento e Próximos Passos

**Objetivo:** Adicionar sons, múltiplos tipos de inimigos e power-ups.

1.  **Áudio:**
    *   Crie um `AudioManager` (Autoload) para tocar SFX e música.
    *   Chame `AudioManager.play_sfx()` para tiros e explosões.

2.  **Inimigos Múltiplos:**
    *   Use a arquitetura de `Resource` (`EnemyData.tres`) para criar variações de inimigos com diferentes velocidades, vidas e sprites, sem precisar de novos scripts.

3.  **Power-ups:**
    *   Crie uma cena `PowerUp.tscn` (`Area2D`).
    *   Quando o jogador a coleta, modifique uma variável no jogador (ex: `fire_rate`, `move_speed`).
