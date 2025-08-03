# Manual de Implementação: Top-Down Shooter

Este documento é o guia completo para a arquitetura e sistemas do jogo Top-Down Shooter, consolidando todos os manuais de sistema do template em um guia de implementação específico para este projeto.

## Índice

1.  **Visão Geral e Arquitetura Principal**
    *   Estrutura de Arquivos
    *   Arquitetura de Dados com `Resources`
    *   Sistemas Globais (Autoloads)
2.  **O Jogador (Nave)**
    *   Cena e Componentes
    *   Máquina de Estados (FSM) do Jogador
3.  **Sistema de Combate**
    *   Hitbox, Hurtbox e `AttackData`
    *   Combate à Distância (Tiros)
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
    *   Mapa e Minimapa
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

## 2. O Jogador (Nave)

### Cena e Componentes (`player.tscn`)
O jogador é um `CharacterBody2D` com os seguintes componentes:
-   **`AnimatedSprite2D`**: Para as animações da nave.
-   **`CollisionShape2D`**: Colisão principal.
-   **`Camera2D`**: Segue o jogador.
-   **`StateMachine`**: Gerencia os estados do jogador.
-   **`Hurtbox` (Area2D)**: Para receber dano.
-   **`Marker2D` (`Muzzle`)**: Ponto de onde os projéteis são disparados.

### Máquina de Estados (FSM) do Jogador
A lógica do jogador é dividida em estados para organização.
-   **`StateMachine.gd`**: O gerenciador que transiciona entre estados.
-   **`State.gd`**: A classe base para todos os estados.
-   **Estados:**
    -   `Idle`: Estado padrão, nave parada.
    -   `Move`: Controla a movimentação da nave com base no input.
    -   `Hurt`: Ativado ao receber dano, cria invencibilidade temporária.

---

## 3. Sistema de Combate

### Hitbox, Hurtbox e `AttackData`
-   **Hurtbox**: Uma `Area2D` no jogador e nos inimigos (layer "hurtbox") que detecta ataques.
-   **Hitbox**: Uma `Area2D` nos projéteis (layer "hitbox") que causa dano.
-   **`AttackData`**: Um dicionário enviado com cada ataque, contendo `base_damage`, `knockback_force`, `source` (quem atacou), etc. A função `take_damage` na vítima usa esses dados para calcular o dano final.

### Combate à Distância (Tiros)
-   **`projectile.tscn`**: Uma cena base de `Area2D` para todos os projéteis. O script do projétil define sua velocidade, direção e o `AttackData` que ele carrega.
-   **Lógica de Tiro**: No estado de ataque do jogador, uma instância de `projectile.tscn` é criada na posição do `Muzzle` e sua direção é definida.

### Feedback de Dano (Texto Flutuante)
-   **`FloatingTextManager.gd` (Autoload)**: Gerencia a criação de textos flutuantes.
-   **`FloatingText.tscn`**: Uma cena `Node2D` com um `Label` e um `Tween` para animar o texto subindo e desaparecendo.
-   **Integração**: A função `take_damage` de qualquer personagem chama `FloatingTextManager.show_damage_text()` para criar o efeito visual.

---

## 4. Inimigos e IA

### Cena Base do Inimigo (`enemy_base.tscn`)
Uma cena `CharacterBody2D` genérica para todos os inimigos, contendo:
-   `AnimatedSprite2D`, `CollisionShape2D`, `Hurtbox`.
-   `StateMachine` com estados de IA.
-   `PlayerDetector` (Area2D): Para detectar o jogador e iniciar o combate.
-   `AttackRange` (Area2D): Para saber quando atacar.

### Máquina de Estados (FSM) da IA
-   **`enemy.gd`**: Script principal que carrega o `EnemyData` e delega o comportamento à FSM.
-   **Estados da IA:**
    -   `Patrol`: Move-se entre pontos predefinidos. Transiciona para `Chase` ao detectar o jogador.
    -   `Chase`: Segue o jogador. Transiciona para `Attack` se o jogador estiver no alcance.
    -   `Attack`: Para de se mover e dispara projéteis contra o jogador.

---

## 5. Sistemas de Progressão e Mundo

