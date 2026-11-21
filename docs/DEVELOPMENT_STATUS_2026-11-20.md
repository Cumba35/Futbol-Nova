# Fútbol Nova — estado de desarrollo y pruebas — 20 noviembre 2026

## Objetivo inmediato

Prioridad máxima: modo Amistosos local 11v11, offline y Android ARM64. No ampliar carrera, gestión ni multijugador online hasta que el amistoso sea estable y se pueda probar manualmente en un teléfono.

## Estado confirmado de GitHub Actions

### Ejecución 44675666114
- Commit: `acfb1d97c57cf04efc4cf9ddfa0d496c8fa5fe66`.
- URL: https://github.com/Cumba35/Futbol-Nova/actions/runs/44675666114
- Godot 4.4.1 exportó correctamente `FutbolNova-debug.apk`.
- El artefacto `futbol-nova-android-debug` fue publicado (29,665,557 bytes en la consulta del 20-11-2026).
- Pasaron las pruebas de acciones de entrada, limpieza táctil, hub, vuelo del balón, base 11v11 y amistoso runtime con goles/períodos.
- También pasaron la prueba de marcos de portería/red, catálogo/geometría de estadios, perfil de Máximo Padilla, acceso y política de recursos NOVA, smoke test Android y regresiones de alcance masculino y perfil de Anier Cumbá.
- La última consulta del job mostraba `Regression — test_player_statistics_consistency.gd` en ejecución. No hay conclusión final registrada todavía: no declarar toda la suite aprobada.

## Mejora de jugabilidad aplicada

La inspección de `scripts/gameplay/match_11v11_controller.gd` encontró una carencia real: la IA podía pasar/despejar con la posesión, pero no tenía una decisión de remate explícita. Se añadió:

- Detección de oportunidad de tiro dentro del tercio ofensivo y a distancia razonable.
- Dirección hacia la portería rival según el equipo y el cambio de lado tras el descanso.
- Elevación moderada del remate.
- Potencia ajustada por el atributo de tiro/finalización del jugador.
- Liberación de posesión y aplicación de impulso físico al balón.

Código sincronizado:
- Distribución: commit `9d18af88c48ecff344c0284ba663e6e8476b46c1`.
- Nova Workspace: commit `17d2b681fd0de19932b8aca3f8e0f6a88f55cb93`.

Nueva prueba:
- `tests/test_friendly_ai_shooting.gd`: ambos equipos, cambio de lado, descarte de tiros lejanos/altos/fuera del campo, orientación y lanzamiento físico de la IA.
- Distribución: commit `f4d7ab5ff431568f666e6f61ecb240848c18e9ad`.
- Nova Workspace: commit `5f927b6306e782c63d4b383e43e39395e6a75cb6`.

Workflow actualizado:
- Paso independiente `Core test — friendly AI shooting and goal direction`.
- Commit `beae6be90693ce2784ecd857b6a70326ca2cf6cf`.
- Nueva ejecución: https://github.com/Cumba35/Futbol-Nova/actions/runs/44676104232 (pendiente al registrar este documento).

## Investigación pública de GitHub

