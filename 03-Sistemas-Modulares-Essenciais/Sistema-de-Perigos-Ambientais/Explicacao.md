# Manual de Perigos Ambientais

Este documento descreve um sistema para criar perigos ambientais, como poças de lava, espinhos, nuvens de veneno, etc. O objetivo é ter uma cena `Hazard` genérica e reutilizável.

## 1. A Filosofia: Dano Desacoplado

Um perigo ambiental é, em essência, uma `Hitbox` persistente que pertence ao "mundo" em vez de a um inimigo. Ele aplica um `AttackData` a qualquer personagem (jogador ou inimigo) que entrar em contato.

## 2. O Recurso de Perigo (`HazardData.tres`)

Para máxima flexibilidade, definimos as propriedades de um perigo em um `Resource`.

- **Criação:** Crie um script `HazardData.gd` que herda de `Resource`.
  ```gdscript
  class_name HazardData
  extends Resource

  @export var damage_per_tick: int = 5
  @export var tick_interval: float = 1.0
  @export var knockback_force: float = 100.0
  @export var damage_type: String = "fire"
  ```

## 3. A Cena Base: `Hazard.tscn`

Esta cena pode ser colocada em qualquer nível para criar uma área de dano.

- **Criação:** Crie uma nova cena `Hazard.tscn`.
- **Estrutura da Cena:**
  - **Nó Raiz:** `Hazard` (Area2D)
    - **Script:** `hazard.gd`
    - **Collision Layer:** "world_hazard", **Collision Mask:** "hurtbox".
  - **Nós Filhos:**
    - `CollisionShape2D`: Define a forma e o tamanho da área de perigo.
    - `AnimatedSprite2D` ou `GPUParticles2D`: O efeito visual.
    - `DamageTimer` (Timer): Controla a frequência do dano.

- **Script (`hazard.gd`):**
  ```gdscript
  class_name Hazard
  extends Area2D

  @export var data: HazardData

  var bodies_in_area: Array[Node] = []

  func _ready():
      if not data: 
          print("ERRO: Hazard sem HazardData!")
          return

      $DamageTimer.wait_time = data.tick_interval
      $DamageTimer.start()
      
      body_entered.connect(_on_body_entered)
      body_exited.connect(_on_body_exited)
      $DamageTimer.timeout.connect(_on_damage_timer_timeout)

  func _on_body_entered(body):
      if body.has_method("take_damage") and not bodies_in_area.has(body):
          bodies_in_area.append(body)
          apply_damage(body)

  func _on_body_exited(body):
      if bodies_in_area.has(body):
          bodies_in_area.erase(body)

  func _on_damage_timer_timeout():
      for body in bodies_in_area:
          if is_instance_valid(body):
              apply_damage(body)
          else:
              bodies_in_area.erase(body)

  func apply_damage(target_body):
      var attack_data = AttackData.new() # Supondo que AttackData seja um Resource
      attack_data.base_damage = data.damage_per_tick
      attack_data.knockback_force = data.knockback_force
      attack_data.source = self
      attack_data.damage_type = data.damage_type
      
      target_body.take_damage(attack_data)
  ```

## 4. Exemplos de Uso

Agora, para criar uma poça de lava, você cria um `lava_hazard.tres` (um recurso `HazardData`), ajusta seus valores no Inspector, e arrasta esse arquivo para o campo `Data` da sua cena `Hazard` no nível.