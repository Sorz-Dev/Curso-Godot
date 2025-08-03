# Manual de IA com Machine Learning (Avançado)

Este documento é um guia de arquitetura para a integração de Inteligência Artificial treinada com Machine Learning (ML) em um projeto Godot.

**Alerta de Complexidade:** Esta é uma técnica avançada. Ela **não** substitui a necessidade de IAs tradicionais (como as baseadas em Máquinas de Estado). O ML é uma ferramenta poderosa para comportamentos específicos e emergentes, mas é mais difícil de controlar, depurar e implementar do que uma FSM bem projetada.

## 1. Filosofia: Quando e Por Que Usar ML para IA?

- **NÃO USE** para comportamentos simples e previsíveis. Um "Goomba" que apenas anda para a esquerda e para a direita é muito mais fácil e eficiente de fazer com nossa Máquina de Estados.
- **USE** para comportamentos complexos e adaptativos que são difíceis de programar manualmente. Bons casos de uso:
  - Um chefe que aprende os padrões de ataque do jogador e se adapta.
  - NPCs que aprendem a navegar por níveis complexos com obstáculos dinâmicos.
  - Inimigos que coordenam táticas em equipe de forma emergente.

## 2. A Arquitetura Padrão: Treinamento Externo, Inferência Interna

O erro mais comum é tentar "treinar" a IA dentro do jogo em tempo real. Isso é computacionalmente inviável. A abordagem profissional é dividida em duas fases distintas:

1.  **Fase de Treinamento (Offline):** A IA (o "agente") aprende a se comportar em um ambiente controlado. Isso é feito **fora do Godot**, geralmente em um framework Python como PyTorch ou TensorFlow, e pode levar horas ou dias de processamento.
2.  **Fase de Inferência (Online):** O "cérebro" treinado da IA (o "modelo") é exportado e carregado no Godot. Dentro do jogo, o modelo não aprende mais; ele apenas usa o que aprendeu para tomar decisões (isso é chamado de "inferência" e é muito rápido).

## 3. Fase 1: O Ambiente de Treinamento (Godot + Python)

Para treinar a IA, você precisa que o Godot (o "ambiente") se comunique com um script Python (o "agente"). A melhor maneira de fazer isso é via **WebSockets**.

### 3.1. O Lado Godot (O Ambiente)
O seu jogo Godot precisa ser modificado para:
- **Rodar em alta velocidade:** Use `Engine.time_scale` para acelerar o jogo milhares de vezes e treinar mais rápido.
- **Enviar o estado do mundo (Observação):** A cada passo da física, envie um pacote de dados para o Python com tudo que a IA precisa saber. Ex: `{"player_pos": [x, y], "enemy_health": 80, "can_attack": true}`.
- **Receber uma Ação:** Aguarde o Python responder com uma ação. Ex: `{"action": "attack"}`.
- **Executar a Ação:** Execute a ação recebida no jogo.
- **Calcular a Recompensa:** Calcule um número que diz ao Python se a ação foi boa ou ruim. Ex: `+10` por acertar o jogador, `-1` por tomar dano, `-0.01` por cada segundo que passa (para incentivar a velocidade). Envie essa recompensa.

### 3.2. A Ponte de Comunicação (WebSocket)
- **Em Godot:** Use a classe `WebSocketServer` ou `WebSocketClient` para se comunicar com o script Python.
- **Em Python:** Use uma biblioteca como `websockets` para receber as observações e enviar as ações.

### 3.3. O Lado Python (O Agente de Reinforcement Learning)
Este é um script Python que usa uma biblioteca de Aprendizado por Reforço (Reinforcement Learning - RL), como a popular **Stable Baselines3**.
- Ele inicia um servidor WebSocket para ouvir o Godot.
- **O Loop de Treinamento:**
  1.  Recebe a **Observação** do Godot.
  2.  Alimenta a observação no modelo de RL.
  3.  O modelo escolhe uma **Ação**.
  4.  Envia a Ação de volta para o Godot.
  5.  Recebe a **Recompensa** do Godot.
  6.  Usa a tupla (Observação, Ação, Recompensa) para atualizar seus pesos e "aprender".
- Este loop é repetido milhões de vezes até que o comportamento do agente seja satisfatório.

## 4. Fase 2: A Inferência no Jogo (Usando o Modelo Treinado)

### 4.1. Exportando o Modelo (Formato ONNX)
Após o treinamento, o modelo Python é salvo. O formato padrão da indústria para interoperabilidade é o **ONNX (Open Neural Network Exchange)**. Bibliotecas como Stable Baselines3 podem exportar para este formato. Você terá um arquivo como `enemy_brain.onnx`.

### 4.2. Carregando o Modelo em Godot
Esta é a parte mais desafiadora. Godot não pode ler arquivos `.onnx` nativamente. Você precisa de uma extensão:
- **Solução:** Usar uma GDExtension que integra um "runtime" de ONNX no Godot. Um exemplo promissor é o **Godot-ONNX**.
- **O que isso significa:** Você provavelmente precisará compilar código C++ ou baixar uma versão pré-compilada desta extensão para o seu projeto.

### 4.3. O "Estado de IA por ML"
Dentro da sua Máquina de Estados (`FSM`) do inimigo, você criaria um novo estado, `ML_State.gd`.
- **Lógica do `ML_State.gd`:**
  - `enter()`: Carrega o arquivo `enemy_brain.onnx` usando a GDExtension.
  - `process_physics(delta)`:
    1.  Coleta as observações do jogo (posição do jogador, etc.), exatamente como na fase de treinamento.
    2.  Alimenta essas observações no modelo ONNX carregado.
    3.  O modelo retorna uma ação (ex: um número de 0 a 3, onde 0=andar, 1=pular, etc.).
    4.  Executa a ação correspondente no inimigo.

## 5. Conclusão: Um Exemplo Prático

- **Problema:** Queremos um inimigo que aprenda a encurralar o jogador em um labirinto.
- **Fase 1 (Treinamento):**
  - **Observação:** Posição do inimigo, posição do jogador, 8 RayCasts ao redor do inimigo para detectar paredes.
  - **Ações:** Mover para cima, baixo, esquerda, direita.
  - **Recompensa:** `+1` a cada segundo que a distância para o jogador diminui. `-1` se bater em uma parede. `+100` se pegar o jogador.
  - Rodamos o jogo e o script Python por 2 horas em `time_scale = 20`.
- **Fase 2 (Inferência):**
  - Exportamos o modelo treinado para `corner_enemy.onnx`.
  - Usamos a extensão Godot-ONNX para carregar o modelo.
  - O inimigo no jogo usa seu `ML_State` para coletar as mesmas observações e consultar o modelo `.onnx` a cada frame para decidir para onde se mover. O resultado é um inimigo que navega pelo labirinto de forma inteligente e emergente.

Esta abordagem é imensamente poderosa, mas requer um investimento significativo em aprendizado de ferramentas externas (Python, RL) e possivelmente compilação de código.
