# Investigación complementaria de GitHub — Fútbol Nova

**Fecha:** 19-11-2026  
**Proyecto:** Godot 4.4.1, GDScript, Android ARM64, juego local/offline.  
**Política:** estudiar patrones y arquitectura; no importar código, datos, marcas, imágenes, modelos ni sonidos sin verificar derechos y compatibilidad individual.

## Nuevos repositorios públicos examinados

| Repositorio | Enfoque observado | Aprendizaje aplicable | Decisión |
|---|---|---|---|
| [modelence/open-soccer](https://github.com/modelence/open-soccer) | Juego de fútbol arcade 11v11 en navegador, React/TypeScript y Canvas; motor dividido en lógica, tipos, matemáticas, proyección, render y UI; IA CPU, reglas y controles configurables. | Mantener la lógica de partido independiente de la representación visual, usar tipos/contratos claros y aislar entrada, reglas y HUD. | No trasladar React/Canvas al proyecto Godot. No copiar código ni recursos; revisar licencia y cada dependencia antes de cualquier reutilización. |
| [haeretici/soccer-js](https://github.com/haeretici/soccer-js) | Motor 2D isométrico JavaScript con paso fijo de simulación, semilla determinista, IA de equipos, reglas, jugadas a balón parado, pruebas y simulación headless. | Reproducibilidad de partidos, pruebas por escenarios, telemetría y separación entre simulación y render. | Referencia de diseño; no añadir JavaScript/Node al APK ni sustituir el motor 3D GDScript. No se copió código ni assets. |
| [Colhodm/FIFA](https://github.com/Colhodm/FIFA) | Simulador 3D en navegador con simulación determinista, física de balón, jugadores controlados cinemáticamente, validaciones de snapshots, pruebas y simulaciones headless. | Separar estado de partido serializable, reglas y simulación de la capa 3D; probar que cada partido alcanza el final y que el estado físico es finito. | El README no declara una licencia de reutilización; solo estudio conceptual. No copiar código ni assets. |
| [Yeyo-Dev/Soccer_league_game](https://github.com/Yeyo-Dev/Soccer_league_game) | Prototipo 2D HTML Canvas con selección de equipos, formaciones, atributos, IA y controles táctiles. | Revisar accesibilidad táctil y consistencia entre controles de teclado y pantalla. | Prototipo experimental sin licencia declarada; no reutilizar código ni assets. |
| [cheapsnack/basicfootball](https://github.com/cheapsnack/basicfootball) | Juego 3D 11v11, tiros libres/penaltis, física híbrida, IA y pruebas de lógica; React Three Fiber/Rapier. | Pruebas puras de lógica de juego y separación entre cuerpos físicos y movimiento de jugadores. | Stack y dependencia física distintos; estudiar conceptos, sin portar el motor ni añadir dependencias. |

## Mejoras y criterios que se incorporan al plan de Fútbol Nova

1. **Simulación reproducible:** cada escenario crítico debe poder ejecutarse con semilla conocida para localizar fallos de IA, pases, tiros, goles y reglas.
2. **Estado desacoplado:** los datos esenciales del partido (tiempo, marcador, posesión, jugadores, balón y eventos) deben poder inspeccionarse y serializarse sin depender de nodos visuales.
3. **Pruebas headless:** ampliar pruebas por escenario y conservar la misma lógica de partido que utiliza la escena jugable.
4. **Entrada táctil robusta:** mantener pruebas multitáctiles, joystick, liberación de acciones y controles de pase/tiro.
5. **Separación de subsistemas:** IA, reglas, física, entrada, presentación y HUD deben evolucionar sin acoplamientos innecesarios.
6. **Compatibilidad prioritaria:** no elevar Godot 4.4.1 ni añadir motores nativos/web o backend online al modo amistoso offline sin una necesidad probada.

## Límites de la investigación

La existencia de un repositorio público no equivale a permiso de reutilización. La licencia del código no cubre automáticamente dependencias, escudos, uniformes, fotografías, música, nombres comerciales ni bases de datos. Si una licencia no está clara, se implementa una solución original inspirada únicamente en ideas generales.

**Resultado:** esta ronda añade referencias y criterios de diseño; no se incorporó código externo ni se añadieron dependencias al juego.



## Segunda ronda de investigación — 20-11-2026

| Repositorio | Hallazgo relevante | Aplicación a Fútbol Nova | Licencia / límite |
|---|---|---|---|
| [devinarena/Pixel-Striker](https://github.com/devinarena/Pixel-Striker) | Juego móvil Godot; minijuegos de portero y penaltis donde el guardameta decide una estirada según la dirección del balón. | Referencia directa para una futura capa de reacción/estirada del portero y controles móviles; separar el minijuego de penaltis del amistoso 11v11. | MIT confirmada por GitHub. Proyecto pequeño y con última actividad antigua; no se copió código ni recursos. |
| [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) | Godot 4, balón rígido, partidos locales, portero IA y pruebas automatizadas; orientado a fútbol arcade 3v3 y multijugador. | Revisar telemetría, control de balón y pruebas de física; no trasladar su combate/online al amistoso. | GitHub no declara licencia en los metadatos consultados; solo observación conceptual, no reutilizar código/assets. |
| [modelence/open-soccer](https://github.com/modelence/open-soccer) | Partido CPU 11v11 con saques, córners, saques de banda, fuera de juego, control de jugador y práctica libre; motor web separado por dominio. | Referencia para lista de reglas y separación motor/HUD; convertir la lista en pruebas de aceptación para el modo amistoso. | GitHub no declara licencia en los metadatos consultados; no copiar código/assets. |
| [ogulcanunverenpt-star/purpleshoe](https://github.com/ogulcanunverenpt-star/purpleshoe) | Godot 4.7, partido 11-a-side con 10 jugadores de campo y un portero por lado, IA de equipo y reinicios; además integra servicios online. | Comparar roles, selección de jugador, situaciones de reinicio y límites entre juego local/online. | Licencia no confirmada en los metadatos consultados; no copiar código/assets. Requiere Godot más nuevo y su backend no es necesario para el modo offline. |
| [FlavioMili/Player12](https://github.com/FlavioMili/Player12) | Simulación C++23 con portero, reglas, tácticas, fatiga y estadísticas de partido. | Lista de sistemas a cubrir en futuras fases: tiros a puerta, atajadas, posesión y fatiga. | No es un proyecto Godot/Android; no portar motor ni dependencias. |

### Cambios de diseño derivados de la investigación

- Se mantiene Godot 4.4.1 y el motor GDScript existente; no se incorpora una dependencia externa para resolver IA de portero.
- Se añadió seguimiento lateral del portero limitado al espacio entre postes y una predicción de cruce basada en velocidad del balón, con horizonte máximo de 1,25 s para evitar oscilaciones.
- La prueba de posicionamiento verifica ambos equipos, cambio de lado, límite entre postes y anticipación solo cuando el balón viaja hacia la propia portería.
- La futura estirada/blocaje/rebote se mantiene como tarea separada: el posicionamiento predictivo no equivale todavía a una atajada física.
- Se reforzó la prueba de remate para verificar que el balón se impulsa físicamente hacia la portería rival.

**Política de reutilización:** Pixel-Striker es MIT, pero no se copió código; en los demás repositorios se estudian únicamente ideas generales hasta confirmar licencia y dependencias. Ningún escudo, camiseta, imagen, sonido ni base de datos externa se incorpora en esta ronda.


## Tercera ronda de investigación — 20-11-2026

| Repositorio | Observación útil | Decisión para Fútbol Nova | Licencia / límites |
|---|---|---|---|
| [Tobilion/footysim](https://github.com/Tobilion/footysim) | Motor de simulación 11v11 headless con agentes, geometría, pases, intercepciones, tiros y métricas calculadas a partir del estado espacial. | Referencia para ampliar estadísticas y escenarios de aceptación de partido completo; no trasladar su motor Python al APK Godot. | API de GitHub devuelve `license: null`; no copiar código ni datos. |
| [ageraustine/marl-football](https://github.com/ageraustine/marl-football) | Entorno multiagente 11-a-side configurable, simulación separada del render y pipeline de entrenamiento. | Referencia conceptual para mantener simulación y representación desacopladas y evaluar IA por escenarios. | No se verificó licencia compatible en esta revisión; solo estudio conceptual. |
| [AKM-8byte/FreeKick](https://github.com/AKM-8byte/FreeKick) | Godot 4, física configurable de balón, IK procedural y replay; licencia MIT. | Referencia para física y presentación de futuras animaciones, manteniendo el motor propio y sin añadir addon ahora. | MIT confirmada; no se copió código ni assets. |
| [devinarena/Pixel-Striker](https://github.com/devinarena/Pixel-Striker) | Juego móvil Godot con lógica de portero y penaltis; licencia MIT. | Referencia para futuras decisiones de reacción/estirada; no portar su minijuego al partido 11v11. | MIT confirmada; no se copió código ni assets. |
| [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) | Godot 4, balón físico, partidos locales, IA y pruebas. | Referencia para escenarios de física y telemetría. | API devuelve `license: null`; no copiar. |
| [modelence/open-soccer](https://github.com/modelence/open-soccer) | Partido CPU 11v11 en navegador con reinicios y reglas. | Checklist conceptual para ampliar reglas y pruebas de aceptación. | API devuelve `license: null`; no copiar. |
| [ogulcanunverenpt-star/purpleshoe](https://github.com/ogulcanunverenpt-star/purpleshoe) | Godot 4, partido 11-a-side, IA y reinicios. | Comparar situaciones de partido, sin importar backend ni recursos. | API devuelve `license: null`; no copiar. |

### Resultado aplicado

La mejora de esta iteración es original: cada guardameta recibe un `StaticBody3D` con cápsula y material de rebote, para que los tiros puedan tener contacto físico con el cuerpo del portero. La prueba de posicionamiento ahora intenta validar un disparo real contra esa cápsula. No se importó código externo, addons, modelos ni recursos.

La licencia MIT de un repositorio no concede derechos sobre recursos de terceros que pueda incluir; cualquier reutilización futura se revisará por archivo y dependencia. Los repositorios sin licencia declarada se usan solo como inspiración de ideas generales.
