# GEMINI.md - Documento Mestre do Curso de Godot

---

## **Visão Geral e Filosofia de Ensino**

Este documento é o manual central e a documentação viva para o curso **"Godot 2D - Do Zero ao Jogo Completo"**. Ele consolida a filosofia de ensino, a estrutura dos módulos e as arquiteturas detalhadas de todos os sistemas que serão construídos.

### **Filosofia Didática Oficial da Formação**

A abordagem do curso é guiada por um princípio fundamental: **ensinar a tecnologia como ela é hoje, com foco na prática e na mentalidade profissional desde o início.**

-   **Abordagem Moderna:** Ensinamos as ferramentas e recursos atuais como o padrão natural da tecnologia, sem nos prendermos a como "as coisas eram antes". Se uma ferramenta tem IA, a IA faz parte do seu uso padrão. Se o GDScript tem features modernas, elas são o ponto de partida.
-   **Foco no Iniciante:** A jornada é desenhada para quem está começando. Evitamos ruído e distrações históricas para focar no que é necessário para construir o futuro.
-   **Prática Aplicada:** O aprendizado é contextualizado. Ensinamos a ferramenta no seu estado atual, mostrando como usá-la na prática, dentro de projetos reais e funcionais.
-   **Mentalidade Profissional:** O aluno aprende como as coisas funcionam no mercado *hoje*, acelerando sua curva de aprendizado e preparando-o para desafios reais.

**Benefícios:**
-   Curso mais limpo, objetivo e rápido.
-   Conteúdo que permanece relevante por mais tempo.
-   Formação de profissionais preparados para o mercado atual.

---

## **Estrutura e Roadmap do Curso**

A jornada é dividida em módulos, onde cada módulo (a partir do 2) resulta em um jogo completo e funcional, introduzindo conceitos de forma incremental.

### **Módulo 0: Bem-vindo à Godot Engine**
-   **Objetivo:** Familiarizar o aluno com o ambiente, a filosofia e a interface da Godot, sem a necessidade de programação.
-   **Aulas:**
    -   **0.1 - Apresentação do Curso e do Instrutor:** Boas-vindas, apresentação da estrutura de módulos e dos projetos que serão desenvolvidos.
    -   **0.2 - A Filosofia Godot:** Explicação dos conceitos centrais:
        -   **Nós (Nodes):** Blocos de construção focados.
        -   **Cenas (Scenes):** Conjuntos de nós para criar objetos complexos (personagens, itens, níveis).
        -   **Árvore de Cenas (Scene Tree):** A estrutura hierárquica de pai e filho.
        -   **Sinais (Signals):** O sistema de comunicação desacoplado.
    -   **0.3 - Instalando o Godot e Configurando o Ambiente:** Guia para baixar a versão correta, instalar os templates de exportação e fazer configurações iniciais no editor para maior produtividade.
    -   **0.4 - Tour Completo pela Interface do Godot 4.x:** Exploração detalhada das quatro regiões principais do editor: Viewport (centro), Painel de Cenas e Arquivos (esquerda), Inspector e Nós (direita), e o painel inferior (Saída, Debugger, Animação).

### **Módulo 1: A Caixa de Ferramentas Godot**
-   **Objetivo:** Apresentar os nós e conceitos fundamentais que são os blocos de construção de qualquer jogo 2D.
-   **Aulas:**
    -   **1.1 - Nós 2D Essenciais:**
        -   `Node2D`: O pino de referência para posição, rotação e escala.
        -   `Sprite2D`: Para exibir imagens estáticas.
        -   `AnimatedSprite2D`: Para animações frame a frame.
    -   **1.2 - Corpos e Colisões:**
        -   `CharacterBody2D`: Para controle preciso de personagens (jogador, NPCs).
        -   `StaticBody2D`: Para objetos de cenário imóveis (chão, paredes).
        -   `RigidBody2D`: Para objetos controlados pela física (caixas, pedras).
        -   `Area2D`: Para detecção e gatilhos (moedas, zonas de dano, hitboxes).
    -   **1.3 - Nós de UI (Interface do Usuário):**
        -   `Control`: O nó base para toda a UI.
        -   `Label`: Para exibir texto.
        -   `Button`: Para interação do usuário.
        -   `TextureRect`: Para exibir imagens na UI.
        -   `Containers` (`VBoxContainer`, `HBoxContainer`, etc.): Para organização responsiva da UI.
    -   **1.4 - Nós Auxiliares:**
        -   `Timer`: Para ações baseadas em tempo (cooldowns, spawn de inimigos).
        -   `Camera2D`: Para seguir o jogador e controlar a visão do jogo.
        -   `CanvasLayer`: Para garantir que a UI fique fixa na tela, independente da câmera.

