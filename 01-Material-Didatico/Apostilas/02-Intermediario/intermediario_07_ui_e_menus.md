# Apostila 07: UI e Menus

**Nível de Dificuldade:** Básico a Intermediário

**Pré-requisitos:** Conhecimento dos nós de `Control` e Sinais.

---

## 1. A Filosofia: Separação e Responsividade

A Interface do Usuário (UI) é um mundo à parte dentro do seu jogo. Ela deve ser tratada como tal, com duas regras principais:

1.  **Separação do Mundo do Jogo:** A UI não deve ser afetada pela câmera do jogo, pelo zoom ou pelo movimento do jogador. Ela deve "flutuar" sobre o jogo. A solução para isso é o nó **`CanvasLayer`**. Qualquer cena de UI principal (HUD, Menu de Pause, etc.) deve ter um `CanvasLayer` como seu nó raiz.
2.  **Design Responsivo:** A UI deve se adaptar a diferentes tamanhos e proporções de tela. O pesadelo de um desenvolvedor é ter botões que saem da tela em um monitor ultrawide. A solução para isso é usar os **`Containers`** do Godot (`VBoxContainer`, `HBoxContainer`, `MarginContainer`, `CenterContainer`, etc.) em vez de posicionar cada elemento manualmente.

---

## 2. Estrutura de Menus Essenciais

### 2.1. Menu Principal (`main_menu.tscn`)

-   **Nó Raiz:** `MainMenu` (CanvasLayer)
-   **Estrutura de Nós (Exemplo):**
    ```
    - MainMenu (CanvasLayer)
      - MarginContainer (Define as margens da tela)
        - CenterContainer (Centraliza o conteúdo)
          - VBoxContainer (Empilha os botões verticalmente)
            - Title (Label)
            - NewGameButton (Button)
            - LoadGameButton (Button)
            - OptionsButton (Button)
            - QuitButton (Button)
    ```
-   **Lógica (`main_menu.gd`):**
    -   O script é simples. Ele apenas conecta o sinal `pressed` de cada botão a uma função.
    -   `_on_new_game_pressed()`: Chama `SceneManager.switch_scene(...)`.
    -   `_on_load_game_pressed()`: Mostra a cena do menu de load.
    -   `_on_options_pressed()`: Mostra a cena do menu de opções.
    -   `_on_quit_pressed()`: Chama `get_tree().quit()`.

### 2.2. Menu de Pause (`pause_menu.tscn`)

-   **Nó Raiz:** `PauseMenu` (CanvasLayer)
-   **Propriedade Chave:** No Inspector, a propriedade `Process -> Mode` do nó raiz **deve ser definida como `Always`**. Isso garante que o menu continue funcionando mesmo quando o jogo está pausado.
-   **Lógica (`pause_menu.gd`):**
    -   **Ativação:** A função `_unhandled_input(event)` é a melhor para capturar a tecla de pause (geralmente `ui_cancel` / ESC), pois ela só é acionada se o input não foi consumido por outra parte do jogo ou UI.
        ```gdscript
        func _unhandled_input(event: InputEvent):
            if event.is_action_pressed("ui_cancel"):
                # Inverte o estado de pause e a visibilidade do menu
                get_tree().paused = not get_tree().paused
                self.visible = get_tree().paused
        ```
    -   **Funcionalidade:** Os botões ("Continuar", "Opções", "Sair") funcionam de forma semelhante ao menu principal, mas a função "Continuar" simplesmente reverte o `get_tree().paused` e a visibilidade.
    -   **Importante:** Ao sair para o menu principal, **sempre despause o jogo primeiro**: `get_tree().paused = false`, e *depois* chame `SceneManager.switch_scene(...)`.

### 2.3. Menu de Opções (`options_menu.tscn`)

-   **Nó Raiz:** `OptionsMenu` (CanvasLayer)
-   **Estrutura:** O nó `TabContainer` é seu melhor amigo aqui. Ele cria automaticamente um sistema de abas.
    -   Adicione um `TabContainer` à sua cena.
    -   Adicione nós `Control` como filhos diretos dele. O nome de cada nó `Control` se tornará o título da aba (ex: "Gráficos", "Áudio", "Controles").
    -   Dentro de cada aba, use `VBoxContainer` e `HBoxContainer` para organizar as opções.
-   **Lógica (`options_menu.gd`):**
    -   **Carregamento:** No `_ready()`, o script deve ler todas as configurações do `SettingsManager` e popular os valores dos controles (sliders, checkboxes, etc.).
    -   **Aplicação e Salvamento:** Cada controle de UI (ex: `MasterVolumeSlider`) tem seu sinal (`value_changed`) conectado a uma função. Essa função faz duas coisas:
        1.  Chama a função de aplicação correspondente (ex: `AudioManager.set_master_volume(new_value)`).
        2.  Chama a função para salvar a configuração (ex: `SettingsManager.set_setting("master_volume", new_value)`).

### 2.4. HUD do Jogo (`game_hud.tscn`)

-   **Nó Raiz:** `GameHUD` (CanvasLayer)
-   **Lógica (`game_hud.gd`):**
    -   A HUD é reativa. Ela não gerencia estado, apenas o exibe.
    -   No `_ready()`, ela se conecta aos sinais dos gerenciadores globais.
        -   `ExperienceManager.health_changed.connect(_on_health_changed)`
        -   `WalletManager.money_changed.connect(_on_money_changed)`
    -   As funções `_on_*` recebem os novos dados e simplesmente atualizam o texto de um `Label` ou o valor de uma `TextureProgressBar`.

---

## 4. Dicas de UI/UX

-   **Feedback é Rei:** Use `Tweens` ou `AnimationPlayer` para dar vida à sua UI. Botões devem mudar de cor ou tamanho ao passar o mouse (`mouse_entered`, `mouse_exited`). Menus devem aparecer com um fade ou um slide, não instantaneamente.
-   **Consistência:** Mantenha um guia de estilo para fontes, cores e tamanhos de botões em todo o jogo. O nó `Theme` é excelente para aplicar um estilo consistente a todos os controles de uma vez.
-   **Navegação por Teclado/Controle:** Garanta que a propriedade `Focus -> Neighbor` dos seus botões esteja configurada corretamente para que o jogador possa navegar pelos menus sem usar o mouse. Os `Containers` geralmente cuidam disso automaticamente, mas é bom verificar.
