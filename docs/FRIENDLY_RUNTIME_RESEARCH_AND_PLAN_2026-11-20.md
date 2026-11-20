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


## Resultado de implementación — 2026-11-20

La primera fase del plan quedó implementada en esta rama. Consultar `ORIGINAL_CLUBS_FRIENDLY_IMPLEMENTATION_2026-11-20.md` para el inventario exacto de cambios, los 44 perfiles, el avatar provisional de Raymond y los límites pendientes de validación. La integración registra Nova C35 y FC Río de Argenti en el catálogo global y habilita su amistoso 11v11. La ejecución real del workflow de Godot sigue pendiente; no se declara lista para fusionar hasta obtener CI verde.

## Revisión adicional de alternativas y diagnóstico CI — 2026-11-20 23:40 UTC

### Alternativas públicas revisadas en esta pasada

- OpenComputerFutbolSimulator (https://github.com/antxiko/OpenComputerFutbolSimulator): licencia MIT confirmada en LICENSE; README declara Godot 4.6.2/GDScript, simulación 2D y flujo end-to-end con plantillas, calendario y visor. Referencia arquitectónica y de pruebas reproducibles. No se portó código porque NOVA usa Godot 4.4.1 y su motor 3D en tiempo real.
- Godotball (https://github.com/aliyavuzz/Godotball): README describe Godot 4.4.1, GDExtension C++17, física del balón, árbitro y AI de 22 jugadores, y declara Apache-2.0. No se verificó un archivo LICENSE independiente ni la cadena completa de derechos de GameplayFootball; no copiar código ni binarios hasta auditar procedencia.
- League-Soccer / fotbiler-football (https://github.com/erengaygusuz/fotbiler-football): README declara Apache-2.0; C++/CMake con física 3D, AI, reglas y pruebas headless. Historial amplio (536 commits visibles), pero no es integración directa para el runtime GDScript/Godot de NOVA. Solo se toman ideas de separación y pruebas, sin portar código.
- Player12 (https://github.com/FlavioMili/Player12): README declara GPL-3.0 y simulación compartida de jugadores, balón, fatiga, presión y porteros; C++23/SDL3/SQLite no coincide con NOVA. Se descarta reutilizar código para no introducir obligaciones GPL incompatibles con la estrategia actual.
- OpenFootManager (https://github.com/openfootmanager/openfootmanager): README declara GPLv3 y arquitectura Rust/Tauri/React/SQLite con simulación por eventos. Referencia conceptual para estados, persistencia y pruebas, no dependencia adecuada para el motor Godot.

### Diagnóstico del workflow

- En el run 44837677459 (commit 6aeb507) pasaron la prueba de partido 11v11, el amistoso end-to-end hasta el pitido final, el importador de clubes y el disparo de la IA.
- Ese run falló en tests/test_friendly_goalkeeper_positioning.gd: detectó que CollisionShape3D del portero no exponía una cápsula válida. Las pruebas posteriores se omitieron por la parada del job; el APK se exportó al principio, pero no se publicó como artefacto validado porque el job terminó fallando.
- Se habilitó explícitamente la CollisionShape3D del portero y se amplió la aserción para distinguir nodo ausente, forma nula, clase incorrecta y dimensiones insuficientes. La corrección debe validarse con CI; no se asume que resuelva el fallo.
- El commit 786e5f599e34dcac88919982440412eff287b043 añadió diagnóstico de asignación de jugadores personalizados. El run 44837958720 se ejecuta para ese SHA; su resultado aún no certifica la corrección del portero.
- No publicar APK ni declarar CI verde hasta que el run más reciente termine con todos los pasos, regresiones y subida de artefacto correctos.

### Próximas verificaciones

1. Ejecutar el test de portero y revisar el log detallado si vuelve a fallar.
2. Verificar la colisión real con balón en movimiento y el desplazamiento sincronizado del cuerpo animable.
3. Confirmar 22 plazas por equipo, que Raymond y jugadores personalizados no se duplican y que el control humano conserva la identidad correcta.
4. Completar regresiones y smoke test Android; inspeccionar el artefacto APK solo tras CI verde.
5. Replicar cada archivo confirmado en Cumba35/Nova-Workspace bajo proyectos/juegos/futbol-nova/ y releer ambos repositorios para comparar contenidos.


## Auditoría ampliada de alternativas públicas — 2026-11-20

Se realizó una segunda búsqueda centrada en juegos Godot de fútbol, física de balón, IA de jugadores y flujo de partido. El proyecto NOVA declara Godot 4.4 y renderer GL Compatibility en `project.godot`; las propuestas se comparan con esa base y con el objetivo de Android/arm64.

| Repositorio | Licencia y mantenimiento observados | Compatibilidad / utilidad | Decisión |
|---|---|---|---|
| [krimshi/godot-soccer](https://github.com/krimshi/godot-soccer) | LICENSE leído directamente: MIT. Historial público pequeño (7 commits en la consulta). | Juego 2D sencillo en Godot; puede servir para contrastar manejo de balón y organización de escenas, pero no es un motor 3D 11v11 ni evidencia de soporte Android probado. | Fuente legalmente reutilizable bajo MIT si una pieza concreta supera revisión técnica; conservar copyright/licencia. No portar el juego entero. |
| [pdimitrop/Armistice](https://github.com/pdimitrop/Armistice) | MIT visible en GitHub. 2 commits observados; sin suite de pruebas ni CI declarados. | Godot 4.7 .NET, Forward+, Jolt; requiere un paquete de recursos externo de aproximadamente 12 GB. NOVA está en Godot 4.4, GDScript y GL Compatibility; la versión, renderer y peso lo hacen inadecuado para integrar ahora. | Referencia visual/arquitectónica solamente. No introducir .NET, Forward+ ni el paquete masivo de assets en la rama Android. |
| [AhkunTa/soccer-online](https://github.com/AhkunTa/soccer-online) | 176 commits observados, pero no se encontró LICENSE en la raíz consultada; el README lo describe como fork de nicolasbize/soccer-course. | Godot 4.6, GDScript, 6 contra 6, estados de jugador/balón/partido, IA por roles y red ENet. Arquitectura interesante, pero versión posterior y formato distinto al 11v11 de NOVA. | No copiar código ni recursos mientras no se verifique licencia del fork y de su upstream. Estudiar conceptos de estados e IA solamente. |
| [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball) | README declara Apache-2.0, pero no se verificó un archivo LICENSE en la raíz y se basa en GameplayFootball; falta auditar los avisos/licencias de upstream, submódulos y recursos. 16 commits observados. | Godot 4.4.1, GDExtension C++17, SCons, Jolt y sistema básico 22 jugadores. La versión está próxima a NOVA, pero introducir C++/GDExtension aumenta el coste de compilación Android y mantenimiento. | No integrar binarios ni código hasta completar auditoría de licencia y benchmark Android. Mantener como referencia de subsistemas y criterios de rendimiento. |
| [modelence/open-soccer](https://github.com/modelence/open-soccer) | 127 commits observados; no se encontró LICENSE en la raíz y aparece una solicitud pública de aclaración de licencia/permiso para un derivado comercial. | Motor 11v11 en TypeScript/Canvas con reglas, IA, controles y división de motor/renderizado; no es Godot y requeriría reescritura. | No copiar código, assets ni datos. Estudiar la separación entre simulación, física, render y reglas como patrón conceptual. |

### Conclusión técnica de la auditoría

- La opción de menor riesgo para el modo amistoso actual es continuar con el controlador GDScript ya integrado y reforzar pruebas de comportamiento, no reemplazar el motor por un framework completo.
- El único candidato adicional con licencia MIT comprobada directamente y tecnología Godot/GDScript es `krimshi/godot-soccer`, pero su alcance 2D y mantenimiento reducido no justifican una dependencia nueva.
- `Godotball` es el candidato más cercano a la versión de Godot y al 11v11, pero antes de reutilizar cualquier parte se exige verificar licencia real de cada componente heredado y medir coste/beneficio de GDExtension en Android.
- Se descarta integrar por ahora motores Godot 4.6/4.7, proyectos Forward+/.NET o motores web/Canvas en el runtime Android de NOVA.
- No se copió código, escenas, modelos, texturas, audio ni datos de estos repositorios. Esta investigación solo aporta criterios y decisiones; cualquier incorporación futura requiere revisión de archivo, licencia, procedencia, seguridad, compatibilidad y pruebas aisladas.

Referencias añadidas:
- https://github.com/krimshi/godot-soccer
- https://github.com/pdimitrop/Armistice
- https://github.com/AhkunTa/soccer-online
- https://github.com/aliyavuzz/Godotball
- https://github.com/modelence/open-soccer


## Corrección de estado CI — 2026-11-20 23:44 UTC

- El run 44837958720 (commit 786e5f599e34dcac88919982440412eff287b043) terminó en failure en el paso de posicionamiento del portero. El log conserva el mensaje genérico de la aserción de cápsula; las pruebas posteriores y la publicación del APK se omitieron.
- El run 44838667226 está ejecutándose con la revisión que incluye la aserción diagnóstica ampliada y la forma explícitamente habilitada. Su paso de test de portero aún no se ha ejecutado; todavía no se conoce el tipo exacto del fallo.
- La revisión del collider no se da por resuelta. Esperar el resultado del run 44838667226 y actuar según el diagnóstico concreto.
- El PR #10 sigue abierto y en draft. No se ha fusionado ni publicado APK validada.
