# Fútbol Nova — investigación de pantallas, plantillas y estadios

**Fecha:** 19 noviembre 2026  
**Ámbito:** selector de amistoso, datos de clubes/jugadores, estadio base, Godot 4.4.1 y Android.

## Alternativas públicas revisadas

### 1. Habeeb-Rahman-CA/soccer5v5-game-godot
- GitHub: https://github.com/Habeeb-Rahman-CA/soccer5v5-game-godot
- README y LICENSE consultados directamente.
- Código declarado MIT; el proyecto declara Godot 4.6 (GL Compatibility), squads JSON, recursos de jugador, estados de juego, IA de campo/portero y escenas de estadio.
- Incluye etiquetas de Real Madrid y Barcelona en su catálogo de ejemplo.
- **Decisión:** no importar escenas, scripts, datos de jugadores ni assets. La versión 4.6 no coincide con el runtime de Fútbol Nova (4.4.1), y la presencia de nombres de clubes no acredita derechos sobre escudos, equipaciones o plantillas. Se toma como referencia arquitectónica general para separar roster JSON, recursos de jugador y escena de partido.

### 2. antxiko/OpenComputerFutbolSimulator
- GitHub: https://github.com/antxiko/OpenComputerFutbolSimulator
- README y LICENSE consultados directamente.
- Código MIT. El aviso de datos distingue expresamente el código de los JSON con nombres de clubes/jugadores, camisetas y estadios, cuyo uso se limita a un proyecto personal no comercial.
- El proyecto usa Godot 4.6.2 y sus propias plantillas 2025/26.
- **Decisión:** no copiar código ni datos. La licencia MIT del código no libera los datos deportivos del aviso separado. Se estudia la organización de equipos, plantillas y pantallas como referencia de arquitectura.

### 3. awest813/League-Soccer
- GitHub: https://github.com/awest813/League-Soccer
- README y LICENSE Apache-2.0 consultados en la revisión anterior.
- Arquitectura amplia de simulación, IA, árbitro, estadísticas y controles, pero núcleo C++/CMake dirigido a escritorio.
- **Decisión:** conservarlo como referencia de separación de subsistemas y pruebas headless; no incorporar el motor C++ ni dependencias ajenas a GDScript/Android.

### 4. OpenFootball
- Repositorios de descubrimiento: https://github.com/openfootball/clubs y https://github.com/openfootball/leagues
- Los catálogos sirven para investigar clubes y competiciones, pero no deben confundirse con una lista oficial de miembros de una temporada ni con plantillas actuales jugador-club.
- No se importan datos nuevos en esta revisión; se conserva la procedencia de los datos ya catalogados en Fútbol Nova y se mantiene pendiente la auditoría de temporada de algunas ligas.

## Decisiones aplicadas en Fútbol Nova

1. Conservar Godot 4.4.1, GDScript y ejecución offline.
2. Mantener las identidades originales del juego: Albor Madrid representa a Real Madrid y Litoral Barcelona representa a FC Barcelona.
3. Usar los IDs internos estables `FN-ESP-REAL-MADRID` y `FN-ESP-BARCELONA` para el amistoso inicial.
4. Mostrar Real Madrid a la izquierda como local y FC Barcelona a la derecha como visitante.
5. Mostrar once perfiles de la plantilla Nova por equipo antes de iniciar, evitando IDs repetidos y priorizando posiciones.
6. Mantener claro que los 22 perfiles por club son ficticios; no presentarlos como las plantillas profesionales 2026/27.
7. Añadir Estadio Nova como recinto original del juego base mediante geometría procedural de bajo coste.
8. No incorporar escudos, equipaciones, patrocinadores, modelos 3D, fotografías o sonidos oficiales/de terceros.

## Archivos de implementación

- `scripts/ui/pre_match_setup.gd`
- `scripts/main.gd`
- `data/stadiums/base_stadiums.json`
- `tests/test_friendly_match_runtime.gd`
- `docs/PRE_MATCH_TEAM_SELECTION.md`
- `docs/SPAIN_DATABASE_2026_27.md`
- `docs/GLOBAL_CLUB_AND_SQUAD_COMPLETION.md`

## Validación pendiente

- Ejecutar el workflow manual `.github/workflows/futbol-nova-android-apk.yml` en GitHub Actions.
- Confirmar importación de recursos y ausencia de errores GDScript.
- Pasar las pruebas de menú, amistoso 11v11, diez ligas base y perfiles.
- Exportar APK Android ARM64.
- Probar visualmente la pantalla de preparación, el estadio y el partido en un dispositivo Android real, con escalado y rendimiento.
- Solo después de resultados satisfactorios actualizar el estado de publicación de las ligas.

