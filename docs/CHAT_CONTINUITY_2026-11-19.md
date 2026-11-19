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
El usuario pidió que los jugadores personalizados aparezcan en sus respectivos equipos y selecciones. El contrato está documentado en `docs/CUSTOM_PLAYERS_TEAM_AND_NATIONAL_SELECTION.md`. La implementación todavía está pendiente: el código actual indexa perfiles por ID y aplica atributos si el ID ya está en la plantilla, pero no resuelve todas las pertenencias de club/selección ni transmite la identidad y apariencia al motor 3D. No declarar la función lista hasta probarla desde el selector de plantillas hasta el partido.

## Referencias del proyecto
- Prioridad y criterios de aceptación: `docs/FRIENDLY_MODE_PRIORITY_AND_ACCEPTANCE.md`
- Jugadores personalizados en clubes y selecciones: `docs/CUSTOM_PLAYERS_TEAM_AND_NATIONAL_SELECTION.md`
- Estado técnico del runtime: `docs/NATIVE_RUNTIME_INTEGRATION_STATUS_2026-11-19.md`
- Política de motor exclusivamente nativo: `docs/NATIVE_ONLY_ENGINE_POLICY.md`
- Pull request de desarrollo: https://github.com/Cumba35/Futbol-Nova/pull/5

## Nota de precisión
Este registro resume las decisiones y el estado conocido al 2026-11-19. No representa una nueva compilación, una prueba física en el teléfono ni una declaración de que las funciones pendientes ya estén implementadas.
