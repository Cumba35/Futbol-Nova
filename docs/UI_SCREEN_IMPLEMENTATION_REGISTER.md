# Fútbol Nova — Registro de implementación de pantallas

**Actualizado:** 2026-11-14  
**Alcance:** fútbol masculino exclusivamente. No importar ni generar futbolistas, plantillas, clubes o selecciones femeninas.

## Menú principal
| Pantalla | Estado actual para la APK de prueba |
|---|---|
| Inicio | Funcional: entrada al amistoso local 11v11, ayuda y desafío diario. Continuar y Nueva partida no forman parte del juego base de esta prueba. |
| Online | Pantalla funcional de estado e información; permite abrir el catálogo de módulos. No hay multijugador real sin backend y módulo publicado. |
| Modos | Navegación funcional por los modos y acceso al catálogo. Entrenamiento y varias pantallas de carrera/competiciones tienen funciones locales parciales; los módulos no instalados no se anuncian como jugables. |
| Configuración | Las once categorías abren y permiten volver. Controles muestra el estado del módulo; Módulos abre el catálogo; Datos e Información muestran el estado del juego. Otras categorías siguen siendo informativas, sin controles persistentes. |

## Amistoso base 11 contra 11
- Inicio abre la preparación del amistoso.
- Se muestran clubes del registro offline que tengan plantilla válida.
- El local y el visitante deben ser distintos.
- Se crea una alineación 4-3-3 con once IDs reales de cada plantilla.
- El controlador instancia 21 jugadores de IA más el jugador controlado.
- El reloj, el marcador, la pausa y la continuación entre períodos están conectados.
- La prueba de integración `tests/test_friendly_match_runtime.gd` valida la creación del partido desde la escena principal.

## Estado de alcance
Las cuatro pantallas principales tienen navegación y contenido. Eso no significa que todos los módulos secundarios estén terminados: online real, funciones avanzadas de configuración, torneo de selecciones, penaltis, árbitro completo, porteros avanzados y animaciones finales siguen pendientes.

## Navegación implementada
- Cuatro botones principales: Inicio, Online, Modos y Configuración.
- Navegación circular mediante swipe horizontal y cruceta del mando.
- Indicador de posición de pantalla.
- Submenús de configuración y entrenamiento diferenciados de las cuatro pantallas principales.
- Acciones de juego todavía no disponibles aparecen desactivadas; no se finge funcionalidad.
- «Momentos» solo aparece en Inicio.
- No hay modo Femenino ni Ultimate Team.

## Pendiente de validación
Se ampliaron `tests/test_game_hub.gd`, `tests/test_legend_career.gd` y `tests/test_moments_service.gd`; el workflow también incluye pruebas del módulo de mando y los sistemas compartidos. La auditoría estática del código y los manifiestos pasó 17/17 comprobaciones. GitHub Actions continúa terminando los jobs antes de asignar un runner (runner_id=0, sin pasos ni logs), por lo que aún no hay resultado de ejecución Godot. La prueba física Android (tacto, mando, vertical/horizontal, foco y escalado) también está pendiente.


## Competiciones continentales y sorteos
- El navegador de Ligas y Copas muestra las cuatro competiciones continentales americanas y sus años de fundación: Caribe, Sudamérica y Norteamérica/Centroamérica (2020); TAS (2021).
- Se añadió `NovaCompetitionDrawCeremony`, una secuencia animada reutilizable con extracción de bolas, revelación secuencial y botón **SALTAR SORTEO**. `GameHub.present_competition_draw()` y `present_edition_draw()` presentan el resultado ya resuelto sin volver a sortear. Los motores de las tres ligas regionales y TAS entregan el campo `draw_presentation`.
- Pendiente: conectar todas las operaciones de sorteo existentes y futuras a la ceremonia y ejecutar validación en Godot 4; el modo Torneos sigue sin interfaz funcional.


## Ceremonia de sorteos de competiciones
- El servicio deportivo publica `draw_ceremony_requested` al crear un cuadro o sorteo. GameHub escucha el evento y muestra la ceremonia automáticamente.
- Conectados: competiciones regionales americanas, Liga de Campeones del Caribe, TAS, Copa de Cuba, Supercopa de Cuba y playoffs de ascenso de Segunda/Tercera División.
- La animación revela clubes, grupos, fases y rivales; el botón **SALTAR SORTEO** muestra todos los resultados restantes y conserva el sorteo ya calculado.
- Las ligas todos-contra-todos generan calendario automáticamente y no tienen sorteo de emparejamientos.
- Pruebas añadidas: `tests/test_competition_draw_ceremony.gd` y prueba de señal en `tests/test_game_hub.gd`. Incluidas en el workflow Android con Godot 4.4.1; ejecución pendiente.


## Selector visual de estadios — 20 noviembre 2026
- Rediseño del selector de estadio del amistoso siguiendo la referencia visual proporcionada: lista vertical de tarjetas a la izquierda, vista panorámica 3D a la derecha, nombre/capacidad/versión y selección fucsia.
- La vista previa se construye con la geometría real del StadiumBuilder dentro de un SubViewport; no depende de imágenes externas ni de conexión.
- Los datos de capacidad y versión proceden del catálogo local. La selección sigue entregándose como `stadium_id` al iniciar el partido y no modifica preferencias globales.
- El botón de confirmación conserva la validación de plantillas de 11 jugadores.
- Prueba de catálogo ampliada para exigir metadatos de versión. La validación visual/táctil y el rendimiento del SubViewport en Android siguen pendientes de CI y prueba en dispositivo.


## Selector FIFA-inspired de equipos y uniformes — 20 noviembre 2026
- Se añadió una pantalla dedicada de local vs visitante con navegación independiente de clubes y equipaciones.
- Vista previa de cuerpo completo procedural en SubViewport 3D, monograma temporal y primera/segunda equipación.
- Los IDs de club y uniforme se transmiten al amistoso; el controlador aplica colores al equipo y uniforme diferenciado al portero.
- La paleta está centralizada y cuenta con prueba automatizada incluida en GitHub Actions.
- Pendientes: probar en Godot 4.4.1/Android, reemplazar modelos/monogramas temporales, añadir patrones originales, gesto de deslizamiento, OVR, detectar conflictos cromáticos y conectar la habilitación contractual de tercera equipación.


## Dirección visual del juego base y Nova C35 — 20 noviembre 2026
- El único estadio incluido en la instalación base pasa a ser Estadio del Fénix, sede de Nova C35. Otros estadios se reservan para paquetes opcionales.
- La escena procedural incluye grada de cuatro lados y cuatro niveles, cubierta y soportes, iluminación, marcador C35, paneles LED, túnel, banquillos y multitud instanciada.
- La pantalla previa al amistoso conserva la selección de equipos/equipaciones y muestra únicamente el estadio base.
- La IA de partido utiliza un maniquí procedural articulado con torso, cabeza, brazos, piernas, medias, botas y movimiento de extremidades ligado al desplazamiento.
- El perfil de Nova C35 está definido en `data/nova_c35_club.json`; identidad y colores iniciales son propuestas editables.
- Pendiente: modelos humanos rigged, animaciones avanzadas, rostros/peinados, crowd reactivo y audio, y pruebas de rendimiento en Android.
