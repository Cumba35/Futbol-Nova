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
