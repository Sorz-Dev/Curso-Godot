# Apostila 00: Dicionário de Nós Essenciais 2D

**Nível de Dificuldade:** Referência Fundamental

**Pré-requisitos:** Nenhum. Use este documento como uma consulta rápida sempre que se perguntar "como eu faço...?"

---

## 1. A Filosofia: A Ferramenta Certa para o Trabalho

Godot oferece centenas de nós. A arte do desenvolvimento eficiente não é saber todos, mas sim reconhecer os 20-30 mais importantes e entender qual problema cada um resolve. Este documento é o seu guia de referência para as ferramentas mais comuns e poderosas no desenvolvimento de jogos 2D.

--- 

## 2. Nós de Base e Estrutura

*Estes são os blocos de construção mais fundamentais para a organização da sua cena.*

**`Node`**
-   **O que é?** O nó mais básico de todos. Não tem posição, aparência ou funcionalidade, apenas um nome e a capacidade de ter filhos e um script. É a base de tudo na árvore de cenas.
-   **Quando usar?** Para criar Singletons (Autoloads), para organizar scripts de sistemas, ou para servir como uma "pasta" na sua árvore de cenas para agrupar outros nós (ex: um nó "Inimigos" para conter todas as instâncias de inimigos).

**`Node2D`**
-   **O que é?** O nó base para **tudo** que precisa existir no espaço 2D. Ele adiciona as propriedades de `Transform` (Posição, Rotação, Escala).
-   **Quando usar?** Como o nó raiz para a maioria dos seus objetos de jogo (jogador, inimigo, projétil) ou como um "pivô" para controlar a posição de vários nós filhos juntos.

**`CanvasLayer`**
-   **O que é?** Uma camada de desenho que "flutua" sobre o mundo do jogo e ignora a `Camera2D`. Tudo que for filho de um `CanvasLayer` é desenhado em coordenadas de tela, não de mundo.
-   **Quando usar?** **Sempre** como o nó raiz de suas cenas de UI principais (HUD, Menu de Pause, Inventário) para garantir que elas fiquem fixas na tela, não importa para onde a câmera se mova.

--- 

## 3. Nós Visuais

*Tudo que serve para desenhar algo na tela.*

**`Sprite2D`**
-   **O que é?** Um `Node2D` que exibe uma imagem (textura).
-   **Quando usar?** Para qualquer objeto estático no seu jogo: o personagem (se ele não tiver animações), um item, um ícone, uma parte do cenário.

**`AnimatedSprite2D`**
-   **O que é?** Um `Sprite2D` que pode tocar animações frame a frame (como um flip-book) a partir de um recurso `SpriteFrames`.
-   **Quando usar?** Para animações de personagens (parado, correndo, pulando), efeitos (explosões) e qualquer coisa que precise de uma sequência de imagens.

**`TileMap`**
-   **O que é?** Uma ferramenta incrivelmente poderosa para construir níveis usando um grid de tiles (ladrilhos). Permite "pintar" o cenário.
-   **Quando usar?** Para criar o layout de 99% dos jogos 2D, desde jogos de plataforma até RPGs top-down. Você pode definir colisões, navegação e outras propriedades diretamente nos tiles.

**`GPUParticles2D`**
-   **O que é?** Um sistema de partículas que roda na placa de vídeo, capaz de renderizar milhares de partículas (fumaça, fogo, chuva, estrelas) com alta performance.
-   **Quando usar?** Para adicionar polimento visual: rastros de fumaça de foguetes, chuva, efeitos de magia, explosões.

**`Line2D`**
-   **O que é?** Desenha uma linha (ou uma série de linhas conectadas) com espessura e cor customizáveis.
-   **Quando usar?** Para desenhar a trajetória de um projétil, o raio de um laser, ou para ferramentas de debug visual.

**`Polygon2D`**
-   **O que é?** Desenha um polígono preenchido com uma cor ou textura.
-   **Quando usar?** Para criar formas geométricas customizadas, áreas de efeito visual ou fundos estilizados.

**`Light2D`**
-   **O que é?** Simula uma fonte de luz em um ambiente 2D, afetando outros nós e podendo projetar sombras.
-   **Quando usar?** Para criar atmosferas, lanternas para o jogador, tochas em uma masmorra, ou para efeitos de "névoa de guerra" no minimapa.

--- 

## 4. Nós de Física e Colisão

*Os nós que permitem que seu mundo interaja consigo mesmo.*

**`CharacterBody2D`**
-   **O que é?** O nó de física projetado para ser controlado pelo jogador ou por IA. Sua função `move_and_slide()` é a forma principal de movê-lo e fazê-lo interagir com o mundo de forma robusta.
-   **Quando usar?** Para o seu jogador e para a maioria dos inimigos que andam, voam ou pulam.

**`StaticBody2D`**
-   **O que é?** Um corpo de física que não se move. Ele é uma parede imóvel.
-   **Quando usar?** Para o chão, paredes, plataformas e qualquer obstáculo fixo do cenário.

