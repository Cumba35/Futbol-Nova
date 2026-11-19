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

## Incidencia de CI corregida

El 2026-11-19, el workflow `Fútbol Nova - pruebas y APK Android` (run 44541374751) completó correctamente las pruebas específicas del amistoso, incluida la aceptación 11v11 hasta el pitido final. Se detuvo después en `tests/test_shared_foundation.gd`, que referenciaba directamente el autoload `FootballDatabase` desde una prueba ejecutada con `--script`. La prueba se corrigió para resolver el autoload desde `root` en tiempo de ejecución. La corrección debe considerarse pendiente de validación hasta que una nueva ejecución de CI termine correctamente.

## Siguiente prioridad

Corregir cualquier nuevo bloqueo real de CI y conseguir el APK Android. Después, realizar una prueba manual centrada en el control táctil, la posesión, los pases, los tiros, los goles y la IA durante un amistoso completo.
