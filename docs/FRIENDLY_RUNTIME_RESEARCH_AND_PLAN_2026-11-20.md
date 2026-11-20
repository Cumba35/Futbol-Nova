# Investigación y plan de integración del modo amistoso — 2026-11-20

## Alcance y estado verificado

Esta rama parte de `feature/friendly-original-clubs-2026-11-20`. La PR #8 permanece abierta y en borrador; no se modifica ni se fusiona.

La pantalla `scripts/ui/pre_match_setup.gd` ya coloca Nova C35 (`FN-NOVA-C35`) como local y FC Río de Argenti (`FN-NOVA-RDA`) como visitante, pero los muestra desde `data/original_clubs_2026.json` como opciones informativas. La validación bloquea correctamente el inicio mientras no existan equipos y onces reales en el registro jugable.

El registro principal se construye en `scripts/data/football_data_service.gd` a través de importadores de catálogos/plantillas. `NovaFootballDataRegistry` exige referencias de jugadores válidas y expone `get_team_roster()`. El servicio `NovaCustomPlayerRosterService` persiste jugadores creados por usuario en `user://custom_player_roster.json`; esto no equivale a datos de plantilla versionados en el repositorio y, por sí solo, no registra un club nuevo en el catálogo oficial.

Los JSON de club originales declaran objetivo 22, pero C35 solo referencia dos IDs conocidos y RDA todavía no tiene IDs vinculados. No se debe retirar el bloqueo ni anunciar que el amistoso es funcional hasta importar los dos clubes, verificar 22 perfiles por club, generar onces de 11 y probar el flujo completo de runtime.

## Investigación de repositorios públicos

Fecha de consulta: 2026-11-20. La investigación se limita a patrones técnicos; no se copia código ni activos en esta fase.

