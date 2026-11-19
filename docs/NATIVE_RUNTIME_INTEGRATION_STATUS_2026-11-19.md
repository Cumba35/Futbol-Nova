# Fútbol Nova — integración del runtime nativo con los datos existentes

Fecha: 2026-11-19. Rama: `work/native-3d-engine`.

## Integración incorporada

- `data/native_runtime_manifest.json` define el contrato de fuentes canónicas, navegación, motor, reglas de habilitación de plantillas y políticas visuales.
- `native-android/app/build.gradle` empaqueta el directorio `data/` como assets offline de la aplicación.
- `CanonicalDataRepository.java` carga el manifiesto, perfiles personalizados, catálogo de módulos, ligas, clubes, archivos de plantillas cubanas, catálogo de habilidades, técnicas y balones.
- Las plantillas solo se habilitan si tienen exactamente 22 jugadores con IDs no vacíos y únicos.
- Los perfiles personalizados se indexan por ID estable. Solo se aplican a una plaza de plantilla cuando el ID del jugador coincide; no se asignan jugadores a clubes arbitrariamente.
- El selector del amistoso utiliza equipos procedentes de las plantillas que pasan la validación. En esta fase las fuentes con plantillas completas son primera y segunda división cubanas (16+16 plantillas en los archivos actuales).
- La pantalla raíz incluye Inicio, Online, Modos y Configuración. Los modos opcionales muestran el estado real del catálogo y no se anuncian como instalados si siguen planificados, en desarrollo o en pruebas.

## Motor 3D nativo

- Java 17 para la aplicación Android e interfaz adaptativa.
- C++17 y OpenGL ES 3.0 para renderizado y simulación inicial.
- Formación 4-3-3 procedural para 22 futbolistas.
- Cámara de tercera persona, más baja, que sigue la posición y orientación del futbolista controlado.
- Campo, líneas, estructuras de grada simplificadas y marcos de portería.
- Blockout corporal mejorado con torso, cabeza, brazos, muslos, piernas y movimiento procedural.
- Atributos de altura, GRL, ritmo, regate y defensa procedentes de los datos de la plantilla.
- Controles táctiles con zonas corregidas para movimiento, pase, tiro, regate y presión; se corrigió el desajuste entre coordenadas dibujadas y zonas táctiles en pantallas panorámicas.
- Movimiento de balón condicionado a la proximidad del jugador, toque de regate y presión defensiva aplicada al equipo controlado.
- Reloj de partido, marcador actualizado, detección básica de gol entre los postes y reinicio del saque en el centro después de marcar.
- IA inicial que desplaza las líneas y acompaña la acción; todavía no equivale a una IA táctica completa.

## Límites que se mantienen deliberadamente

- El archivo `data/base_league_clubs_2026.json` registra 451 clubes de referencia; `global_clubs.generated.json` contiene un lote generado de 68. No se deben sumar ni anunciar como clubes jugables. El catálogo de nombres de clubes no equivale a plantillas validadas.
- Las demás ligas/temporadas y las selecciones nacionales siguen sujetas a sus estados de verificación, procedencia y validación del motor. Estar empaquetadas como JSON no las convierte en contenido jugable.
- Los modelos de jugadores siguen siendo un blockout procedural de primitivas, no modelos humanos de alta fidelidad ni equivalentes visuales a FIFA/FC.
- Los menús de carrera, entrenador, ligas, copas, TAS y entrenamiento están representados en el catálogo, pero sus sistemas de juego aún deben construirse y probarse.
- El reloj y marcador básicos ya están conectados al motor, existe detección inicial de goles y el saque se reinicia en el centro; todavía faltan árbitro, sustituciones, faltas, fueras de juego, porteros funcionales, animaciones esqueléticas, repetición y pruebas completas en teléfono.
- Los estadios listados en la especificación de producto aún deben convertirse en escenarios 3D reales; las gradas y porterías actuales son primitivas de prueba.

## Pruebas y publicación

La compilación de CI debe completar `:app:assembleDebug`, verificar el APK y comprobar que contiene `lib/arm64-v8a/libfutbolnova.so`. La compilación correcta no sustituye la instalación y prueba del partido en un dispositivo Android real. El workflow ahora también se dispara cuando cambia el directorio canónico `data/`. No publicar el APK como versión terminada mientras falten los criterios de aceptación.

## Auditoría de código nativo — continuidad 2026-11-19

Revisión estática de `native_engine.cpp` y `MainActivity.java` sobre el HEAD de `work/native-3d-engine` (`77ffe0097b80bd4283e59e131cc4d2c9aae9e345`). Esta revisión no equivale a compilación ni prueba en dispositivo.