- [krimshi/godot-soccer](https://github.com/krimshi/godot-soccer) — MIT confirmada; referencia ligera 2D.
- [awest813/League-Soccer](https://github.com/awest813/League-Soccer) — Apache-2.0 confirmada; IA táctica y motor de partido más complejo, pero su arquitectura no se porta directamente a la base GDScript móvil.
- [Tobilion/footysim](https://github.com/Tobilion/footysim) — simulación espacial 11v11 y pruebas headless; licencia no declarada por la API consultada, no copiar código.
- [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball) — Godot 4.4.1 y GDExtension; licencia no declarada, no copiar.
- [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) — Godot 4 y física; licencia del juego no declarada, no copiar.
- [antxiko/OpenComputerFutbolSimulator](https://github.com/antxiko/OpenComputerFutbolSimulator) — arquitectura de datos y simulación determinista; no se importa su stack ni se copia código.

No se añadieron dependencias externas ni assets de terceros. Las referencias se utilizan para orientar diseño y pruebas; cualquier reutilización futura requiere verificar licencia y atribución.

## Próximas tareas, por orden

1. Confirmar que la prueba nueva de tiro IA pasa en Godot 4.4.1.
2. Añadir un escenario runtime en que la IA genere una ocasión, remate y pueda producir un gol real, no solo aplicar un impulso.
3. Mejorar porteros: lectura de trayectoria, blocaje, despeje, estirada y rebotes.
4. Completar presión/entradas, faltas y reinicios del juego.
5. Registrar estadísticas reales del amistoso: tiros, tiros a puerta, pases, posesión y atajadas.
6. Comprobar sesión larga, memoria, temperatura y fluidez en Android.
7. Instalar y jugar la APK en un dispositivo Android real. La exportación en CI no sustituye esta prueba.

## Sincronización obligatoria

El código y los documentos del proyecto se guardan en `Cumba35/Futbol-Nova` y se sincronizan en `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova/`. Después de cada escritura se releen los archivos y se comparan SHA de contenido. Los workflows de compilación permanecen en el repositorio independiente de distribución.

## Estado honesto

La APK debug ya se exportó y el artefacto está publicado. El amistoso ha superado las pruebas runtime existentes en CI. La decisión de tiro de IA, la corrección de su trayectoria y el posicionamiento lateral del portero están implementados; las dos nuevas pruebas dedicadas están añadidas a CI, pero aún esperan resultado. No hay validación manual en un teléfono real ni se declara terminado el modo amistoso.


## Cambios posteriores y CI — 20 noviembre 2026

- Controlador actualizado: decisión de remate de IA con destino elevado y posicionamiento del portero limitado al espacio entre postes.
- Pruebas nuevas/actualizadas: `test_friendly_ai_shooting.gd` y `test_friendly_goalkeeper_positioning.gd`.
- Workflow ampliado con una prueba independiente para el posicionamiento de porteros.
- Ejecución que contiene las nuevas pruebas: https://github.com/Cumba35/Futbol-Nova/actions/runs/44676590754 (pendiente en el momento de esta actualización).
- El código y las pruebas se guardan en `Cumba35/Futbol-Nova` y en `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova/`; los workflows siguen en el repositorio de distribución.
- No hay todavía validación manual en teléfono Android. El APK de CI es una compilación debug de prueba.



## Pruebas de integración reforzadas — 20 noviembre 2026

La prueba de remates comprueba ahora que el balón recibe impulso físico hacia la portería rival (componente Z con el signo correcto), no solo que aumenta su velocidad. La prueba del portero comprueba también que la ruta táctica real de `_choose_target()` utiliza el cálculo de posicionamiento validado.

La ejecución más reciente que contiene estas aserciones es https://github.com/Cumba35/Futbol-Nova/actions/runs/44676823822 (en cola al actualizar este documento). Los intentos anteriores quedaron cancelados por la concurrencia de GitHub Actions; no se cuentan como pruebas superadas.


## Anticipación predictiva del portero — 20 noviembre 2026

El portero ya no sigue únicamente la coordenada lateral actual del balón: cuando el balón viaja hacia su propia portería, el controlador proyecta su cruce con el plano de gol usando la velocidad física actual, con horizonte máximo de 1,25 segundos. Si el balón se aleja, no anticipa esa trayectoria. Se mantiene el límite lateral de ±3,1 m y el cambio de lado. La prueba dedicada comprueba local, visitante y selector táctico integrado.

Ejecución que contiene el código y las aserciones más recientes: https://github.com/Cumba35/Futbol-Nova/actions/runs/44676823822 (pendiente/encolada al registrar esta actualización). La atajada, blocaje y animación de estirada siguen pendientes; este cambio es posicionamiento predictivo, no una atajada completa.


## Actualización — bloqueo físico del guardameta (20-11-2026)

- Añadido `StaticBody3D` y cápsula de colisión al actor GK; se mantiene a los jugadores de campo sin cuerpos físicos extra para reducir coste móvil.
- La cápsula usa material con rebote para que un tiro pueda impactar y rebotar físicamente en el portero.
- Ampliada `test_friendly_goalkeeper_positioning.gd` con un escenario de física que comprueba el contacto real entre un disparo `RigidBody3D` y la cápsula del guardameta.
- El workflow ya no publica el APK antes de las regresiones: el artefacto Android se sube solo al final, si todas las pruebas anteriores terminan correctamente.
- Estado: código y prueba guardados en el repositorio de distribución y en Nova Workspace. La nueva ejecución CI debe confirmar compilación, colisión y regresiones. No declarar aprobado ni subir esta compilación como APK final a Dropbox hasta que la ejecución termine correctamente.
- Pendiente: estirada/animación, blocaje, rebote controlado, despeje tras atajada, y partido amistoso de extremo a extremo con goles reales y pitido final.


## Ajuste de sincronización del portero móvil — 20 noviembre 2026

- Corrección adicional: el collider del guardameta ahora es `AnimatableBody3D`, no `StaticBody3D`, porque el actor cambia de posición durante la simulación.
- La prueba comprueba que la colisión sigue al actor y que el balón rebota tras el impacto.
- Estado de validación: pendiente de la nueva ejecución CI tras esta corrección.


## Corrección de fixtures y pruebas de física — 20 noviembre 2026

La primera ejecución que probó la cápsula falló en la prueba de posicionamiento porque el fixture consultaba `global_position` fuera del árbol de escena. Se corrigió añadiendo el controlador y el balón al árbol antes de comprobar el objetivo táctico. La prueba de tiro también recibió todos los campos esperados por el actor IA (`home_position`, `target`, `speed` y `stamina`) para evitar errores de diccionario durante los pasos físicos. El controlador usa valores por defecto seguros para `home_position` y `speed` cuando recibe datos incompletos. La siguiente ejecución debe confirmar estos arreglos junto con el collider `AnimatableBody3D`.


## Corrección de plantillas y endurecimiento de inicio — 20-11-2026

- La nota anterior que describía Nova C35 como 2/11 y FC Río de Argenti como 0/11 quedó superada por la importación original de plantillas. Las fichas actuales `data/nova_c35_club.json` y `data/fc_rio_de_argenti_club.json` registran 22 IDs cada una; la aceptación integrada comprueba que ambas aparecen completas y que el botón de inicio está habilitado.
- Los clubes conservan el valor predeterminado C35 local vs FC Río de Argenti visitante. El partido tiene once titulares por equipo: 22 futbolistas activos, un jugador controlado y 21 actores IA.
- La selección del jugador controlado ahora se centraliza y prueba: Anier Cumbá (`NOVA-PLAYER-0035`) cuando C35 es local; Raymond Valdez (`NOVA-PLAYER-0037`) cuando FC Río de Argenti es local. Para otros clubes se mantiene el fallback del once inicial.
- Se corrigió una condición de estabilidad en `start_match()`: antes de esta actualización, el controlador detenía el partido activo y modificaba referencias internas antes de validar clubes, plantillas y jugador controlado. Ahora valida toda la solicitud primero y solo reemplaza el encuentro cuando la configuración es válida.
- Se añadió `tests/test_match_start_atomic_validation.gd` y se incorporó al workflow Android. La prueba cubre club local/visitante repetido, once incompleto, ID de jugador controlado inválido y reinicio válido sin duplicar actores.
- La nueva rama de trabajo es `work/friendly-match-stability-2026-11-20`, basada en `feature/friendly-runtime-research-2026-11-20`; la copia maestra se trabaja en `work/futbol-nova-friendly-match-stability-2026-11-20`. No se fusionó ninguna rama.
- La ejecución `44676705137` consultada en el repositorio de distribución terminó `cancelled`; no valida los últimos cambios. La nueva ejecución disparada por esta rama debe terminar en éxito antes de declarar aprobada la corrección.
- Las plantillas contienen perfiles ficticios marcados como tales y con estadísticas iniciales en cero; no deben presentarse como futbolistas reales ni como estadísticas históricas verificadas.
- Pendiente: CI completa, inspección del artefacto APK ARM64, instalación y partido manual en Android; después continuar con atajadas reales del portero, despejes/rebotes controlados, faltas/reinicios y métricas de rendimiento.


### Seguimiento de GitHub Actions — actualización de ejecución — 20-11-2026

- Run 475: [44838944703](https://github.com/Cumba35/Futbol-Nova/actions/runs/44838944703), commit `9330937a51b8e72eee2e93f3c1a9ebc47f0cf3fa`, sigue en curso. Superó importación, exportación APK, validaciones de catálogos, controles táctiles, modelo de vuelo y prueba base 11v11; al consultar, estaba ejecutando `test_friendly_match_runtime.gd`. Esta revisión contiene la corrección de validación atómica de `start_match()`, pero todavía no contiene la nueva prueba dedicada.
- Run 479: [44839033925](https://github.com/Cumba35/Futbol-Nova/actions/runs/44839033925), commit `9febe0ca7878d5d4571f791ed9f90023c863c3e5`, está pendiente detrás de la ejecución activa. Incluye la selección de Anier/Raymond centralizada, sus aserciones en la prueba base y `test_match_start_atomic_validation.gd` en el workflow.
- Runs 476–478 fueron cancelados al actualizar commits sucesivos; no se cuentan como pruebas aprobadas.
- Aunque el paso de exportación APK ya pasó en run 475, la subida del artefacto está al final del workflow y depende de que terminen correctamente todas las pruebas. No se confirmó un APK nuevo descargable para esta revisión.
- El siguiente resultado válido debe ser una ejecución completa de run 479 (o una posterior equivalente), seguida de inspección del artefacto, instalación y partido manual en Android.


## Corrección de regresión del perfil de Máximo — 21-11-2026

- La ejecución CI 44839033925 superó las pruebas principales del amistoso 11v11, el runtime con goles y períodos, selección del jugador controlado, IA de tiro y posicionamiento/colisión del portero; falló después en `test_maximo_padilla_profile.gd`.
- La causa funcional de la aserción era una expectativa obsoleta: la ficha canónica de Máximo ya registra su club actual como Nova C35 (`FN-NOVA-C35`), pero la prueba todavía exigía Litoral Barcelona (`FN-ESP-BARCELONA`). Se actualizó la expectativa para validar el club actual y su nombre.
- La prueba aislada ahora agrega el servicio de carrera al SceneTree, desactiva la sincronización con FootballDatabase y usa un archivo temporal propio; esto evita consultar rutas absolutas `/root` desde un Node fuera del árbol y evita tocar datos persistentes del usuario.
- Cambio guardado en el commit `20724842f9f097c6cd67c6a7ac974e19b6092083` de la rama `work/friendly-match-stability-2026-11-20`.
- Pendiente: releer y verificar el archivo en GitHub, confirmar la nueva ejecución CI completa, revisar pruebas que estaban omitidas tras el fallo y validar la APK en Android. No declarar el amistoso terminado hasta probarlo manualmente.


## Corrección de atribución del último toque — 21-11-2026

La revisión del controlador detectó un error de atribución que podía contaminar celebraciones y cualquier estadística futura: `notify_ball_kicked()` asignaba por defecto el ID del jugador humano aunque quien ejecutara la acción fuera un actor IA. Se corrigieron los tres caminos de acción de IA (despeje del portero, remate y pase/despeje de campo) para enviar el ID real del actor. La función ya no sustituye un último toque conocido cuando recibe una llamada sin ID.

- Código: `scripts/gameplay/match_11v11_controller.gd`.
- Prueba ampliada: `tests/test_friendly_ai_shooting.gd`, que mantiene un ID humano distinto y exige que el último toque corresponda al delantero IA.
- Commit de código: `a02fbce41f3863f74bc2020f0dd3f6ee2bd31f99`.
- Commit de prueba: `befa749c402451f9a8191112bb7c64cb6cb2cb31`.
- Ejecución CI que contiene ambos cambios: https://github.com/Cumba35/Futbol-Nova/actions/runs/44843892726 (pendiente al registrar esta nota).
- Sincronización de los dos archivos en `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova/`: commits `b5bca1cecabb7d77a47ca37aaef03ed1b48906ff` y `9e02524572696544cada0477348184bbb959cd9a`.

## Revisión de alternativas públicas — 21-11-2026

- `awest813/League-Soccer`: Apache-2.0; motor completo con 22 agentes, reglas, IA táctica, estadísticas y pruebas de integración. Se usa como referencia arquitectónica, no como dependencia: su motor C++/OpenGL/SDL no es un reemplazo de bajo riesgo para el controlador Godot/GDScript y el objetivo Android ARM64.
- `krimshi/godot-soccer`: MIT; ejemplo pequeño 2D en Godot. Útil como comparación de interacción jugador-balón, no como motor 3D 11v11.
- `Tobilion/footysim`: simulador 11v11 por agentes, determinista y con pruebas; no se pudo verificar una licencia declarada, por lo que no se copia ni integra código.

No se añaden dependencias ni assets de terceros. Se conserva la arquitectura ligera de Fútbol Nova y se adoptan únicamente criterios de diseño y validación.

## Pendientes inmediatos

1. Confirmar CI del arreglo de último toque y ejecutar el resto de regresiones.
2. Integrar atajada controlada del portero (captura/parada, rebote y despeje con transición de posesión), no solo colisión física.
3. Resolver faltas y salidas del campo con reinicios jugables; actualmente la señal de falta no completa por sí sola la colocación y reanudación.
4. Añadir estadísticas de partido derivadas de eventos reales y pruebas de goles atribuidos al jugador correcto.
5. Validar el ciclo completo y el rendimiento instalando la APK ARM64 en Android. La exportación CI no sustituye esta prueba.

No se declara finalizado el modo amistoso ni se fusiona/publica la rama.


## Reinicios de balón fuera del campo — 21-11-2026

Se conectó el clasificador de reglas del partido al ciclo de actualización del amistoso. El juego conserva la posición anterior del balón para resolver correctamente qué línea cruzó primero y usa el último toque y el sentido de ataque vigente para determinar el saque correspondiente.

- Saque de banda cuando el balón cruza una línea lateral.
- Córner cuando el último toque fue del equipo defensor antes de salir por su línea de meta.
- Saque de puerta cuando el último toque fue del equipo atacante antes de salir por la línea de meta.
- El balón vuelve a una posición válida dentro del campo, se limpian velocidad/posesión y el motor prioriza el equipo al que se concedió el reinicio hasta que recupere la posesión.
- La interfaz informa el tipo de reinicio y usa los nombres de los clubes seleccionados.
- La prueba integrada `tests/test_friendly_match_runtime.gd` cubre saque de banda, córner y saque de puerta, además del flujo existente de goles y períodos.

Archivos: `scripts/main.gd`, `scripts/gameplay/match_11v11_controller.gd` y `tests/test_friendly_match_runtime.gd`. Los cambios están guardados en esta rama y sincronizados en Nova Workspace. La nueva ejecución de CI debe validar la compilación y las pruebas; todavía no se declara aprobado.

## Estado de funcionalidad pendiente

Los reinicios ya se colocan en el campo y asignan el equipo correcto, pero aún no son una animación reglamentaria de saque de banda/córner/saque de puerta. También siguen pendientes las atajadas con blocaje y animación, la gestión completa de faltas y tiros libres, estadísticas de partido y la prueba manual del APK en Android.



## Integración de faltas y tiros libres — 20-11-2026

- La señal real `foul_committed` del motor 11v11 ahora está conectada a la escena principal.
- Al producirse una falta durante un amistoso activo, se identifica el futbolista infractor, se coloca el balón cerca del punto de contacto dentro del campo, se concede el reinicio al equipo contrario y se detiene brevemente el reloj para preparar el tiro libre.
- La prueba integrada `tests/test_friendly_match_runtime.gd` emite la señal de falta del jugador controlado y verifica equipo beneficiado, posición del balón e interrupción del reloj.
- Alcance: se completa el reinicio funcional básico; todavía no hay barrera reglamentaria, animación de colocación, árbitro visible ni selección de tiro directo/indirecto. Las pruebas de Godot 4.4.1 y las regresiones deben pasar antes de considerar validado este cambio.



## Registro de implementación — reinicio por falta — 20-11-2026

- Rama de distribución: `work/friendly-match-completion-2026-11-20`.
- Rama canónica de Nova Workspace: `work/futbol-nova-friendly-match-completion-2026-11-20`.
- Distribución: `scripts/main.gd` commit `10ea872e0217d0957521218ecc40f8d0dff79fff`; prueba `tests/test_friendly_match_runtime.gd` commit `d3287d13571d229838cc22e7dae0c04cf4bfdf50`.
- Nova Workspace: espejo de código commit `e989f559087d025c56b6cf140dbe27fd62e90598`; espejo de prueba commit `d823d7691890f6867938c7f2b7ad750103056ffa`.
- Los archivos de código y prueba se releyeron desde ambas ramas. Los SHA de contenido coinciden exactamente entre distribución y Workspace: main `a0df194a3a02d8fba38d1bbaf750c18b5acbeab8`; prueba `8899ef1667b5a29fc157152afc11f678aa3e9280`.
- Validación CI: pendiente/no confirmada. La consulta de estados del commit no devolvió checks; no se afirma que Godot haya ejecutado la prueba ni que el APK de esta rama esté validado.
- No se fusionó ninguna rama ni se publicó una versión final.



## Requisito confirmado: modalidad de control en amistosos — 21-11-2026

**Regla de producto obligatoria para los partidos amistosos:**

1. La modalidad predeterminada controla a los **11 jugadores del equipo del usuario**. El usuario puede cambiar cuál futbolista controla durante el partido; los otros diez siguen participando con la IA mientras no estén seleccionados.
2. En los **ajustes del partido**, antes de iniciar el amistoso, debe existir una opción explícita para elegir **«Controlar a los 11 jugadores»** o **«Controlar un solo jugador»**.
3. «Controlar a los 11 jugadores» debe venir seleccionado por defecto en cada nuevo amistoso, salvo que las reglas de configuración ya existentes definan una preferencia persistente del usuario; no cambiar silenciosamente el valor predeterminado.
4. «Controlar un solo jugador» limita el control directo al futbolista seleccionado para ese partido. Los otros diez compañeros y los once rivales continúan bajo la IA; el usuario no debe poder cambiar el control directo a otro compañero durante esa modalidad.
5. La elección pertenece a los ajustes del partido y debe respetarse durante todo el encuentro, incluidas pausas, goles, reinicios y cambios de período. No debe alterar las plantillas, posiciones, atributos ni la IA de los equipos.
6. En la prueba de referencia, mantener Nova C35 contra FC Río de Argenti y Anier como jugador seleccionable/controlable.

**Criterios de aceptación y pruebas pendientes:**

- Un amistoso nuevo arranca en «Controlar a los 11 jugadores» sin exigir que el usuario cambie ajustes.
- En esa modalidad, el control/selección de futbolista permite jugar con los once compañeros durante el mismo partido.
- Si se selecciona «Controlar un solo jugador», únicamente el futbolista elegido recibe control directo; los demás jugadores siguen moviéndose y jugando mediante IA.
- La modalidad elegida se conserva después de goles, pausas, reinicios y cambio de período.
- La opción aparece en los ajustes previos al partido y queda visible en el resumen/configuración del amistoso.
- Añadir pruebas automatizadas para el valor predeterminado, ambas modalidades, bloqueo del cambio de jugador en modo individual y persistencia durante los estados del partido.

**Estado:** requisito confirmado y registrado para la siguiente fase; todavía no se declara implementado ni probado. Debe implementarse respetando las reglas y controles ya existentes, sin reemplazar el modo 11 jugadores como predeterminado.


## Diagnóstico CI y corrección de perfil — 21-11-2026

- Run 44884181189 (workflow run 515, commit inicial `5c516b0096846c6ba9aef914622d921c548f4f1e`) superó la importación, exportación inicial ARM64, controles básicos, partido amistoso, goles/períodos, IA de remate, posicionamiento del portero, geometría del estadio, perfil de Máximo y políticas de acceso/recursos.
- Falló en `tests/test_anier_cumba_profile.gd`: la prueba esperaba el club Real Madrid, pero el registro canónico `data/custom_players.json` ya asigna a Anier a Nova C35 (`FN-NOVA-C35`). No es un fallo de atributos ni del motor de partido; es una aserción obsoleta.
- Se corrigieron las aserciones de club actual en `tests/test_anier_cumba_profile.gd` y la ficha `docs/ANIER_CUMBA_PLAYER_IMPLEMENTATION.md`. Se conserva Real Madrid como club favorito y Nova C35 como club actual dentro de Fútbol Nova.
- Commit de corrección de prueba: `e11dd4a196a7bcb6da01b2dfcce268ce5499280d`. Commit de documentación: `927521eafbbed1c788d11666b590b553f664ac88`.
- El nuevo CI debe confirmar la corrección y ejecutar las regresiones restantes. No se declara validado ni se publica APK hasta obtener resultado completo.
- La modalidad «Controlar a los 11 jugadores» por defecto y «Controlar un solo jugador» sigue siendo requisito registrado, no implementación terminada. La siguiente fase debe incluir selección/cambio de jugador en el primer modo, bloqueo de cambio en el segundo, IA para los demás y pruebas de persistencia en goles, pausas, reinicios y cambios de período.


## Enfoque prioritario: amistoso jugable — 21-11-2026

- El propietario confirma que la prioridad de desarrollo es exclusivamente completar el modo de amistosos para probar el juego; no ampliar modos secundarios.
- Partido de aceptación: Nova C35 vs FC Río de Argenti. Jugador de prueba: Anier Cumbá.
- Auditoría del controlador `scripts/gameplay/match_11v11_controller.gd`: `start_match()` crea un `CharacterBody3D` humano y 21 actores IA. No existe todavía cambio real entre los once jugadores del equipo. El modo de control de un jugador es el comportamiento actual; la opción configurable todavía no está integrada.
- El portero dispone de posicionamiento predictivo y cápsula física `AnimatableBody3D`; aún no hay sistema completo de reacción, blocaje, estirada, recuperación y conteo validado de atajadas.
- `NovaPlayerStatisticsService` registra carrera/temporada con alineaciones y goles, pero el amistoso requiere estadísticas efímeras de partido separadas para no alterar datos oficiales.
- Se añadió `docs/FRIENDLY_PLAYABLE_MVP_ROADMAP_2026-11-21.md` con fases P0-P5, criterios de aceptación, arquitectura exigida para cambiar de jugador, pruebas Android y auditoría de alternativas públicas.
- Investigación: League-Soccer y Fotbiler Football declaran Apache-2.0 en sus README; se estudian sus patrones de reglas/estadísticas y cambio manual/asistido, sin portar componentes C++ a Godot. Soccer Box y otros repositorios sin licencia verificable quedan como referencia conceptual únicamente. Godotball exige auditoría de la procedencia de GameplayFootball antes de reutilización.
- Run 44884835646 (commit `bcc2677dbcc3da63367c87b5bdb9919176d6ab5b`) continúa ejecutando; importación de clubes y pruebas previas de base, 11v11, arranque atómico y partido completo han pasado en la última consulta. El test del importador original/Raymond estaba en curso; no hay resultado global final ni APK validada.
- Próximo cambio de código: P1 control de los once con intercambio atómico de identidad, modelo, ID, estado y posesión. No implementar un teletransporte que conserve el modelo visual de Anier bajo el ID de otro jugador.
- No fusionar PR #10 ni publicar sin autorización expresa.


## Corrección de regresión del selector de avatar — 21-11-2026

- El run 44884835646 (workflow 518) terminó en fallo en el check 86 de `tests/test_anier_cumba_profile.gd`. El error no estaba en la escena de Anier: la prueba aún exigía el antiguo selector por nombre de club («Litoral Barcelona»), mientras `scripts/main.gd` ya resuelve el avatar por ID de futbolista (`NOVA-PLAYER-0035/0036/0037`).
- Se actualizó la prueba para verificar el contrato vigente: selección por ID, escenas dedicadas para Máximo y Raymond, y Anier como escena predeterminada. No se alteró la lógica de juego ni se cambió la identidad visual.
- Commit: `c117774c483da8d78b4f35d4369922b1d74eed9c`. Espejo actualizado en Nova Workspace; el blob del archivo de prueba coincide exactamente (`8b2255b246a35d6989ef0c7eda6d16da4e5f8d6e`).
- Nuevo workflow 521 / run `44886164732` está pendiente al registrar esta nota. Se esperará su resultado antes de declarar CI verde o APK validada.
- La implementación de control directo de los once aún no se ha modificado: primero debe resolverse el traspaso correcto de visual, estado y control entre actores, sin teletransportar ni mezclar identidades.


## Correcciones de regresión compartida — 21-11-2026

- El run 44886277408 (workflow 522) confirmó que la corrección del selector de avatar funcionó: `test_anier_cumba_profile.gd` pasó y también pasaron las pruebas del amistoso, IA, portero, geometría y smoke test Android. El workflow llegó a 47 pasos correctos y se detuvo en `test_shared_foundation.gd`.
- El nuevo fallo mostró dos problemas independientes: `football_data_service.gd` dependía de nombres globales de autoload al compilarse como script aislado, y la prueba de clubes predeterminados todavía esperaba Real Madrid/Barcelona en lugar de Nova C35/FC Río de Argenti.
- Se cambió la resolución de `FootballDatabase` y `ContentPackages` a referencias obtenidas desde el árbol de escenas, y se añadieron esos servicios como fixtures en la prueba aislada cuando no están presentes. También se actualizó la expectativa de clubes predeterminados para el amistoso de aceptación.
- Commits de código: `e59c362031af0738adbe89852ec19a9f5d663742` y `f2b3a26b40e224677c71d1b0ba6a70354f8ab651`. Los dos archivos se espejaron en Nova Workspace con igualdad de blob.
- Próxima validación: ejecutar el workflow completo con ambos cambios. No se declara todavía CI verde ni APK validada.


## Ajuste de tipado para autoloads dinámicos — 21-11-2026

- El run 44887407639 (workflow 523) detectó que Godot 4.4.1 no podía inferir el tipo de dos resultados al llamar métodos sobre referencias dinámicas de tipo `Node` en `football_data_service.gd`. El fallo impedía cargar el autoload y provocaba que el test del hub se quedara esperando.
- Se declararon explícitamente como `bool` los resultados de guardado del catálogo y commit del partido, conservando la resolución dinámica de `FootballDatabase` y `ContentPackages`.
- Commit: `a92beccb8d496f92f5262295e82276f8a0916c1c`; espejo de código actualizado en Nova Workspace con blob idéntico.
- El siguiente workflow debe validar el tipado, los fixtures de autoload y la selección predeterminada Nova C35 vs FC Río de Argenti. No se considera todavía validado el APK.


## Diagnóstico y corrección de CI — 21-11-2026 09:17 UTC

- Workflow 527 / run `44887708165` terminó en `failure`. Godot 4.4.1 importó el proyecto y exportó/firma el APK arm64 de depuración correctamente; las validaciones de nombres de clubes, archivo histórico, acciones de entrada y controles táctiles pasaron.
- La suite se detuvo en el test del hub (`tests/test_game_hub.gd`) antes de ejecutar las pruebas centrales del amistoso. El fallo era una expectativa textual desactualizada: el test exigía que el servicio usara el autoload global `FootballDatabase`, pero el servicio ya resuelve la base de datos mediante la referencia dinámica `_football_database` para soportar tests aislados.
- Se corrigió la expectativa del test para verificar la misma guarda de error y la lectura de temporada mediante `_football_database`, sin cambiar la lógica de juego ni la persistencia real. La corrección se guardó también en `Nova-Workspace/proyectos/juegos/futbol-nova/tests/test_game_hub.gd`.
- La exportación APK de ese run no se considera validada: el workflow falló antes de completar las pruebas y omitió la subida del artefacto validado.
- Próximo paso: comprobar el nuevo workflow generado por la corrección. Si el hub pasa, continuar con las pruebas 11v11, control/rotación de jugadores, IA, goles, porteros, tiempos y smoke test Android. No declarar CI verde ni APK validada hasta que termine toda la suite.
- Nota de ramas: la PR #10 sigue abierta y en draft, pero GitHub informa como head `feature/friendly-runtime-research-2026-11-20`; la rama de trabajo solicitada es `work/friendly-match-completion-2026-11-20`. Ambas ramas están divergidas (48 commits exclusivos en work, 3 exclusivos en feature según la comparación actual). No se fusionó ni se cambió la PR; hay que reconciliar esta relación antes de atribuir los commits nuevos a la PR #10.


## Control manual de los once en amistosos — 21-11-2026

- Se implementó un primer ciclo manual de control de los once futbolistas locales en `scripts/gameplay/match_11v11_controller.gd`. La secuencia sigue el orden original del once y evita seleccionar jugadores visitantes.
- El nodo CharacterBody3D que deja de estar controlado se conserva como actor IA, con su modelo, ID, posición y metadatos. El actor genérico seleccionado se promueve a CharacterBody3D transfiriendo sus hijos visuales y su transformación; el último toque del balón no se altera por el mero cambio.
- Se conectó el cambio a la tecla TAB y al nuevo botón táctil CAMBIO. `main.gd` actualiza la referencia al nodo controlado y conecta sus señales de habilidad/presión.
- Se añadió prueba de runtime para recorrer los once IDs y comprobar 11 jugadores por lado, 21 actores IA, identidad en el nodo, referencia del controlador y conservación del último toque.
- Archivos cambiados y espejados con SHA idéntico en Nova Workspace: `scripts/gameplay/match_11v11_controller.gd`, `scripts/main.gd`, `scripts/input/touch_controls.gd`, `tests/test_friendly_match_runtime.gd` y `docs/FRIENDLY_PLAYABLE_MVP_ROADMAP_2026-11-21.md`.
- La implementación todavía no está validada por CI. Los workflows 530–534 se cancelaron por pushes sucesivos; el workflow 535 quedó pendiente y la actualización de documentación generará otro run. Se debe esperar un workflow que incluya el último commit y revisar todos los pasos antes de marcarlo como terminado.
- Próxima revisión técnica: comprobar compilación Godot 4.4.1, ciclo de cambio con posesión/no posesión, promoción y retorno a los modelos originales, controles táctiles, pausa/reanudación y exportación/smoke test Android. No fusionar PR #10 ni publicar APK.
- La PR #10 permanece abierta en draft, pero su head actual es `feature/friendly-runtime-research-2026-11-20`, no la rama de trabajo `work/friendly-match-completion-2026-11-20`. La comparación indica ramas divergidas (48 commits exclusivos en work y 3 en feature); no se ha alterado la PR. Resolver esta discrepancia de integración antes de presentar estos commits como parte de PR #10.


## Fútbol Nova — control de equipo / jugador individual (2026-11-21 09:41 UTC)

- Se implementó la selección persistente entre control de equipo (estilo FIFA) y control de un jugador desde la preparación del amistoso y Configuración > Juego.
- En control individual se puede elegir el futbolista inicial del once local. En pausa se puede seleccionar otro jugador o volver al control de equipo.
- El controlador expone los once IDs y selección directa; el cambio puede hacerse con el partido pausado.
- Se añadió avatar genérico para jugadores locales sin escena 3D individual, evitando sustituir su identidad visual por el avatar de Anier.
- Se corrigió la prueba de ciclo para recorrer once cambios y regresar al jugador inicial; la prueba de falta usa el jugador actualmente controlado.
- No declarar validado hasta que el workflow Godot 4.4.1 termine en verde. El último workflow observado antes de estos commits falló en el test de amistoso por expectativas incorrectas del ciclo y por emitir una falta para un jugador que ya no era el controlado.

- Diferencia funcional de modalidades: `team` permite alternar al vuelo con CAMBIO/TAB; `single` mantiene al futbolista elegido y bloquea el ciclo automático. Si el usuario quiere cambiarlo, abre pausa > Configuración > Juego y selecciona otro; desde ahí también puede volver a Control de equipo.
- El último futbolista activo se guarda como preferencia local cuando se cambia mediante CAMBIO/TAB o el selector de pausa.


## Validación del amistoso y APK Android — 21-11-2026 19:53 UTC

- La ejecución GitHub Actions #591 (44942050664) terminó con conclusión success en el commit 46c9f1a67250aad6bfaa6744f3d704cbee98789c.
- Los 61 pasos del job finalizaron correctamente. Incluye importación de recursos Godot 4.4.1, exportación Android ARM64, pruebas de entrada táctil, base 11v11, partido amistoso en vivo con goles y períodos, IA de tiro y dirección, posicionamiento del portero, escena Android, regresiones completas y validación de módulos opcionales.
- Se generó y subió el artefacto futbol-nova-android-debug, ID 14722277336, tamaño 29,752,378 bytes, SHA-256 7b0b7964226f985ad914935e4aac5886149fe3aaa9f5aab946cd455687d13887, con vencimiento el 05-12-2026 19:52 UTC. Es una APK de depuración Android ARM64.
- También se publicó el artefacto de código fuente Godot futbol-nova-godot-source, ID 14721828251.
- Esto confirma compilación y pruebas automatizadas en CI; no equivale a una instalación ni prueba física en el teléfono del usuario. La validación real de controles, rendimiento y experiencia de juego en Android queda pendiente de que el usuario instale y juegue la APK.
- No se fusionó ninguna PR ni se publicó una versión de producción. La APK es un artefacto de prueba de CI.
- Ejecución y descarga: https://github.com/Cumba35/Futbol-Nova/actions/runs/44942050664
