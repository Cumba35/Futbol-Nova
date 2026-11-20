# Amistoso predeterminado: Nova C35 vs FC Río de Argenti

Fecha de revisión: 2026-11-20

## Selección inicial

La pantalla de preparación del amistoso selecciona por defecto:

1. Nova C35 (`FN-NOVA-C35`) — local.
2. FC Río de Argenti (`FN-NOVA-RDA`) — visitante.

Los dos clubes tienen 22 identificadores de jugador registrados en sus fichas y una plantilla de 22 perfiles para el modo offline. El partido coloca once titulares por equipo: 22 futbolistas activos en el campo, uno controlado por el usuario y 21 actores de IA.

La prueba de aceptación del amistoso comprueba que el botón de inicio esté habilitado, que el resumen indique plantillas completas y que el partido arranque con 11 jugadores locales, 11 visitantes y 21 actores IA.

## Jugador controlado según el equipo local

La selección se determina explícitamente por el club local:

- Si Nova C35 es local, se controla a **Anier Cumbá**, ID `NOVA-PLAYER-0035`.
- Si FC Río de Argenti es local, se controla a **Raymond Valdez**, ID `NOVA-PLAYER-0037`.
- Para los demás clubes se conserva el jugador predeterminado del once inicial.

La lógica está centralizada en `NovaPreMatchSetup.get_default_controlled_player_id()` y cubierta por `tests/test_match_11v11_foundation.gd`.

## Procedencia e integridad de los datos

- Las fichas de clubes y plantillas identifican los perfiles creados para completar los clubes como ficticios mediante `fictional: true` y `identity_type: original_fictional_player`.
- Los perfiles generados son contenido ficticio original del juego; no se presentan como futbolistas reales ni como estadísticas históricas verificadas.
- Las estadísticas de carrera y temporada comienzan en cero.
- Los IDs existentes de Anier, Máximo y Raymond se mantienen diferenciados. Raymond usa `NOVA-PLAYER-0037` en la plantilla de FC Río de Argenti.
- No se inventan resultados, apariciones ni estadísticas de partidos anteriores.

## Validación y límites

La aceptación integrada existente comprueba selección de clubes, plantillas completas, 22 futbolistas activos, Anier como control para C35 local, Raymond presente en la plantilla visitante, controles táctiles, balón, goles, marcador, reloj, pausas, períodos y finalización.

La nueva prueba `tests/test_match_start_atomic_validation.gd` verifica que una solicitud inválida (clubes iguales, once incompleto o ID de jugador controlado desconocido) no interrumpa un partido que ya está activo.

Estas pruebas todavía necesitan una ejecución CI terminada con éxito y una prueba manual en Android. La APK debug no se considera validada solo por estar exportada.

## Archivos relacionados

- `data/nova_c35_club.json`
- `data/fc_rio_de_argenti_club.json`
- `data/players/nova_original_club_rosters_2026.json`
- `scripts/data/original_club_importer.gd`
- `scripts/ui/pre_match_setup.gd`
- `scripts/main.gd`
- `tests/test_original_club_importer.gd`
- `tests/test_friendly_match_runtime.gd`
- `tests/test_match_11v11_foundation.gd`
- `tests/test_match_start_atomic_validation.gd`
