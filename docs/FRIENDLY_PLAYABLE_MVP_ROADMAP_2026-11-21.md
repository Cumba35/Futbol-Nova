# Fútbol Nova — plan de cierre del amistoso jugable

**Fecha:** 2026-11-21  
**Rama de trabajo:** `work/friendly-match-completion-2026-11-20`  
**Partido de aceptación fijo:** Nova C35 vs FC Río de Argenti  
**Control:** equipo completo Nova C35; no existe futbolista principal ni protagonista fijo. Anier Cumbá (`NOVA-PLAYER-0035`) es un integrante normal de la plantilla.  
**Motor:** Godot 4.4.1, GDScript, objetivo Android ARM64.

## Objetivo

Entregar primero un amistoso local completo que pueda iniciarse, jugarse y finalizarse de forma repetible. No ampliar carrera, online ni modos secundarios mientras el amistoso tenga bloqueos de jugabilidad.

## Auditoría del estado real del código

| Subsistema | Lo que existe | Trabajo necesario antes de marcarlo completo |
|---|---|---|
| Inicio de amistoso | Selector de equipos, alineaciones 11v11 y validación de catálogo | Validar la sesión real de principio a fin en Android |
| Control del equipo | Cambio manual entre los once jugadores locales, con ID y nodo visual conservados | El control no debe estar asociado permanentemente a Anier ni a otro futbolista; pendiente de validación Godot/CI y prueba táctil Android |
| IA | Movimiento táctico, persecución del balón, pases, tiros y tackles básicos | Roles, apoyos, presión, decisiones de pase/tiro y comportamiento sin balón más robustos |
| Porteros | Posicionamiento predictivo y `AnimatableBody3D` con cápsula | Reacción a disparos, desplazamiento lateral explosivo, blocaje/desvío, recuperación y estadísticas de atajadas |
| Reglas | Reloj, goles, pausas, cambio de campo y algunos reinicios | Árbitro/estado de reinicios unificado, faltas, tiros libres, penaltis reglamentarios y límites de balón |
| Estadísticas | `NovaPlayerStatisticsService` para carrera/temporada | Resumen exclusivo del amistoso; no escribir estadísticas de liga/carrera en amistosos de prueba |
| Validación | Pruebas de importación, alineación, IA, portero y runtime | Prueba de control/cambio, atajadas reales, faltas/reinicios, resumen estadístico y ciclo completo en dispositivo |

### Requisito de control de equipo y modalidad individual (decisión del propietario — 2026-11-21)

El amistoso admite dos modalidades configurables desde Opciones > Juego y desde la preparación del partido:

- **Control de equipo (estilo FIFA):** el usuario dirige al equipo, maneja un jugador cada vez, cambia libremente entre los once con CAMBIO/TAB y los diez restantes se comportan mediante IA.
- **Control de un jugador:** el usuario elige cuál de los once manejar al inicio. Los demás diez compañeros y los once rivales quedan bajo IA. El usuario puede cambiar a otro futbolista durante el encuentro o regresar al control de equipo desde la pausa.

No existe futbolista principal, protagonista ni personaje fijo. Los once integrantes de Nova C35 tienen la misma importancia, incluido Anier Cumbá. El jugador activo es solo el foco momentáneo de los controles, no un protagonista ni un rol permanente. La modalidad y el último jugador elegido se guardan localmente.

`NovaMatch11v11Controller.start_match()` mantiene actualmente un actor humano y 21 actores IA. Se incorporaron preferencias persistentes para `team`/`single`, selector de jugador inicial, catálogo de los once IDs, selección directa de jugador desde la pausa y avatar genérico para futbolistas sin escena individual. La implementación sigue pendiente de validación Godot/CI y pruebas reales. Ningún flujo ni test puede exigir que Anier sea el jugador inicial, darle prioridad o tratarlo como personaje central.

**Requisito de arquitectura:** no simular un cambio de jugador teletransportando el avatar de Anier y dejando su identidad visual asociada a otro ID. La identidad, el modelo, el estado de movimiento, la posesión y el ID de estadísticas deben cambiar de forma atómica. Si el modelo no puede intercambiarse correctamente, no habilitar la opción hasta resolverlo.

