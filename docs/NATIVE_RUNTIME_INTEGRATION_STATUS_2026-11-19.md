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
