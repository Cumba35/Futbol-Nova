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


## Revisión pública adicional — 19-11-2026 (segunda pasada)

| Repositorio | Hallazgo | Decisión |
|---|---|---|
| [lel1guy/FootPong](https://github.com/lel1guy/FootPong) | MIT declarada; Godot 4.6/GDScript, prototipo 2D tipo Pong con marcador, reinicio de balón y pausa; documenta exportación Android. | Referencia pequeña para estados de marcador/pausa y empaquetado Android. No portar el juego 2D ni sustituir el motor 3D 11v11; versión distinta. |
| [devinarena/Pixel-Striker](https://github.com/devinarena/Pixel-Striker) | MIT declarada; juego móvil Godot con tiros libres, portero y penaltis. | Referencia de UX móvil y preferencias. No importar assets ni escenas sin revisar sus atribuciones individuales; no cubre amistosos 11v11. |
| [AhkunTa/soccer-online](https://github.com/AhkunTa/soccer-online) | Godot 4.6, GDScript, 6v6 local y base multijugador/torneos; licencia no confirmada en esta revisión. | No reutilizar código ni recursos hasta confirmar licencia; la arquitectura online no es necesaria para el modo offline base. |
| [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) | Godot 4.7.1, físicas 3D y modo local/online; licencia no confirmada. | No incorporar. Referencia conceptual de pruebas físicas y autoridad de partido; incompatible por versión y enfoque arcade. |
| [pdimitrop/Armistice](https://github.com/pdimitrop/Armistice) | MIT declarada; Godot 4.7, fútbol 3D de tesis; README advierte que el repo contiene código fuente y no todos los assets ejecutables. | Solo ideas de estructura de escenas 3D; no portar por versión/renderer y recursos externos. |

No se ha copiado código, escenas ni recursos de estos proyectos. Se mantiene el criterio de compatibilidad con Godot 4.4.1, GDScript, Android ARM64 y juego offline. Las licencias declaradas en README deben confirmarse en los archivos LICENSE antes de cualquier reutilización concreta.


## Revisión de proyectos móviles Godot — 19-11-2026 (tercera pasada)

| Repositorio | Licencia / tecnología revisada | Utilidad y límites | Decisión |
|---|---|---|---|
| [etherealxx/cornucobia](https://github.com/etherealxx/cornucobia) | LICENSE Apache-2.0 leído; Godot 4.3; Android; el README distingue código/escenas/recursos propios de addons, shaders y arte externo. | Referencia de exportación móvil, organización de recursos y créditos/licencias. Su juego es 2D de plataformas, no aporta simulación futbolística. | Estudiar prácticas de empaquetado y control de licencias; no importar arte, addons, shaders ni código. |
| [Cohen-Mini/SoccerCareerSimulator](https://github.com/Cohen-Mini/SoccerCareerSimulator) | Godot 4.7/GDScript, managers de calendario/guardado/mundo; no se encontró LICENSE. | Ideas de separación de gestores para futura carrera y progresión. Versión distinta y derechos no confirmados. | No copiar ni integrar; solo referencia conceptual hasta que exista licencia verificable. |

No se importó código ni assets. En Cornucobia, aunque el código principal declara Apache-2.0, los recursos gráficos y addons tienen licencias separadas; no se asume que todo el repositorio tenga una única licencia. Se mantiene la prioridad Android ARM64, Godot 4.4.1, GDScript y modo offline.

## Revisión adicional — compatibilidad GDScript y referencias Android (19-11-2026)

- Documentación oficial de Godot: [GDScript basics](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_basics.html) y [migración a Godot 4](https://docs.godotengine.org/en/latest/tutorials/migrating/upgrading_to_godot_4.html). La auditoría del test detectó que `StringName` y `String` son tipos distintos; los nombres de nodo se convierten explícitamente con `String(node.name)` antes de aplicar operaciones de texto.
- [lel1guy/FootPong](https://github.com/lel1guy/FootPong): MIT declarada, Godot 4.6/GDScript, Android export, menú de pausa y reinicio de balón. Se conserva como referencia de flujo móvil y pruebas de estados; no se traslada el prototipo 2D a la simulación 3D 11v11.
- [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball): referencia para física, árbitro y 22 jugadores en Godot 4.4.1, pero depende de GDExtension/C++/SCons. Se mantiene fuera del APK para no introducir complejidad de compilación ARM64 sin necesidad demostrada.
- No se copió código ni assets externos. Se priorizan GDScript, Godot 4.4.1, renderer GL Compatibility, Android ARM64 y funcionamiento offline.

## Exploración adicional de repositorios públicos — 19-11-2026

- [blurz17/blurz-native-football-](https://github.com/blurz17/blurz-native-football-): proyecto Android ARM64 nativo (SDL2/JNI/OpenGL ES/ODE), con documentación sobre controles táctiles, cámara, modo entrenamiento y pausa. Su arquitectura no es Godot y el README consultado no permite confirmar una licencia inequívoca para el conjunto del repositorio; **no copiar ni integrar** hasta verificar cada licencia y dependencia. Se conserva como referencia conceptual de HUD táctil y rendimiento móvil.
- [antxiko/OpenComputerFutbolSimulator](https://github.com/antxiko/OpenComputerFutbolSimulator): simulador manager en Godot 4.6.2/GDScript con datos JSON, simulación determinista, temporadas, plantillas y guardados. Es útil para estudiar separación de datos y reproducibilidad, pero no se importa por la diferencia de versión y alcance; revisar la licencia exacta antes de reutilizar cualquier archivo.
- [mamipour/shootball](https://github.com/mamipour/shootball): Godot 4.6, juego 2D con Nakama y física autoritativa de servidor; licencia CC BY-NC 4.0 según README, por lo que no es apto para integrar en un producto comercial ni para copiar recursos. Solo referencia conceptual de sincronización online; Fútbol Nova mantiene el modo local/offline como base.
- Criterio de integración: mantener el motor Godot/GDScript actual, evitar dependencias C++/JNI o servicios online para funciones básicas, y adoptar patrones solo tras validar compatibilidad con Godot 4.4.1, Android ARM64, licencia y pruebas.


## Revisión pública adicional — 19-11-2026 (cuarta pasada)

- [RobinNunkesser/gd-godot-crazy-cage-football](https://github.com/RobinNunkesser/gd-godot-crazy-cage-football): licencia MIT confirmada leyendo `LICENSE`; Godot 4.7, GDScript, física 3D, overlay táctil y prueba headless. Puede orientar la organización de controles táctiles y pruebas de estado, pero el diseño arcade de jaula y la versión 4.7 no permiten trasladarlo directamente a Fútbol Nova (Godot 4.4.1). No se copió código ni assets.
- [Tobilion/footysim](https://github.com/Tobilion/footysim): motor headless 11v11 por ticks con agentes, geometría de campo, acciones resueltas a partir de atributos y pruebas; implementación Python. El README consultado no acredita una licencia reutilizable, así que no copiar ni integrar. Referencia conceptual para ampliar escenarios deterministas de IA, pases, intercepciones, entradas y tiros.
- [GPTmadeit/ashfall](https://github.com/GPTmadeit/ashfall): proyecto móvil Android en Godot 4.5+ / GDScript con pruebas automatizadas y checklist explícito de pruebas en dispositivo; no es un juego de fútbol y no se importa. Referencia de buenas prácticas para separar pruebas automatizadas de validación real en Android; su renderer/versión tampoco coincide con el objetivo actual.
- [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game): Godot 4.7.1, GDScript, física 3D, partidos locales, IA de portero y telemetría; la licencia no se confirmó en el README consultado. No reutilizar código ni assets. La arquitectura de telemetría y pruebas es una referencia conceptual, no una dependencia.
- Decisión: no añadir dependencias de terceros en esta pasada. Mantener Godot 4.4.1, GDScript, GL Compatibility, Android ARM64 y modo offline; cualquier integración requiere licencia verificable, revisión de assets/dependencias y pruebas de compatibilidad.


## Revisión pública adicional — 19-11-2026 (quinta pasada)

- [devinarena/Pixel-Striker](https://github.com/devinarena/Pixel-Striker): licencia MIT confirmada leyendo el archivo `LICENSE` del repositorio; proyecto Godot/GDScript móvil de tiros libres, portero y penaltis, con preferencias y servicios de juego. Su proyecto es 2D y no reemplaza el partido 3D 11v11. Referencia conceptual de UX móvil y preferencias; no se importaron escenas ni assets.
- [RETDESK/Soccer-KickOff](https://github.com/RETDESK/Soccer-KickOff): repositorio declara MIT y es un juego 2D de fútbol en Godot. Puede servir como referencia de organización sencilla de escenas, pero no aporta simulación 3D ni lógica 11v11. No se copiaron archivos ni assets.
- [modelence/open-soccer](https://github.com/modelence/open-soccer): juego 11v11 de navegador con reglas, cámara de retransmisión, controles reasignables y motor separado en lógica, render, proyección, matemáticas y tipos. Utiliza React/TypeScript/Canvas y no se encontró archivo LICENSE en la raíz revisada; se conserva solo como referencia arquitectónica y no se copia ni adapta código.
- Se reexaminó [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game): el archivo `project.godot` declara Godot 4.7.1; no se encontró `LICENSE` en la raíz. Su juego es 3v3 más porteros, arcade y con servicios online; no se integra en Fútbol Nova.
- Decisión: mantener Godot 4.4.1, GDScript, GL Compatibility, Android ARM64 y funcionamiento offline. Las ideas de controles, cámara, separación de lógica y pruebas se implementan de forma original; no se importó código ni assets externos.


## Revisión pública adicional — controles táctiles y UI móvil (19-11-2026)

- [HubbleCommand/mobile_controls](https://github.com/HubbleCommand/mobile_controls): licencia MIT comprobada leyendo `LICENSE`; `project.godot` declara Godot 4.3 y GL Compatibility. El addon contiene joystick virtual, detección de gestos multitáctiles y puente de botones para móvil. Es el candidato más cercano al motor/renderer actual para estudiar controles táctiles. La revisión del código detectó que el joystick emite `InputEventJoypadMotion` y depende de que se configuren ejes válidos; no se copia ni activa sin adaptar el mapeo a las acciones de Fútbol Nova y probar simultaneidad, liberación del dedo, pausas y Android ARM64.
- [ConcreteBerryGames/GodotMobileBoilerplate](https://github.com/ConcreteBerryGames/GodotMobileBoilerplate): el README declara MIT y Godot 4.4.1; el proyecto de ejemplo usa Forward+ y está orientado a un juego 2D vertical, por lo que no se integra. Referencia de escalado de UI, guardado, diálogos de confirmación y localización, que deben implementarse de forma nativa en las pantallas de Fútbol Nova.
- [thruthesky/gohud](https://github.com/thruthesky/gohud): MIT y GDScript puro, pero su README exige Godot 4.7+; no es compatible con la base 4.4.1 sin migrar el motor. No integrar ni copiar. Queda como referencia visual futura para paneles redondeados, HUD y accesibilidad.
- Decisión de esta pasada: no añadir addons ni cambiar el motor durante la validación CI en curso. La prioridad es conservar GL Compatibility, Android ARM64 y modo offline; cualquier adopción futura exige revisión de todos los archivos/assets del addon, mapeo explícito de InputMap y pruebas de regresión.


## Revisión pública adicional — joystick táctil, personajes y ajustes (19-11-2026)

- [JoenTNT/godot_thumbstick_addon](https://github.com/JoenTNT/godot_thumbstick_addon): licencia MIT leída; GDScript; `project.godot` declara Godot 4.4 y GL Compatibility. Incluye joystick virtual con modos estático/dinámico/seguimiento, zona muerta, umbral de activación, señales de pulsación/liberación y escenas de ejemplo. Es el candidato más próximo a la base actual para prototipar el joystick de Android. No se integra todavía: hay que enlazar sus señales a las acciones de movimiento originales, asegurar que la liberación siempre devuelve el vector a cero, probar multitouch con pase/tiro y revisar todos los recursos/atribuciones antes de copiar archivos. Su controlador multitáctil separado marca explícitamente que es un prototipo sin terminar; no usar esa parte.
- [MarkVelez/godot-modular-settings-menu](https://github.com/MarkVelez/godot-modular-settings-menu): MIT leída; framework de ajustes para Godot 4 con persistencia/validación, secciones de gráficos, controles y audio. El repositorio no aporta una versión de motor exacta en un `project.godot` raíz y varios ajustes gráficos están pensados para PC/renderer avanzado; conservar como referencia de organización y persistencia, no importar el menú completo. Adaptar de forma original solo las opciones que existan en Fútbol Nova y funcionen en Android GL Compatibility.
- [MacdonaldRobinson/godot4-3d-characters](https://github.com/MacdonaldRobinson/godot4-3d-characters): MIT leída; proyecto Godot 4.3, GL Compatibility; incluye selector de personaje, AnimationTree/AnimationPlayer, cámara y joystick virtual. Referencia útil para el futuro selector 3D de equipaciones/personajes y flujo de animaciones. No portar el proyecto entero: contiene muchos recursos y dependencias (incluidos modelos/animaciones y addon de terreno) que requieren licencias/atribuciones separadas y no están diseñados para fútbol 11v11.
- [Maaack/Godot-Options-Menus](https://github.com/Maaack/Godot-Options-Menus): README dice Godot 4.7 (compatible 4.4+) y persistencia/accesibilidad; la API de repositorio no expone licencia y no se encontró archivo LICENSE en la raíz examinada. No reutilizar código ni recursos hasta confirmar licencia en un commit concreto; se mantiene solo como referencia de características.
- [Kazox61/GodotMobileControls](https://github.com/Kazox61/GodotMobileControls): metadatos y README/licencia no bastaron para confirmar derechos ni compatibilidad. No reutilizar.

Decisión: el joystick de JoenTNT es el único candidato que merece una prueba aislada después de cerrar la CI actual; todavía no se incorpora ni se reemplaza la entrada existente. La UI de pausa, equipaciones y ajustes se seguirá desarrollando de forma nativa, respetando el renderer GL Compatibility, Godot 4.4.1, Android ARM64 y modo offline.
