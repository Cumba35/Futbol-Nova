# Fútbol Nova — estado de desarrollo y pruebas — 20 noviembre 2026

## Objetivo inmediato

Prioridad máxima: modo Amistosos local 11v11, offline y Android ARM64. No ampliar carrera, gestión ni multijugador online hasta que el amistoso sea estable y se pueda probar manualmente en un teléfono.

## Estado confirmado de GitHub Actions

### Ejecución 44675666114
- Commit: `acfb1d97c57cf04efc4cf9ddfa0d496c8fa5fe66`.
- URL: https://github.com/Cumba35/Futbol-Nova/actions/runs/44675666114
- Godot 4.4.1 exportó correctamente `FutbolNova-debug.apk`.
- El artefacto `futbol-nova-android-debug` fue publicado (29,665,557 bytes en la consulta del 20-11-2026).
- Pasaron las pruebas de acciones de entrada, limpieza táctil, hub, vuelo del balón, base 11v11 y amistoso runtime con goles/períodos.
- También pasaron la prueba de marcos de portería/red, catálogo/geometría de estadios, perfil de Máximo Padilla, acceso y política de recursos NOVA, smoke test Android y regresiones de alcance masculino y perfil de Anier Cumbá.
- La última consulta del job mostraba `Regression — test_player_statistics_consistency.gd` en ejecución. No hay conclusión final registrada todavía: no declarar toda la suite aprobada.

## Mejora de jugabilidad aplicada

La inspección de `scripts/gameplay/match_11v11_controller.gd` encontró una carencia real: la IA podía pasar/despejar con la posesión, pero no tenía una decisión de remate explícita. Se añadió:

- Detección de oportunidad de tiro dentro del tercio ofensivo y a distancia razonable.
- Dirección hacia la portería rival según el equipo y el cambio de lado tras el descanso.
- Elevación moderada del remate.
- Potencia ajustada por el atributo de tiro/finalización del jugador.
- Liberación de posesión y aplicación de impulso físico al balón.

Código sincronizado:
- Distribución: commit `9d18af88c48ecff344c0284ba663e6e8476b46c1`.
- Nova Workspace: commit `17d2b681fd0de19932b8aca3f8e0f6a88f55cb93`.

Nueva prueba:
- `tests/test_friendly_ai_shooting.gd`: ambos equipos, cambio de lado, descarte de tiros lejanos/altos/fuera del campo, orientación y lanzamiento físico de la IA.
- Distribución: commit `f4d7ab5ff431568f666e6f61ecb240848c18e9ad`.
- Nova Workspace: commit `5f927b6306e782c63d4b383e43e39395e6a75cb6`.

Workflow actualizado:
- Paso independiente `Core test — friendly AI shooting and goal direction`.
- Commit `beae6be90693ce2784ecd857b6a70326ca2cf6cf`.
- Nueva ejecución: https://github.com/Cumba35/Futbol-Nova/actions/runs/44676104232 (pendiente al registrar este documento).

## Investigación pública de GitHub

