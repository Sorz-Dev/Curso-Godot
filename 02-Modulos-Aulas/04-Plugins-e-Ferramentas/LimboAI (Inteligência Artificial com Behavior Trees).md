# Módulo 6 - Aula 3: LimboAI (Inteligência Artificial com Behavior Trees)

**Objetivo da Aula:** Introduzir o conceito de Árvores de Comportamento (Behavior Trees) e apresentar o plugin `LimboAI` como uma ferramenta poderosa e visual para construir IAs complexas.

---

### Roteiro do Vídeo

**1. Introdução (0-1m)**
*   "Olá! Bem-vindo a mais uma aula do nosso módulo de plugins. Hoje vamos mergulhar fundo no cérebro dos nossos NPCs e inimigos: a Inteligência Artificial."
*   "Já vimos como usar uma Máquina de Estados, que é ótima para gerenciar um conjunto finito de estados (parado, patrulhando, atacando). Mas e se o comportamento for mais complexo? E se o inimigo precisar decidir entre patrulhar, procurar por vida, dar cobertura a um aliado ou fugir?"
*   "Para essas IAs mais dinâmicas, usamos um padrão chamado **Árvore de Comportamento (Behavior Tree)**, e a melhor ferramenta para isso no Godot é o plugin **LimboAI**."

**2. O que é uma Árvore de Comportamento? (1m-2m30s)**
*   **A Ideia Central:** "Diferente de uma Máquina de Estados (onde você está sempre *em um* estado), uma Árvore de Comportamento é uma árvore de tarefas. A cada frame, a IA percorre a árvore de cima para baixo, da esquerda para a direita, tentando executar tarefas."
*   **Analogia:** "Pense em uma lista de prioridades de um soldado:
    1.  *Prioridade 1:* Há um inimigo à vista?
        *   *Se sim:* O inimigo está perto?
            *   *Se sim:* Atire.
            *   *Se não:* Procure cobertura e avance.
    2.  *Prioridade 2 (se a 1 falhar):* Minha vida está baixa?
        *   *Se sim:* Procure por um kit médico.
    3.  *Prioridade 3 (se as outras falharem):* Volte para a sua rota de patrulha."
*   "Isso é uma Árvore de Comportamento! É uma forma hierárquica de tomar decisões, muito mais flexível e escalável que uma Máquina de Estados."

**3. Apresentando o LimboAI (2m30s-4m)**
*   **O que é?** "`LimboAI` é um plugin que nos dá um editor visual, integrado ao Godot, para construir e depurar essas árvores. Em vez de escrevermos a lógica em código, nós a montamos com blocos."
*   **Principais Componentes:**
    *   **`BTPlayer` (Behavior Tree Player):** Um nó que você adiciona ao seu personagem (inimigo, NPC) para executar uma árvore de comportamento.
    *   **Editor Visual:** Uma nova janela no Godot para montar a árvore, arrastando e soltando nós.
    *   **Nós de Comportamento:**
        *   **Compostos (Composites):** Nós que controlam o fluxo. Os mais comuns são `Sequence` (tenta executar todos os filhos em ordem, falha se um falhar) e `Selector` (tenta executar os filhos em ordem, tem sucesso se um tiver sucesso - como a nossa lista de prioridades).
        *   **Ações (Actions):** As folhas da árvore. São as tarefas reais, como `MoverPara`, `Atacar`, `TocarAnimação`. Você escreve essas ações em GDScript.
    *   **Blackboard:** Um "quadro negro", um dicionário onde a IA armazena suas informações (`player_last_seen_position`, `has_low_health`, etc.) para que os nós da árvore possam acessá-las.

**4. Instalação (4m-4m30s)**
*   "A instalação é padrão, via `AssetLib`."
*   **Passos:**
    1.  Vá na `AssetLib` e procure por "LimboAI".
    2.  Faça o `Download` e `Instale`.
    3.  Vá em `Projeto` -> `Configurações do Projeto...` -> `Plugins` e ative o `LimboAI`.

**5. Vantagens sobre Máquinas de Estado (4m30s-5m30s)**
*   **Modularidade:** Cada pequena tarefa (como "EncontrarInimigo") é sua própria ação. Você pode reutilizar essa ação em várias árvores diferentes.
*   **Reatividade:** A árvore é reavaliada constantemente, permitindo que a IA reaja a mudanças no ambiente de forma muito mais rápida e natural.
*   **Visual e Depurável:** É muito mais fácil para um designer entender e ajustar a lógica de uma IA visualmente. O LimboAI ainda mostra em tempo real quais nós da árvore estão sendo executados, facilitando a depuração.

**6. Conclusão (5m30s-6m)**
*   **Resumo:** "Apresentamos as Árvores de Comportamento como um padrão avançado para IA e o plugin `LimboAI` como a ferramenta visual para construí-las em Godot. Elas nos permitem criar comportamentos complexos de forma modular e reativa."
*   "Este é um tópico avançado. Quando chegarmos em projetos que exijam inimigos mais inteligentes, como em um jogo de estratégia ou um RPG, teremos uma aula no **Módulo 7** dedicada a construir uma IA completa usando o LimboAI, escrevendo nossas próprias ações e usando o Blackboard."
*   "Na nossa próxima aula de plugins, vamos olhar para uma ferramenta que nos ajuda a criar movimentos de câmera mais bonitos e cinematográficos."
