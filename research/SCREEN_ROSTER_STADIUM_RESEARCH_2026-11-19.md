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

Correcciones guardadas en la rama independiente: `scripts/ui/pre_match_setup.gd` ahora usa `Button.text_alignment`; `tests/test_friendly_match_runtime.gd` declara el preload del servicio de Momentos y tipos `String` explícitos. La rama maestra de Workspace recibió la corrección de la tarjeta y mantiene los tipos explícitos en su prueba equivalente.

**Estado posterior:** los archivos corregidos se releyeron desde GitHub. Todavía no hay resultado de una ejecución nueva con esos commits; no se declara aprobada la prueba runtime ni la exportación APK.