### Bloqueadores confirmados en el código actual

- La simulación crea 22 posiciones de jugadores de campo; no existe todavía un actor/estado de portero separado ni lógica de atajada.
- El control humano está fijado al índice 9 (`players[9]`). No existe cambio de jugador controlado ni selección dinámica por proximidad.
- Los otros 21 jugadores se mueven hacia posiciones de formación desplazadas por la ubicación del balón. No hay decisiones diferenciadas de delantero, defensa o portero, ni marcaje individual.
- La colisión balón-jugador solo aplica un impulso sencillo cuando la velocidad horizontal del balón ya es baja; no resuelve de forma completa contactos a alta velocidad, cuerpo contra cuerpo, postes ni travesaño.
- Pase y tiro se disparan en la dirección de orientación del jugador controlado; el pase no selecciona compañero objetivo ni calcula una línea de pase.
- El botón de presión solo modifica velocidad de movimiento de los jugadores del equipo local; no implementa una acción completa de entrada/robo ni una defensa controlada.
- El reloj nativo acumula segundos reales. No hay aún duración configurable de dos tiempos, descanso ni estado de final de partido conectado al bucle de simulación.
- La detección de gol y el reinicio son básicos. No están implementados los estados completos de saque inicial, saque de banda, córner, saque de puerta, fuera de juego, falta o penalti.
- El HUD actual muestra marcador y tiempo acumulado; no muestra eventos arbitrales, jugador activo, energía ni estadísticas finales.

### Integración pendiente de perfiles personalizados

Se guardaron asignaciones confirmadas por el propietario en `data/custom_players.json`: Anier Cumbá (`NOVA-PLAYER-0035`) y Máximo Padilla (`NOVA-PLAYER-0036`) están asignados a Cuba (`CUB`, `FIFA-MA-052`). Se corrigió el dato previo de Anier que decía `BRA`. La pantalla Inicio muestra ahora la selección nacional registrada junto a cada perfil personalizado.

Raymond fue asignado por el propietario a Brasil (`BRA`, `FIFA-MA-028`), pero no se encontró su perfil en `data/custom_players.json`; no se inventó ni duplicó un registro y la vinculación por ID sigue pendiente.

Esto aún no equivale a convocatorias jugables: `national_teams_manifest.json` declara 0 paquetes publicados y confirma que las plantillas nacionales no se han construido. `CanonicalDataRepository.java` todavía no carga plantillas nacionales al selector de Amistosos ni incorpora automáticamente los perfiles por `club_id`/selección. El motor tampoco recibe ID, nombre, número de camiseta ni configuración visual individual. Por tanto, la asignación ya está guardada y visible en Inicio, pero Cuba/Brasil todavía no son equipos nacionales seleccionables ni se ha probado la aparición de estos jugadores en un partido 3D.

Contrato y criterios detallados: `docs/CUSTOM_PLAYERS_TEAM_AND_NATIONAL_SELECTION.md`. La pertenencia debe resolverse por IDs, no por nombres; no inferir convocatorias solo por `nationality`, `birth_country`, `favorite_club` o `favorite_national_team`.

### Orden técnico inmediato

1. Resolver perfiles personalizados por ID para clubes y selecciones, detectar duplicados y exponerlos en las plantillas/selector de amistosos.
2. Enviar identidad y perfil visual del jugador al motor nativo, conservando rasgos personales y adaptando equipación al equipo.
3. Separar el estado de partido del renderizado: fases de juego, posesión, reinicios y reloj configurable.
4. Añadir dos porteros como actores dedicados con posicionamiento, anticipación, desplazamiento lateral, bloqueo y despeje.
5. Corregir colisiones continuas de balón con jugadores, porteros, postes, larguero y límites del campo.
6. Implementar selección/cambio de jugador y acciones con objetivos: pase a compañero, tiro orientado y robo.
7. Sustituir el movimiento uniforme por roles y decisiones tácticas mínimas para ambos equipos.
8. Incorporar saques, pausa, descanso, segundo tiempo, final y revancha.
9. Añadir pruebas automatizadas de pertenencia, perfiles, física/reglas y ejecutar CI; después instalar y probar el APK en Android real.

No marcar ninguno de estos puntos como resuelto sin cambio de código y evidencia de prueba.


## Implementación inicial de porteros y colisiones — 2026-11-19

Commit de código: `fe26b055510452c46a15491a051041c06e509bbf`.
Archivo: `native-android/app/src/main/cpp/native_engine.cpp`.

