# Roadmap do Desenvolvedor de Jogos (Mobile-First)

**Para:** Meu Amigo, o Futuro Desenvolvedor de Jogos Mobile

**De:** Bruno

---

## **Aviso Importante: A Jornada Mobile-Only**

Desenvolver um jogo inteiro em um celular ou tablet é **totalmente possível** com a Godot Engine, o que é incrível. No entanto, é uma jornada com desafios únicos. Seja paciente. O espaço de tela é menor, a criação de arte e som requer apps específicos, e o fluxo de trabalho é diferente. Este roadmap foi pensado para **você**, que tem a paixão e a vontade de criar, usando as ferramentas que tem em mãos.

## Fase 0: A Mentalidade (O Mês Zero)

Esta fase é universal e talvez a mais importante.

-   **Seu Objetivo:** Terminar projetos. Um jogo de "toque na tela" completo é infinitamente melhor do que 1% de um clone de um RPG massivo.
-   **A Regra de Ouro:** **Escopo Pequeno.** Sua primeira ideia é sempre grande demais. Corte-a pela metade. Depois, corte-a pela metade novamente. Comece por aí.

---

## Fase 1: Fundamentos de Godot 2D e Controles de Toque (Meses 1-4)

*O objetivo é se tornar fluente na Godot e em GDScript, pensando em "toque" desde o primeiro dia.*

-   **Ferramenta Principal:** **Godot Engine 4.x** (Instalada pela Google Play Store)

-   **Mês 1: O Básico da Engine e o Primeiro Toque**
    -   **Foco:** Entender a filosofia da Godot (Nós, Cenas, Sinais) e criar sua primeira interação.
    -   **Projeto:** Uma tela com um botão. Ao tocar no botão, um `Label` na tela muda de texto. Isso te ensinará sobre os nós de UI e o sistema de Sinais.
    -   **Recurso:** Apostila `fundamentos_00_a_filosofia_godot.md` e `fundamentos_02_camera_e_ui.md`.

-   **Mês 2: Primeiro Jogo - "Pong de Toque"**
    -   **Foco:** Input de toque, colisões, física simples.
    -   **Projeto:** Um jogo de Pong para um jogador, onde a raquete do jogador segue a posição do dedo na tela.
    -   **Recursos:** Apostila `fundamentos_03_combate_simples.md` (a colisão da bola é uma forma de "combate").

-   **Mês 3: Segundo Jogo - Plataforma com Botões Virtuais**
    -   **Foco:** Implementar controles na tela para um jogo que normalmente usaria um teclado.
    -   **Projeto:** Um jogo de plataforma simples, mas com botões de `TouchScreenButton` na tela para mover para a esquerda, direita e pular.
    -   **Recurso:** **Mini-Tutorial de Controles de Toque (Abaixo)**.

-   **Mês 4: Terceiro Jogo - Top-Down com Joystick Virtual**
    -   **Foco:** Implementar um controle analógico virtual para movimento livre.
    -   **Projeto:** Uma nave que se move com um joystick virtual na tela e atira com um botão virtual.
    -   **Recurso:** **Mini-Tutorial de Controles de Toque (Abaixo)**.

---

### **Mini-Tutorial Essencial: Controles de Toque**

*Esta é a seção mais importante para você. Adicione esta UI a uma `CanvasLayer` para que ela flutue sobre seu jogo.*

#### **1. Botões Virtuais (`TouchScreenButton`)**

-   **O que é?** Um nó de botão feito especificamente para o toque. É a forma mais fácil de começar.
-   **Como Usar:**
    1.  Adicione um `TouchScreenButton` à sua cena de UI.
    2.  No Inspector, dê a ele uma textura para o estado `Normal` e, opcionalmente, para o estado `Pressed`.
    3.  **O mais importante:** Na propriedade `Action`, digite o nome da ação do seu Input Map (ex: `jump`).
    4.  É isso! Este botão agora se comporta exatamente como se o jogador estivesse pressionando a tecla associada à ação `jump`.

#### **2. Joystick Virtual (Lógica Customizada)**

-   **O que é?** Não existe um nó de joystick nativo. Nós o criamos combinando nós de UI e um pouco de código.
-   **Estrutura da Cena (`virtual_joystick.tscn`):**
    -   `JoystickBase` (`TextureRect` ou `Panel`): A área externa do joystick.
    -   `JoystickKnob` (`TextureRect`): O pino que se move.