- [krimshi/godot-soccer](https://github.com/krimshi/godot-soccer) — MIT confirmada; referencia ligera 2D.
- [awest813/League-Soccer](https://github.com/awest813/League-Soccer) — Apache-2.0 confirmada; IA táctica y motor de partido más complejo, pero su arquitectura no se porta directamente a la base GDScript móvil.
- [Tobilion/footysim](https://github.com/Tobilion/footysim) — simulación espacial 11v11 y pruebas headless; licencia no declarada por la API consultada, no copiar código.
- [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball) — Godot 4.4.1 y GDExtension; licencia no declarada, no copiar.
- [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game) — Godot 4 y física; licencia del juego no declarada, no copiar.
- [antxiko/OpenComputerFutbolSimulator](https://github.com/antxiko/OpenComputerFutbolSimulator) — arquitectura de datos y simulación determinista; no se importa su stack ni se copia código.

No se añadieron dependencias externas ni assets de terceros. Las referencias se utilizan para orientar diseño y pruebas; cualquier reutilización futura requiere verificar licencia y atribución.

## Próximas tareas, por orden

1. Confirmar que la prueba nueva de tiro IA pasa en Godot 4.4.1.
2. Añadir un escenario runtime en que la IA genere una ocasión, remate y pueda producir un gol real, no solo aplicar un impulso.
3. Mejorar porteros: lectura de trayectoria, blocaje, despeje, estirada y rebotes.
4. Completar presión/entradas, faltas y reinicios del juego.
5. Registrar estadísticas reales del amistoso: tiros, tiros a puerta, pases, posesión y atajadas.
6. Comprobar sesión larga, memoria, temperatura y fluidez en Android.
7. Instalar y jugar la APK en un dispositivo Android real. La exportación en CI no sustituye esta prueba.

## Sincronización obligatoria

El código y los documentos del proyecto se guardan en `Cumba35/Futbol-Nova` y se sincronizan en `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova/`. Después de cada escritura se releen los archivos y se comparan SHA de contenido. Los workflows de compilación permanecen en el repositorio independiente de distribución.

## Estado honesto

La APK debug ya se exportó y el artefacto está publicado. El amistoso ha superado las pruebas runtime existentes en CI. La decisión de tiro de IA, la corrección de su trayectoria y el posicionamiento lateral del portero están implementados; las dos nuevas pruebas dedicadas están añadidas a CI, pero aún esperan resultado. No hay validación manual en un teléfono real ni se declara terminado el modo amistoso.


## Cambios posteriores y CI — 20 noviembre 2026

- Controlador actualizado: decisión de remate de IA con destino elevado y posicionamiento del portero limitado al espacio entre postes.
- Pruebas nuevas/actualizadas: `test_friendly_ai_shooting.gd` y `test_friendly_goalkeeper_positioning.gd`.
- Workflow ampliado con una prueba independiente para el posicionamiento de porteros.
- Ejecución que contiene las nuevas pruebas: https://github.com/Cumba35/Futbol-Nova/actions/runs/44676590754 (pendiente en el momento de esta actualización).
- El código y las pruebas se guardan en `Cumba35/Futbol-Nova` y en `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova/`; los workflows siguen en el repositorio de distribución.
- No hay todavía validación manual en teléfono Android. El APK de CI es una compilación debug de prueba.



## Pruebas de integración reforzadas — 20 noviembre 2026

La prueba de remates comprueba ahora que el balón recibe impulso físico hacia la portería rival (componente Z con el signo correcto), no solo que aumenta su velocidad. La prueba del portero comprueba también que la ruta táctica real de `_choose_target()` utiliza el cálculo de posicionamiento validado.

La ejecución más reciente que contiene estas aserciones es https://github.com/Cumba35/Futbol-Nova/actions/runs/44676823822 (en cola al actualizar este documento). Los intentos anteriores quedaron cancelados por la concurrencia de GitHub Actions; no se cuentan como pruebas superadas.


## Anticipación predictiva del portero — 20 noviembre 2026

El portero ya no sigue únicamente la coordenada lateral actual del balón: cuando el balón viaja hacia su propia portería, el controlador proyecta su cruce con el plano de gol usando la velocidad física actual, con horizonte máximo de 1,25 segundos. Si el balón se aleja, no anticipa esa trayectoria. Se mantiene el límite lateral de ±3,1 m y el cambio de lado. La prueba dedicada comprueba local, visitante y selector táctico integrado.

Ejecución que contiene el código y las aserciones más recientes: https://github.com/Cumba35/Futbol-Nova/actions/runs/44676823822 (pendiente/encolada al registrar esta actualización). La atajada, blocaje y animación de estirada siguen pendientes; este cambio es posicionamiento predictivo, no una atajada completa.
