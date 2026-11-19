# Auditoría de alternativas públicas de GitHub — Fútbol Nova

**Fecha de revisión:** 18 de noviembre de 2026  
**Repositorio de distribución:** `Cumba35/Futbol-Nova`  
**Repositorio maestro:** `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova`  
**Regla de desarrollo:** ChatGPT + GitHub; Godot, SDK y herramientas de compilación se ejecutan solo en GitHub Actions.

## Criterios de selección

Se priorizan soluciones GDScript/Godot compatibles con Android ARM64, modo local/offline, bajo coste de CPU y pruebas headless. Una licencia identificada permite evaluar reutilización bajo sus términos, pero no concede derechos sobre assets de terceros, marcas, datos deportivos ni contenido descargado. Cuando la licencia no aparece o no se puede confirmar, solo se estudian ideas generales y no se copia código ni recursos.

## Repositorios examinados

| Proyecto | Licencia declarada / evidencia | Tecnología y aportación | Decisión para Fútbol Nova |
|---|---|---|---|
| [AKM-8byte/FreeKick](https://github.com/AKM-8byte/FreeKick) | MIT; archivo LICENSE visible en GitHub | Godot 4.7.2, GDScript; vuelo del balón, spin/Magnus, contacto, portero, IK y repetición | Referencia más cercana para balón y jugadas a balón parado. Fútbol Nova fija Godot 4.4.1: no se importan escenas ni assets. Se mantienen modelos propios y se deben probar los componentes en 4.4.1 antes de integrarlos. |
| [angree/openswos](https://github.com/angree/openswos) | MIT indicado en README | Godot 4 + C#; recreación de fútbol con movimiento, balón, porteros, entradas, cabezazos, reinicios, lesiones y árbitro | Referencia de cobertura funcional, transiciones y enfoque de estudiar/parafrasear algoritmos. No adoptar C# ni redistribuir archivos SWOS originales/protegidos. |
| [awest813/League-Soccer](https://github.com/awest813/League-Soccer) | Apache-2.0 indicado en README y archivo LICENSE | C++17, SDL/OpenGL; 22 jugadores, IA táctica, árbitro, estadísticas, repeticiones y suites de integración; CI Linux/macOS/Windows | Buena referencia de separación modular y pruebas headless. No portar el motor C++ ni dependencias gráficas al runtime Android de Fútbol Nova. |
| [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball) | GitHub no presenta una licencia identificable en la revisión | Godot 4.4.1 + GDExtension C++/SCons; física de balón, árbitro y 22 jugadores | Versión de Godot compatible, pero añade toolchain nativo y coste de mantenimiento; no se incorpora código ni assets sin licencia confirmada. |
| [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) | No se confirmó archivo/licencia reutilizable | Godot 4.7.1, GDScript, cuerpos rígidos, porteros IA, pruebas y multijugador autoritativo | Ideas para colisiones, telemetría y pruebas; su combate arcade, versión de motor y backend no encajan con el amistoso offline. Sin copiar código ni assets. |
| [richardschembri/GodotBasic3DFootball](https://github.com/richardschembri/GodotBasic3DFootball) | No se encontró licencia clara en la revisión | Demo de fútbol 3D básica para Godot | Solo referencia de estudio; no reutilizar código, modelos ni recursos. |
| [gaemi/agentic-fc](https://github.com/gaemi/agentic-fc) | MIT visible en GitHub | Go; simulación determinista, semillas, flujos de eventos auditables y calibración de partidos para agentes | Útil conceptualmente para la simulación de temporadas, RNG reproducible y registro de eventos. No es motor 3D ni runtime Godot; no añadir Go/MCP al APK. |
| [lel1guy/FootPong](https://github.com/lel1guy/FootPong) | MIT declarado en README | Godot 4.6, GDScript, Android export; juego 2D sencillo con marcador y reinicio | Referencia limitada para estructura de exportación móvil y flujo de marcador; no aporta un motor 11v11. |
| [ODS-RL/football-env](https://github.com/ODS-RL/football-env) | Licencia no confirmada durante esta revisión | Python; entorno 2D para agentes, repetición de logs y presets tácticos | Solo referencia conceptual para reproducibilidad y experimentación de IA; no integrar Python en el juego Android. |
| [openfootmanager/openfootmanager](https://github.com/openfootmanager/openfootmanager) | GPLv3 indicada por el proyecto | Simulación de gestión con comentarios/eventos de partido y gestión de plantillas | No es motor de partido 3D. La licencia GPLv3 y el stack web no encajan con el runtime actual; estudiar únicamente conceptos generales. |

## Investigación complementaria — 19 noviembre 2026

Se amplió la búsqueda a simulación táctica, fútbol 3D y física de cuerpos rígidos:

| Proyecto | Evidencia revisada | Ideas útiles | Decisión |
|---|---|---|---|
| [noddy703/tacticmesh](https://github.com/noddy703/tacticmesh) | README y arquitectura descrita; motor web/JavaScript, MIT para el código fuente y permisos separados para packs/assets | Motor de paso fijo, modo de simulación acelerada, formaciones y tácticas configurables, valoración individual, estadísticas y packs de equipos JSON/ZIP | Referencia para separar simulación de presentación, reproducibilidad y formatos de datos. No portar su motor web al juego Godot 3D ni reutilizar packs/imágenes sin verificar permisos individuales. |
| [RobinNunkesser/gd-godot-crazy-cage-football](https://github.com/RobinNunkesser/gd-godot-crazy-cage-football) | Inspección de `scripts/ball.gd`, `scripts/player.gd`, `project.godot` y pruebas; Godot 4.x, cuerpos rígidos 3D. La licencia no quedó confirmada en los archivos revisados | CCD para reducir tunneling, límites de velocidad, materiales físicos, monitorización de contactos y pruebas separadas de física de balón/jugador | Solo ideas técnicas de alto nivel. No copiar código ni assets hasta confirmar licencia. La física de Fútbol Nova debe mantener su modelo y calibración propios. |
| [abotbro/godot-football-engine](https://github.com/abotbro/godot-football-engine) | README de un motor de fútbol Godot; licencia y madurez no verificadas | Referencia para comparar separación de mecánicas, física y simulación | No integrar ni copiar; falta auditoría de licencia, contenido y compatibilidad real. |

### Conclusiones de la revisión

- El paso fijo y la semilla determinista son especialmente útiles para reproducir bugs del partido; se deben aplicar al núcleo de simulación y no forzar a toda la presentación 3D a funcionar como simulación por turnos.
- La selección de formaciones/tácticas y el registro de estadísticas deben mantenerse como datos independientes de la escena visual.
- Las ideas de CCD y límites de velocidad merecen pruebas específicas con los tamaños, velocidades, postes y dimensiones de las porterías de Fútbol Nova; no se deben copiar valores de un juego arcade de jaula.
- Ningún repositorio externo justifica reemplazar el motor Godot actual ni añadir servicios de red al juego base offline.
- La búsqueda de hoy no autoriza copiar código o recursos de los proyectos cuya licencia no se verificó en el commit/archivo correspondiente.

## Decisiones técnicas aplicadas

1. Mantener GDScript y el motor Godot 4.4.1 fijado en el pipeline Android.
2. No añadir GDExtensions, C++, SCons, servidores, Python, Go, bases de datos remotas ni paquetes de red al APK para resolver problemas que se pueden cubrir con código local.
3. Separar reglas, reloj, control, IA, física, presentación y simulación de temporada.
4. Preferir funciones puras y deterministas para reglas y modelos físicos; probarlas sin escena cuando sea posible.
5. La física de vuelo propia `scripts/ball_flight_model.gd` y el gesto `scripts/set_piece_swipe_controller.gd` se consideran componentes iniciales, no funciones integradas al partido hasta que el balón real, el HUD y el árbitro los utilicen y las pruebas de aceptación pasen.
6. No importar escudos, equipaciones, caras, modelos, animaciones, audio, bases de datos ni assets de esos repositorios.
7. Toda reutilización futura exige revisar el archivo LICENSE del commit exacto, conservar avisos, atribuir procedencia y auditar licencias individuales de assets/dependencias.

## Próximas mejoras priorizadas

- **P0 — validación pendiente:** completar CI de los cambios de porterías y atribución de goles; añadir pruebas headless de `BallFlightModel` y `SetPieceSwipeController`; comprobar exportación y artefacto APK en Android. La protección contra goles fuera de un partido activo y la conservación de ejecuciones CI ya están implementadas, pendientes de certificación por la suite.
- **P1 — control del balón:** conectar pase, tiro, primer toque, posesión y gesto táctil al mismo modelo de balón, con límites de velocidad/altura y pruebas deterministas.
- **P1 — porteros y reinicios:** conectar el predictor de intercepción, perfiles de reacción, barrera y reinicios reglamentarios; no marcar estas funciones como disponibles antes de probarlas.
- **P2 — IA colectiva:** introducir presión por zonas, coberturas y roles de manera escalonada, midiendo coste de CPU con 22 futbolistas.
- **P2 — estadísticas/repeticiones:** registrar eventos estructurados y reproducibles; generar estadísticas a partir de eventos reales, no de estimaciones visuales.
- **P3 — temporada:** evaluar semillas y RNG determinista para reproducir simulaciones y depurar resultados.

## Evidencia y límites

La investigación se realizó sobre README, páginas de repositorio, documentación y licencias visibles públicamente. No se descargó ni incorporó código de terceros en esta revisión. Los proyectos de referencia no demuestran que Fútbol Nova tenga esas capacidades. La cobertura real se determina por el código propio, pruebas ejecutadas en GitHub Actions y validación final de la APK en Android.


## Estado de mejoras aplicadas — 18 noviembre 2026

**Implementado en el código propio:**
- Colisiones físicas de postes y largueros, más paneles de red trasero, laterales y superior en ambas porterías.
- Atribución de goles y saques de puerta basada en la orientación actual de los equipos después del descanso, sin depender del nombre fijo del sensor.
- Protección del marcador para impedir que un área de gol altere el resultado cuando el amistoso no está activo.
- Acceso dinámico al autoload de datos en la preparación del amistoso para que las pruebas headless no dependan de una referencia global estática.
- CI Android con setup-android v4, pruebas individuales con timeout y ejecución no cancelable por commits posteriores de la misma rama.

**Pendiente de demostrar con CI:** que las nuevas pruebas de física y de cambio de lado pasen en Godot 4.4.1; que las regresiones terminen; que se exporte y publique el artefacto APK Android ARM64. No se considera validado por el mero hecho de haber guardado el código.

**Pendiente de integración funcional:** `BallFlightModel` y `SetPieceSwipeController` siguen siendo componentes iniciales sin conexión completa al balón real y al HUD. Se mantiene como siguiente prioridad su conexión con pase, tiro, primer toque y efecto, acompañada de pruebas deterministas.


## Revisión de regresión propia — 19 noviembre 2026

Durante la inspección de `scripts/gameplay/match_11v11_controller.gd` se encontró una regresión funcional en la liberación de la posesión: las ramas de futbolistas de campo y porteros llamaban a `_clear_ball_possession()`, pero el impulso estaba dentro de la rama alternativa que nunca se ejecutaba cuando la IA era realmente dueña del balón. La corrección propia centraliza la liberación y el impulso en `apply_ai_kick()` y añade una prueba con `RigidBody3D`.

La búsqueda pública se mantiene como fuente de ideas, no como permiso para copiar. Se revisaron las referencias previas `noddy703/tacticmesh`, `RobinNunkesser/gd-godot-crazy-cage-football` y `abotbro/godot-football-engine`; ninguna justifica reemplazar el motor propio ni importar assets sin una auditoría de licencia por archivo.
