# Apostila: Construindo um Jogo de Plataforma 2D em Godot

## Aula 1: Movimentação e Física do Jogador

**Objetivo:** Criar um personagem que anda, corre e pula com física de plataforma.

1.  **Configuração do Projeto:**
    *   Crie um novo projeto Godot.
    *   Em `Project > Project Settings > Physics > 2D`, defina o `Default Gravity`.
    *   Configure as ações de input para `move_left`, `move_right`, e `jump`.

2.  **Cena do Jogador (`player.tscn`):**
    *   Crie uma cena com `CharacterBody2D` como raiz.
    *   Adicione `AnimatedSprite2D` e `CollisionShape2D`.
    *   Crie o script `player.gd`.

3.  **Script de Movimento (`player.gd`):**
    *   Exporte variáveis para `speed`, `jump_velocity`, e `gravity`.
    *   No `_physics_process(delta)`:
        *   Aplique a gravidade: `velocity.y += gravity * delta`.
        *   Obtenha a direção do input horizontal.
        *   Defina `velocity.x` com base na direção e velocidade.
        *   Verifique se o jogador está no chão com `is_on_floor()`.
        *   Se `is_on_floor()` e o input de pulo for pressionado, defina `velocity.y = jump_velocity`.
        *   Chame `move_and_slide()`.

## Aula 2: Animação do Personagem

**Objetivo:** Fazer o personagem reagir visualmente às suas ações.

1.  **Preparar Animações:**
    *   No `AnimatedSprite2D`, crie animações: `idle`, `run`, `jump`, `fall`.

2.  **Máquina de Estados (FSM):**
    *   Crie a estrutura da FSM com `StateMachine.gd` e `State.gd`.
    *   Crie os estados `Idle`, `Run`, `Jump`, `Fall`.
    *   No `enter()` de cada estado, toque a animação correspondente (ex: `$AnimatedSprite2D.play("run")`).
    *   A lógica de transição nos estados deve verificar as condições (ex: no estado `Run`, se `!owner.is_on_floor()`, transicione para `Fall`).

## Aula 3: Level Design com TileMap

**Objetivo:** Construir um nível usando `TileMap`.

1.  **Criar o TileSet:**
    *   Importe uma spritesheet de tiles.
    *   Crie um novo `TileSet` e adicione a textura.
    *   No modo de edição do `TileSet`, vá para a aba "Physics" e adicione uma camada de física (`Physics Layer 0`) aos tiles que devem ser sólidos.

2.  **Construir o Nível (`level.tscn`):**
    *   Crie uma nova cena com um `Node2D` como raiz.
    *   Adicione um nó `TileMap` e associe o `TileSet` criado.
    *   Pinte o cenário usando os tiles.
    *   Instancie a cena do jogador no nível.

## Aula 4: Câmera e Inimigos Simples

**Objetivo:** Fazer a câmera seguir o jogador e adicionar um inimigo básico.

1.  **Câmera 2D:**
    *   Adicione uma `Camera2D` como filha do jogador.
    *   Ative `Smoothing Enabled` para um movimento suave.
    *   Defina os `Limit` (Left, Top, Right, Bottom) da câmera para que ela não mostre além dos limites do nível.

2.  **Inimigo "Goomba":**
    *   Crie uma cena `enemy.tscn` (`CharacterBody2D`).
    *   No script, dê a ele uma velocidade horizontal constante.
    *   Use um `RayCast2D` na frente do inimigo para detectar paredes. Se o RayCast colidir, inverta a direção da velocidade.
    *   Adicione uma `Hurtbox` ao jogador e uma `Hitbox` ao inimigo para causar dano por toque.

## Aula 5: Coletáveis e UI

**Objetivo:** Adicionar moedas para coletar e uma UI para mostrar a contagem.

1.  **Cena da Moeda (`coin.tscn`):**
    *   Crie uma cena `Area2D` com um `AnimatedSprite2D`.
    *   Conecte o sinal `body_entered`. Se o corpo for o jogador, emita um sinal global (ex: `Global.coin_collected.emit()`) e se destrua (`queue_free()`).

2.  **HUD:**
    *   Crie uma `GameHUD.tscn` (`CanvasLayer`).
    *   Adicione um `Label` para a contagem de moedas.
    *   No script da HUD, conecte-se ao sinal `Global.coin_collected` para atualizar o texto do `Label`.
