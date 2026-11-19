# Anexo de investigación pública — 18 de noviembre de 2026

Este anexo amplía `PUBLIC_GITHUB_RESEARCH_2026-11-18.md`. Se consultaron páginas públicas de GitHub y la documentación oficial de Godot 4.4. No se copió código, escenas, modelos, texturas, animaciones, música ni datos de terceros.

## Repositorios adicionales examinados

| Repositorio | Evidencia pública revisada | Aplicación posible | Decisión |
|---|---|---|---|
| [Jameshskelton/PK_Shootout](https://github.com/Jameshskelton/PK_Shootout) | Juego de penaltis 2D en Godot 4; turnos alternos, portero IA y reglas de tanda. La licencia reutilizable no quedó confirmada en esta revisión. | Casos de prueba de tanda, alternancia, desempate y estados del portero. | Referencia funcional únicamente. No reutilizar código ni assets hasta verificar licencia y derechos por archivo. |
| [devinarena/Pixel-Striker](https://github.com/devinarena/Pixel-Striker) | Juego móvil Godot con tiros libres, modo portero y penaltis; la auditoría principal ya lo registra como MIT declarado. | Diseño de modos de práctica, interacción táctil y flujo de exportación móvil. | Adaptar ideas, no trasladar su juego 2D ni sus recursos al simulador 3D 11v11. |
| [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball) | Port de GameplayFootball a Godot 4.4.1 con GDExtension C++, física y lógica de partido; no se verificó una licencia aplicable en el repositorio examinado. | Comparar arquitectura de física, árbitro y posicionamiento de 22 jugadores. | No incorporar código. La extensión nativa aumenta complejidad de toolchain y mantenimiento Android; mantener GDScript como primera opción. |
| [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) | Juego Godot 4.7.1 con física rígida, porteros IA, telemetría y red autoritativa; licencia reutilizable no confirmada. | Ideas de telemetría, desconexión, control de estado y pruebas de colisión. | No incorporar código ni dependencias de servidor. La versión y el diseño arcade no coinciden con el proyecto offline Godot 4.4.1. |
| [Jameshskelton/PK_Shootout](https://github.com/Jameshskelton/PK_Shootout) | La página describe una tanda con cinco tiros por equipo y muerte súbita si hay empate. | Diseñar pruebas unitarias para la futura tanda de penaltis de Fútbol Nova. | No declarar la tanda integrada por estudiar este proyecto; implementar reglas propias y verificarlas contra el reglamento documentado. |

## Documentación oficial consultada

- [Godot 4.4 — controles, gamepads y joysticks](https://docs.godotengine.org/en/4.4/tutorials/inputs/controllers_gamepads_joysticks.html): recomienda mapear acciones comunes en Input Map y permite controles en Android. La guía advierte que el soporte de mandos en plataformas móviles utiliza una implementación distinta y puede ser menos fiable; probar mandos reales en Android sigue siendo necesario.
- [Godot 4.4 — clase Input](https://docs.godotengine.org/en/4.4/classes/class_input.html): `Input.get_vector()` ofrece vector limitado y zona muerta circular, útil para unificar movimiento analógico y direccional.
- [Godot 4.4 — ejemplos de entrada](https://docs.godotengine.org/en/4.4/tutorials/inputs/input_examples.html): diferencia eventos puntuales de pulsación y lectura continua del estado de entrada.

## Acciones técnicas priorizadas

1. Mantener Godot 4.4.1 y GDScript en la compilación principal; no actualizar a 4.6/4.7 solo para adoptar ejemplos externos.
2. Completar pruebas deterministas del modelo de vuelo, contacto con marco/red, reinicios, reloj y estados de partido.
3. Verificar que un gol solo se registra con el partido activo, balón en juego y orientación correcta tras cada descanso.
4. Mantener un único contrato de entrada para pantalla táctil y gamepad; usar vectores normalizados y zonas muertas configurables, sin depender de que Android interprete todos los mandos igual.
5. Probar en Android físico los controles táctiles, gamepad, rendimiento de 22 jugadores y consumo de memoria antes de publicar APK.
6. No afirmar que CI pasó por el mero hecho de que el workflow exista: exigir un run con runner asignado, pasos ejecutados y artefacto APK no vacío.

## Límites de esta revisión

La búsqueda pública aporta patrones y casos de prueba, no evidencia de que esas funciones ya estén implementadas en Fútbol Nova. No se copiaron archivos externos. Antes de cualquier reutilización se debe verificar la licencia del commit exacto y de cada asset/dependencia, conservar avisos y documentar atribución. Los resultados de Godot 4.4 no sustituyen una prueba real del APK en Android.
