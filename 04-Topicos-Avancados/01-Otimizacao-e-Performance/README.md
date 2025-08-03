# Módulo Avançado 1: Otimização e Performance

Este módulo foca em transformar um jogo funcional em um jogo profissional, garantindo que ele rode de forma suave em uma vasta gama de hardware, especialmente em dispositivos mobile e computadores menos potentes.

### Aulas Planejadas:

- **1.1 - A Mentalidade da Otimização:**
  - Por que otimizar? Quando otimizar?
  - Entendendo o "custo" de cada nó e cada linha de código.
  - O trade-off entre performance e complexidade.

- **1.2 - Profiling na Prática:**
  - Apresentação detalhada do **Profiler** da Godot (Monitor, Profiler, Debugger de Rede).
  - Identificando gargalos: picos de processamento (CPU) vs. renderização (GPU).
  - Análise de uso de memória.

- **1.3 - Otimização de Scripts (CPU):**
  - Melhores práticas de GDScript: `_process` vs. `_physics_process`, `call_deferred`.
  - Evitando `get_node()` em loops.
  - Estratégias para otimizar algoritmos complexos (ex: A* para pathfinding).
  - Introdução ao `Threading` para tarefas pesadas.

- **1.4 - Otimização de Renderização (GPU):**
  - Entendendo `Draw Calls` e como reduzi-los.
  - Uso de `Texture Atlases` e `Sprite Sheets`.
  - Otimização de Shaders: complexidade e impacto na performance.
  - `Culling`: `Occlusion Culling` e `Frustum Culling` em 2D.

- **1.5 - Otimização Específica para Mobile:**
  - Gerenciamento de memória em dispositivos com recursos limitados.
  - Estratégias para lidar com diferentes resoluções e aspect ratios de forma performática.
  - Reduzindo o tamanho do build final (`.apk`/`.ipa`).
