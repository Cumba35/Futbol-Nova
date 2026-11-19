# Registro de continuidad — Fútbol Nova

Fecha: 2026-11-19 (UTC)
Repositorio: Cumba35/Futbol-Nova
Rama de trabajo: work/native-3d-engine
Pull request: #5 — https://github.com/Cumba35/Futbol-Nova/pull/5

## Continuidad entre conversaciones
El usuario indicó que continuará el trabajo de Fútbol Nova en otro chat y pidió conservar los datos del proyecto en GitHub, en sus ubicaciones correspondientes. Este registro enlaza esa continuidad con la documentación técnica y de alcance ya mantenida en el repositorio; no sustituye los documentos de implementación.

## Decisiones vigentes
- Prioridad principal y exclusiva del ciclo actual: modo Amistosos, hasta completar y probar un partido de principio a fin en Android.
- Motor nativo propio: Java 17, C++17 y OpenGL ES 3.0. No usar Godot, Unity ni motores externos en el runtime o APK.
- Android ARM64 y funcionamiento offline son requisitos de la prueba.
- No declarar el modo terminado solo porque compile o muestre una escena 3D; debe superar los criterios de aceptación documentados.
- Mantener el trabajo en la rama work/native-3d-engine y la PR #5 mientras esté en desarrollo.
- Cada APK que se genere para este proyecto debe guardarse también en Dropbox, además de conservar el artefacto de CI cuando corresponda. No afirmar que se guardó o compartió hasta verificarlo.

## Estado conocido al iniciar esta continuidad
La aplicación nativa cuenta con shell/menús Android, carga offline de datos canónicos, selector de plantillas verificadas, preparación de amistoso y un prototipo 3D OpenGL ES. Hay lógica inicial de balón, posesión, controles táctiles, marcador/reloj y reinicio tras gol. Los futbolistas siguen siendo modelos procedurales de blockout; no son todavía modelos humanos de alta fidelidad ni cuentan con animaciones esqueléticas completas. La IA, porteros, colisiones y reglas aún requieren trabajo antes de una prueba completa.

## Próximo foco de implementación
Seguir el orden P0/P1/P2 de `docs/FRIENDLY_MODE_PRIORITY_AND_ACCEPTANCE.md`, priorizando:
1. Resolver jugadores personalizados para sus clubes y selecciones, y mostrarlos en plantillas y amistosos.
2. Enviar identidad y perfil visual de esos jugadores al motor 3D, manteniendo rasgos personales y adaptando la equipación al equipo.
3. Porteros, colisiones y comportamiento físico del balón.
4. IA básica de compañeros y rivales.
5. Pase, tiro, regate, robo y cambio de jugador.
6. Goles, reinicios y reglas básicas del juego.
7. Pausa, reanudación, salida y reinicio fiables.
8. Dos tiempos, descanso, resultado final y revancha.

## Requisito añadido en esta continuidad
El usuario confirmó las selecciones nacionales: Anier Cumbá y Máximo Padilla juegan con Cuba; Raymond juega con Brasil. En `data/custom_players.json` ya se actualizaron los perfiles existentes de Anier (`NOVA-PLAYER-0035`) y Máximo (`NOVA-PLAYER-0036`) con Cuba (`CUB`, `FIFA-MA-052`); Anier tenía un valor anterior contradictorio (`BRA`) que fue corregido. Se añadió a la pantalla Inicio una etiqueta de selección nacional para los perfiles personalizados. Raymond no aparece en el catálogo `data/custom_players.json` de esta rama y no se encontró un perfil con ese nombre en la búsqueda realizada; su asignación a Brasil (`BRA`, `FIFA-MA-028`) queda documentada, pero pendiente de enlazar a su ID estable, sin inventar un perfil.

Importante: el manifiesto de selecciones indica que hay 0 paquetes de selecciones publicados y que las plantillas nacionales aún no están construidas. Por eso, estos cambios guardan las asignaciones del canon y las muestran en la ficha de Inicio, pero todavía NO hacen que Cuba o Brasil aparezcan como equipos jugables ni que los jugadores estén dentro de una plantilla nacional 22v22 en Amistosos. La integración completa sigue pendiente; no declarar la función lista hasta probarla desde selector hasta partido 3D.

## Referencias del proyecto
- Prioridad y criterios de aceptación: `docs/FRIENDLY_MODE_PRIORITY_AND_ACCEPTANCE.md`
- Jugadores personalizados en clubes y selecciones: `docs/CUSTOM_PLAYERS_TEAM_AND_NATIONAL_SELECTION.md`
- Estado técnico del runtime: `docs/NATIVE_RUNTIME_INTEGRATION_STATUS_2026-11-19.md`
- Política de motor exclusivamente nativo: `docs/NATIVE_ONLY_ENGINE_POLICY.md`
- Pull request de desarrollo: https://github.com/Cumba35/Futbol-Nova/pull/5

## Nota de precisión
Este registro resume las decisiones y el estado conocido al 2026-11-19. No representa una nueva compilación, una prueba física en el teléfono ni una declaración de que las funciones pendientes ya estén implementadas.


