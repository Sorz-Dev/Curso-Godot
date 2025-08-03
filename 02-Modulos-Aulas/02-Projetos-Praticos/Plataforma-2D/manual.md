# Manual de Implementação: Plataforma 2D

Este documento é o guia completo para a arquitetura e sistemas do jogo de Plataforma 2D, consolidando todos os manuais de sistema do template em um guia de implementação específico para este projeto.

## Índice

1.  **Visão Geral e Arquitetura Principal**
    *   Estrutura de Arquivos
    *   Arquitetura de Dados com `Resources`
    *   Sistemas Globais (Autoloads)
2.  **O Jogador**
    *   Cena e Componentes
    *   Física de Plataforma
    *   Máquina de Estados (FSM) do Jogador
3.  **Sistema de Combate**
    *   Hitbox, Hurtbox e `AttackData`
    *   Combate Corpo a Corpo (Melee)
    *   Feedback de Dano (Texto Flutuante)
4.  **Inimigos e IA**
    *   Cena Base do Inimigo
    *   Máquina de Estados (FSM) da IA
5.  **Sistemas de Progressão e Mundo**
    *   Níveis e Experiência (XP)
    *   Inventário e Itens
    *   Equipamentos e Stats
    *   Loot de Inimigos
    *   Lojas e Moeda
6.  **Interação e Narrativa**
    *   Sistema de Interação com Objetos
    *   Sistema de Diálogo
    *   Cutscenes Simples
7.  **Mundo e UI**
    *   Level Design com `TileMap`
    *   Perigos Ambientais
    *   Interface do Usuário (UI)
    *   Sistema de Save/Load
8.  **Sistemas Avançados (Opcional)**
    *   Eventos Globais e Flags
    *   IA com Machine Learning

---

## 1. Visão Geral e Arquitetura Principal

### Estrutura de Arquivos
O projeto segue uma estrutura organizada para separar cenas, scripts, assets e outros componentes, facilitando a navegação e manutenção.

### Arquitetura de Dados com `Resources`
A base do projeto é uma arquitetura orientada a dados. Em vez de definir stats como vida e dano diretamente nos scripts, usamos `Resources` (`.tres` arquivos) para desacoplar os dados da lógica.

-   **`CharacterStats.gd`**: Um recurso base para qualquer entidade que tenha stats (jogador, inimigos). Contém `max_health`, `move_speed`, `base_damage`, `defense`, etc.
-   **`EnemyData.gd`**: Herda de `CharacterStats` e adiciona informações específicas de inimigos, como a cena a ser instanciada, tipo de IA, tabela de loot e XP concedido.

### Sistemas Globais (Autoloads)
Singletons que gerenciam sistemas centrais acessíveis de qualquer lugar do jogo.
-   **`Global.gd`**: Armazena variáveis de estado do jogo (ex: `player_data`).
-   **`SceneManager.gd`**: Gerencia a transição entre cenas com efeitos de fade.
-   **`SettingsManager.gd`**: Carrega, aplica e salva as configurações do jogador.
-   **`AudioManager.gd`**: Controla a reprodução de músicas e SFX.
-   **`SaveManager.gd`**: Lida com a lógica de salvar e carregar o progresso.

---

## 2. O Jogador

### Cena e Componentes (`player.tscn`)
O jogador é um `CharacterBody2D` com os seguintes componentes:
-   **`AnimatedSprite2D`**: Para as animações de correr, pular, etc.
-   **`CollisionShape2D`**: Colisão principal.
-   **`Camera2D`**: Segue o jogador, com limites para não sair do nível.
-   **`StateMachine`**: Gerencia os estados do jogador.
-   **`Hurtbox` (Area2D)**: Para receber dano.
-   **`Hitbox` (Area2D)**: Para causar dano em ataques corpo a corpo.

### Física de Plataforma
-   A gravidade é aplicada constantemente à `velocity.y` no `_physics_process`.
-   O movimento horizontal é controlado pelo input.
-   O pulo aplica uma força negativa instantânea à `velocity.y`.
-   `move_and_slide()` é a função que move o personagem e gerencia colisões com o cenário.

