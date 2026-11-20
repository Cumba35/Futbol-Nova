# Auditoría de referencias públicas — modo amistoso 11v11

Fecha de revisión: 2026-11-19

## Objetivo

Mejorar el modo amistoso de Fútbol Nova sin sustituir su arquitectura ni importar dependencias innecesarias. El objetivo inmediato sigue siendo un partido local, sin conexión, controlable en Android y exportable como APK arm64.

## Referencias revisadas

### Godotball
- Repositorio: https://github.com/aliyavuzz/Godotball
- Motor: Godot 4 / GDScript con extensión nativa.
- Áreas útiles para estudiar: física del balón, IA de jugadores, árbitro y pruebas del motor.
- Estado de licencia: la API de GitHub no declara licencia para el repositorio y no se encontró un archivo LICENSE en la raíz. No copiar ni incorporar código de este proyecto hasta que exista una licencia verificable y compatible.

### Soccer Box Game
- Repositorio: https://github.com/namelesssyf/soccer-box-game
- Motor: Godot 4 / GDScript.
- Áreas útiles para estudiar: estructura de estados de partido, entrada táctil/dispositivos, telemetría y pruebas automatizadas.
- Estado de licencia: la API de GitHub no declara licencia para el repositorio. El archivo LICENSE encontrado pertenece al complemento `addons/godot_ai`, no concede por sí solo derechos sobre el resto del juego. No copiar código del juego. Revisar por separado la licencia de cada dependencia antes de considerar su uso.

### GodotBasic3DFootball
- Repositorio: https://github.com/richardschembri/GodotBasic3DFootball
- Área útil: ejemplo pequeño de escena 3D, movimiento y colisiones.
- Estado: referencia educativa; revisar los avisos de terceros y la licencia antes de reutilizar archivos o recursos.


