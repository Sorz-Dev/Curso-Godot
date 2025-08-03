# Manual de Feedback de Dano (Floating Text)

Este documento descreve um sistema para exibir números de dano "flutuantes" na tela, fornecendo feedback visual claro e satisfatório ao jogador sempre que dano é causado ou recebido.

## 1. A Filosofia: Feedback Imediato e Satisfatório

Ver o número do dano saltar de um inimigo confirma o acerto e comunica a eficácia do ataque. É um elemento de "game feel" crucial em muitos RPGs e jogos de ação, tornando o combate mais legível e recompensador.

## 2. A Arquitetura: Um Gerenciador e uma Cena de Texto

O sistema é composto por dois elementos principais:
1.  **`FloatingTextManager.gd` (Autoload):** Um singleton responsável por instanciar e gerenciar os textos flutuantes.
2.  **`FloatingText.tscn`:** Uma cena simples para um único texto flutuante, contendo um `Label` e a lógica de animação.

### 2.1. A Cena do Texto Flutuante (`FloatingText.tscn`)

- **Nó Raiz:** `FloatingText` (Node2D)
  - **Script:** `floating_text.gd`
- **Nós Filhos:**
  - `Label`: Para exibir o texto do dano.
    - **Dica:** Configure a fonte no Inspector para ter um contorno, facilitando a leitura contra fundos variados.
  - `Tween`: Para animar o movimento e o fade-out.

- **Script (`floating_text.gd`):**
  ```gdscript
  class_name FloatingText
  extends Node2D

  @onready var label = $Label
  @onready var tween = $Tween

  # Função chamada pelo Manager para iniciar o texto
  func start(text: String, color: Color, duration: float = 1.0):
      label.text = text
      label.modulate = color

      # Configura a animação com o Tween
      # Anima a posição Y para subir (ex: 50 pixels para cima)
      tween.tween_property(self, "position:y", position.y - 50, duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
      
      # Anima o desaparecimento (fade out) nos últimos 30% da duração
      tween.tween_property(label, "modulate:a", 0.0, duration * 0.3).set_delay(duration * 0.7)

      # Conecta o sinal de finalização do tween para se autodestruir
      tween.finished.connect(queue_free)
  ```

### 2.2. O Gerenciador (`FloatingTextManager.gd` - Autoload)

- **Criação:** Crie um script `FloatingTextManager.gd` e adicione-o como um Autoload.
- **Script (`FloatingTextManager.gd`):**
  ```gdscript
  extends Node

  # Pré-carrega a cena do texto flutuante
  const FloatingTextScene = preload("res://scenes/ui/floating_text.tscn")

  # A função principal que outros sistemas chamarão
  func show_text(text: String, position: Vector2, color: Color = Color.WHITE):
      var instance = FloatingTextScene.instantiate()
      instance.global_position = position
      get_tree().current_scene.add_child(instance)
      instance.start(str(text), color) # str() para garantir que o dano (int) seja convertido

  # Funções helper para tipos comuns de dano
  func show_damage_text(amount: int, position: Vector2):
      show_text(str(amount), position, Color.RED)

  func show_healing_text(amount: int, position: Vector2):
      show_text(str(amount), position, Color.GREEN)
  ```

## 3. Integração

A integração é feita na função `take_damage` de qualquer personagem.

- **No script do personagem (`player.gd` ou `enemy.gd`):**
  ```gdscript
  func take_damage(attack_data: Dictionary):
      # ... (cálculo de dano) ...
      var final_damage = ...
      current_health -= final_damage

      # Chama o FloatingTextManager para mostrar o dano
      FloatingTextManager.show_damage_text(final_damage, global_position)
      
      # ... (resto da lógica de dano) ...
  ```

Este sistema simples e eficaz adiciona uma camada significativa de polimento visual ao combate, com um custo de performance mínimo.