### Máquina de Estados (FSM) do Jogador
A lógica do jogador é dividida em estados para organização.
-   **`StateMachine.gd`**: O gerenciador que transiciona entre estados.
-   **`State.gd`**: A classe base para todos os estados.
-   **Estados:**
    -   `Idle`: Parado.
    -   `Run`: Movendo-se no chão.
    -   `Jump`: Subindo no ar.
    -   `Fall`: Caindo.
    -   `Hurt`: Ativado ao receber dano.

---

## 3. Sistema de Combate

### Hitbox, Hurtbox e `AttackData`
-   **Hurtbox**: Uma `Area2D` no jogador e nos inimigos (layer "hurtbox") que detecta ataques.
-   **Hitbox**: Uma `Area2D` ativada durante a animação de ataque (layer "hitbox") que causa dano.
-   **`AttackData`**: Um dicionário enviado com cada ataque, contendo `base_damage`, `knockback_force`, etc.

### Combate Corpo a Corpo (Melee)
-   A `Hitbox` do jogador é ativada apenas durante os frames de ataque da `AnimationPlayer`. Ao detectar uma `Hurtbox`, chama a função `take_damage` no alvo.

### Feedback de Dano (Texto Flutuante)
-   **`FloatingTextManager.gd` (Autoload)**: Gerencia a criação de textos flutuantes.
-   **`FloatingText.tscn`**: Uma cena `Node2D` com um `Label` e um `Tween` para animar o texto.
-   **Integração**: A função `take_damage` chama `FloatingTextManager.show_damage_text()`.

---

## 4. Inimigos e IA

### Cena Base do Inimigo (`enemy_base.tscn`)
Uma cena `CharacterBody2D` genérica para inimigos de plataforma.
-   Componentes similares ao jogador, mas com IA.
-   `PlayerDetector` (Area2D): Para detectar o jogador.

### Máquina de Estados (FSM) da IA
-   **`enemy.gd`**: Carrega o `EnemyData` e delega o comportamento à FSM.
-   **Estados da IA:**
    -   `Patrol`: Anda de um lado para o outro.
    -   `Chase`: Segue o jogador se detectado.
    -   `Attack`: Ataca o jogador se estiver no alcance.

---

## 5. Sistemas de Progressão e Mundo

(Estes sistemas são idênticos aos do manual do Top-Down Shooter e podem ser reutilizados)

### Níveis e Experiência (XP)
-   **`ExperienceManager.gd` (Autoload)**: Rastreia o progresso de nível do jogador.

### Inventário e Itens
-   **`ItemResource.gd`** e **`InventoryManager.gd` (Autoload)**: Gerenciam os itens coletados.

### Equipamentos e Stats
-   **`EquipmentManager.gd` (Autoload)**: Gerencia itens equipados e seus bônus de stats.

### Loot de Inimigos
-   **`LootTable.gd`** e **`LootSystem.gd` (Autoload)**: Gerenciam drops de itens de forma ponderada.

### Lojas e Moeda
-   **`WalletManager.gd` (Autoload)** e **`ShopInventory.gd`**: Gerenciam a economia do jogo.

---

## 6. Interação e Narrativa

### Sistema de Interação com Objetos
-   **`Interactable.tscn`**: Componente `Area2D` para tornar qualquer objeto interativo.

### Sistema de Diálogo
-   **`DialogueResource.gd`** e **`DialogueManager.gd` (Autoload)**: Para criar e exibir conversas.

### Cutscenes Simples
-   Usa o `AnimationPlayer` para orquestrar eventos e animações de cena.

---

## 7. Mundo e UI

### Level Design com `TileMap`
-   O nó `TileMap` é usado para construir os níveis.
-   Uma camada de física no `TileSet` define quais tiles são sólidos.

### Perigos Ambientais
-   **`Hazard.tscn`**: Uma cena `Area2D` genérica para criar áreas de dano como espinhos e lava.

### Interface do Usuário (UI)
-   **`CanvasLayer`**: Usado como nó raiz para todas as cenas de UI.
-   **Menus**: Estruturados com nós de controle padrão.

### Sistema de Save/Load
-   **`SaveManager.gd` (Autoload)**: Gerencia o salvamento e carregamento do progresso em JSON.

---

## 8. Sistemas Avançados (Opcional)

### Eventos Globais e Flags
-   **`WorldStateManager.gd` (Autoload)**: Rastreia o estado global do mundo para criar um jogo reativo.

### IA com Machine Learning
-   Uma abordagem avançada para IA, envolvendo treinamento offline em Python e inferência online em Godot via ONNX.