**No se declara que el APK, la interfaz visual o la ejecución Godot hayan sido validados en dispositivo.**


## Correcciones tras la primera ejecución de CI — 19-11-2026

La ejecución `44441146949` en Godot 4.4.1 llegó a ejecutar la importación y las pruebas iniciales. La validación de nombres de clubes y el archivo histórico pasaron; también pasaron la prueba del hub, el modelo de vuelo del balón y la base 11v11. La prueba runtime del amistoso se detuvo por errores de parseo (`MOMENTS_SERVICE_SCRIPT` no declarado y dos variables sin tipo explícito) y por una propiedad de alineación no válida en el control `Button` de las tarjetas.

Correcciones guardadas en la rama independiente: `scripts/ui/pre_match_setup.gd` ahora usa `Button.alignment`; `tests/test_friendly_match_runtime.gd` declara el preload del servicio de Momentos y tipos `String` explícitos. La rama maestra de Workspace recibió la corrección de la tarjeta y mantiene los tipos explícitos en su prueba equivalente.

**Estado posterior:** los archivos corregidos se releyeron desde GitHub. Todavía no hay resultado de una ejecución nueva con esos commits; no se declara aprobada la prueba runtime ni la exportación APK.


## Integración de perfiles individuales al partido — 19-11-2026

Se cerró una brecha entre el selector y el runtime: el selector ya enviaba los IDs de los titulares, pero el motor solo los utilizaba como identificadores y no aplicaba sus atributos. Ahora `build_lineup` resuelve los IDs desde `FootballData.registry.players_by_id` y adjunta el perfil a cada plaza. Los 21 actores de IA guardan nombre, posición, valoración, atributos y pie preferido; la velocidad se calcula desde `spd` y la del portero desde `gkspd`. Pases, despejes y entradas usan `short`, `longp`, `kick` y `tack`. El jugador controlado conserva su perfil como metadata y recibe ajustes de velocidad, aceleración, pase, tiro y alcance de entrada desde sus atributos.

Se amplió `test_friendly_match_runtime.gd` para verificar que los 21 jugadores de IA y el jugador controlado reciben perfiles reales del catálogo Nova, que las estadísticas modifican parámetros de juego, y que el amistoso conserva equipos, colores y estadio. La suite aún debe volver a ejecutarse en GitHub Actions después de estos commits; no se declara el test aprobado ni la APK exportada.


## Nueva revisión pública — Soccer Box (19-11-2026)

Se revisó `namelesssyf/soccer-box-game` como referencia de pantallas de lobby, tutorial, resultados, personalización, telemetría y física de balón. El README declara Godot 4.7.1 y un estilo arcade de 3 jugadores más portero por equipo; Fútbol Nova mantiene Godot 4.4.1 y su objetivo 11 contra 11. No se localizó una licencia verificable en el repositorio durante esta revisión. Por incompatibilidad de versión/arquitectura y licencia no confirmada, no se copió código, escenas, datos ni assets. Se conserva únicamente como referencia de ideas de UX y cobertura de pruebas.


## Corrección posterior de regresiones detectadas por CI — 19-11-2026

La ejecución `44442727494` confirmó que `text_alignment` no es una propiedad válida de `Button` en Godot 4.4.1; el código se corrigió a `Button.alignment` (propiedad documentada por Godot 4.4). También se corrigió la inferencia de tipos de las coordenadas de asientos y del estado booleano del HUD.

La aceptación detectó que, después de `stop_match()`, el controlador 11v11 ya no conserva referencia al balón; por eso el reinicio de práctica no debía delegarse a ese controlador. `_reset_training_ball()` ahora reinicia directamente posición, velocidades lineal/angular y estado de sueño/congelación del balón de la escena. `_reset_ball()` solo delega al controlador mientras el amistoso esté activo. La prueba ahora inyecta velocidades y comprueba que ambas se limpian.

El commit con la corrección del reinicio es `f6148b068c4598e1b1e648146ed3e56022685e9d`; la prueba de velocidad se añadió en `a86b6d2bff91dd1db305a7a6a0adcf93526662ce`. La ejecución nueva de CI de este último commit está pendiente; no se declara todavía el test runtime ni la APK como aprobados.


## Resultado CI y corrección siguiente — 19-11-2026

Run #190 / job 135291158173 ejecutó correctamente las pruebas del hub y las cuatro pantallas principales, física del balón, fundación 11v11, amistoso real con goles y períodos, y geometría física de porterías/redes. La prueba de aceptación del amistoso verificó la apertura de las cuatro páginas principales, las once categorías de Configuración, el selector con Real Madrid local a la izquierda y Barcelona visitante a la derecha, las plantillas 22 por club, once titulares visibles por equipo, los tres estadios, inicio del 11v11 y el avance de reloj/períodos hasta el final.

