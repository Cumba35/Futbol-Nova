# Implementación del amistoso Nova C35 vs FC Río de Argenti — 2026-11-20

## Alcance implementado

Esta entrega transforma los dos clubes originales que antes aparecían solo como opciones informativas en equipos registrados y seleccionables para el partido amistoso local 11 contra 11.

- Nova C35: 22 perfiles, incluidos Anier Cumbá y Máximo Padilla; 20 perfiles ficticios originales.
- FC Río de Argenti: 22 perfiles, incluido Raymond Valdez con dorsal 5; 21 perfiles ficticios originales.
- Total añadido al registro aislado del importador: 44 perfiles (3 perfiles del catálogo de jugadores del propietario y 41 perfiles ficticios generados).
- Los perfiles ficticios llevan `fictional=true`, procedencia explícita y estadísticas de carrera/temporada inicializadas a cero.
- Los dos clubes se registran como clubes originales de exhibición; no se incorporan a competiciones ni calendarios de liga.
- El amistoso exige plantillas con al menos 22 jugadores, IDs únicos y once inicial válido. Se permiten futbolistas personalizados adicionales sin bloquear la selección.
- Los selectores priorizan Nova C35 como local y FC Río de Argenti como visitante. El motor controla a Anier Cumbá cuando C35 es local y a Raymond Valdez cuando RDA es local; el jugador controlado se retira de la lista de actores IA para evitar duplicarlo.
- El estadio, duración por tiempo, modo de reloj y prórroga siguen usando la configuración existente del modo amistoso.

## Raymond Valdez

Datos confirmados incorporados: fecha de nacimiento 26/05/2007, edad 19, altura 171 cm, peso 63 kg, DC/MCO, dorsal 5, media 91 y potencial 96. Se asignó el nuevo ID interno `NOVA-PLAYER-0037`, tal como autorizó el propietario.

Los valores individuales de atributos se han generado como propuesta provisional y están marcados `provisional_generated_pending_owner_review`; no se presentan como datos confirmados. La nacionalidad permanece `UNK` porque no se ha confirmado en la ficha disponible. Las estadísticas empiezan en cero.

Se vinculó la ficha con la referencia visual aportada por el propietario en Dropbox y se añadió una escena 3D procedural provisional, controlable y con colisión. No es todavía un parecido facial de alta fidelidad. La acción de habilidad dispara una finta original de control cercano/cambio de ritmo. La celebración original de señalar al cielo se activa cuando Raymond es el jugador controlado, su último toque registrado produce un gol de su equipo y el motor reconoce ese evento. No se copiaron animaciones ni capturas de movimiento de futbolistas reales.

## Integración técnica

- `scripts/data/original_club_importer.gd`: importa perfiles y clubes, valida IDs, referencias, plantillas de 22 y registros de jugador.
- `data/players/nova_original_club_rosters_2026.json`: datos versionados de los 41 perfiles ficticios y las dos plantillas.
- `data/custom_players.json`: incorpora el perfil de Raymond sin sobrescribir las fichas existentes de Anier y Máximo.
- `scripts/data/football_data_service.gd`: ejecuta el importador durante la inicialización del catálogo y valida los totales esperados (727 clubes y 15.994 jugadores).
- `scripts/ui/pre_match_setup.gd`: muestra solo clubes con al menos 22 jugadores y un once válido; prioriza los dos clubes originales.
- `scripts/main.gd`, `scripts/gameplay/match_11v11_controller.gd` y `scripts/player_controller.gd`: seleccionan el avatar de Raymond cuando RDA juega como local y registran el último toque del jugador controlado para la celebración.
- `scripts/players/raymond_valdez.gd` y `scenes/players/raymond_valdez.tscn`: avatar provisional y animaciones originales.
- `tests/test_original_club_importer.gd`: valida los dos equipos, los 44 perfiles, los onces, estadísticas cero, datos de Raymond y su escena.
- `tests/test_friendly_match_runtime.gd`: amplía la prueba de aceptación para iniciar C35 vs RDA y comprobar que Raymond aparece en el once visitante.
- `.github/workflows/futbol-nova-android-apk.yml`: añade la prueba del importador/avatar al flujo automatizado.

## Límites y validación pendiente

- No se ha ejecutado Godot localmente en este entorno; la compilación/importación de recursos y las pruebas de runtime quedan pendientes del workflow de GitHub Actions.
- No declarar esta entrega lista para fusionar hasta que el workflow termine sin fallos y se revisen los resultados.
- La escena de Raymond es un bloque visual procedural temporal; el parecido 3D final depende de revisar la referencia visual del propietario.
- Los atributos individuales de Raymond son provisionales hasta confirmación.
- El motor 11v11 existente sigue siendo una base local jugable, no una simulación completa de árbitro, faltas y reglamento profesional.

## Política de dependencias y licencias

La implementación es nativa GDScript/Godot y no añade dependencias externas. La investigación previa de proyectos públicos se conserva en `FRIENDLY_RUNTIME_RESEARCH_AND_PLAN_2026-11-20.md`; no se copiaron código ni recursos de repositorios cuya licencia no estuviera verificada.


## Enfoque de validación del amistoso — 2026-11-20

La validación prioritaria es el flujo de amistoso completo: preparación, selección de equipos, 11 contra 11, jugador controlado, IA, controles táctiles, posesión, pases, tiros, porteros, goles, marcador, descanso, cambio de campo, tiempo reglamentario, prórroga, penaltis, pausa y limpieza al salir. También se comprueba que el amistoso no altere los retos de entrenamiento ni las estadísticas de competición.

En la primera ejecución de CI, el test principal del amistoso llegó hasta el pitido final y pasó; el importador de clubes también pasó. La suite encontró después un fallo de aceptación en la comprobación de la cápsula del portero. Se reorganizó la creación del collider para construirlo antes de insertar el actor en el árbol, se hizo explícita la sincronización física y se añadieron datos de diagnóstico al test. La corrección queda pendiente de confirmar en una nueva ejecución de CI; no se considera validada hasta entonces.
