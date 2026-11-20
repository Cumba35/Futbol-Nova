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




## Tiro de IA en el amistoso — 20 noviembre 2026

La revisión directa del controlador reveló que los futbolistas de IA podían conservar posesión y pasar/despejar, pero no tenían una decisión explícita de remate a portería. Se añadió al controlador una selección ligera de tiro cuando el balón está en el tercio ofensivo y dentro de una distancia razonable de la portería rival. La dirección se calcula según el lado de ataque y se invierte correctamente tras el descanso; la potencia usa el atributo de tiro/finalización disponible del jugador. No se añadió motor externo ni dependencia nativa.

Se creó `tests/test_friendly_ai_shooting.gd` para validar: oportunidades de ambos equipos, inversión tras cambio de lado, rechazo de tiros lejanos/altos/fuera del campo, dirección de remate y aplicación de impulso físico real cuando un delantero IA tiene posesión. El workflow ejecuta esta prueba como paso independiente después de la aceptación de amistoso en vivo.

Referencias adicionales consultadas:
- [krimshi/godot-soccer](https://github.com/krimshi/godot-soccer) — licencia MIT verificada; proyecto 2D, útil solo como comparación ligera de interacción jugador-balón.
- [awest813/League-Soccer](https://github.com/awest813/League-Soccer) — licencia Apache-2.0 verificada; motor completo con IA táctica y simulación, pero su motor/alcance no justifica sustituir la base Godot móvil.
- [Tobilion/footysim](https://github.com/Tobilion/footysim) — simulación 11v11 por agentes y pruebas headless; la API no declara licencia, por lo que solo se consideran ideas generales y no se copia código.

**Límite:** la nueva decisión de tiro está implementada y añadida a CI; todavía debe superar la ejecución Godot de la nueva prueba y validarse visualmente en un dispositivo Android. No equivale a tener un sistema completo de porteros/atajas ni estadísticas de tiros.