## Fases de implementación y criterios de aceptación

### P0 — Base CI y ejecución repetible
- [ ] Completar el workflow actual; registrar el resultado de cada prueba.
- [ ] Corregir cualquier regresión con prueba que reproduzca el fallo.
- [ ] Exportar APK ARM64 y comprobar instalación/arranque en Android.
- [ ] Confirmar C35 local, RDA visitante y selección neutral/dinámica del primer jugador controlado; Anier no debe ser obligatorio.
- [ ] No fusionar PR #10 ni publicar APK sin autorización.

### P1 — Control de equipo (prioridad máxima)
- [x] El amistoso se diseña para controlar al equipo completo; no hay modo de protagonista ni futbolista principal.
- [x] Opción de control de equipo o de un jugador en preparación del amistoso y en Configuración > Juego.
- [x] Selector del futbolista inicial (once local) y preferencia local persistente.
- [x] Cambio directo a un futbolista seleccionado desde la configuración en pausa; retorno al control de equipo.
- [ ] Validar en CI que las dos modalidades y el selector funcionen sin errores.
- [ ] El arranque debe usar el jugador elegido en modo individual y una selección neutral en modo equipo, sin fijar Anier ni otro jugador como protagonista.
- [x] Cambio manual cíclico por los once jugadores locales con botón táctil `CAMBIO` y tecla `TAB` (implementación inicial pendiente de validación).
- [ ] Validar la promoción/reutilización de actores, animaciones y colisiones en Godot 4.4.1 y Android.
- [ ] Cambio asistido opcional al defender, sin cambiar de forma inesperada al jugador cuando el usuario usa cambio manual.
- [x] Mantener control humano solo en un futbolista a la vez; los otros diez vuelven a IA inmediatamente (implementación inicial pendiente de CI).
- [ ] Conservar ID, dorsal, modelo/visual, atributos, stamina, posición y equipo al cambiar.
- [ ] No permitir seleccionar jugadores del rival.
- [ ] Probar cambio con balón, sin balón, durante pase, tiro, pausa, gol y reinicio.
- [ ] El cambio manual no debe alterar la identidad, la posesión ni las acciones pendientes del jugador activo; cualquier asistencia automática debe ser opcional y no convertir a un futbolista en protagonista.

### P2 — IA para los 21 no controlados
- [ ] Roles de 4-3-3, líneas y distancias de apoyo.
- [ ] Reacción de compañeros a pase, desmarque, pérdida y recuperación.
- [ ] Presión por cercanía/ángulo, cobertura y repliegue.
- [ ] Portador IA: decidir entre pase, conducción, tiro y despeje.
- [ ] Evitar persecución colectiva del balón y solapamientos.
- [ ] Dificultad y coste de CPU configurables para Android.
- [ ] Pruebas deterministas de escenarios y test de carga de 22 jugadores.

### P3 — Porteros
- [ ] Predicción de punto de intercepción y tiempo de reacción.
- [ ] Paso lateral y estirada con límite de alcance, cooldown y recuperación.
- [ ] Blocaje cuando la velocidad/altura y orientación lo permitan; si no, desvío controlado.
- [ ] Despeje con dirección segura y sin conceder posesión fantasma.
- [ ] Reacción a rebotes y segundas jugadas.
- [ ] Pruebas de tiro bajo, alto, cruzado, cercano, lejano, rebote y penalti.
- [ ] Contabilizar atajadas solo tras contacto/intervención válida, no por mero posicionamiento.

### P4 — Reglas y reinicios
- [ ] Máquina de estados única para saque inicial, banda, córner, saque de puerta, falta, penalti, descanso y final.
- [ ] Determinar equipo beneficiado a partir del último toque registrado.
- [ ] Colocar jugadores y balón en posiciones legales antes de reanudar.
- [ ] Evitar movimiento, robo de balón o gol durante el estado de reinicio.
- [ ] Añadir faltas, ventaja si se implementa, tiros libres y tarjetas con pruebas.
- [ ] Verificar cambio de lado y equipo que saca en cada período.