### **Módulos 2-5: Projetos Práticos (Exemplos de Estrutura)**
-   **Jogo 1 - "Pong Moderno":** Foco em input, colisões e UI simples.
-   **Jogo 2 - "Clicker de Moedas":** Foco em UI, Timers e Save/Load.
-   **Jogo 3 - "Nave Espacial (Top-Down Shooter)":** Foco em instanciar cenas, `Area2D` e movimento.
-   **Jogo 4 - "Plataforma 2D Simples":** Foco em física de plataforma, `TileMap` e `AnimatedSprite2D`.

### **Módulo 6: Plugins Essenciais (Visão Geral)**
-   **Objetivo:** Apresentar ferramentas da comunidade que resolvem problemas complexos, preparando o terreno para implementações futuras.
-   **Aulas:**
    -   **6.1 - Dialogue Manager:** Apresentação do plugin para sistemas de diálogo avançados, sua sintaxe e funcionalidades.
    -   **6.2 - GodotSteam:** Introdução à integração com a Steam (Conquistas, Cloud Save) e como configurar o ambiente de teste.
    -   **6.3 - LimboAI:** Explicação do que são Árvores de Comportamento (Behavior Trees) e como o LimboAI facilita a criação de IAs complexas.
    -   **6.4 - Phantom Camera:** Demonstração de como usar o plugin para criar movimentos de câmera cinematográficos e dinâmicos.

### **Módulo 7: Tutoriais de Sistemas Essenciais (Implementação Detalhada)**
-   **Objetivo:** Construir, passo a passo, os sistemas modulares e reutilizáveis que formam a espinha dorsal de um jogo profissional.
-   **Aulas:**
    -   **7.1 - Sistema de Áudio Centralizado (Singleton):** Criar um `AudioManager` para gerenciar músicas e SFX de forma global.
    -   **7.2 - Gerenciador de Cenas e Transições:** Criar um `SceneManager` com animações de fade para trocas de cena suaves.
    -   **7.3 - Sistema de Save e Load (com JSON):** Implementar um `SaveManager` para persistir dados do jogo.
    -   **7.4 - Sistema de Inventário (com Recursos Customizados):** Construir um `InventoryManager` usando `ItemResource` para definir itens.
    -   **7.5 - Introdução a Shaders 2D:** Criar efeitos visuais como "hit flash" e contornos.
    -   **7.6 - O Menu de Pause e a Tela de Configurações:** Estruturar a UI de pause e o `TabContainer` para as opções.
    -   **7.7 - Sistema de Configurações Gráficas:** Implementar as opções de resolução, modo de tela e V-Sync.
    -   **7.8 - Sistema de Configurações de Áudio:** Criar sliders de volume que interagem com o `AudioManager`.
    -   **7.9 - Padrão de Design: Máquina de Estados (State Machine):** Implementar uma FSM para controle de personagens.
    -   **7.10 - Sistema de Múltiplos Slots de Save:** Aprimorar o `SaveManager` para lidar com múltiplos arquivos de save.
    -   **7.11 - Sistema de Localização (Idiomas):** Usar o sistema de tradução do Godot com arquivos CSV.
    -   **7.12 - Sistema de Diálogos (usando Dialogue Manager):** Implementar um fluxo de diálogo completo com o plugin.

---

## **Arquitetura e Manuais de Sistemas**

Esta seção detalha as arquiteturas de referência para cada sistema principal do jogo.

### **Manual de Sistemas Globais (Autoloads)**

Gerenciam o estado e os sistemas globais do jogo, acessíveis de qualquer lugar.