**`RigidBody2D`**
-   **O que é?** Um corpo controlado pelo motor de física do Godot. É afetado por gravidade, atrito e forças externas.
-   **Quando usar?** Para objetos que devem reagir de forma realista: caixas que podem ser empurradas, pedras que rolam, destroços de uma explosão.

**`Area2D`**
-   **O que é?** Um nó que detecta quando outros corpos ou áreas entram ou saem de seu espaço, mas não tem colisão sólida.
-   **Quando usar?** Para Hitboxes (causar dano), Hurtboxes (receber dano), coletar itens, acionar eventos, zonas de diálogo, etc.

**`CollisionShape2D` / `CollisionPolygon2D`**
-   **O que é?** Um nó filho **obrigatório** para todos os nós de Corpo e Área. Define a forma geométrica da colisão.
-   **Quando usar?** Sempre que você usar um `CharacterBody2D`, `StaticBody2D`, `RigidBody2D` ou `Area2D`.

**`RayCast2D`**
-   **O que é?** Projeta um raio invisível em uma direção e reporta a primeira coisa que ele atinge.
-   **Quando usar?** Para armas de tiro instantâneo (hitscan), para a IA "ver" se há uma parede na frente, para detectar o chão sob um personagem (uma alternativa ao `is_on_floor()`).

--- 

## 5. Nós de UI (Control)

*Todos herdam de `Control` e são usados para construir interfaces.*

### 5.1. Exibição de Informação

**`Label`**: Para exibir texto simples.
**`RichTextLabel`**: Um `Label` avançado que suporta formatação (negrito, cores, imagens) e efeitos como máquina de escrever.
**`TextureRect`**: Para exibir uma imagem/textura na UI.
**`ColorRect`**: Para desenhar um retângulo de cor sólida. Perfeito para fundos de painéis ou para a animação de fade do `SceneManager`.
**`TextureProgressBar`**: Uma barra de progresso que usa três texturas (fundo, progresso, frente) para criar barras de vida/mana estilizadas.

### 5.2. Interação do Usuário

**`Button`**: Um botão de texto padrão.
**`TextureButton`**: Um botão que usa texturas para seus diferentes estados (normal, pressionado, hover).
**`CheckButton` / `CheckBox`**: Uma caixa de seleção que pode ser marcada ou desmarcada.
**`OptionButton`**: Um botão que, quando clicado, mostra uma lista de opções selecionáveis (dropdown).
**`HSlider` / `VSlider`**: Sliders (barras deslizantes) horizontais e verticais. Perfeitos para menus de volume.
**`LineEdit`**: Uma caixa para o usuário digitar uma única linha de texto (ex: nome do jogador).
**`TextEdit`**: Uma caixa para o usuário digitar múltiplas linhas de texto.

### 5.3. Contêineres (Os Mais Importantes!)

*Estes nós organizam automaticamente seus filhos, tornando a UI responsiva.*

**`MarginContainer`**: Adiciona uma margem (um "respiro") ao redor de seu único nó filho.
**`CenterContainer`**: Centraliza seu único nó filho dentro de si.
**`VBoxContainer`**: Empilha seus filhos verticalmente.
**`HBoxContainer`**: Empilha seus filhos horizontalmente.
**`GridContainer`**: Organiza seus filhos em um grid com um número de colunas definido.
**`ScrollContainer`**: Permite que o conteúdo filho seja maior que o contêiner, criando barras de rolagem.
**`TabContainer`**: Cria um sistema de abas a partir de seus nós filhos.
**`PanelContainer`**: Um contêiner que desenha um painel de `Theme` ao seu redor, dando um fundo e borda.

--- 

## 6. Nós Auxiliares e de Lógica

**`Timer`**
-   **O que é?** Um cronômetro que emite um sinal `timeout` quando o tempo acaba.
-   **Quando usar?** Para cooldowns, spawn de inimigos, duração de power-ups, etc.

**`AnimationPlayer`**
-   **O que é?** Um nó de animação que pode animar **qualquer propriedade** de **qualquer nó** ao longo do tempo.
-   **Quando usar?** Para animações complexas, cutscenes, tweens de UI e para sincronizar eventos com animações (ativar hitboxes, tocar sons).

**`AudioStreamPlayer`**
-   **O que é?** O nó padrão para tocar sons (SFX) e músicas.
-   **Quando usar?** Para qualquer som no jogo. Use players separados para música e efeitos para controlar seus volumes de forma independente através dos barramentos de áudio.

**`Path2D` e `PathFollow2D`**
-   **O que são?** `Path2D` permite que você desenhe um caminho no editor. `PathFollow2D`, quando filho de um `Path2D`, pode ser movido ao longo desse caminho.
-   **Quando usar?** Para criar rotas de patrulha para inimigos, plataformas móveis que seguem um trajeto complexo, ou para definir o movimento de projéteis.

**`SubViewport`**
-   **O que é?** Uma "tela dentro da tela". Ele renderiza o que uma `Camera` separada está vendo e exibe o resultado como uma textura.
-   **Quando usar?** A técnica padrão para criar minimapas, espelhos, ou telas de segurança em um jogo.