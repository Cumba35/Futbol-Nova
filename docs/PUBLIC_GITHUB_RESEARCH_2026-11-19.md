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