-   **Configuração (`Project > Project Settings > Autoload`):**
    1.  `Global`: `res://scripts/core/globals.gd`
    2.  `SceneManager`: `res://scripts/core/scene_manager.gd`
    3.  `SettingsManager`: `res://scripts/core/settings_manager.gd`
    4.  `SaveManager`: `res://scripts/core/save_manager.gd`
    5.  `AudioManager`: `res://scripts/core/audio_manager.gd`
    6.  `WorldStateManager`: `res://scripts/core/world_state_manager.gd`
    7.  `ExperienceManager`: `res://scripts/core/experience_manager.gd`
    8.  `InventoryManager`: `res://scripts/systems/inventory_manager.gd`
    9.  `EquipmentManager`: `res://scripts/systems/equipment_manager.gd`
    10. `LootSystem`: `res://scripts/systems/loot_system.gd`
    11. `FloatingTextManager`: `res://scripts/ui/floating_text_manager.gd`

-   **`Global.gd`:** Armazena variáveis de estado do jogo (ex: `player_data`, `game_time`).
-   **`SceneManager.gd`:** Gerencia a transição entre cenas, incluindo animações de fade.
-   **`SettingsManager.gd`:** Carrega, aplica e salva as preferências do jogador (gráficos, áudio, controles) em um arquivo `settings.json`.
-   **`AudioManager.gd`:** Controla a reprodução de músicas e SFX, respondendo às configurações de volume.
-   **`SaveManager.gd`:** Lida com a lógica de salvar e carregar o progresso do jogo.

---

### **Manual de Arquitetura de Dados (Resources)**

A filosofia central é usar `Resource` para criar uma arquitetura orientada a dados, desacoplando dados da lógica.

-   **`CharacterStats.gd` (Resource):** Contém atributos fundamentais.
    ```gdscript
    class_name CharacterStats
    extends Resource

    @export_group("Atributos Primários")
    @export var max_health: int = 100
    @export var move_speed: float = 200.0
    
    @export_group("Combate")
    @export var base_damage: int = 10
    @export var defense: int = 5
    @export var attack_speed: float = 1.0 # Ataques por segundo
    ```

-   **`EnemyData.gd` (Resource, herda de `CharacterStats`):** Adiciona informações específicas de inimigos.
    ```gdscript
    class_name EnemyData
    extends CharacterStats

    @export_group("Comportamento e Aparência")
    @export var scene: PackedScene 
    @export var ai_type: Enum("Patrulha", "Estacionário", "Voador") = "Patrulha"

    @export_group("Loot e Recompensas")
    @export var loot_table: Resource
    @export var experience_points: int = 10
    ```

-   **`ItemResource.gd` (Resource):** Define os dados de um item.
    ```gdscript
    class_name ItemResource
    extends Resource

    @export var id: StringName
    @export var name: String
    @export_multiline var description: String
    @export var stackable: bool = false
    @export var texture: Texture2D
    @export var base_value: int = 10
    enum ItemType { CONSUMABLE, EQUIPMENT, KEY_ITEM }
    @export var type: ItemType = ItemType.CONSUMABLE
    ```

-   **Vantagens:**
    -   **Flexibilidade:** Crie variações de conteúdo (inimigos, itens) sem código.
    -   **Balanceamento Facilitado:** Ajuste valores diretamente no Inspector.
    -   **Colaboração:** Designers podem trabalhar nos dados enquanto programadores focam na lógica.

---

### **Manual da Máquina de Estados (FSM)**

Arquitetura para controlar o comportamento de entidades como o jogador e a IA.

-   **Componentes:**
    1.  **A Máquina (`StateMachine.gd`):** Um nó que gerencia o estado atual e as transições. Contém a função `transition_to(state_name)`.
    2.  **Os Estados (`State.gd` e seus filhos):** Nós individuais, cada um representando um comportamento (`Idle`, `Run`, `Attack`).

-   **`State.gd` (Classe Base):** Define a interface que todo estado deve ter:
    ```gdscript
    class_name State
    extends Node

    var state_machine: StateMachine
    @onready var owner = get_parent().get_parent()

    func enter(payload: Dictionary = {}):
        pass
    func process(delta: float):
        pass
    func process_physics(delta: float):
        pass
    func handle_input(event: InputEvent):
        pass
    func exit():
        pass
    ```

-   **Estrutura:** Um `CharacterBody2D` (ex: `Player`) contém um nó `StateMachine`, que por sua vez contém todos os nós de estado como filhos.

---

### **Manual de Combate Unificado**

Arquitetura flexível para qualquer gênero de jogo de ação.

