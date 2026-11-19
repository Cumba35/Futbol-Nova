# Investigación de repositorios públicos — Fútbol Nova

**Revisión:** 18 de noviembre de 2026  
**Objetivo:** identificar enfoques reutilizables para mejorar física, IA, reglas y pruebas sin comprometer el funcionamiento offline, Android ARM64 ni el flujo ChatGPT + GitHub.

## Repositorios revisados

| Repositorio | Enfoque útil | Compatibilidad y licencia revisada | Decisión |
|---|---|---|---|
| [League-Soccer](https://github.com/awest813/League-Soccer) | Simulación 22 jugadores, física del balón, árbitro, fuera de juego, faltas, estadísticas y pruebas de integración headless. | Código C++17 con CMake, enfoque principalmente desktop. El repositorio declara Apache-2.0. | Referencia de arquitectura y cobertura; no copiar ni introducir el motor C++ en el juego Godot/GDScript. |
| [FreeKick](https://github.com/AKM-8byte/FreeKick) | Física configurable del balón, vuelo, efecto, rebotes, IK, repeticiones deterministas y pruebas físicas. | MIT confirmado en el repositorio. La versión documentada usa Godot 4.7.2; Fútbol Nova está fijado a Godot 4.4.1. | Referencia conceptual para física y pruebas. No importar scripts ni assets: diferencia de versión y el juego tiene otro alcance. |
| [Godotball](https://github.com/aliyavuzz/Godotball) | Port de GameplayFootball a Godot 4.4.1, física personalizada, árbitro y comportamiento básico de 22 jugadores. | GDExtension C++17, SCons y compilador nativo; aumenta la complejidad de build y mantenimiento. | Referencia técnica, no dependencia. No se copia código. |
| [Soccer Box Game](https://github.com/namelesssyf/soccer-box-game) | Balón rígido, guardameta IA, telemetría, pruebas y separación cliente/servidor. | Godot 4.7.1, 3 jugadores de campo y portero por equipo, multijugador autoritativo y backend externo. No se confirmó una licencia reutilizable. | No encaja con el amistoso offline 11v11; solo referencia conceptual. |

## Mejoras aplicadas a Fútbol Nova a partir de la auditoría

- Se añadió una validación para que el marcador solo cambie cuando el amistoso 11v11 está activo.
- Se añadieron pruebas de gol para ambos equipos, reinicio del balón y rechazo de goles fuera de un encuentro activo.
- Se corrigió el cambio de lado en el descanso reglamentario y en el descanso de la prórroga, actualizando posiciones, orientación y direcciones tácticas.
- Se añadió timeout individual y agrupación de logs por prueba Godot en GitHub Actions.
- Se conserva el motor GDScript existente y no se añaden dependencias nativas ni conexiones online obligatorias.

## Política de reutilización

La consulta de un repositorio público no concede derechos para copiar su código, modelos, sonidos, imágenes o bases de datos. Antes de incorporar cualquier componente de terceros se debe comprobar el archivo LICENSE en el commit exacto, su procedencia, las licencias de los assets y las obligaciones de atribución. Si la compatibilidad técnica o legal no está clara, se conserva únicamente la idea general y se implementa una solución original.

No se copiaron código ni assets de los repositorios enumerados.

## Otras alternativas examinadas — 18 de noviembre de 2026

| Repositorio | Licencia / motor | Utilidad potencial | Decisión |
|---|---|---|---|
| [nicolasbize/soccer-course](https://github.com/nicolasbize/soccer-course) | MIT; Godot 4.4; juego 2D de fútbol local. | Arquitectura sencilla de eventos, entrada, gestor de juego y organización de escenas en una versión de motor coincidente. | No trasladar sus escenas, arte ni lógica: está diseñado para 2D y dos jugadores locales, no para la simulación 3D 11v11. Se mantiene como referencia de organización y separación de responsabilidades. |
| [Habeeb-Rahman-CA/soccer5v5-game-godot](https://github.com/Habeeb-Rahman-CA/soccer5v5-game-godot) | MIT; Godot 4.6; fútbol 5v5. | Referencia para entrada de dos jugadores, señales/eventos y estructura de juego pequeño. | No copiar código ni recursos: versión más nueva y alcance 5v5; Fútbol Nova se mantiene en Godot 4.4.1 y 11v11. |
| [ryan-haskell/godot-soccer-demo](https://github.com/ryan-haskell/godot-soccer-demo) | No se encontró archivo LICENSE en la raíz examinada. | Experimento de física básica del balón en Godot. | Solo lectura conceptual; sin licencia verificada no se reutiliza código ni assets. |
| [matheuscumpian/godot-soccer](https://github.com/matheuscumpian/godot-soccer) | Proyecto de curso GameDev.tv; licencia de reutilización de código y assets no confirmada en la inspección. | Referencia visual de un prototipo de fútbol Godot. | No incorporar código ni assets sin comprobar derechos y atribuciones de cada recurso. |

### Principios técnicos extraídos, sin copiar implementación

- Mantener un límite claro entre entrada del jugador, controlador de partido, reglas y presentación/HUD.
- Probar el balón con escenarios reproducibles: impulso, rebote, fricción, límites del campo y reinicio después de gol.
- Separar las reglas de un partido 11v11 de los prototipos 2D o de fútbol 5v5.
- Evitar elevar la versión del motor o agregar extensiones nativas solo para aprovechar una demo; la compatibilidad Android ARM64 y el build de GitHub Actions tienen prioridad.


## Otras alternativas examinadas

| Repositorio | Licencia / tecnología | Idea útil | Decisión |
|---|---|---|---|
| [angree/openswos](https://github.com/angree/openswos) | MIT confirmada en `LICENSE`; Godot 4 + C#; requiere que el usuario aporte archivos originales de Sensible World of Soccer. | Cobertura de movimiento, balón, porteros, entradas, reinicios, lesiones, árbitro y descanso. | Referencia de amplitud funcional; no adoptar C# ni reutilizar los assets propietarios de SWOS. |
| [gaemi/agentic-fc](https://github.com/gaemi/agentic-fc) | MIT confirmada; Go; simulación de gestión operada por agentes, con semilla y eventos auditables. | Reproducibilidad, registro de eventos y calibración de simulaciones de temporada. | Solo ideas para futuras simulaciones de gestión; no añadir Go ni MCP al APK. |
| [lel1guy/FootPong](https://github.com/lel1guy/FootPong) | MIT confirmada; Godot 4.6 y GDScript; juego 2D tipo Pong. | Marcador, reinicio de balón y pausa sencilla. | Referencia menor de UI; no aporta simulación 3D 11v11 y usa otra versión de Godot. |
| [ODS-RL/football-env](https://github.com/ODS-RL/football-env) | MIT confirmada; Python; simulación 2D para agentes con semillas reproducibles y repetición de logs. | Reproducibilidad de IA y registro de partidos. | Referencia conceptual; no integrar Python ni el entorno 2D en el juego Android. |
| [openfootmanager/openfootmanager](https://github.com/openfootmanager/openfootmanager) | GPLv3 confirmada en `LICENSE.md`; Rust, Tauri y React. | Ideas de simulación de gestión de clubes. | No incorporar código por diferencia de stack y obligaciones copyleft; estudiar solo conceptos generales. |
| [richardschembri/GodotBasic3DFootball](https://github.com/richardschembri/GodotBasic3DFootball) | No se encontró archivo LICENSE en la revisión; demo GDScript 3D de dos jugadores. | Referencia de prototipo 3D y controles básicos. | No copiar código ni assets; además, el proyecto declara recursos de terceros que requieren licencias separadas. |

La revisión amplía el panorama, pero no cambia la decisión técnica: el juego base conserva GDScript/Godot 4.4.1, offline-first y sin dependencias nativas o servicios externos obligatorios.


## Revisión ampliada de referencias públicas — 19 de noviembre de 2026

Se revisaron referencias adicionales para UI de partido, plantillas, estadios y simulación. La consulta no autoriza copiar automáticamente código, nombres, plantillas, imágenes ni recursos; cada archivo y dependencia debe conservar su licencia y procedencia.

| Repositorio | Licencia / stack verificados | Ideas aprovechables | Decisión para Fútbol Nova |
|---|---|---|---|
| [awest813/League-Soccer](https://github.com/awest813/League-Soccer) | Apache-2.0 en LICENSE; C++17/CMake, orientado a Linux/macOS/Windows. Declara motor 3D 22 jugadores, IA táctica, física, árbitro y HUD. | Lista de eventos de partido, separación del motor y presentación, métricas de posesión/tiros, roles de IA y arquitectura de pruebas. | No portar su motor C++ al APK Godot ni mezclar dependencias desktop. Convertir solo necesidades en pruebas y módulos GDScript independientes. Si se reutilizara código en el futuro, incluir LICENSE, NOTICE y atribuciones Apache-2.0 y auditar la ascendencia GameplayFootball/Google Research Football por separado. |
| [antxiko/OpenComputerFutbolSimulator](https://github.com/antxiko/OpenComputerFutbolSimulator) | MIT para código fuente según LICENSE; Godot 4.6.2/GDScript. Su propio LICENSE separa explícitamente los datos de clubes/jugadores de la licencia del código. | Datos JSON por equipo, validación de plantillas, generador idempotente, semilla reproducible, atributos data-driven y pantallas de plantilla/calendario. | Referencia de arquitectura de datos y pruebas. No importar sus JSON de clubes/jugadores ni asumir que están cubiertos por MIT; Godot 4.6.2 no coincide con 4.4.1. |
| [AKM-8byte/FreeKick](https://github.com/AKM-8byte/FreeKick) | MIT en LICENSE; Godot 4.7.2 según README, entrenamiento de tiros libres 3D. | Diseño de cámara de entrenamiento, contacto con balón, objetivos visuales y replays. | Referencia conceptual de un modo de práctica futuro; no copiar assets, modelos o código ni cambiar el motor del juego base para adoptarlo. |
| [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) | README declara Godot 4.7.1, GDScript y servidor Node/PostgreSQL; no se encontró LICENSE en la raíz consultada. | Lobby, tutorial, premios, telemetría, pruebas de colisiones y flujos de partido. | Solo referencia UX. No reutilizar código/assets sin licencia verificable; su diseño arcade 4v4 y arquitectura online no corresponden al 11v11 offline. |
| [Tobilion/footysim](https://github.com/Tobilion/footysim) | Motor espacial 11v11 tick-driven; Python. Licencia no confirmada en esta revisión. | Casos de simulación reproducible, eventos de pase/intercepción/entrada y métricas derivadas de geometría. | Solo lista de ideas de pruebas; no añadir Python al APK ni copiar código/datos. |
| [PDXDJN/GodotGamesList](https://github.com/PDXDJN/GodotGamesList) | Catálogo comunitario de repositorios; no es motor de juego. | Descubrir demos Godot de fútbol y revisar licencias antes de evaluar. | Usarlo como índice de descubrimiento, no como fuente de código ni de derechos. |

### Acciones derivadas para el proyecto

1. Mantener la pantalla de preparación como fuente única de selección de local, visitante, titulares, duración y estadio; validar que las IDs de jugadores pertenecen al club seleccionado y que no se repiten.
2. Mantener las plantillas separadas de las escenas: JSON/registro local con IDs estables, posición, atributos y procedencia. No tratar perfiles ficticios como plantillas oficiales reales.
3. Extender pruebas de UI para navegación de las cuatro pantallas principales, categorías de Configuración, filtros de clubes, cambios de estadio, escalado compacto Android y estados deshabilitados con explicación.
4. Derivar las estadísticas del HUD de eventos reales del controlador 11v11; no generar posesión, tiros o precisión por valores decorativos.
5. Medir coste de CPU y memoria de 22 jugadores y del estadio procedural en Android ARM64 antes de aumentar polígonos, luces o efectos.
6. Mantener la exportación reproducible en GitHub Actions con Godot 4.4.1 y no declarar APK terminada hasta que importación, todas las pruebas y exportación ARM64 concluyan correctamente.

**Fuentes consultadas:** README y LICENSE de los repositorios enlazados arriba. No se copiaron archivos de terceros en esta revisión.


## Revisión adicional de repositorios públicos — 19 de noviembre de 2026

| Repositorio | Licencia / tecnología comprobadas | Valor como referencia | Decisión |
|---|---|---|---|
| [TechAoba/soccer-game](https://github.com/TechAoba/soccer-game) | MIT confirmada en LICENSE; Godot/GDScript; demo 2D en desarrollo. | Organización de escenas, recursos, shaders y utilidades en un proyecto Godot pequeño. | Referencia de estructura solamente. No aporta un motor 3D 11v11; si se reutiliza código en el futuro, conservar el aviso MIT y auditar individualmente los assets. |
| [modelence/open-soccer](https://github.com/modelence/open-soccer) | React/TypeScript/Canvas, Modelence y opción Expo; no se encontró LICENSE en la raíz consultada. | Separación del motor por dominios, cámara broadcast, HUD, práctica y estructura de datos para 11v11. | Solo estudiar conceptos de arquitectura. No copiar código, recursos ni datos sin licencia verificable; no adoptar Modelence, CDN, backend ni dependencias web en Fútbol Nova. |

La revisión de [openfootmanager/openfootmanager](https://github.com/openfootmanager/openfootmanager) también confirma GPL-3.0 en LICENSE.md; su simulación de gestión puede inspirar pruebas de temporada, pero no se incorpora código debido al stack Rust/Tauri/React y a las obligaciones copyleft. Esta referencia ya se había registrado anteriormente y se vuelve a comprobar su licencia.

**Conclusión:** no se incorporó código ni assets externos en esta ronda. Se mantiene Godot 4.4.1, GDScript, Android ARM64 y funcionamiento offline; las referencias solo generan ideas para pruebas y arquitectura.