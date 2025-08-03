# Manual do Sistema de Interação

Este documento descreve um sistema genérico e unificado para gerenciar a interação do jogador com objetos do mundo, como NPCs, baús, portas, placas, etc.

## 1. A Filosofia: Desacoplamento

O objetivo é evitar que o jogador precise saber o que ele está interagindo. O jogador não "fala com o NPC" ou "abre o baú". Ele apenas "interage com o objeto próximo". O objeto, por sua vez, é responsável por executar sua própria lógica.

## 2. O Componente `Interactable`

Esta é uma cena reutilizável que pode ser adicionada como filha a qualquer objeto que precise de interação.

- **Criação:** Crie uma nova cena `interactable.tscn`.
- **Estrutura da Cena (`interactable.tscn`):**
  - **Nó Raiz:** `Interactable` (Area2D)
    - **Script:** `interactable.gd`
  - **Nós Filhos:**
    - `CollisionShape2D`: Define a área de alcance da interação.
    - `InteractionPrompt` (Label ou Sprite2D): Um nó visual (ex: um ícone "E" ou um balão de texto) que aparece sobre o objeto para indicar que ele é interativo. Fica invisível por padrão.
- **Script (`interactable.gd`):**
  ```gdscript
  class_name Interactable
  extends Area2D

  # Sinal que será emitido quando o jogador pressionar o botão de interação.
  # O objeto pai (o baú, o NPC) irá se conectar a este sinal.
  signal interacted

  # Chamado quando um corpo entra na área de detecção.
  func _on_body_entered(body):
      # Verificamos se quem entrou é o jogador (pelo grupo "Player").
      if body.is_in_group("Player"):
          show_prompt()

  # Chamado quando o corpo sai.
  func _on_body_exited(body):
      if body.is_in_group("Player"):
          hide_prompt()

  func show_prompt():
      $InteractionPrompt.show()

  func hide_prompt():
      $InteractionPrompt.hide()

  # Esta função é chamada pelo jogador quando ele quer interagir.
  func do_interaction():
      emit_signal("interacted")
      hide_prompt() # Esconde o prompt após interagir.
  ```

## 3. A Lógica do Jogador

O jogador precisa de um pequeno script para detectar e gerenciar com qual `Interactable` ele pode interagir.

- **Script do Jogador (`player.gd`):**
  - Adicione as seguintes variáveis:
    ```gdscript
    var interactable_in_range: Interactable = null
    ```
  - Adicione um `Area2D` ao jogador chamado `InteractionDetector`. Este detector é responsável por encontrar os `Interactable`.
  - Conecte os sinais `area_entered` e `area_exited` deste detector.

  ```gdscript
  # Em player.gd

  # Conectado ao sinal area_entered do InteractionDetector
  func _on_interaction_detector_area_entered(area: Area2D):
      if area is Interactable:
          interactable_in_range = area

  # Conectado ao sinal area_exited do InteractionDetector
  func _on_interaction_detector_area_exited(area: Area2D):
      if area == interactable_in_range:
          interactable_in_range = null

  # No _input ou em um estado de input
  func handle_player_input(event: InputEvent):
      if event.is_action_pressed("interact") and interactable_in_range:
          interactable_in_range.do_interaction()
  ```

## 4. Exemplo de Uso: Um Baú (`chest.tscn`)

- **Estrutura da Cena:**
  - `Chest` (StaticBody2D ou Node2D)
    - **Script:** `chest.gd`
    - `AnimatedSprite2D`: Com animações "fechado" e "aberto".
    - `Interactable`: Instância da cena `interactable.tscn`.
- **Lógica do Baú (`chest.gd`):**
  ```gdscript
  extends Node2D

  var is_open = false

  func _ready():
      # Conecta o sinal do seu próprio componente Interactable à sua função de interação.
      $Interactable.interacted.connect(on_interacted)

  func on_interacted():
      if not is_open:
          is_open = true
          $AnimatedSprite2D.play("aberto")
          
          # Lógica para dar loot ao jogador
          print("Você recebeu 10 moedas!")
          
          # Desativa futuras interações se o baú só puder ser aberto uma vez.
          $Interactable.get_node("CollisionShape2D").disabled = true
  ```

## Resumo do Fluxo

1.  O jogador se aproxima de um objeto (ex: Baú).
2.  O `InteractionDetector` do jogador detecta o componente `Interactable` do baú.
3.  O `Interactable` do baú detecta o jogador e mostra seu `InteractionPrompt`.
4.  O jogador armazena uma referência ao `interactable_in_range`.
5.  O jogador aperta o botão "interact".
6.  O script do jogador chama `interactable_in_range.do_interaction()`.
7.  O `Interactable` do baú emite seu sinal `interacted`.
8.  O script `chest.gd`, que estava ouvindo esse sinal, executa sua lógica `on_interacted` (toca a animação, dá o loot, etc.).

Este sistema é extremamente modular. Para criar um NPC, o processo é o mesmo: o script `npc.gd` conectaria o sinal `interacted` do seu componente `Interactable` a uma função que iniciaria o diálogo (`DialogueManager.start_dialogue(...)`).