El mismo run falló en tests/test_maximo_padilla_profile.gd: el script de carrera tenía referencias directas al autoload FootballDatabase en las funciones de guardado/carga. En un test aislado Godot no resuelve nombres globales de autoload que no están en el proyecto de prueba; el error secundario de new() se produjo porque el script dependiente no compiló.

Corrección aplicada en scripts/legend/legend_career_service.gd, commit 1efc90260a8d24e19d0d8b0dd335181a1ece4518: ambas rutas resuelven /root/FootballDatabase con get_node_or_null y usan call() solo si el autoload existe. Se releyó el archivo desde GitHub y se verificó que ya no quedan referencias globales directas a FootballDatabase en el script.

Nuevo run #193 (44444407781) disparado por el cambio de código, SHA 1efc90260a8d24e19d0d8b0dd335181a1ece4518; estado al documentar: en ejecución; configuración de Godot y firma temporal completadas, importación de recursos en curso. Las pruebas de Máximo, diez ligas, regresiones y exportación APK siguen pendientes de resultado de este nuevo run. No declarar aún APK ni CI global aprobados.


## Referencias adicionales y seguimiento CI — 19-11-2026


## Corrección del test de Máximo y controles de partido — 19-11-2026

Run #193 terminó con fallo en `tests/test_maximo_padilla_profile.gd`: el test llegaba a cargar el perfil, pero al añadir el `CharacterBody3D` a la escena dejaba activo `_physics_process`, que consultaba acciones InputMap ausentes en el entorno aislado de `--script`; además, el servicio de carrera se añadía al árbol global y podía escribir también en la base persistente global durante la prueba. El watchdog interno terminó la prueba antes de que concluyera.

Cambios guardados en la rama:
- `project.godot`, commit `419545d37c331c48ebf432bf60e0d5c3a083fdd6`: asigna controles de teclado WASD y teclas F/espacio/E/Q a pase, tiro, habilidad y presión; antes las ocho acciones estaban definidas sin eventos físicos.
- `tests/test_maximo_padilla_profile.gd`, commit `19b2028fa0c4ab2dd1c5e339e5380c84ae66ebb2`: desactiva la física de la instancia durante la comprobación estática del modelo 3D, ejecuta el servicio de carrera aislado del árbol global para evitar escrituras de prueba en el autoload de base de datos y corrige el texto del watchdog a 45 segundos.