| Repositorio | Hallazgos útiles | Licencia / mantenimiento / decisión |
|---|---|---|
| [antxiko/OpenComputerFutbolSimulator](https://github.com/antxiko/OpenComputerFutbolSimulator) | Godot 4.6.2 y GDScript; simulador de fútbol 2D, estructura de datos, calendario y pruebas. | MIT confirmado en LICENSE. Actividad pública visible hasta 2026-08-04; revisar compatibilidad y dependencias antes de portar. Referencia de arquitectura, no sustituto directo del motor 3D 11v11 de NOVA. |
| [mjasnikovs/godot-state-machine](https://github.com/mjasnikovs/godot-state-machine) | Máquina de estados de personaje basada en enum + AnimationPlayer; validación de estados/animaciones y casos de interrupción. | MIT confirmado. Repositorio reciente (última actualización pública observada 2026-09-26); exige Godot 4.7.2+, por lo que la compatibilidad con la versión del proyecto debe comprobarse. Solo patrón conceptual para animaciones. |
| [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball) | Port de GameplayFootball a Godot 4.4, GDExtension C++17, física del balón, árbitro, goles y AI de 22 jugadores. | El endpoint de repositorio no informa licencia y no se localizó un LICENSE verificable. No reutilizar código hasta aclarar derechos; referencia de características y arquitectura. |
| [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) | Godot 4.7.1, juego local y online, física, arbitraje, marcador, telemetría y estados autoritativos. | No se encontró licencia verificable en la raíz consultada y su modelo arcade/multijugador difiere del simulador NOVA. No copiar código/activos. |
| [Tobilion/footysim](https://github.com/Tobilion/footysim) | Motor 11v11 por ticks, agentes, física, decisiones, resolución de contactos y estadísticas. | Implementado en Python; no se verificó licencia compatible en esta revisión. Útil para estudiar separación de subsistemas, no para integrar código directamente. |

## Decisiones técnicas para NOVA

1. Mantener el motor de partido y el registro existente como fuente de verdad. No introducir otro motor completo sin benchmark y comparación de APIs.
2. Añadir un importador dedicado de clubes originales que:
   - lea un catálogo versionado de jugadores ficticios y los dos clubes;
   - valide IDs únicos, 35 atributos normalizados, posiciones, dorsal único por club y exactamente 22 jugadores por equipo;
   - preserve los IDs/datos de Anier Cumbá (`NOVA-PLAYER-0035`) y Máximo Padilla (`NOVA-PLAYER-0036`);
   - cree un ID nuevo y estable para Raymond Valdez, dorsal 5, y lo asigne únicamente a RDA;
   - compruebe que Raymond no aparece simultáneamente en otra plantilla.
3. Las estadísticas de carrera de los nuevos jugadores comienzan en cero. Las medias/atributos iniciales se etiquetan como ficticios/generados y no se presentan como datos reales.
4. El perfil de Raymond conserva los datos de su ficha: 19 años, nacimiento 2007-05-26, 171 cm, 63 kg, media 91 y potencial 96; posición primaria/secundaria según ficha (DC/MCO). Su perfil de movimiento tendrá parámetros originales inspirados en rasgos generales de regate, control cercano, cambios de ritmo, fintas y creatividad asociados por el usuario a Messi y Neymar. No usar animaciones, modelos, capturas de movimiento ni clips protegidos de esos jugadores. La celebración se implementará como animación original inspirada en la referencia de celebración de Messi, no como copia de una grabación.
5. El importador se ejecutará durante `initialize_catalog()` después de cargar los registros base y antes de validar el catálogo. Los clubes originales se registrarán como equipos jugables mediante el esquema oficial `NovaTeamProfile`; no basta con mostrarlos en el selector.
6. La preparación amistosa validará que los dos IDs existen en `registry.teams_by_id`, cada plantilla tiene 22 jugadores válidos y se puede construir un once de 11. El botón solo se habilitará cuando todas las comprobaciones sean verdaderas.
7. El inicio debe pasar los IDs, onces, estadio, duración y configuración de reloj al controlador de partido existente. El amistoso no debe modificar clasificaciones, calendarios oficiales ni Momentos diarios.
8. Al terminar, comprobar marcador final, estadísticas de partido, retorno a la interfaz y limpieza de estado; los amistosos no deben contaminar estadísticas de temporada.

## Matriz de aceptación pendiente

- [ ] Importación offline de los dos clubes y 44 jugadores ficticios sin duplicados.
- [ ] C35 conserva a Anier y Máximo; RDA incluye a Raymond con dorsal 5.
- [ ] Raymond tiene 35 atributos válidos y metadata de animación/celebración.
- [ ] Ambos equipos generan un once de 11 y una banca de 11.
- [ ] C35 local y RDA visitante aparecen seleccionados por defecto.
- [ ] Se puede iniciar un amistoso con estadio, duración y reloj seleccionados.
- [ ] El balón, jugadores, reloj, marcador y goles funcionan durante el partido.
- [ ] El partido finaliza correctamente y permite regresar al menú sin dejar nodos/estado residual.
- [ ] Los amistosos no alteran competiciones oficiales, estadísticas de temporada ni retos diarios.
- [ ] Pruebas headless Godot, lint/import y CI pasan sin regresiones.

## Bloqueos que impiden declarar funcional el modo

- La inicialización actual del catálogo valida 22 jugadores por equipo y un conteo global de 725 equipos/15.950 jugadores; la incorporación de dos clubes debe actualizar los invariantes y pruebas de forma explícita, no desactivar validaciones.
- No se ha verificado aún el esquema completo de `NovaTeamProfile` ni el flujo de arranque del controlador para un equipo fuera de los catálogos actuales.
- No se ha ejecutado Godot local/CI para este cambio.
- La versión de Godot del proyecto debe cotejarse con las referencias externas antes de adoptar APIs.

## Referencias

- https://github.com/antxiko/OpenComputerFutbolSimulator
- https://github.com/mjasnikovs/godot-state-machine
- https://github.com/aliyavuzz/Godotball
- https://github.com/namelesssyf/soccer-box-game
- https://github.com/Tobilion/footysim

Este documento registra investigación y decisiones; no certifica que el código del modo amistoso haya sido implementado ni probado.
