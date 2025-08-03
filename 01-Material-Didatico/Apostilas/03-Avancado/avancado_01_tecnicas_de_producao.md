# Apostila 10: Tópicas Avançadas e Polimento

**Nível de Dificuldade:** Avançado

**Pré-requisitos:** Conhecimento sólido de todos os sistemas anteriores.

---

## 1. Shaders Visuais: Dando Vida aos Pixels

Shaders são pequenos programas que rodam na GPU e manipulam como cada pixel de uma textura é desenhado. Eles são a chave para efeitos visuais únicos.

-   **Filosofia:** Comece simples. Efeitos sutis têm um grande impacto no "game feel".
-   **Como Usar:**
    1.  Em um nó `Sprite2D` ou `ColorRect`, vá em `CanvasItem -> Material`.
    2.  Crie um `Novo ShaderMaterial`.
    3.  Dentro do material, crie um `Novo Shader`.
    4.  O editor de shader abrirá na parte inferior.
-   **Exemplo 1: Hit Flash (Piscar em Branco)**
    -   **Conceito:** Misturar a cor original da textura com uma cor de "flash" (geralmente branco), controlado por um fator de 0 a 1.
    -   **Código (`hit_flash.gdshader`):**
        ```glsl
        shader_type canvas_item;

        // 'uniform' cria uma variável que podemos controlar de fora (código ou Inspector)
        uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
        uniform float flash_modifier : clamp(0.0, 1.0) = 0.0;

        void fragment() {
            vec4 original_color = texture(TEXTURE, UV);
            // A função 'mix' interpola entre a cor original e a cor do flash
            vec4 final_color = mix(original_color, flash_color, flash_modifier);
            COLOR = final_color;
        }
        ```
    -   **Uso em GDScript:**
        ```gdscript
        # Em player.gd, na função take_damage()
        var material = $Sprite2D.material
        material.set_shader_parameter("flash_modifier", 0.8)
        var tween = create_tween()
        tween.tween_property(material, "shader_parameter/flash_modifier", 0.0, 0.2)
        ```
-   **Exemplo 2: Contorno**
    -   **Conceito:** Para cada pixel, olhe os pixels vizinhos. Se o pixel atual for opaco e um vizinho for transparente, significa que estamos na borda. Pinte a borda com uma cor de contorno.
    -   Este shader é mais complexo e é um ótimo exemplo para estudar a partir de recursos online como `godotshaders.com`.

---

## 2. Mapa e Minimapa: Consciência Espacial

A forma mais eficiente e flexível de criar um minimapa em Godot é usando um `SubViewport`.

-   **Arquitetura:**
    1.  **Cena Principal:** Adicione uma segunda `Camera2D` (`MapCamera`).
        -   Desative a propriedade `Enabled` dela.
        -   Ajuste o `Zoom` para capturar a área desejada do minimapa.
        -   Use o `Cull Mask` para fazer com que ela enxergue apenas nós em uma camada específica, "map_layer".
    2.  **Cena da HUD (`CanvasLayer`):**
        -   Adicione um `SubViewportContainer`.
        -   Dentro dele, adicione um `SubViewport`.
        -   No script da HUD, a cada frame, sincronize a posição da `MapCamera` com a do jogador: `map_camera.global_position = player.global_position`.
    3.  **Ícones do Mapa:** Para que um inimigo ou um baú tenha um ícone no minimapa, adicione a ele um `Sprite2D` filho e coloque este sprite na camada "map_layer". A câmera principal irá ignorá-lo, mas a `MapCamera` irá renderizá-lo no `SubViewport`.

-   **Névoa de Guerra (Fog of War):**
    -   **Conceito:** O mapa é revelado conforme o jogador explora.
    -   **Implementação Simples:** Crie uma grande imagem preta sobre o `SubViewport` do minimapa. Adicione um nó `Light2D` como filho do ícone do jogador no minimapa, usando uma textura de luz suave. Configure o `Light2D` para usar o modo "Mask". A luz irá "recortar" a imagem preta, revelando o mapa por baixo apenas ao redor do jogador.

---

## 3. IA com Machine Learning (Tópico de Visão Futura)

Esta é a fronteira da IA em jogos, mas é crucial entender a arquitetura correta.

-   **Filosofia:** O treinamento é feito **offline**, a inferência é feita **online**. Nunca tente treinar um modelo de ML em tempo real no jogo do jogador; é computacionalmente inviável.
-   **Fase 1: Treinamento (Python + Godot)**
    1.  **Ambiente (Godot):** Seu jogo é modificado para rodar em alta velocidade (`Engine.time_scale`) e se comunicar via WebSockets. A cada passo, ele envia **Observações** (posição do jogador, vida do inimigo, etc.) para um script Python.
    2.  **Agente (Python):** Um script usando uma biblioteca como `Stable Baselines3` recebe as observações.
    3.  **Ação:** O modelo de ML escolhe uma **Ação** (andar, pular, atacar) e a envia de volta para o Godot.
    4.  **Recompensa:** O Godot executa a ação e calcula uma **Recompensa** (um número que diz se a ação foi boa ou ruim) e a envia de volta.
    5.  **Aprendizado:** O agente Python usa a tupla (Observação, Ação, Recompensa) para aprender. Este ciclo se repete milhões de vezes.
-   **Fase 2: Inferência (No Jogo)**
    1.  **Exportação:** O "cérebro" treinado é exportado do Python para um formato padrão chamado **ONNX** (`meu_chefe.onnx`).
    2.  **Importação:** Godot não lê ONNX nativamente. É necessário usar uma GDExtension (como `Godot-ONNX`) que permite carregar e executar esses modelos.
    3.  **Uso:** Dentro da FSM do seu inimigo, você cria um `MLState`. A cada frame, este estado coleta as mesmas observações do ambiente, as alimenta no modelo ONNX carregado, recebe uma ação de volta e a executa. O modelo não está mais aprendendo, apenas **usando o que aprendeu** (inferência).

-   **Quando Usar?** Não use para um zumbi que anda para frente. Use para um chefe que precisa aprender a se esquivar dos padrões de ataque do jogador ou para IAs que precisam navegar em ambientes complexos de forma emergente. É uma ferramenta poderosa para comportamentos que são difíceis de programar manualmente com `if/else`.
