# Manual de Mapa e Minimapa

Este documento descreve uma arquitetura para implementar um sistema de mapa e minimapa, melhorando a navegação e a experiência do usuário.

## 1. A Filosofia: Consciência Espacial

Um mapa ajuda o jogador a se localizar, a planejar rotas e a encontrar objetivos. Um minimapa oferece informações contextuais imediatas (inimigos próximos, pontos de interesse) sem quebrar a imersão.

## 2. O Minimapa (HUD)

O minimapa é a versão mais comum e útil para a maioria dos jogos de ação. A técnica mais eficiente em Godot é usar um `SubViewport` e uma segunda câmera.

- **Estrutura de Nós na Cena do Nível (`level.tscn`):**
  - `Level` (Node2D)
    - `Player`
      - `Camera2D` (Câmera principal do jogo)
    - `MapCamera` (Camera2D)
      - **Propriedades Importantes:**
        - `Zoom`: Ajuste o zoom para que a câmera capture a área desejada para o minimapa (ex: `Vector2(4, 4)`).
        - `Cull Mask`: Desmarque a camada do mundo principal e marque uma nova camada, por exemplo, a camada "map_layer". Isso faz com que esta câmera SÓ enxergue o que estiver nesta camada.
        - `Current`: `false`.

- **Estrutura de Nós na HUD (`game_hud.tscn`):**
  - `GameHUD` (CanvasLayer)
    - `MinimapContainer` (PanelContainer ou outro nó de controle para o estilo)
      - `SubViewportContainer`
        - `SubViewport`
          - **Propriedades Importantes:**
            - `Stretch`: `true`.
            - `Size`: O tamanho em pixels do seu minimapa (ex: 200x200).
        - `PlayerIcon` (Sprite2D): Um ícone para o jogador, centralizado no `MinimapContainer`.

- **Lógica de Funcionamento:**
  1.  **Sincronização:** No script da HUD ou do jogador, a `MapCamera` precisa seguir o jogador.
      ```gdscript
      # Em player.gd ou um script de HUD
      var map_camera = get_tree().get_root().get_node("Level/MapCamera")

      func _process(delta):
          if map_camera:
              map_camera.global_position = self.global_position
      ```
  2.  **Renderização:** O `SubViewport` renderiza o que a `MapCamera` vê. O `SubViewportContainer` exibe essa renderização como uma textura na sua HUD.
  3.  **Ícones do Mapa:** Para que ícones de inimigos, quests ou baús apareçam no minimapa, eles precisam ter um nó filho (ex: um `Sprite2D`) que esteja na camada "map_layer". A câmera principal não os verá, mas a `MapCamera` sim.

## 3. O Mapa de Tela Cheia

Esta é a tela que o jogador abre para ver o mapa completo da região.

- **A Abordagem da "Captura de Tela":**
  - **Preparação:** Crie uma câmera `MapCaptureCamera` (semelhante à `MapCamera`, mas com zoom para enquadrar o nível inteiro).
  - **Lógica:** Ao abrir o mapa pela primeira vez, você pode:
    1.  Mover a `MapCaptureCamera` para o centro do nível.
    2.  Capturar um único frame do que ela vê: `var image = get_viewport().get_texture().get_image()`.
    3.  Salvar essa imagem como um `.png` em `user://maps/level_1.png`.
    4.  Nas próximas vezes, apenas carregue a imagem salva.
  - **UI do Mapa (`map_screen.tscn`):**
    - Um `TextureRect` para exibir a imagem do mapa capturado.
    - Ícones para o jogador, quests, etc., são adicionados sobre esta textura, com suas posições convertidas do espaço do mundo para o espaço do mapa.

- **A Abordagem Vetorial (Mais Flexível):**
  - **Lógica:** Não use uma imagem. Em vez disso, "desenhe" o mapa.
  - **Preparação:**
    - Ao carregar um nível, itere sobre o `TileMap`. Para cada célula que não for vazia, armazene sua posição em um array.
    - Salve este array de "células descobertas".
  - **UI do Mapa:**
    - A UI do mapa, ao abrir, lê o array de células descobertas.
    - Para cada célula, ela desenha um pequeno quadrado (`ColorRect`) na posição correspondente na tela.
    - Isso cria um mapa de estilo "pixelado" que pode ser facilmente estilizado e atualizado. Ícones são adicionados da mesma forma que na abordagem anterior.

## 4. "Névoa de Guerra" (Fog of War)

Para incentivar a exploração, o mapa pode começar totalmente preto e ser revelado à medida que o jogador explora.

- **Lógica:**
  1.  Divida o mundo em uma grade.
  2.  Mantenha um registro (um `Dictionary` ou `Array`) de quais células da grade foram visitadas pelo jogador.
  3.  Na UI do mapa, apenas desenhe as partes do mapa (ou da imagem de fundo) que correspondem às células visitadas.
  4.  Para o minimapa, você pode usar um `Light2D` com uma textura de "sombra" na camada do mapa, onde o jogador é a única fonte de luz, revelando a área ao seu redor.

Este sistema, especialmente o minimapa, é um grande ganho de qualidade de vida para o jogador, e a abordagem com `SubViewport` é a mais performática e flexível em Godot.