## Avance de continuidad — porteros y colisiones (2026-11-19)

Se inició el primer bloque P0 del amistoso 3D. En `native-android/app/src/main/cpp/native_engine.cpp` se incorporó una primera implementación de porteros en los puestos 0 y 11, con seguimiento/anticipación del balón, estirada lateral y bloqueo. También se añadieron colisiones continuas balón-jugador, colisiones con postes/travesaño y comprobación del cruce de la línea de gol. Código guardado en commit `fe26b055510452c46a15491a051041c06e509bbf` de `work/native-3d-engine`.

Estado honesto: cambio guardado y releído en GitHub; todavía no hay evidencia de compilación CI posterior ni de prueba física en Android. No considerar porteros/colisiones terminados hasta revisar CI y probar tiros, paradas, rebotes y goles en el dispositivo. Detalle técnico en `docs/NATIVE_RUNTIME_INTEGRATION_STATUS_2026-11-19.md`.


## Continuidad — corrección CI y despejes de portero (2026-11-19)

El primer CI de porteros falló por cierre ausente del namespace C++ antes de JNI. Se corrigió en `d6fabd32aabeed4278bd94ac936750cf833a5f6d`. Luego se añadió despeje dirigido del portero (hacia el campo, con componente lateral y elevación) y se eliminaron parámetros no usados de la colisión del marco en `8463db93b7a74b5443408b48c750eb6a8c059c29`. El archivo `native_engine.cpp` fue releído y verificado en GitHub. CI `44640197543` corresponde al commit de corrección de namespace; falta comprobar CI para el HEAD más reciente con despejes y probar en Android. No declarar la función terminada todavía.


## Continuidad — CI ARM64 y referencias públicas (2026-11-19)

- CI `44640197543`, `44640242076` y `44640261718` terminó correctamente. La última compiló el cambio de colisiones de los 22 jugadores y verificó el APK y la biblioteca nativa ARM64.
- Artefacto disponible en la ejecución `44640261718`: `futbol-nova-native-android-arm64`, ID `14586755428`, 3,428,804 bytes, SHA-256 `34a30da7329e983cffb22c935594405c3b0c30f74e4168238965d0a04b4dbcec`. No se ha probado en el teléfono.
- Referencias revisadas: `TheAmgadX/Soccer-AI` (C++17, FSM de jugadores/portero/tácticas, 2D/SDL2), `Ademola-Game-dev/League-Soccer` (motor 3D, 22 jugadores, OpenGL, Apache-2.0) y `FlavioMili/Player12` (simulación compartida de partido, C++23/SDL3). Se registraron como referencias; no se incorporó código externo todavía por diferencias de plataforma, dependencias y arquitectura.
- Próximo trabajo: proteger el área de los porteros tras la separación de colisiones y mejorar la IA de los jugadores de campo. No cerrar P0 sin pruebas de partido en Android.
- Documento técnico ampliado en `docs/NATIVE_RUNTIME_INTEGRATION_STATUS_2026-11-19.md`.


## Ajuste de porteros tras colisiones — 2026-11-19

Se corrigió el efecto secundario de la separación de jugadores que podía desplazar a los porteros fuera del área que protegen. Después de resolver contactos, las coordenadas X/Z de los porteros 0 y 11 se limitan a sus respectivos corredores. Commit `14a8797f8321d2d79c6c8d4b701c69498ce45b45`; archivo releído y verificado. La CI exitosa anterior es del commit `39c4ddcb1c7858ef46689881a09abfe6dfd3e469`, así que este ajuste todavía necesita su propia compilación.

## Reglas permanentes de entrega y validación — 2026-11-19

- No generar ni volver a compilar una APK para entrega salvo orden explícita del usuario. Las compilaciones CI de verificación de código no autorizan por sí solas a crear una nueva APK de entrega.
- Cuando el usuario ordene generar una APK, guardarla también en Dropbox dentro de `/Aplicaciones/Fútbol Nova/`, junto a la versión del proyecto y sin sobrescribir una APK existente sin confirmar la versión/destino. Verificar el archivo y su ubicación en Dropbox después de subirlo.
- Prioridad de pruebas: modo Amistosos local 11v11. Validar el flujo de pantallas desde Inicio → preparación del partido → selección de clubes/equipaciones/alineación → partido → pausa → reanudación/descanso → final; verificar que cada control visible haga la acción indicada, que Atrás/continuar no pierdan estado y que no se abran modos no instalados.
- Validar la presentación de las pantallas contra las referencias archivadas y las especificaciones vigentes: `assets/references/`, `docs/MAIN_MENU_FOUR_SCREENS.md`, `docs/VISUAL_DESIGN_SYSTEM.md` y `docs/UI_SCREEN_IMPLEMENTATION_REGISTER.md`. La referencia FIFA 23 guía jerarquía y flujo, no autoriza copiar marcas o recursos.
- Las pruebas automatizadas/estáticas no sustituyen la prueba manual en un teléfono Android. Registrar por separado compilación, pruebas automatizadas, revisión visual y prueba real de partido.
