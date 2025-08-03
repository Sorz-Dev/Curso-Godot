# Apostila 00: Dicionário de Nós Essenciais 3D

**Nível de Dificuldade:** Referência Fundamental (para desenvolvimento 3D)

**Pré-requisitos:** Compreensão dos conceitos 2D análogos (Nós, Cenas, etc.).

---

## 1. A Filosofia: Pensando em Três Dimensões

Se você entende a lógica dos nós 2D, o 3D é uma extensão natural. A principal diferença é a adição de um terceiro eixo (Y é para cima, por padrão) e a necessidade de lidar com malhas (meshes), materiais e iluminação.

--- 

## 2. Nós de Base e Estrutura 3D

**`Node3D`**
-   **O que é?** O equivalente 3D do `Node2D`. É o nó base para **tudo** que precisa de uma posição, rotação e escala no espaço 3D.
-   **Quando usar?** Como o nó raiz para seus objetos 3D, como um pivô para um braço robótico, ou como um ponto de spawn para inimigos.

**`WorldEnvironment`**
-   **O que é?** Um nó crucial que define as configurações de renderização globais do seu mundo 3D.
-   **Quando usar?** Sempre. Use-o para definir a cor do céu, adicionar neblina (fog), brilho (glow/bloom), oclusão de ambiente (SSAO) e outros efeitos de pós-processamento que fazem seu jogo parecer profissional.

--- 

## 3. Nós Visuais 3D

**`MeshInstance3D`**
-   **O que é?** O principal nó para exibir uma malha 3D (um modelo importado de um programa como o Blender). É o equivalente 3D do `Sprite2D`.
-   **Quando usar?** Para exibir seu personagem, uma espada, uma árvore, uma parede, etc.

**`CSG (Constructive Solid Geometry)`**
-   **O que são?** Uma família de nós (`CSGBox3D`, `CSGCylinder3D`, `CSGPolygon3D`, etc.) que permitem criar e combinar formas 3D diretamente no editor do Godot, sem precisar do Blender. Você pode somar, subtrair e intersectar formas.
-   **Quando usar?** Perfeito para **prototipar níveis** (fazer o "blockout" ou "grayboxing") de forma extremamente rápida. Não é recomendado para os gráficos finais do jogo, pois pode ser menos performático que malhas otimizadas.

**`GridMap`**
-   **O que é?** O equivalente 3D do `TileMap`. Permite construir níveis em um grid usando um conjunto de malhas pré-definidas (uma `MeshLibrary`).
-   **Quando usar?** Para criar mundos modulares e baseados em grid, como dungeons ou cidades.

**`GPUParticles3D`**
-   **O que é?** O sistema de partículas 3D de alta performance.
-   **Quando usar?** Para fogo, fumaça, chuva, neve, efeitos de magia, explosões em 3D.

--- 

## 4. Nós de Iluminação 3D

**`DirectionalLight3D`**
-   **O que é?** Representa uma fonte de luz infinitamente distante, como o sol. Seus raios são paralelos. A posição do nó não importa, apenas sua rotação.
-   **Quando usar?** Para a iluminação principal de cenas externas.

**`OmniLight3D`**
-   **O que é?** Uma luz que emite em todas as direções a partir de um ponto, como uma lâmpada.
-   **Quando usar?** Para tochas, lâmpadas, explosões e outras fontes de luz pontuais.

**`SpotLight3D`**
-   **O que é?** Uma luz que emite a partir de um ponto em uma direção específica, formando um cone, como uma lanterna ou um farol de carro.
-   **Quando usar?** Para lanternas, faróis e iluminação dramática focada.

--- 

## 5. Nós de Física e Colisão 3D

*Funcionam de forma muito semelhante aos seus equivalentes 2D.*

**`CharacterBody3D`**: Para personagens controlados pelo jogador ou IA.
**`StaticBody3D`**: Para objetos de cenário imóveis (chão, paredes).
**`RigidBody3D`**: Para objetos controlados pela física (caixas, barris).
**`Area3D`**: Para detecção sem colisão sólida (gatilhos, zonas de dano).
**`CollisionShape3D` / `CollisionPolygon3D`**: A forma geométrica obrigatória para os nós acima.
**`RayCast3D`**: Para projetar um raio e detectar colisões. Essencial para armas de tiro em jogos de FPS.

--- 

## 6. Nós Auxiliares 3D

**`Camera3D`**
-   **O que é?** O olho do jogador no mundo 3D. Define o ponto de vista, o campo de visão (FOV) e os planos de corte (clipping planes).
-   **Quando usar?** Em qualquer cena 3D. Você a moverá via script para criar controles em primeira pessoa, terceira pessoa ou câmeras fixas.

**`AnimationPlayer`**
-   **O que é?** Tão ou mais importante no 3D quanto no 2D. Ele não apenas anima propriedades, mas também é o principal meio de tocar as animações importadas de modelos 3D (ex: animações de andar, correr, atacar criadas no Blender).
-   **Quando usar?** Para todas as animações de personagens e para criar cutscenes complexas.

**`AudioStreamPlayer3D`**
-   **O que é?** Um player de áudio que simula som posicional no espaço 3D. O som fica mais alto quando a câmera se aproxima do nó e o balanço estéreo muda com a rotação.
-   **Quando usar?** Para sons que devem vir de um local específico no mundo: o som de um motor de carro, os passos de um inimigo, o crepitar de uma tocha.
