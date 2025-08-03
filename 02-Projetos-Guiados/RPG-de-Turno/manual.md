# Manual de Visão Geral - RPG de Turno

## 1. Visão do Projeto

**Conceito:** Um RPG clássico com combate baseado em turnos, inspirado em jogos como os primeiros Final Fantasy e Dragon Quest. O jogador monta um grupo, explora um mundo e enfrenta inimigos em batalhas estratégicas.

## 2. Pilares do Design

1.  **Combate Estratégico:** As batalhas são sobre tomar as decisões certas (atacar, defender, usar magia, usar item) em vez de reflexos rápidos.
2.  **Gerenciamento de Grupo:** O jogador gerencia os equipamentos, habilidades e stats de um grupo de personagens.
3.  **Menus Complexos:** Grande parte do jogo acontece em menus (menu de batalha, inventário, tela de status). A UI precisa ser clara e eficiente.

## 3. Foco de Aprendizado

*   **Arquitetura de Dados com `Resources`**: Este é o foco principal. Usaremos `.tres` para definir tudo: personagens, suas classes, habilidades, inimigos, itens e equipamentos.
*   Criação de sistemas de UI complexos e interconectados.
*   IA de inimigo baseada em turnos (escolher o ataque mais eficaz, focar em alvos com pouca vida).
*   Gerenciamento de estado do jogo (de exploração para batalha e de volta).
