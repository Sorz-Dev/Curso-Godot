# Módulo 6 - Aula 2: GodotSteam (Integração com a Steam)

**Objetivo da Aula:** Apresentar o plugin `GodotSteam`, a ferramenta essencial para integrar seu jogo com a plataforma Steam, cobrindo suas funcionalidades e o processo de instalação.

---

### Roteiro do Vídeo

**1. Introdução (0-45s)**
*   "Olá! Na aula de hoje do nosso módulo de plugins, vamos falar sobre o sonho de muitos desenvolvedores: publicar um jogo na Steam."
*   "Mas para que seu jogo realmente 'viva' na plataforma, ele precisa se comunicar com ela: Conquistas (Achievements), placares de líderes (Leaderboards), salvar na nuvem (Cloud Saves)... Como fazemos isso?"
*   "A resposta é o plugin **GodotSteam**, uma implementação completa da API da Steam para o nosso motor preferido."

**2. O que é o GodotSteam e por que usá-lo? (45s-2m)**
*   **O que é?** "`GodotSteam` é uma extensão GDExtension (a forma moderna e performática de criar plugins para Godot 4) que 'traduz' todas as funcionalidades da API da Steam para que possamos chamá-las diretamente do nosso código GDScript."
*   **Por que é essencial?** "Sem ele, integrar seu jogo com a Steam seria um processo extremamente complexo, envolvendo C++ e um conhecimento profundo da API da Valve. O GodotSteam abstrai toda essa complexidade."
*   **Principais Funcionalidades que ele nos dá acesso:**
    *   **Conquistas e Estatísticas:** Desbloquear achievements e registrar estatísticas do jogador.
    *   **Leaderboards:** Enviar pontuações para placares de líderes globais.
    *   **Steam Cloud:** Salvar os jogos dos jogadores na nuvem da Steam, permitindo que eles continuem de onde pararam em qualquer computador.
    *   **Informações do Usuário:** Pegar o nome e o avatar do jogador na Steam.
    *   **Overlay e Amigos:** Interagir com o overlay da Steam e a lista de amigos.
    *   **Workshop:** Suporte para conteúdo criado pela comunidade.
    *   **DRM:** Proteção básica para seu jogo.

**3. Instalação e Configuração (2m-4m30s)**
*   "A instalação do GodotSteam é um pouco diferente de outros plugins, pois é uma GDExtension, mas ainda é simples."
*   **Passos:**
    1.  Vá para a página de releases do `GodotSteam` no GitHub (procure por "GodotSteam GitHub").
    2.  Baixe a versão correspondente à sua versão do Godot (ex: Godot 4.x).
    3.  O download virá com uma pasta `addons`. Copie a pasta `godotsteam` de dentro dela para a pasta `addons` do seu projeto.
    4.  **O Arquivo Chave:** Dentro da pasta, você verá um arquivo `godotsteam.gdextension`. É isso que configura o plugin.
    5.  **Ativação:** Diferente de plugins de GDScript, GDExtensions geralmente são ativadas automaticamente. Se não, verifique em `Projeto` -> `Configurações do Projeto...` -> `Plugins`.
*   **Configuração para Testes:**
    *   "Para testar a API da Steam, você não precisa ter um jogo publicado. A Valve fornece um 'App ID' de teste que todos podem usar: o `480` (que corresponde ao jogo 'Spacewar')."
    *   Na raiz do seu projeto, crie um arquivo de texto chamado `steam_appid.txt`.
    *   Dentro deste arquivo, coloque apenas o número `480`.
    *   "Agora, quando você rodar seu jogo a partir do cliente Steam (não pelo editor Godot), a Steam pensará que você está rodando o 'Spacewar' e ativará a API para testes."

**4. Como Funciona na Prática (Visão Geral) (4m30s-5m30s)**
*   "O GodotSteam cria um Singleton (Autoload) global chamado `Steam`."
*   "A partir de qualquer script, você pode chamar suas funções:"
    *   `Steam.get_persona_name()`: Pega o nome do jogador.
    *   `Steam.set_achievement("ACH_WIN_GAME")`: Desbloqueia uma conquista.
    *   `Steam.file_write("savegame.dat", data)`: Escreve um arquivo no Steam Cloud.
*   "Muitas funções da API da Steam são assíncronas. O GodotSteam lida com isso usando os sinais do Godot. Por exemplo, quando você pede os dados de um leaderboard, você conecta um sinal para receber a resposta quando ela chegar dos servidores da Steam."

**5. Conclusão (5m30s-6m)**
*   **Resumo:** "Apresentamos o `GodotSteam`, o plugin definitivo para integrar seu jogo à Steam. Vimos suas principais funcionalidades e como fazer a configuração inicial para testes usando o App ID 480."
*   "Assim como outros plugins complexos, não vamos implementá-lo agora. Mas quando chegarmos em um dos nossos projetos maiores, vamos retornar a este tópico e criar uma aula no **Módulo 7** mostrando como, por exemplo, implementar um sistema de conquistas do zero usando este plugin."
*   "Na próxima aula de plugins, vamos explorar uma ferramenta para criar IA avançada: as Árvores de Comportamento (Behavior Trees)."
