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

## Decisiones técnicas aplicadas

1. Mantener GDScript y el motor Godot 4.4.1 fijado en el pipeline Android.
2. No añadir GDExtensions, C++, SCons, servidores, Python, Go, bases de datos remotas ni paquetes de red al APK para resolver problemas que se pueden cubrir con código local.
3. Separar reglas, reloj, control, IA, física, presentación y simulación de temporada.
4. Preferir funciones puras y deterministas para reglas y modelos físicos; probarlas sin escena cuando sea posible.
5. La física de vuelo propia `scripts/ball_flight_model.gd` y el gesto `scripts/set_piece_swipe_controller.gd` se consideran componentes iniciales, no funciones integradas al partido hasta que el balón real, el HUD y el árbitro los utilicen y las pruebas de aceptación pasen.
6. No importar escudos, equipaciones, caras, modelos, animaciones, audio, bases de datos ni assets de esos repositorios.
7. Toda reutilización futura exige revisar el archivo LICENSE del commit exacto, conservar avisos, atribuir procedencia y auditar licencias individuales de assets/dependencias.

## Próximas mejoras priorizadas

- **P0 — calidad y seguridad:** completar pruebas headless de `BallFlightModel`, `SetPieceSwipeController`, reloj y puntuación; impedir goles fuera de partido activo; garantizar que el workflow no cancele builds principales por commits de documentación.
- **P1 — control del balón:** conectar pase, tiro, primer toque, posesión y gesto táctil al mismo modelo de balón, con límites de velocidad/altura y pruebas deterministas.
- **P1 — porteros y reinicios:** conectar el predictor de intercepción, perfiles de reacción, barrera y reinicios reglamentarios; no marcar estas funciones como disponibles antes de probarlas.
- **P2 — IA colectiva:** introducir presión por zonas, coberturas y roles de manera escalonada, midiendo coste de CPU con 22 futbolistas.
- **P2 — estadísticas/repeticiones:** registrar eventos estructurados y reproducibles; generar estadísticas a partir de eventos reales, no de estimaciones visuales.
- **P3 — temporada:** evaluar semillas y RNG determinista para reproducir simulaciones y depurar resultados.

## Evidencia y límites

La investigación se realizó sobre README, páginas de repositorio, documentación y licencias visibles públicamente. No se descargó ni incorporó código de terceros en esta revisión. Los proyectos de referencia no demuestran que Fútbol Nova tenga esas capacidades. La cobertura real se determina por el código propio, pruebas ejecutadas en GitHub Actions y validación final de la APK en Android.


## Alternativas Godot adicionales

| Repositorio | Licencia / tecnología | Utilidad potencial | Decisión |
|---|---|---|---|
| [nicolasbize/soccer-course](https://github.com/nicolasbize/soccer-course) | MIT; Godot 4.4; fútbol 2D local | Organización de escenas, eventos y entrada en una versión coincidente del motor | Solo referencia de arquitectura 2D; no importar escenas, arte ni lógica al juego 3D 11v11. |
| [Habeeb-Rahman-CA/soccer5v5-game-godot](https://github.com/Habeeb-Rahman-CA/soccer5v5-game-godot) | MIT; Godot 4.6; 5v5 | Estructura de partidos pequeños, señales y controles de dos jugadores | No copiar recursos ni elevar el motor: alcance 5v5 y versión 4.6 no corresponden al amistoso 11v11 en Godot 4.4.1. |
| [ryan-haskell/godot-soccer-demo](https://github.com/ryan-haskell/godot-soccer-demo) | No se encontró archivo LICENSE en la raíz examinada | Experimento de física básica del balón | Lectura conceptual únicamente; sin licencia identificada no se reutiliza código ni assets. |
| [matheuscumpian/godot-soccer](https://github.com/matheuscumpian/godot-soccer) | Proyecto de curso GameDev.tv; licencia de reutilización no confirmada | Referencia visual de prototipo Godot | No incorporar código ni recursos sin comprobar los derechos y atribuciones de cada recurso. |


## Revisión adicional de proyectos móviles

| Repositorio | Licencia / tecnología | Utilidad potencial | Decisión |
|---|---|---|---|
| [devinarena/Pixel-Striker](https://github.com/devinarena/Pixel-Striker) | MIT declarada; Godot; juego móvil con Android, tiros libres, penaltis y portero | Referencia para flujos táctiles, modos de práctica y exportación móvil | No sustituye ni aporta un motor 11v11: sus modos son minijuegos de fútbol. Se estudian patrones de interacción y empaquetado, sin incorporar assets ni código en esta fase. |

**Criterio de compatibilidad:** Pixel-Striker y FreeKick se desarrollan con versiones de Godot distintas a la versión 4.4.1 fijada en Fútbol Nova. Antes de considerar cualquier componente, debe portarse de forma explícita y pasar las pruebas headless y Android del proyecto; no se eleva la versión del motor solo para copiar una demo.
