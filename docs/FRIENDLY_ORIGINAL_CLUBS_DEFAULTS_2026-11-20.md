# Amistoso: clubes originales por defecto

Fecha: 2026-11-20

## Cambio

La pantalla de preparación del amistoso presenta, en el orden del catálogo `data/original_clubs_2026.json`, los dos primeros clubes originales como selección inicial:

1. Nova C35 (`FN-NOVA-C35`) — local.
2. FC Río de Argenti (`FN-NOVA-RDA`) — visitante.

Las opciones muestran el avance conocido de plantilla: C35 2/11 y RDA 0/11, de acuerdo con los registros verificados disponibles en el catálogo original. El selector sigue permitiendo escoger otros clubes.

## Protección de integridad

Estos dos clubes todavía no están registrados como equipos jugables completos en el registro principal. Por ello, el botón de inicio permanece bloqueado al seleccionarlos y la pantalla explica que se requieren once jugadores verificados por equipo. No se generan jugadores, estadísticas, identificadores ni perfiles ficticios para forzar el inicio.

El test de aceptación verifica los valores predeterminados originales y el bloqueo seguro por plantillas incompletas. Después selecciona dos clubes de prueba con plantillas válidas para conservar la cobertura del motor de partido amistoso, sin alterar los nuevos valores predeterminados.

## Pendiente para disputar este amistoso

- Importar los perfiles originales verificados de Nova C35 y FC Río de Argenti al catálogo jugable.
- Completar al menos once jugadores reales/verificados por equipo (el objetivo de plantilla sigue siendo 22).
- Resolver la identidad única del jugador Raymond antes de asignarlo a RDA.
- Ejecutar la suite Godot y CI; no se declara la prueba aprobada hasta obtener resultado exitoso.

## Archivos

- `scripts/ui/pre_match_setup.gd`
- `tests/test_friendly_match_runtime.gd`