### Níveis e Experiência (XP)
-   **`ExperienceManager.gd` (Autoload)**: Rastreia `current_level`, `current_xp` e `xp_for_next_level`.
-   **Integração**: Inimigos concedem XP ao morrer (definido em seu `EnemyData.tres`).

### Inventário e Itens
-   **`ItemResource.gd`**: `Resource` que define os dados de um item (nome, descrição, textura, se é empilhável).
-   **`InventoryManager.gd` (Autoload)**: Gerencia uma lista de itens do jogador e emite o sinal `inventory_changed` quando modificado.

### Equipamentos e Stats
-   **`ItemResource.gd`** é expandido com `ItemType` (EQUIPMENT) e `EquipmentSlot` (WEAPON, HEAD, etc.).
-   **`EquipmentManager.gd` (Autoload)**: Gerencia os itens equipados e recalcula os stats totais do jogador somando os bônus de cada item.

### Loot de Inimigos
-   **`LootTable.gd`**: `Resource` que contém uma lista de `LootItem`s.
-   **`LootItem.gd`**: `Resource` que define um item específico na tabela, sua quantidade e seu "peso" (chance de dropar).
-   **`LootSystem.gd` (Autoload)**: Processa uma `LootTable` para determinar o loot com base nos pesos.

### Lojas e Moeda
-   **`WalletManager.gd` (Autoload)**: Rastreia o dinheiro do jogador.
-   **`ShopInventory.gd`**: `Resource` que define os itens à venda em uma loja.
-   **`ShopUI.tscn`**: A interface que permite comprar e vender itens.

---

## 6. Interação e Narrativa

### Sistema de Interação com Objetos
-   **`Interactable.tscn`**: Uma cena `Area2D` reutilizável que pode ser adicionada a qualquer objeto (NPC, baú). Ela mostra um prompt visual e emite um sinal `interacted`.
-   **Lógica do Jogador**: Detecta o `Interactable` mais próximo e, ao pressionar a tecla de interação, chama a função `do_interaction()` no objeto.

### Sistema de Diálogo
-   **`DialogueResource.gd`**: `Resource` que define uma árvore de diálogo com falas, informações do personagem e escolhas.
-   **`DialogueManager.gd` (Autoload)**: Gerencia a UI de diálogo e o fluxo da conversa.

### Cutscenes Simples
-   Usa o nó `AnimationPlayer` como um "diretor" de cena para animar propriedades de nós (câmera, personagens) e chamar funções em momentos específicos usando a "Call Method Track".

---

## 7. Mundo e UI

### Mapa e Minimapa
-   Usa um `SubViewport` com uma segunda `Camera2D` (`MapCamera`) para renderizar o minimapa. A `MapCamera` enxerga apenas uma camada específica ("map_layer") para ícones customizados.

### Perigos Ambientais
-   **`Hazard.tscn`**: Uma cena `Area2D` genérica que aplica um `AttackData` a qualquer corpo que entrar, usando um `Timer` para dano contínuo (ticks).

### Interface do Usuário (UI)
-   **`CanvasLayer`**: Usado como nó raiz para todas as cenas de UI principais (MainMenu, OptionsMenu, PauseMenu, GameHUD) para garantir que renderizem sobre o jogo.
-   **Menus**: Estruturados com nós de controle padrão (`VBoxContainer`, `TabContainer`, `Button`, etc.).

### Sistema de Save/Load
-   **`SaveManager.gd` (Autoload)**: Gerencia a leitura e escrita de arquivos de save em formato JSON, com suporte a múltiplos slots.
-   **Objetos Persistentes**: Nós no grupo "Persist" devem implementar as funções `save() -> Dictionary` e `load(data: Dictionary)` para salvar e restaurar seu estado.

---

## 8. Sistemas Avançados (Opcional)

### Eventos Globais e Flags
-   **`WorldStateManager.gd` (Autoload)**: Um dicionário global que armazena o estado do mundo (ex: `"chefe_derrotado": true`). Permite que o mundo reaja dinamicamente às ações do jogador.

### IA com Machine Learning
-   Uma abordagem avançada para comportamentos complexos e adaptativos.
-   **Arquitetura**: O treinamento é feito offline em Python (com bibliotecas como Stable Baselines3) e o modelo treinado é exportado no formato ONNX. Uma GDExtension (como Godot-ONNX) é usada para carregar e executar o modelo dentro do Godot para a tomada de decisões (inferência).