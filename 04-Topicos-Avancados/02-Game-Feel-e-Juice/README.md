# Módulo Avançado 2: Game Feel e "Juice"

Este módulo é dedicado à arte de fazer um jogo ser *gostoso* de jogar. Vamos além da funcionalidade e mergulhamos nos detalhes que criam uma experiência de usuário memorável e responsiva.

### Aulas Planejadas:

- **2.1 - A Teoria do "Juice":**
  - O que é Game Feel? Por que é importante?
  - Análise de exemplos clássicos (Celeste, Dead Cells).
  - Os 12 princípios básicos do "Juice".

- **2.2 - Feedback Visual e Impacto:**
  - **Screenshake:** Implementando um sistema de tremor de câmera reutilizável.
  - **Partículas:** Criando efeitos de impacto, poeira, e rastros com `GPUParticles2D`.
  - **Hit-Stop / Hit-Lag:** Pausando a ação por milissegundos para dar peso aos ataques.
  - **Animação de Squash & Stretch:** Aplicando princípios da animação clássica para dar vida aos personagens.

- **2.3 - Polimento de Controles:**
  - **Coyote Time:** Permitir que o jogador pule mesmo depois de sair de uma plataforma.
  - **Jump Buffering:** Registrar o input de pulo um pouco antes de tocar o chão.
  - Ajuste fino de aceleração e desaceleração para um movimento mais natural.

- **2.4 - Feedback Auditivo:**
  - A importância do Sound Design para o Game Feel.
  - Sincronizando SFX com animações e eventos.
  - Variação de pitch e volume para evitar repetitividade.

- **2.5 - Transições e UI:**
  - Animações de transição de UI (`Tween` e `AnimationPlayer`).
  - Menus que respondem ao input com som e animação.
  - Criando transições de cena polidas.
