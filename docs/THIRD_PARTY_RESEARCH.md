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


## Revisión adicional — 18-11-2026

- `AKM-8byte/FreeKick`: MIT confirmada; el proyecto usa Godot 4.7.2. Solo referencia conceptual de física y pruebas de tiros libres; no se copia código ni assets por diferencia de versión y alcance.
- `richardschembri/GodotBasic3DFootball`: GDScript 3D, sin licencia identificada por la API de GitHub; no reutilizar código ni assets.
- `bowman290/godot-football`: GDScript, sin licencia identificada; no reutilizar código ni assets.
- No se incorporan dependencias externas. La versión Godot 4.4.1 y la ejecución offline/Android siguen siendo obligatorias.

## Investigación adicional de proyectos públicos — 19-11-2026

| Repositorio | Licencia revisada | Motor / enfoque | Decisión para Fútbol Nova |
|---|---|---|---|
| RobinNunkesser/gd-godot-crazy-cage-football | MIT (LICENSE leído) | Godot 4.7, física 3D, overlay táctil, test headless | Referencia útil para organización de overlay táctil, estados de partido y pruebas. No portar directamente por diferencia con Godot 4.4.1 y diseño arcade de jaula; no se copiaron assets. |
| pdimitrop/Armistice | MIT (LICENSE leído) | Godot 4.7, fútbol 3D | Referencia conceptual de arquitectura y escenas 3D; no importar por versión 4.7, Forward+ y dependencia de assets externos grandes. |
| namelesssyf/soccer-box-game | No declarada en metadatos revisados | Godot 4.7.1, física 3D arcade y tests | No copiar ni reutilizar código/assets sin licencia explícita. |
| erengaygusuz/fotbiler-football | No confirmada en esta revisión | Simulación 22 jugadores, IA táctica, árbitro, carrera; código C++ propio | Referencia de funcionalidades y casos de prueba, no compatible como dependencia Godot/GDScript. |

No se añadió código externo en esta revisión. Se mantiene Godot 4.4.1, Android ARM64, renderer y recursos compatibles con móviles, y juego offline. Cualquier incorporación futura requiere revisar el archivo LICENSE de cada componente y registrar atribución.


## Revisión pública adicional — 19-11-2026

| Repositorio | Hallazgo | Decisión |
|---|---|---|
| `angree/openswos` ([GitHub](https://github.com/angree/openswos)) | Recreación de SWOS en Godot 4 + C#, licencia MIT declarada; material de estudio sobre reglas, balón, porteros, entradas y ritmo de partido. | No portar directamente: C# y arquitectura diferentes, además depende de archivos de juego originales que el usuario debe aportar. Estudiar patrones sin copiar assets. |
| `antxiko/OpenComputerFutbolSimulator` ([GitHub](https://github.com/antxiko/OpenComputerFutbolSimulator)) | Godot 4.6.2/GDScript; motor determinista, datos JSON, calendario, ascensos/descensos, carrera y guardados. | Útil para comparar simulación reproducible y datos. No portar archivos hasta verificar licencia y adaptar a Godot 4.4.1. |
| `aliyavuzz/Godotball` ([GitHub](https://github.com/aliyavuzz/Godotball)) | Godot 4.4.1, Apache-2.0 declarado, motor C++/GDExtension con SCons para física, árbitro y 22 jugadores. | Coincide la versión, pero la compilación nativa aumenta el riesgo de Android ARM64 y el tamaño. Referencia técnica, sin dependencia incorporada. |
| `namelesssyf/soccer-box-game` ([GitHub](https://github.com/namelesssyf/soccer-box-game)) | Godot 4.7.1, físicas, control local y online; licencia no confirmada en los datos consultados. | Solo referencia conceptual; no reutilizar código ni assets sin licencia y adaptación confirmadas. |
| `openfootmanager/openfootmanager` ([GitHub](https://github.com/openfootmanager/openfootmanager)) | Manager con simulación por eventos, SQLite y arquitectura Rust/Tauri/React; GPL-3.0. | Referencia de diseño para gestión y persistencia, no dependencia directa: tecnología distinta y copyleft GPL incompatible con una integración no revisada. |

No se importó código externo en esta revisión. Se priorizan Godot 4.4.1, GDScript, Android ARM64, ejecución offline y licencias compatibles.
