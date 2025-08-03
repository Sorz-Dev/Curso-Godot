# Manual do Sistema de Diálogo

Este documento descreve uma arquitetura para um sistema de diálogo baseado em `Resource`, permitindo a criação de conversas complexas no editor.

## 1. A Base: Recurso de Diálogo (`DialogueResource.gd`)

O coração do sistema é um `Resource` que contém toda a informação de uma conversa, incluindo falas, informações do personagem e opções de escolha.

- **Criação:** Crie um novo script `DialogueResource.gd` que herda de `Resource`.
- **Script (`DialogueResource.gd`):**
  ```gdscript
  class_name DialogueResource
  extends Resource

  # Informações do personagem que está falando
  @export var character_name: String
  @export var character_portrait: Texture2D

  # Array de falas. Cada entrada é uma string.
  @export var lines: Array[String]

  # Array de opções de escolha para o jogador no final do diálogo.
  # Cada opção é outro DialogueResource, criando uma árvore de conversa.
  @export var choices: Array[DialogueResource]

  # (Opcional) Um sinal do Godot para emitir ao final desta fala.
  # Útil para acionar eventos no jogo (ex: dar um item, iniciar uma quest).
  @export var event_signal: StringName 
  ```
- **Uso:**
  - Crie recursos de diálogo no FileSystem (`.tres`).
  - Você pode criar uma conversa inteira encadeando `DialogueResource` dentro do array `choices` de outro.
  - Para uma conversa linear, basta preencher o array `lines` e deixar `choices` vazio.
  - Para um diálogo que termina, deixe `lines` e `choices` vazios.

## 2. O Gerenciador: `DialogueManager.gd`

Um Autoload responsável por apresentar o diálogo na tela e gerenciar o estado da conversa.

- **Nó Raiz:** `DialogueManager` (CanvasLayer)
  - O Manager é a própria UI para simplificar.
- **Sinais:**
  - `dialogue_started()`: Emitido quando uma conversa começa. O jogo pode usar isso para pausar a ação ou esconder a HUD.
  - `dialogue_finished()`: Emitido quando a conversa termina. O jogo retoma o controle.
- **Estrutura de Nós Filhos:**
  - `DialogueBox` (PanelContainer): O contêiner principal da caixa de diálogo.
    - `CharacterNameLabel` (Label)
    - `CharacterPortrait` (TextureRect)
    - `LineLabel` (RichTextLabel): Usar `RichTextLabel` permite efeitos de texto (negrito, itálico) e o efeito de "máquina de escrever".
    - `ChoicesContainer` (VBoxContainer): Onde os botões de escolha do jogador serão adicionados dinamicamente.
- **Variáveis:**
  - `current_dialogue`: O `DialogueResource` atualmente em exibição.
  - `line_index`: O índice da fala atual no array `lines`.
  - `is_active`: `true` se um diálogo estiver em andamento.
- **Funções Principais:**
  - `start_dialogue(dialogue_resource: DialogueResource)`:
    1.  Verifica se já há um diálogo ativo. Se sim, retorna.
    2.  `is_active = true`
    3.  `current_dialogue = dialogue_resource`
    4.  `line_index = 0`
    5.  Mostra a `DialogueBox`.
    6.  Emite `dialogue_started()`.
    7.  Chama `display_current_line()`.
  - `_input(event)`:
    - Se um diálogo está ativo e o jogador pressiona a tecla de "ação/confirmar":
      - Chama `next_line()`.
  - `display_current_line()`:
    - Atualiza `CharacterNameLabel`, `CharacterPortrait` e `LineLabel` com os dados de `current_dialogue` e `line_index`.
    - (Opcional) Inicia um `Timer` ou `Tween` para criar o efeito de texto de máquina de escrever no `LineLabel`.
  - `next_line()`:
    1.  Incrementa `line_index`.
    2.  Verifica se ainda há falas no array `lines`.
    3.  Se sim, chama `display_current_line()`.
    4.  Se não, significa que as falas acabaram. Chama `display_choices()`.
  - `display_choices()`:
    - Limpa o `ChoicesContainer`.
    - Se `current_dialogue.choices` não estiver vazio:
      - Itera sobre o array `choices`.
      - Para cada `DialogueResource` na lista, cria um novo `Button`.
      - Define o texto do botão (pode ser a primeira linha do diálogo de escolha).
      - Conecta o sinal `pressed` do botão a `_on_choice_selected`, passando o `DialogueResource` da escolha como argumento.
      - Adiciona o botão ao `ChoicesContainer`.
    - Se `choices` estiver vazio, o diálogo terminou. Chama `finish_dialogue()`.
  - `_on_choice_selected(choice_dialogue: DialogueResource)`:
    - Limpa o `ChoicesContainer`.
    - O `choice_dialogue` se torna o novo `current_dialogue`.
    - `line_index = 0`
    - Chama `display_current_line()`.
  - `finish_dialogue()`:
    1.  `is_active = false`
    2.  Esconde a `DialogueBox`.
    3.  Verifica se `current_dialogue.event_signal` tem um valor. Se sim, emite esse sinal.
    4.  Emite `dialogue_finished()`.
    5.  Reseta as variáveis.

## 3. Integração

- **Iniciando um Diálogo:**
  - Um NPC (Non-Player Character) ou um item interativo terá uma variável `@export var dialogue: DialogueResource`.
  - Quando o jogador interage com ele (ex: através de uma `Area2D`), o script do NPC chama `DialogueManager.start_dialogue(dialogue)`.
- **Eventos no Jogo:**
  - Um script (ex: `QuestManager`) pode se conectar aos sinais de evento definidos nos `DialogueResource`.
  - `DialogueManager.connect("nome_do_sinal_de_evento", _on_dialogue_event_triggered)`.
  - A função `_on_dialogue_event_triggered` então executa a lógica do jogo (dar item, atualizar quest, etc.).