Cambios incorporados en la primera pasada:
- Los puestos 0 y 11 de las dos plantillas se reservan como porteros dentro de los 22 actores del partido; se ubican inicialmente delante de sus porterías y usan una equipación diferenciada.
- Cada portero sigue la posición horizontal del balón y anticipa su punto de intercepción cuando detecta un disparo que se aproxima a su área.
- Se añadió una estirada lateral breve cuando la trayectoria proyectada amenaza la portería.
- El balón comprueba el segmento recorrido durante el frame para evitar atravesar jugadores en disparos rápidos.
- Los porteros tienen un volumen de bloqueo mayor que los futbolistas de campo y pueden desviar el balón.
- Se añadieron colisiones con los dos postes y el travesaño de ambas porterías.
- El gol se confirma al cruzar el plano de la línea de meta dentro de la anchura y altura válidas; después se reinician posiciones, balón y estados de estirada.

Limitaciones que siguen pendientes:
- Esta implementación no incluye todavía animaciones esqueléticas, agarre real del balón, despejes dirigidos, selección de tipo de parada ni lógica avanzada de rebotes.
- El modelo visual de los porteros sigue siendo el blockout procedural existente, con equipación diferenciada y una inclinación lateral sencilla.
- No se ha confirmado aún una compilación posterior a este cambio ni una prueba física en Android. No declarar el bloqueador P0 resuelto hasta que CI compile y se pruebe el APK en el teléfono.
- Deben probarse tiros rasos, tiros altos, disparos desde ambos lados, rebotes en postes/travesaño, paradas y goles legítimos para detectar falsos positivos.



### Corrección de compilación y despejes de portero — 2026-11-19

- La primera ejecución CI del cambio inicial falló en C++ por faltar el cierre del namespace anónimo antes de las funciones JNI. El log de GitHub Actions identificó `expected '}'` al final del archivo y señaló el namespace abierto.
- Se añadió el cierre del namespace antes de `nativeInit` en commit `d6fabd32aabeed4278bd94ac936750cf833a5f6d`.
- Se limpió la firma de `collideGoalFrame` para quitar parámetros no usados y se añadió un despeje dirigido cuando un portero toca el balón: envía el balón hacia el campo contrario, con componente lateral según el punto de contacto y elevación mínima para evitar que el rebote vuelva directo a la portería.
- Código actualizado en commit `8463db93b7a74b5443408b48c750eb6a8c059c29`; relectura desde GitHub confirmó el despeje y la firma corregida.
- La compilación del commit de corrección de namespace se lanzó como ejecución `44640197543`; debe comprobarse su conclusión. Como el despeje se guardó en un commit posterior, también debe existir y completarse una ejecución CI para el HEAD más reciente antes de dar por buena la APK.
- No se ha hecho prueba visual/física del juego en un teléfono Android. La estirada sigue siendo una animación procedural sencilla; no es una animación esquelética ni una parada de captura/agarre.



### Resolución de colisiones cuerpo a cuerpo — 2026-11-19

- Commit de esta ampliación: `39c4ddcb1c7858ef46689881a09abfe6dfd3e469`.
- Archivo modificado: `native-android/app/src/main/cpp/native_engine.cpp`.
- Se añadió una pasada de separación simétrica entre los 22 actores para evitar que dos futbolistas ocupen el mismo espacio; se aplica también entre rivales y compañeros.
- Tras resolver contactos, las posiciones se limitan a los márgenes del campo y las coordenadas del futbolista controlado se sincronizan con su actor para evitar desajustes entre movimiento y simulación.
- La lógica previa de porteros, anticipación, estirada y contacto con el balón permanece en el mismo archivo. Esta ampliación no demuestra por sí sola una parada correcta ni una física completa.
- Estado de validación: cambio guardado y releído desde GitHub; todavía falta comprobar CI para este HEAD y probar en Android contactos entre jugadores, choques del balón a distintas alturas/velocidades, paradas de ambos porteros, postes, larguero y goles válidos. El bloque P0 continúa abierto hasta contar con esas evidencias.


### Validación CI y revisión de alternativas públicas — 2026-11-19