### P5 — Estadísticas y validación
- [ ] Estadísticas de partido aisladas: posesión, tiros, tiros a puerta, goles, pases, precisión, tackles, faltas y paradas.
- [ ] Atribución por jugador solo con ID de evento verificable.
- [ ] Resumen final y reinicio limpio para un segundo amistoso.
- [ ] No modificar tablas de liga, carrera, Momentos diarios ni estadísticas oficiales.
- [ ] Pruebas de invariantes: 22 jugadores, 11 por lado, IDs únicos, marcador consistente, reloj válido y eventos ordenados.
- [ ] Prueba de sesión larga, pausa/reanudación, descanso, prórroga, penaltis y salida al menú.

## Investigación de repositorios públicos (solo patrones; no copiar sin licencia y procedencia auditadas)

1. [awest813/League-Soccer](https://github.com/awest813/League-Soccer) — README declara Apache-2.0. Buen referente funcional: 22 jugadores, árbitro, faltas, set pieces, estadísticas, stamina y pruebas de integración. Motor C++/SDL, no es una dependencia para Godot; estudiar separación de reglas, eventos y test de partido.
2. [erengaygusuz/fotbiler-football](https://github.com/erengaygusuz/fotbiler-football) — README declara Apache-2.0. Referencia de controles, cambio manual/asistido, configuración de duración y tácticas. Arquitectura C++/CMake distinta; adaptar comportamiento, no portar código sin revisión.
3. [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) — Godot 4.7.1, 110 commits visibles, pruebas automatizadas, telemetría, física y portero IA. No se verificó licencia en esta revisión; no reutilizar código ni assets.
4. [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball) — README declara Apache-2.0 y Godot 4.4.1, con física y IA de 22 jugadores. El README declara un port de GameplayFootball; verificar LICENSE real y cadena de procedencia antes de copiar cualquier componente. Por ahora, referencia arquitectónica.
5. [Habeeb-Rahman-CA/soccer-game-godot](https://github.com/Habeeb-Rahman-CA/soccer-game-godot) — referencia Godot de cambio asistido, estado de reinicio y control manual; licencia aún no auditada en esta revisión, no copiar.
6. [antxiko/OpenComputerFutbolSimulator](https://github.com/antxiko/OpenComputerFutbolSimulator) — MIT, simulación 2D y pruebas/estructura de datos; útil como referencia de tests y datos, no como motor 3D.

## Política de integración externa

- Priorizar algoritmos descritos en documentación y patrones generales de arquitectura.
- Antes de portar código: leer LICENSE del repositorio y de los componentes/copias de origen, comprobar dependencias, avisos y compatibilidad con Godot 4.4.1/Android ARM64.
- No añadir motores completos ni extensiones nativas si el beneficio no supera el coste de compilación, tamaño y mantenimiento en Android.
- Mantener atribución y avisos de licencia si una integración se aprueba.
- No descargar assets protegidos ni reproducir animaciones/modelos de futbolistas reales.

## Regla de sincronización

Cada cambio de código, prueba, configuración o documento de Fútbol Nova debe sincronizarse a la ruta equivalente en `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova/`. Después, volver a leer ambos repositorios y comparar SHA de contenido. Registrar commit, pruebas ejecutadas, resultado y pendientes. No fusionar ni publicar sin autorización expresa del propietario.

## Estado de esta revisión

La auditoría inicial confirmó que el cambio entre once no existía. Se ha añadido una primera implementación: el actor que deja de estar controlado conserva su nodo/modelo y estado como actor IA; el siguiente actor local se promueve a CharacterBody3D conservando sus hijos visuales, ID y posición. Se incorporó ciclo manual con TAB y botón táctil CAMBIO, más una prueba de aceptación que recorre los once IDs. Esta implementación todavía no se considera validada: debe pasar Godot 4.4.1, la prueba de amistoso y la exportación/smoke test Android. El amistoso sigue en desarrollo.


## Implementación inicial del cambio manual — 21-11-2026

- Se añadió `switch_to_next_home_player()` al controlador 11v11 con ciclo determinista por los once IDs del once local.
- El futbolista saliente conserva su mismo nodo CharacterBody3D, script, modelo y metadatos, y pasa a IA. Un actor genérico seleccionado se promueve a CharacterBody3D transfiriendo sus hijos visuales, ID y transformación; no se teletransporta el avatar anterior para fingir otra identidad.
- Se conserva el último toque registrado al cambiar de futbolista y se actualiza la referencia `main.player` al nuevo nodo controlado.
- Se añadió tecla TAB y botón táctil CAMBIO. La prueba de runtime recorre diez cambios desde Anier para comprobar once IDs únicos, 11 jugadores por equipo, 21 actores IA, referencia activa y conservación del último toque.
- Commits de implementación: `f03952ca37066e81d64c75d7a67d9d5e16704cd0`, `ba7f37fa0a0983d56b2b2bf4ece424e785a4a64e`, `8f8fd368cc25c834a90bf38b32479f1fe1a66fda`, `63c9f298025caeb3c3bd8e7d95b602c201858129`, `1c4b4bce97e7ff8e5b0b7b5ab938112532de423a` y `1e768a3c0beb706ac89c3c0eaf22eae0eb8900f1`.
- Los cuatro archivos de código/prueba afectados se espejaron en Nova Workspace y se releyeron con igualdad exacta de SHA de blob.
- El workflow 535 está pendiente al registrar esta actualización. Los runs 530–534 fueron cancelados por pushes sucesivos; el run 528 anterior sigue en ejecución. No se declara aprobado el cambio hasta que un workflow que incluya el último commit termine correctamente.


## Corrección de diseño del propietario — 2026-11-21 09:36 UTC

- El amistoso se juega manejando al equipo completo. No existe futbolista principal ni protagonista.
- Anier Cumbá es un jugador normal de Nova C35, con la misma importancia que los otros diez.
- El usuario puede controlar sucesivamente a cualquiera de los once; el jugador activo es solo el destinatario temporal de los controles y los demás diez quedan bajo IA.
- Se detectó que `main.gd` y `test_friendly_match_runtime.gd` todavía establecen Anier como control inicial y lo exigen en la aceptación. Esto debe eliminarse antes de considerar correcta la implementación. La neutralidad del jugador inicial y la igualdad de los once pasan a ser criterios explícitos.
- Esta corrección de diseño no significa que el cambio manual esté validado: el workflow 537 seguía en ejecución y el workflow 528 terminó fallando.


## Modalidades de control configurables — 2026-11-21 09:41 UTC

- Se añadieron `match_control_mode` (`team`/`single`) y `preferred_player_id` a las preferencias locales `NovaPreferences`, persistidas en `user://futbol_nova_settings.cfg`.
- La pantalla de preparación del amistoso permite elegir Control de equipo o Control de un jugador y seleccionar el jugador del once local.
- Configuración > Juego ofrece cambio de modalidad y selección directa de futbolista durante la pausa; permite volver a Control de equipo.
- El controlador expone opciones de los once titulares y `switch_to_home_player(player_id)`; se permite el cambio mientras la simulación está pausada.
- Para jugadores sin escena 3D individual se añadió un avatar genérico de Nova, evitando presentar erróneamente el modelo de Anier como otro futbolista.
- Se corrigió el test de ciclo: se requieren once cambios para volver al ID inicial (no diez); la prueba de falta usa el ID del jugador realmente controlado.
- Los cambios de código están guardados en la rama de trabajo y se releyeron tras cada escritura. Pendiente: workflow Godot 4.4.1 y sincronización verificada con Nova Workspace.

- Diferencia funcional de modalidades: `team` permite alternar al vuelo con CAMBIO/TAB; `single` mantiene al futbolista elegido y bloquea el ciclo automático. Si el usuario quiere cambiarlo, abre pausa > Configuración > Juego y selecciona otro; desde ahí también puede volver a Control de equipo.
- El último futbolista activo se guarda como preferencia local cuando se cambia mediante CAMBIO/TAB o el selector de pausa.