Los archivos se releyeron desde GitHub y se verificaron sus SHA. Los nuevos workflows de esos commits están en cola/ejecución; todavía no se certifica el test ni la APK. Se mantiene PR #4 abierto y sin fusionar.
- Se inspeccionó [TechAoba/soccer-game](https://github.com/TechAoba/soccer-game): Godot/GDScript 2D y licencia MIT confirmada en LICENSE. Se conserva como referencia menor de organización de escenas y recursos; no se copiaron archivos.
- Se inspeccionó [modelence/open-soccer](https://github.com/modelence/open-soccer): motor 11v11 en Canvas/TypeScript, cámara broadcast y arquitectura por dominios; no se encontró LICENSE en la raíz consultada. Solo referencia conceptual, sin copiar código/assets y sin añadir Modelence ni dependencias web.
- Se volvió a comprobar [openfootmanager/openfootmanager](https://github.com/openfootmanager/openfootmanager): GPL-3.0 en LICENSE.md; solo referencia de simulación de gestión, sin incorporación de código.
- GitHub Actions run #193 (ID 44444407781), SHA 1efc90260a8d24e19d0d8b0dd335181a1ece4518: importación, validación de nombres originales y archivo histórico, pruebas del hub/pantallas, física del balón, fundación 11v11, amistoso en vivo y porterías/redes completadas con éxito. La prueba de Máximo Padilla estaba en ejecución en la última consulta; pruebas restantes y exportación APK siguen pendientes.
- No se declara todavía CI global aprobado, APK exportada ni prueba en dispositivo Android. PR #4 permanece sin fusionar hasta completar la aceptación.
- Restricción reiterada: desarrollo con GitHub y ChatGPT solamente; sin servicios externos de ejecución, APIs comerciales o SDK de terceros obligatorios.

## Corrección de acciones de entrada detectada en CI — 19-11-2026

- Los logs de GitHub Actions mostraron consultas a acciones inexistentes (`move_left`, `move_right`, `move_forward`, `move_back`, `pass_ball`, `shoot_ball`, `skill_action`, `pressure_action`) durante la instancia del jugador. La causa raíz era que `project.godot` no declaraba estas acciones base; el módulo de mando opcional solo las registraba cuando se instalaba.
- Corrección guardada en `project.godot`: se registraron las ocho acciones en InputMap con zonas muertas apropiadas y eventos vacíos para permitir que los controles táctiles Android las activen mediante `Input.action_press`; el módulo de mando sigue siendo opcional y añade sus bindings de gamepad.
- Se añadió `tests/test_input_actions.gd` para verificar que las ocho acciones existen, se pueden pulsar y liberar. Se agregó un paso dedicado al workflow Android antes de las pruebas principales.
- Commits: `a39be03baaea1f63c838bdafbaefc27d1d58cc33` (InputMap), `535b3d1349c8b3f40a734e8b9ef76c1697c6acd8` (test), `d7276c6d029501c633cda0db44170c4a6218ae12` (workflow).
- El run #193 fue iniciado con un SHA anterior a esta corrección y no puede validar este cambio. El push de código dispara una nueva ejecución; pendiente comprobar el nuevo test, la aceptación de Máximo, las regresiones y la exportación APK.


## Ajuste de la prueba de Máximo Padilla — 19-11-2026

- El run #193 falló en la aceptación de Máximo: el test inició y cargó el registro del catálogo, pero no avanzó hasta el marcador final PASS; el watchdog interno de 120 segundos terminó el proceso. Los logs también mostraron acciones InputMap inexistentes, que ya fueron corregidas en el proyecto base.
- Para evitar una espera indefinida en el test aislado, se sustituyeron las dos esperas directas de `process_frame` por temporizadores cortos del SceneTree y se redujo el watchdog a 45 segundos. La escena y sus comprobaciones visuales permanecen intactas.
- Commit de la prueba: `75bc105132ff84e783a2b6125d24b17e53fed826`. Pendiente confirmar en CI que la prueba completa llegue a `FUTBOL_NOVA_MAXIMO_PADILLA_PROFILE_TEST: PASS` y luego ejecute regresiones/exportación APK.


## Diagnóstico y corrección del test de Máximo — 19-11-2026

El run #208 (44445773924) llegó a la prueba de Máximo y falló por una aserción concreta: el test buscaba `inner_shirt_sleeve_1.0`, pero el nombre del nodo dependía de la conversión implícita de un float a texto. La prueba no terminaba tras la aserción y agotaba después su watchdog de 45 s. También se detectaron avisos de InputMap al activar el controlador durante una prueba que solo debía validar el modelo visual.

Correcciones guardadas en la rama de trabajo:
- `scripts/players/maximo_padilla.gd`: los nombres de las mangas ahora son estables y legibles (`inner_shirt_sleeve_left` / `inner_shirt_sleeve_right`), sin depender del formato de un float.
- `tests/test_maximo_padilla_profile.gd`: el arnés headless registra acciones de entrada ausentes solo para evitar ruido de física en el proceso aislado; la prueba dedicada `test_input_actions.gd` sigue siendo la que valida la configuración real del proyecto. Se detiene la física del jugador después de añadirlo al árbol y se usa `process_frame` para sincronizar la prueba. La aserción del dorsal se alinea con el 30 configurado.
- Commits: `5aaa96227894fb258fd2a31560cafcb89ac7c6c7` (aislamiento del test), `81b687d66b2fe618674c0c95c2de420b0ddb6ff8` (nombres de manga), `f15f95d42d0a9a4637607cce671a714740c1c884` (aserción estable).
- Nuevo run #212 (ID `44446263741`) para el SHA `f15f95d42d0a9a4637607cce671a714740c1c884`; pendiente de resultado. No se declara resuelto hasta que la prueba pase y el workflow termine.


## Candidatos adicionales descartados — 19-11-2026

- [Cohen-Mini/SoccerCareerSimulator](https://github.com/Cohen-Mini/SoccerCareerSimulator): Godot 4/GDScript y JSON, etapa temprana; README describe sistemas de carrera planeados, pero no se encontró LICENSE en la raíz. No se copia código ni datos.
- [abotbro/godot-football-engine](https://github.com/abotbro/godot-football-engine) y [abotbro/football-game-engine](https://github.com/abotbro/football-game-engine): README mínimo, sin documentación técnica sustantiva ni LICENSE verificable en la raíz. Descartados como base de integración.
- Resultado: no se añaden dependencias ni código externo. La arquitectura y ejecución siguen siendo Godot 4.4.1/GDScript/Android offline.
