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


## Auditoría de configuraciones y centralización de defaults — 20-11-2026

- Se revisaron las ramas de Fútbol Nova y Nova Workspace con sus árboles completos y las fuentes de configuración, documentación y pruebas.
- Se creó `docs/CONFIGURATION_CATALOG_AND_RECONCILIATION_2026-11-20.md` con la configuración definida, valores runtime, funciones pendientes, ramas con funcionalidades no integradas y conflictos detectados.
- Se centralizaron en `NovaPreMatchSetup` los IDs predeterminados C35/RDA, estadio, formación 4-3-3, mínimo de 22 jugadores, once de 11 y jugador controlado por equipo local.
- El selector ahora inicializa estadio, duración y modo de reloj desde el mismo diccionario de defaults; la máquina de reloj usa los defaults compartidos de `NovaMatchClockRules`.
- Se añadió `tests/test_match_configuration_defaults.gd` y el workflow lo ejecuta. Comprueba equipos, Anier/Raymond, estadio, 5 minutos, reloj continuo, prórroga/penaltis desactivados, 4-3-3, plantilla 22/11, tabla de duraciones y prórrogas.
- Se corrigió `docs/PRE_MATCH_TEAM_SELECTION.md`: el valor predeterminado actual es Nova C35–FC Río de Argenti y el catálogo contiene siete estadios; se retiró la descripción antigua de tres estadios y la pareja Albor Madrid–Litoral Barcelona como predeterminada.
- Se actualizó `docs/TECHNICAL_ARCHITECTURE.md` con Godot 4.4.1, Android ARM64-v8a, GL Compatibility, paquete y permisos offline verificados.
- Se detectó un conflicto de distribución: los documentos de juego base establecen amistosos offline y módulos opcionales, pero `data/league_content_manifest.json` marca diez ligas como incluidas en el paquete base. Se dejó registrado sin cambiar el manifiesto automáticamente porque altera una decisión de distribución.
- Se conservaron sin fusión las ramas con match-session/replay v3, estadísticas tácticas, carrera/progresión, logros y cosméticos; sus diferencias requieren integración controlada.
- Pendiente: CI completa de esta rama, corrección de cualquier error de parseo detectado, sincronización en Nova Workspace y validación del APK/partido en Android.


### Estado de CI de la auditoría de configuración — 20-11-2026

- Run 482: [44840459560](https://github.com/Cumba35/Futbol-Nova/actions/runs/44840459560), commit `3e75dd8d6a1959f74f2b7d3bce86492db45ba8e1`. Sigue en curso. Ya pasaron exportación APK ARM64, validación de nombres/datos, controles de entrada y táctiles, Game Hub, física del balón, fundamento 11v11, inicio atómico, amistoso integrado, importación de clubes/Raymond y disparos IA. La prueba de posicionamiento de porteros estaba en curso al consultar; las pruebas posteriores y subida final del APK aún estaban pendientes.
- Run 486: `44840509188`, commit `56a151471be058e687e8b99a2eea59e864f5ecb1`, cancelado al encolar una revisión posterior; no cuenta como aprobado.
- Run 487: [44840858252](https://github.com/Cumba35/Futbol-Nova/actions/runs/44840858252), commit `7f295e73c5338b55bc7a2328988feb3bbc7e2c7c`, pendiente en cola. Incluye la centralización final de los defaults, el nuevo test `test_match_configuration_defaults.gd` y el workflow actualizado.
- Ninguna de estas ejecuciones permite declarar validada la configuración nueva hasta que run 487 (o una ejecución posterior del mismo HEAD) termine correctamente. La APK no se declara validada hasta que se publique el artefacto y se instale en Android.