-   **Conceitos Fundamentais:**
    -   **Hitbox:** `Area2D` que representa o alcance de um ataque (Layer: "hitbox", Mask: "hurtbox").
    -   **Hurtbox:** `Area2D` que representa as partes vulneráveis de um personagem (Layer: "hurtbox", Mask: "hitbox").
    -   **`AttackData` (Dicionário):** Um pacote de dados enviado no ataque (`base_damage`, `knockback_force`, `source`, `damage_type`).
    -   **`take_damage(attack_data)`:** Função na vítima que recebe o `AttackData`, calcula o dano final, aplica knockback e gerencia frames de invencibilidade.
        ```gdscript
        # No defensor (jogador, inimigo)
        func take_damage(attack_data: Dictionary):
            # Lógica de frames de invencibilidade
            if is_invincible: return

            var incoming_damage = attack_data.get("base_damage", 0)
            var final_damage = max(1, incoming_damage - stats.defense)

            current_health -= final_damage
            
            # Feedback de Dano
            FloatingTextManager.show_damage_text(final_damage, global_position)

            var knockback_source = attack_data.get("source")
            if knockback_source:
                var direction = (global_position - knockback_source.global_position).normalized()
                velocity = direction * attack_data.get("knockback_force", 0)
            
            state_machine.transition_to("Hurt")
            if current_health <= 0: die()
        ```

-   **Arquétipos de Combate (Exemplos):**
    -   **Melee:** Hack 'n' Slash (arco amplo), Duelista (ataque preciso, parry), Arma Pesada (ataques lentos com carga), Lanceiro (longo alcance).
    -   **Ranged:** Projétil Genérico (`projectile.tscn`), Arqueiro (física de arco), Hitscan (`RayCast2D`), Teleguiado.
    -   **Mágico/Especial:** Dano em Área (AoE), Dano Contínuo (DoT), Armadilhas, Invocações, Buffs/Debuffs.

---

### **Manual do Sistema de Interação**

Sistema genérico para interação com NPCs, baús, portas, etc.

-   **Filosofia:** Desacoplamento. O jogador apenas "interage", o objeto decide o que acontece.
-   **Componente `Interactable.tscn` (`Area2D`):**
    -   Cena reutilizável adicionada como filha a qualquer objeto interativo.
    -   Detecta a entrada/saída do jogador para mostrar/esconder um prompt visual.
    -   Emite um sinal `interacted` quando o jogador pressiona a tecla de interação.
-   **Lógica do Jogador:**
    -   Usa uma `Area2D` para detectar o `Interactable` mais próximo.
    -   Ao pressionar "interact", chama a função `do_interaction()` no `Interactable` em alcance.
-   **Objeto Interativo (Ex: `chest.gd`):**
    -   Conecta-se ao sinal `interacted` do seu próprio componente `Interactable`.
    -   Executa sua lógica específica (tocar animação, dar loot, iniciar diálogo).

---

### **Manual do Sistema de Inventário**

Arquitetura flexível baseada em `Resource` e um singleton.

-   **`ItemResource.gd`:** A base de dados para cada item (ver Manual de Recursos).
-   **`InventoryManager.gd` (Autoload):**
    -   Gerencia uma lista de itens (ex: `Array` de Dicionários `{"item": ItemResource, "quantity": int}`).
    -   Fornece funções `add_item`, `remove_item`.
    -   Emite um sinal `inventory_changed` sempre que o inventário é modificado.
-   **`InventoryUI.tscn` (`CanvasLayer`):**
    -   Conecta-se ao sinal `inventory_changed` para se redesenhar automaticamente.
    -   Usa uma cena `InventorySlotUI.tscn` para cada slot, que é populada com os dados do `ItemResource`.

---

### **Manual do Sistema de Equipamentos**

Permite ao jogador equipar itens para modificar stats.

-   **Expansão do `ItemResource.gd`:**
    -   Adiciona `enum ItemType { CONSUMABLE, EQUIPMENT }`.
    -   Adiciona `enum EquipmentSlot { WEAPON, HEAD, CHEST }`.
    -   Adiciona `@export var stats_bonus: CharacterStats` para definir os bônus que o item concede.
