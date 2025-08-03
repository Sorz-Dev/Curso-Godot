# Apostila 06: Sistemas Globais e Gerenciamento de Estado

**Nível de Dificuldade:** Intermediário

**Pré-requisitos:** Conhecimento sólido de GDScript e da estrutura de cenas.

---

## 1. A Filosofia: O Governo do Jogo

Conforme um jogo cresce, você percebe que certas informações e funcionalidades precisam estar acessíveis em **qualquer lugar, a qualquer momento**.
-   Como tocar um som a partir de um botão de UI e de um inimigo?
-   Como salvar o jogo a partir do menu de pause e de um checkpoint?
-   Como saber o estado de uma quest em uma cena de diálogo e em um item de inventário?

A resposta é ter **gerenciadores globais**, também conhecidos como **Singletons**. Em Godot, a maneira mais fácil e eficiente de criar singletons é usando o sistema **Autoload**.

Um Autoload é um script (ou uma cena) que o Godot carrega **automaticamente** no início do jogo, antes de qualquer outra cena. Ele permanece na memória durante toda a execução e pode ser acessado globalmente por seu nome.

**A Regra de Ouro:** Um Autoload deve gerenciar **um único sistema** e fazê-lo bem. Evite criar um "GodManager.gd" que faz tudo. Em vez disso, crie gerenciadores especializados.

---

## 2. Configurando os Autoloads

A configuração é feita em `Projeto -> Configurações do Projeto... -> Autoload`.

**Ordem de Carregamento Importa!** Os Autoloads são carregados na ordem em que aparecem na lista. Garanta que sistemas dos quais outros dependem sejam carregados primeiro.

-   **Estrutura de Arquivos Sugerida:** `scripts/core/`
-   **Lista de Autoloads Essenciais (e ordem):**
    1.  **`SettingsManager.gd`:** Carrega as configurações do jogador do disco. Outros sistemas (como o de Áudio) dependerão dele no `_ready`.
    2.  **`SaveManager.gd`:** Gerencia os arquivos de save.
    3.  **`WorldStateManager.gd`:** Mantém o estado das flags do jogo. O `SaveManager` o usará para carregar o estado do mundo.
    4.  **`AudioManager.gd`:** Gerencia a reprodução de áudio.
    5.  **`SceneManager.gd`:** Gerencia a transição entre cenas.
    6.  **Outros Gerenciadores:** `InventoryManager`, `ExperienceManager`, etc.

---

## 3. Detalhes dos Gerenciadores Principais

### 3.1. `SceneManager.gd` (Gerenciador de Cenas)

-   **Propósito:** Centralizar a lógica de troca de cenas para permitir transições suaves e evitar código repetido.
-   **Nós:** Geralmente é uma cena (`scene_manager.tscn`) que contém um `CanvasLayer` com um `ColorRect` e um `AnimationPlayer` para as animações de fade.
-   **Função Chave: `switch_scene(scene_path: String)`**
    1.  Armazena `scene_path` em uma variável.
    2.  Toca a animação `fade_out` no seu `AnimationPlayer`.
    3.  Conecta o sinal `animation_finished` do `AnimationPlayer` a uma função `_on_fade_out_finished`.
    4.  Na função `_on_fade_out_finished`:
        -   Chama `get_tree().change_scene_to_file(scene_path)`.
        -   **Importante:** Após a troca de cena, a cena do `SceneManager` persiste, mas o `AnimationPlayer` pode precisar ser reiniciado ou a próxima animação (`fade_in`) pode ser tocada no `_ready` da nova cena, chamando uma função no `SceneManager`. Uma abordagem comum é o `SceneManager` emitir um sinal `scene_changed` ao qual a nova cena pode se conectar para acionar o `fade_in`.

### 3.2. `WorldStateManager.gd` (Gerenciador de Flags)

-   **Propósito:** A "memória" do seu jogo. Rastreia o progresso da história e os estados do mundo.
-   **Estrutura:** Um script simples que herda de `Node`.
-   **Dados:** `var world_state: Dictionary = {}`
    -   Ex: `{"boss_1_defeated": true, "npc_met": "bruno", "gems_collected": 5}`
-   **Funções:**
    -   `set_flag(flag_name: String, value)`: Altera um valor no dicionário e emite um sinal `flag_changed(flag_name, value)`.
    -   `get_flag(flag_name: String, default = null)`: Retorna um valor, ou um padrão se a flag não existir.
-   **Integração com Save/Load:** O `SaveManager`, ao salvar, chama `WorldStateManager.get_save_data()` que retorna o dicionário `world_state`. Ao carregar, ele chama `WorldStateManager.load_from_data(saved_state)`.

### 3.3. `SaveManager.gd` (Gerenciador de Save/Load)

-   **Propósito:** Orquestrar o processo de salvar e carregar, comunicando-se com todos os outros gerenciadores.
-   **Função `save_game(slot_index: int)`:**
    1.  Cria um dicionário vazio: `var save_data = {}`.
    2.  **Coleta dados de cada sistema:**
        -   `save_data["world_state"] = WorldStateManager.get_save_data()`
        -   `save_data["inventory"] = InventoryManager.get_save_data()`
        -   `save_data["player_stats"] = ExperienceManager.get_save_data()`
        -   `save_data["current_scene_path"] = get_tree().current_scene.scene_file_path`
    3.  Converte `save_data` para JSON com `JSON.stringify()`.
    4.  Usa `FileAccess` para escrever a string no arquivo `user://saves/slot_{slot_index}.json`.
-   **Função `load_game(slot_index: int)`:**
    1.  Usa `FileAccess` para ler o arquivo JSON.
    2.  Converte a string para um dicionário com `JSON.parse_string()`.
    3.  **Distribui os dados para cada sistema:**
        -   `WorldStateManager.load_from_data(loaded_data.get("world_state"))`
        -   `InventoryManager.load_from_data(loaded_data.get("inventory"))`
        -   ... e assim por diante.
    4.  **Por último**, chama `SceneManager.switch_scene(loaded_data.get("current_scene_path"))` para levar o jogador à cena correta.

Essa arquitetura de gerenciadores especializados que se comunicam entre si é a chave para construir jogos complexos que são, ao mesmo tempo, robustos e fáceis de manter.