### MIT-licensed Godot soccer reference
- Repository: https://github.com/krimshi/godot-soccer
- License: MIT (verified in the repository's root LICENSE file).
- Relevance: a small 2D GDScript soccer project; useful as a lightweight reference for input handling, player/ball interaction and mobile-friendly gameplay patterns, but not a drop-in 3D 11v11 engine.
- Decision: study patterns only for now. Any copied source or asset would retain the MIT copyright and license notice; no external code or assets have been imported into Fútbol Nova.

### League-Soccer / GameplayFootball fork
- Repository: https://github.com/erengaygusuz/fotbiler-football
- License: Apache License 2.0 (verified in the root LICENSE file).
- Relevance: C++ match engine with 22-player simulation, tactical AI, ball physics and match integration tests. Its engine and build stack differ from this Godot/GDScript mobile project, so direct integration would add unnecessary build and Android compatibility risk.
- Decision: use its documented systems as architectural comparison only; no native engine dependency is being added to the Android build.

## Decisión técnica

Por ahora estas referencias se usan para comparar enfoques, no como dependencias ni como fuente de código copiado. Fútbol Nova conserva su propio controlador 11v11, sistema de posesión, atributos de jugadores, plantillas personalizadas y controles táctiles.

## Lista de validación del amistoso

- [ ] Selección de dos clubes distintos desde la pantalla previa.
- [ ] Once inicial válido por equipo y sustitución de huecos cuando corresponda.
- [ ] Jugadores personalizados incluidos en la alineación y con atributos aplicados.
- [ ] 22 futbolistas activos (incluido el futbolista controlado) y 21 actores de IA.
- [ ] Movimiento táctil y liberación de todos los controles al ocultar la capa táctil.
- [ ] Posesión, pase, tiro, trayectoria del balón, colisiones y gol.
- [ ] Respuesta de IA local y visitante a balón y compañeros.
- [ ] Reloj, pausas, períodos, cambio de lado y final del partido.
- [ ] Prueba de escena Android y exportación de APK arm64.
- [ ] Instalación y prueba manual en un teléfono Android.

## Prueba adicional de controles táctiles

El 2026-11-19 se amplió `tests/test_touch_controls.gd` para comprobar que dos dedos que mantienen el mismo botón no se cancelan mutuamente, que el joystick virtual genera movimiento y que el movimiento se libera al soltar el dedo. Cambio guardado en el commit `8841a9d900218d7b38bf73edcd77f446c8231df0`. Su ejecución automatizada está pendiente en el workflow 331, en cola detrás del workflow 330.

## Incidencia de CI corregida

El 2026-11-19, el workflow `Fútbol Nova - pruebas y APK Android` (run 44541374751) completó correctamente las pruebas específicas del amistoso, incluida la aceptación 11v11 hasta el pitido final. Se detuvo después en `tests/test_shared_foundation.gd`, que referenciaba directamente el autoload `FootballDatabase` desde una prueba ejecutada con `--script`. La prueba se corrigió para resolver el autoload desde `root` en tiempo de ejecución. La corrección debe considerarse pendiente de validación hasta que una nueva ejecución de CI termine correctamente.

## Siguiente prioridad

Corregir cualquier nuevo bloqueo real de CI y conseguir el APK Android. Después, realizar una prueba manual centrada en el control táctil, la posesión, los pases, los tiros, los goles y la IA durante un amistoso completo.

### Controles multitáctiles Godot 4.4 — referencia MIT adicional (2026-11-19)

- Repositorio: https://github.com/JoenTNT/godot_thumbstick_addon
- Licencia: MIT verificada leyendo el archivo raíz `LICENSE`; conservar aviso y texto de licencia si se reutiliza cualquier fragmento.
- Compatibilidad declarada: `project.godot` indica Godot 4.4 y GL Compatibility. El README registra controlador virtual y controlador multitáctil, y el historial del proyecto indica soporte probado en Godot 4.4.
- Relevancia: referencia útil para comparar el manejo de varios dedos y joystick en la versión exacta de Godot usada por Fútbol Nova.
- Decisión: no importar el addon por ahora. El controlador nativo ya está integrado con las acciones InputMap del juego y la aceptación actual verifica dos dedos en un mismo botón, joystick y liberación de acciones. Evitamos duplicar controladores hasta que una prueba en teléfono revele una carencia concreta.

### Referencia Android de fútbol multijugador — MIT (2026-11-19)

- Repositorio: https://github.com/luiz734/multiplayer-soccer
- Licencia: MIT verificada en el archivo raíz `LICENSE`.
- `project.godot` declara Godot 4.2 y el README indica pruebas en Android; el proyecto es multijugador y no dispone de modo de un jugador.
- Relevancia: puede servir para estudiar empaquetado Android, resolución/orientación y estructura de escenas Godot. No aporta el motor de simulación IA local 11v11 que necesita Fútbol Nova.
- Decisión: referencia de exportación solamente; no integrar red ni reemplazar el modo amistoso local.

### Resultados CI tras la corrección de exportación (2026-11-19)

- El workflow 333 (`44548526728`, commit `213a70a8`) importó recursos y superó las pruebas de base 11v11 y amistoso en vivo con goles y períodos. También superó las pruebas anteriores de acciones de entrada y limpieza de controles táctiles.
- Al registrar esta actualización, ejecutaba `Core test — NOVA resource policy`; la exportación arm64 y la subida del APK seguían pendientes.
- El workflow 332 había llegado a la exportación y falló por `gradle_build/use_gradle_build=false` con `min_sdk`/`target_sdk` personalizados. La corrección se guardó en ambos repositorios activando Gradle.
- No hay todavía artefacto `futbol-nova-android-debug` confirmado en el run 333. El artefacto de fuente Godot sí fue publicado; no confundirlo con el APK.


### Corrección de plantilla Android para Godot 4.4.1 — 19-11-2026

- La ejecución 333 (`44548526728`) superó el test de controles táctiles, la base 11v11, el amistoso en vivo con goles/períodos y el smoke test de escena Android.
- La exportación falló con el mensaje `Android build template not installed in the project` después de activar Gradle. El paso anterior que habilitaba Gradle no instalaba `android/build`.
- Se comprobó la documentación oficial de Godot 4.4: el flujo Gradle requiere instalar una plantilla Android dentro del proyecto; los export templates incluyen `android_debug.apk`, `android_release.apk` y `android_source.zip`. La opción CLI `--install-android-build-template` aparece en documentación posterior, no en la referencia 4.4, por lo que no se usa en Godot 4.4.1.
- Para el objetivo actual (APK debug sideload ARM64, sin SDK Android personalizado ni plugins Gradle), se eligió la exportación estándar precompilada: `gradle_build/use_gradle_build=false` y se eliminaron los overrides `min_sdk`/`target_sdk`. Se mantiene exclusivamente `architectures/arm64-v8a=true`.
- Cambio guardado en `Cumba35/Futbol-Nova` (commit `b0972e9187e2aa1f4b782a1d8119a065a4af081d`) y sincronizado en `Cumba35/Nova-Workspace` (commit `df77c1bf8ab2565ed321c68d803aeb426157f1a7`).
- Nueva ejecución 334: https://github.com/Cumba35/Futbol-Nova/actions/runs/44549563484. Al registrar esta nota está en curso; debe validar de nuevo el amistoso y confirmar exportación/subida del APK.
- Referencias oficiales: [Godot 4.4 Android export](https://docs.godotengine.org/en/4.4/tutorials/export/exporting_for_android.html), [Godot 4.4 Android template contents](https://docs.godotengine.org/en/4.4/contributing/development/compiling/compiling_for_android.html) y [Godot 4.4 Android export options](https://docs.godotengine.org/en/4.4/classes/class_editorexportplatformandroid.html).
- Estado: no hay APK confirmado todavía. El proyecto sigue sin validación en un dispositivo Android real.



## Requisitos adicionales del propietario — entrega y pantallas

- No generar APK hasta recibir una orden explícita. Las compilaciones automáticas se usarán solo para validar cambios de código cuando estén configuradas para ello; no se entregará ni guardará una APK nueva por iniciativa propia.
- Al recibir la orden de generar APK, guardarla en Dropbox en `/Aplicaciones/Fútbol Nova/` y verificar desde Dropbox que el archivo quedó en la ruta, con tamaño y fecha correctos. No sobrescribir una versión previa sin autorización clara.
- La prioridad funcional y de calidad es el modo Amistosos local 11v11. Revisar todo el recorrido de pantallas y controles que conducen al partido y permiten pausarlo, reanudarlo y finalizarlo; comprobar el comportamiento real de los botones y la conservación del estado.
- Comparar pantallas con las imágenes de referencia archivadas en `assets/references/` y las especificaciones de menú/diseño/UI. Adaptar composición y jerarquía a Android, conservando identidad propia y sin copiar recursos protegidos.
- Estado de referencia visual: cuatro imágenes confirmadas en el repositorio (pausa, selector de equipación, inicio de Modo Leyenda y configuración). Para Amistosos, revisar además las referencias de HUD, partido, preparación y controles descritas en `docs/GAME_DESIGN.md` y el catálogo de datos/pantallas. Si la imagen original concreta no está archivada o no se puede recuperar, dejarlo como pendiente, no inventar que se comparó.

### Referencias adicionales de IA 11v11 (2026-11-19)

- `TheAmgadX/Soccer-AI` — https://github.com/TheAmgadX/Soccer-AI. C++17 con máquinas de estado separadas para futbolistas, portero y táctica; usa SDL2 y es 2D. La raíz pública consultada no muestra un archivo LICENSE, así que no se copia ni incorpora código. Puede orientar la separación de estados y responsabilidades de IA.
- `firstpixel/SoccerGame` — https://github.com/firstpixel/SoccerGame. Simulación 11v11 en navegador con IA de pase/regate/tiro, roles, atributos, formaciones y física simple del balón. Su stack HTML/Canvas no es integrable en el runtime C++17/OpenGL ES; la raíz consultada tampoco mostró LICENSE, así que solo queda como lectura conceptual.
- Decisión: conservar el motor Android nativo y utilizar estas referencias únicamente para contrastar algoritmos. No se importaron dependencias ni recursos de terceros.


## Investigación adicional: motor nativo Android y simulación reproducible — 2026-11-20

### [blurz17/blurz-native-football-](https://github.com/blurz17/blurz-native-football-)
- Repositorio público de fútbol 3D Android ARM64 con C++, JNI, OpenGL ES y SDL2; documenta cámara de tercera persona, controles multitáctiles, sincronización de render/física y pruebas de estabilidad.
- **Licencia verificada en el archivo raíz `LICENSE`: GPL-3.0.** El repositorio también declara componentes y recursos de terceros en `THIRD_PARTY_NOTICES.md`; la licencia del proyecto no sustituye la revisión de cada dependencia o asset.
- Relevancia: es una referencia muy cercana al objetivo Android nativo para estudiar gestión de punteros, separación de hilos, cámara, rendimiento móvil y organización de la capa JNI.
- Decisión: no copiar ni incorporar código, bibliotecas, modelos, uniformes ni assets. La GPL-3.0 introduce obligaciones de distribución que no deben asumirse accidentalmente; se estudian únicamente patrones generales. Fútbol Nova mantiene su implementación C++17/OpenGL ES 3.0 sin añadir SDL2.

### [santisiri/fobal-simulator](https://github.com/santisiri/fobal-simulator)
- Simulación de fútbol con IA de pase/tiro/regate, física 3D del balón, rebotes en postes/travesaño, reglas, reinicios, cambios de lado, estadísticas, determinismo por semilla y pruebas headless.
- La licencia de reutilización no quedó verificada en esta revisión; por tanto, no se copia código ni recursos.
- Relevancia: usar como lista de comparación para escenarios de aceptación: tiros y atajadas, rebotes, saques, faltas, cambios de lado, determinismo y registro de eventos. No trasladar su runtime HTML/JavaScript al APK nativo.

### Decisión técnica
La mejora inmediata identificada al revisar el código propio fue corregir el límite longitudinal de los porteros tras el descanso; quedó guardada en el commit `af78036a4354b844b201f2f7156dcc5f91deb408` de `work/native-3d-engine`. Su compilación y prueba física siguen pendientes. Las referencias externas no se integran como dependencias.