-   **`EquipmentManager.gd` (Autoload):**
    -   Mantém um dicionário dos itens equipados em cada slot.
    -   Funções `equip_item` e `unequip_item`.
    -   **Função Chave: `recalculate_player_stats()`:**
        1.  Começa com os stats base do jogador.
        2.  Itera sobre todos os itens equipados.
        3.  Soma os `stats_bonus` de cada item.
        4.  Aplica os stats totais calculados ao jogador.
-   **Integração:** A UI de inventário é expandida para mostrar os slots de equipamento e se conecta ao sinal `equipment_changed` do `EquipmentManager`.

---

### **Manual do Sistema de Diálogo**

Arquitetura para diálogos complexos, com duas abordagens:

1.  **Sistema Baseado em `Resource`:**
    -   `DialogueResource.gd`: Um recurso que contém nome/retrato do personagem, um array de falas (`lines`), e um array de escolhas (`choices`), onde cada escolha é outro `DialogueResource`, formando uma árvore.
    -   `DialogueManager.gd` (Autoload): Gerencia a UI, exibe as falas, cria botões para as escolhas e avança na conversa.

2.  **Sistema com Plugin `Dialogue Manager` (Recomendado para complexidade):**
    -   **Arquivo `.dialogue`:** Escreve diálogos em uma sintaxe simples com suporte nativo a personagens, escolhas `[choice]`, condições `[if]` e comandos `[set Global.variable]`.
    -   **`DialogueBox` (Nó do Plugin):** Adicionado à sua UI, gerencia automaticamente a exibição do texto, nome, retrato e criação de botões de escolha.
    -   **Integração:** Inicia-se uma conversa chamando `DialogueUI.start_dialogue(resource, "timeline_name")`. A comunicação com o jogo é feita via Singletons (ex: `Global.gd`).

---

### **Manual de Níveis e Experiência (XP)**

Sistema para gerenciar a progressão do jogador.

-   **`ExperienceManager.gd` (Autoload):**
    -   Rastreia `current_level`, `current_xp`, e `xp_for_next_level`.
    -   `add_xp(amount)`: Adiciona experiência e verifica se o jogador subiu de nível.
    -   `level_up_procedure()`: Incrementa o nível, recalcula o XP necessário para o próximo (usando uma curva exponencial), e emite o sinal `level_up`.
-   **Integração:**
    -   Inimigos (`EnemyData.gd`) definem o XP que concedem ao morrer.
    -   Quests concedem XP ao serem completadas.
    -   A HUD se conecta aos sinais `experience_gained` e `level_up` para atualizar a barra de XP e o label de nível.

---

### **Manual de Save/Load**

Arquitetura para salvar o progresso em JSON, com múltiplos slots.

-   **`SaveManager.gd` (Autoload):**
    -   Gerencia arquivos `slot_X.json` no diretório `user://`.
    -   `save_game(slot_index)`: Coleta dados de todos os sistemas relevantes (Player, Inventory, WorldState), converte para JSON e salva.
    -   `load_game(slot_index)`: Carrega o JSON, aplica os dados aos sistemas e troca para a cena salva.
    -   `get_save_info(slot_index)`: Lê metadados de um save (timestamp, tempo de jogo) para exibir na UI sem carregar o jogo inteiro.
-   **Objetos Persistentes:** Nós que precisam salvar seu estado (ex: um baú aberto) são colocados no grupo "Persist" e devem implementar as funções `save() -> Dictionary` e `load(data: Dictionary)`.

---

### **Manual de UI (Interface do Usuário)**

Estrutura e funcionalidade das cenas de UI.

-   **Princípio:** Cenas de UI principais (`MainMenu`, `OptionsMenu`, `PauseMenu`, `GameHUD`) são `CanvasLayer` para renderizar sobre o jogo.
-   **`PauseMenu.tscn`:**
    -   Deve ter `process_mode` definido como `Always` para funcionar enquanto o jogo está pausado (`get_tree().paused = true`).
    -   Controla o pause e oferece opções para continuar, ir para as opções ou sair.
-   **`OptionsMenu.tscn`:**
    -   Usa um `TabContainer` para organizar as seções (Gráficos, Áudio, Controles, Jogo).
    -   Cada controle na UI (slider, checkbox) se conecta a uma função que chama `SettingsManager.set_setting("chave", valor)`.
    -   O script carrega os valores do `SettingsManager` no `_ready` para popular a UI.

---

### **Manual de Eventos Globais e Flags**