- Las ejecuciones CI `44640197543` (namespace), `44640242076` (despejes de portero) y `44640261718` (colisiones cuerpo a cuerpo) terminaron con conclusión `success`. En la ejecución más reciente finalizaron correctamente los pasos `Compile native Android APK`, `Verify APK and ARM64 native library` y `upload-artifact`.
- La ejecución `44640261718` generó el artefacto `futbol-nova-native-android-arm64` (ID `14586755428`, 3,428,804 bytes; SHA-256 `34a30da7329e983cffb22c935594405c3b0c30f74e4168238965d0a04b4dbcec`). Artefacto asociado al commit `39c4ddcb1c7858ef46689881a09abfe6dfd3e469`. El archivo C++ fue releído en la rama y su blob SHA es `ef4e68e59d9114c33861123ab411d254675bde4e`.
- Investigación de código público: `TheAmgadX/Soccer-AI` usa C++17 y máquinas de estado para jugadores, portero y tácticas; es 2D y depende de SDL2, por lo que sirve como referencia conceptual de IA, no como integración directa al render nativo OpenGL ES. `Ademola-Game-dev/League-Soccer` documenta motor 3D, 22 jugadores, IA y OpenGL, con licencia Apache-2.0; es una referencia para estudiar arquitectura y reglas, pero su plataforma/dependencias no se integran directamente al runtime Android actual. `FlavioMili/Player12` aporta ideas de simulación compartida para movimiento, balón, fatiga, presión y portería, pero su C++23/SDL3 no coincide con el C++17/Android de NOVA. No se copió código de terceros en esta fase.
- La compilación exitosa confirma build y verificación del artefacto ARM64, no funcionamiento visual ni estabilidad en un teléfono. Sigue pendiente instalar y jugar el amistoso en Android.
- Siguiente prioridad técnica: validar y corregir límites de movimiento de porteros después de la resolución de contactos; después, mejorar IA de campo para que presione, cubra líneas de pase y apoye al poseedor, en lugar de limitarse a posiciones de formación. Mantener pruebas de tiros altos/rasos, paradas, postes/travesaño, goles y control táctil.


### Protección del área de portería tras contactos — 2026-11-19

- Commit `14a8797f8321d2d79c6c8d4b701c69498ce45b45`: después de resolver las colisiones entre los 22 futbolistas, se vuelven a limitar las coordenadas de los porteros 0 y 11 al ancho y profundidad de sus respectivas áreas de portería. Así, el empuje de un compañero o rival no los deja fuera del corredor que deben defender.
- Relectura de `native_engine.cpp` desde GitHub confirmó las cuatro restricciones de coordenadas; blob SHA `79f8d4fb4e186115b68b4a5fd3ac8760009c14a1`.
- La ejecución CI `44640261718` valida el commit anterior de colisiones generales, no este ajuste. El cambio nuevo requiere su propia compilación antes de considerarse validado. Si no aparece ejecución automática, revisar el evento/path trigger del workflow y lanzar una compilación manual cuando esté disponible.

## Amistoso nativo — control activo, pase dirigido e IA de presión (2026-11-19)

Cambios guardados en `work/native-3d-engine`:

- El futbolista controlado dejó de estar fijado al índice 9. Se mantiene un índice activo dinámico y el botón táctil **CAMBIAR** selecciona al siguiente compañero ordenado por proximidad al balón.
- El pase corto busca un compañero del equipo local que esté en una distancia jugable, favorece progresar hacia la portería rival y penaliza líneas bloqueadas por defensores. El tiro conserva la dirección de orientación del futbolista.
- La IA de cada equipo identifica a su jugador de campo más cercano al balón para que presione la jugada; los demás conservan sus posiciones de apoyo y formación desplazada por el balón.
- El control nativo ahora asocia joystick y presión a IDs de puntero Android independientes. Los movimientos multitáctiles actualizan cada dedo activo, y soltar un dedo no debe cancelar el joystick o la presión que mantiene otro.
- La escena nativa reinicia el jugador activo, punteros y botones al inicializar un partido. Se corrigió también el cálculo de orientación al cambiar de jugador.

Archivos modificados:
- `native-android/app/src/main/cpp/native_engine.cpp`
- `native-android/app/src/main/java/com/nova/futbolnova/MainActivity.java`

Validación:
- Los cambios se releen desde GitHub y el workflow `.github/workflows/futbol-nova-native-android.yml` se activa con modificaciones de `native-android/**`.
- La compilación ARM64 y la verificación de `lib/arm64-v8a/libfutbolnova.so` deben finalizar en CI antes de dar por compilado este cambio.
- Aún no hay prueba física de la interfaz multitáctil, cambio de futbolista, pase dirigido ni decisiones IA en un teléfono. Estas mejoras son implementación inicial y no cierran P0.
- No se ha autorizado generar una APK de entrega ni subir una nueva APK a Dropbox.