-   **Lógica (`virtual_joystick.gd`):**
    ```gdscript
    extends Control

    var touch_index = -1
    var knob_position = Vector2.ZERO
    var input_vector = Vector2.ZERO

    func _input(event: InputEvent):
        if event is InputEventScreenTouch:
            if event.is_pressed():
                # Se o toque foi na nossa base e não estamos seguindo outro dedo
                if get_rect().has_point(event.position) and touch_index == -1:
                    touch_index = event.index
                    knob_position = event.position
            # Se o dedo foi solto
            elif event.index == touch_index:
                touch_index = -1
                knob_position = get_rect().size / 2
                input_vector = Vector2.ZERO
        
        if event is InputEventScreenDrag and event.index == touch_index:
            knob_position = event.position

    func _process(delta):
        # Limita o pino ao raio da base
        var base_center = get_rect().size / 2
        var vector_from_center = knob_position - base_center
        if vector_from_center.length() > base_center.x:
            knob_position = base_center + vector_from_center.normalized() * base_center.x
        
        $JoystickKnob.position = knob_position - $JoystickKnob.get_rect().size / 2
        
        # Calcula o vetor de output
        input_vector = vector_from_center / base_center.x
    ```
-   **No seu `player.gd`**, em vez de `Input.get_vector()`, você pegaria o `input_vector` do seu script de joystick: `velocity = $path/to/joystick.input_vector * SPEED`.

---

## Fase 2: O Kit de Ferramentas do Artista 2D (Mobile) (Meses 5-6)

*Criar assets no celular é um desafio, mas totalmente possível com os apps certos.*

-   **Ferramentas Principais:** **Pixel Studio** (App), **BandLab** ou **WavePad** (App), **bfxr.net** (Site)

-   **Mês 5: Pixel Art com Pixel Studio**
    -   **Foco:** Aprender a criar seus próprios assets de pixel art diretamente no celular/tablet.
    -   **Projeto:** Criar um tileset, um personagem com animações e um item.

-   **Mês 6: Áudio e "Game Feel"**
    -   **Foco:** Adicionar som e impacto.
    -   **Projeto:** Adicionar sons ao seu jogo de plataforma.
    -   **Ferramentas:** Use `bfxr.net` no navegador do seu celular para gerar sons. Use `BandLab` ou um editor similar para cortar ou gravar áudio.

---

## Fase 3: A Ponte para o 3D (Meses 7-9)

*Criar assets 3D complexos no celular é muito difícil. O foco aqui é aprender a **usar assets prontos**.*

-   **Ferramentas Principais:** **Sketchfab** (Site/App), **Kenney.nl** (Site)

-   **Meses 7-9: Curadoria e Integração de Assets 3D**
    -   **Foco:** Aprender a encontrar, baixar e importar modelos 3D gratuitos ou pagos para a Godot.
    -   **Projeto:** Criar uma cena 3D simples usando assets do Kenney.nl. Baixar um personagem animado do Sketchfab e aprender a usar o `AnimationPlayer` para tocar suas animações pré-existentes.
    -   **Tópicos:** Licenças de assets (CC0, CC-BY), formatos de arquivo (`.gltf`, `.glb`), importação de modelos 3D na Godot.

---

## Fase 4: Desenvolvimento 3D em Godot (Meses 10-12)

*Aplicar seus conhecimentos para criar um jogo 3D simples.*

-   **Projeto:** Um jogo de coleta em terceira pessoa, usando um personagem baixado do Sketchfab e um cenário montado com assets do Kenney.nl. O desafio será implementar a lógica de câmera e os controles de toque 3D (um joystick para movimento, arrastar na tela para girar a câmera).

---

## Fase 5: O Desenvolvedor Profissional (Contínuo)

-   **Ferramentas:** **Spck Editor** (App com cliente Git), **Trello** (App)

-   **Tópicos a Praticar Sempre:**
    -   **Controle de Versão:** Use um app como o Spck Editor para sincronizar seu projeto com um repositório no GitHub. É crucial para a segurança do seu trabalho.
    -   **Publicação:** Aprenda o processo de exportar para Android e publicar na **Google Play Store** e no **Itch.io**. São as plataformas mais acessíveis para você.