Sistema centralizado para rastrear o estado do mundo e o progresso do jogador.

-   **`WorldStateManager.gd` (Autoload):**
    -   Contém um dicionário principal `world_state`.
    -   Ex: `{"chefe_floresta_derrotado": true, "pontes_consertadas": 3}`.
    -   Funções `set_flag(flag_name, value)` e `get_flag(flag_name, default_value)`.
    -   Emite um sinal `flag_changed` para que outros sistemas possam reagir.
-   **Uso:**
    -   **Diálogos Dinâmicos:** NPCs verificam flags para decidir qual diálogo usar.
    -   **Eventos de Nível:** Uma ponte pode se consertar ao ouvir a flag `chefe_derrotado`.
    -   **Sistema de Quests:** Rastreia objetivos verificando e incrementando flags (ex: `slimes_derrotados`).
-   **Persistência:** O `SaveManager` é responsável por salvar e carregar o dicionário `world_state`.

---

### **Manual de IA Inimiga**

Arquitetura para criar comportamentos de IA usando FSM e `Resource`.

-   **`enemy_base.tscn`:** Uma cena base de inimigo com `CharacterBody2D`, `AnimatedSprite2D`, `StateMachine`, `Hurtbox`, e `Area2D`s para detecção.
-   **`enemy.gd`:** Script leve que carrega os dados do `EnemyData` e delega o comportamento para a FSM.
-   **Estados da IA:**
    -   **`Patrol`:** Move-se entre pontos. Transiciona para `Chase` ao detectar o jogador.
    -   **`Chase`:** Segue o jogador. Transiciona para `Attack` se o jogador estiver no alcance, ou para `Patrol` se o jogador for perdido.
    -   **`Attack`:** Para de se mover, toca a animação de ataque (que ativa a `Hitbox`) e entra em cooldown.
-   **Variações:** Criar novos inimigos (mago, covarde, torreta) envolve criar um novo `EnemyData.tres` e, se necessário, novos estados para a FSM, mantendo a cena base.

---

### **Manual de Combate e Feedback**

-   **Feedback de Dano (`FloatingText`):**
    -   `FloatingTextManager.gd` (Autoload) para instanciar cenas `FloatingText.tscn`.
    -   A função `take_damage` do personagem chama `FloatingTextManager.show_damage_text(dano, posicao)` para criar um número de dano flutuante na tela.
-   **Perigos Ambientais (`Hazard.tscn`):**
    -   Uma `Area2D` genérica com um script que aplica um `AttackData` a qualquer corpo que entrar.
    -   Usa um `Timer` para aplicar dano em intervalos (ticks).
    -   Diferentes perigos (lava, espinhos, veneno) são criados apenas ajustando as propriedades (`damage_per_tick`, `tick_interval`, `damage_type`) no Inspector.

---

### **Manual de Navegação**

-   **Mapa e Minimapa:**
    -   **Minimapa:** Usa um `SubViewport` com uma segunda `Camera2D` (`MapCamera`) que segue o jogador. Esta câmera tem um `Cull Mask` para enxergar apenas nós em uma camada "map_layer", permitindo ícones customizados.
    -   **Mapa de Tela Cheia:** Pode ser implementado capturando uma imagem do `SubViewport` ou desenhando o mapa de forma vetorial com base nos `TileMap`s descobertos.
    -   **Névoa de Guerra:** Revela o mapa à medida que o jogador explora, mantendo um registro das áreas visitadas.

---

### **Manual de Documentação de Design**

O curso também abrange a importância da documentação para um fluxo de trabalho profissional.

-   **GDD (Game Design Document):** O documento central que descreve a visão do jogo, mecânicas, narrativa, loop de gameplay, etc.
-   **TDD (Technical Design Document):** Detalha a arquitetura de software, estrutura de dados e APIs dos sistemas.
-   **ADR (Architecture Decision Records):** Registra decisões de arquitetura importantes e suas justificativas (ex: "Por que usamos Godot?").
-   **Outros Documentos:** Guias de Estilo (Arte, Áudio), Planos (Marketing, Testes, Localização), etc.

---

Este documento mestre serve como a "fonte da verdade" para todo o conteúdo e arquitetura do curso, garantindo uma experiência de aprendizado coesa, prática e alinhada com as melhores práticas do desenvolvimento de jogos.