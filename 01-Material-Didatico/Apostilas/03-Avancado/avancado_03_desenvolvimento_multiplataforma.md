# Apostila 12: Desenvolvimento Multiplataforma

**Nível de Dificuldade:** Intermediário a Avançado

**Pré-requisitos:** Projeto de jogo funcional.

---

## 1. A Filosofia: Pense Multiplataforma Desde o Início

Adaptar um jogo para diferentes plataformas no final do desenvolvimento é uma receita para o desastre. A chave é adotar práticas que facilitem o processo desde o primeiro dia.

-   **Abstração de Input:** Nunca programe `if event.is_key_pressed(KEY_W):`. Use o **Input Map** do Godot. Crie ações como `move_forward` e associe a elas a tecla `W`, a alavanca do controle e, futuramente, um joystick virtual. Isso permite remapear controles e adicionar suporte a novas plataformas sem reescrever a lógica de movimento.
-   **Design de UI Responsivo:** Use `Containers` e as âncoras do nó `Control`. Teste sua UI em diferentes proporções de tela (ex: 16:9, 21:9, 4:3) usando as ferramentas do Godot (`Projeto -> Configurações do Projeto -> Display -> Window -> Test Width/Height`).

---

## 2. Desktop (Windows, macOS, Linux)

Esta é a plataforma mais direta para exportar.

-   **Processo de Exportação:**
    1.  Vá em `Projeto -> Exportar...`.
    2.  Clique em `Adicionar...` e escolha o preset para a plataforma desejada.
    3.  Na aba `Recursos`, certifique-se de que a opção `Modo de Exportação` esteja como "Exportar todos os recursos".
    4.  Clique em `Exportar Projeto`, escolha uma pasta e o Godot criará o executável (`.exe`, `.app`, etc.) e os dados necessários.
-   **Considerações Específicas:**
    -   **macOS:** Requer notarização da Apple para ser distribuído fora da App Store, o que envolve um processo de assinatura de código.
    -   **Permissões de Arquivo:** O diretório `user://` é seu amigo. Ele aponta para o local correto e seguro para salvar dados em cada sistema operacional (`%APPDATA%` no Windows, `~/.local/share` no Linux, etc.).

---

## 3. Web (HTML5)

Exportar para a web abre seu jogo para um público massivo, mas vem com desafios únicos.

-   **Processo de Exportação:** Similar ao Desktop, mas escolha o preset `Web`.
-   **Considerações Específicas:**
    -   **Tamanho do Arquivo:** Este é o fator mais crítico. Ninguém vai esperar 5 minutos para seu jogo de 2GB carregar no navegador. Otimize o tamanho das suas texturas e áudio agressivamente.
    -   **Carregamento Assíncrono:** O jogo pode começar a rodar antes de todos os assets serem baixados. Esteja preparado para lidar com isso.
    -   **Sem Acesso ao Sistema de Arquivos:** O diretório `user://` no modo Web usa o armazenamento local do navegador, que pode ser limitado e volátil.
    -   **Performance:** O desempenho pode variar drasticamente entre navegadores e hardwares.

---

## 4. Mobile (Android & iOS)

Desenvolver para mobile exige uma mentalidade focada em toque e performance.

### 4.1. Adaptação de UI e Tela
-   **Proporções Variadas:** Teste em uma variedade de resoluções de celular.
-   **Áreas Seguras (Safe Areas):** Celulares modernos têm "notches" e barras de sistema. Use um `MarginContainer` na raiz da sua UI para garantir que elementos clicáveis não fiquem escondidos sob essas áreas.

### 4.2. Controles de Toque
-   **Nível 1: Botões Virtuais Simples**
    -   **Nó:** Use o `TouchScreenButton`. Ele funciona como um botão normal, mas reage ao toque. Você pode atribuir uma ação do Input Map diretamente a ele no Inspector.
    -   **Implementação:** Crie sua HUD, adicione `TouchScreenButton`s para "pular" e "atacar", defina suas `shape` (forma de colisão) e atribua a `action` correspondente. É a forma mais rápida de portar um jogo.
-   **Nível 2: Joystick Virtual**
    -   **Implementação:** Não há um nó de joystick nativo, então ele precisa ser criado com lógica customizada.
    1.  Crie uma UI com um `TextureRect` para a base do joystick e outro para o pino.
    2.  No `_input(event)` da sua UI:
        -   Se `event is InputEventScreenTouch and event.pressed`:
            -   Verifique se o toque foi na área do joystick. Se sim, armazene o `event.index` (o dedo) e centralize o pino na posição do toque.
        -   Se `event is InputEventScreenDrag and event.index == joystick_touch_index`:
            -   Mova o pino do joystick junto com o dedo, limitando-o ao raio da base.
            -   Calcule o vetor do centro da base até a posição do pino. Este é o seu `input_vector`.
            -   Use `Input.parse_input_event()` para injetar este vetor como se fosse um input de um controle analógico real.
        -   Se `event is InputEventScreenTouch and not event.pressed and event.index == joystick_touch_index`:
            -   Resete o joystick para a posição central e zere o `input_vector`.

### 4.3. Teste e Debug
-   **Android:** Conecte seu celular ao PC com o modo de desenvolvedor e depuração USB ativados. O Godot o detectará e um ícone de Android aparecerá no canto superior direito, permitindo que você rode o jogo diretamente no dispositivo com um clique, com acesso ao console de saída.
-   **iOS:** Requer um Mac com Xcode. O processo é mais complexo e envolve provisionamento de perfis e certificados da Apple.

---

## 5. Consoles (PlayStation, Xbox, Switch)

**AVISO IMPORTANTE:** Publicar em consoles requer um contrato de desenvolvedor com a respectiva empresa (Sony, Microsoft, Nintendo). Os detalhes, SDKs e processos são cobertos por Acordos de Não Divulgação (NDA). As informações abaixo são princípios gerais.

-   **Acesso:** Você não pode simplesmente exportar para um console. Você precisa ser aprovado como desenvolvedor, obter um devkit (hardware especial) e acesso ao portal de desenvolvimento da plataforma.
-   **Performance é Lei:** Consoles têm hardware fixo. Seu jogo **deve** rodar a uma taxa de quadros estável (geralmente 30 ou 60 FPS) e dentro dos limites de memória estritos da plataforma. A otimização não é opcional.
-   **Certificação (TRC/TCR):** Antes de ser publicado, seu jogo passa por um rigoroso processo de certificação. Ele é testado contra uma longa lista de requisitos técnicos (Technical Requirements Checklist). Falhar em qualquer um deles (ex: o jogo não pausa quando o usuário aperta o botão PS) resulta na rejeição do build.
-   **Godot e Consoles:** Existem empresas terceirizadas que se especializam em portar jogos Godot para consoles, lidando com o processo de engenharia e certificação para você.
