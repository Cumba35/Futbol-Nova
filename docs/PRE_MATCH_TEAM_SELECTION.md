# Fútbol Nova — selector de equipos y preparación del partido

**Estado:** selector de clubes, equipos de muestra y selector funcional de tres estadios procedurales integrados el 18-11-2026. La validación Godot/Android sigue pendiente. Los modelos de futbolistas, OVR, escudos, equipaciones, vista previa de estadio/balón y catálogo de balones siguen pendientes.
**Referencia:** captura aportada por el usuario de una pantalla de amistoso con dos futbolistas 3D, escudos, valoración OVR, estadio, accesos de equipación, balón, ajustes y botón de inicio.

## Estado de implementación — 17 noviembre 2026

Implementado en la rama de trabajo:
- Selección independiente de club local y visitante desde el catálogo offline.
- Solo se ofrecen clubes cuya plantilla contiene al menos once jugadores resolubles.
- El inicio se bloquea si los equipos coinciden o una plantilla no supera la validación.
- Selección de once titulares sin IDs repetidos, priorizando las posiciones del sistema 4-3-3.
- Configuración previa del amistoso para duración por tiempo, reloj continuo/detenido y prórroga.
- La tanda de penaltis aparece identificada como «en desarrollo» y deshabilitada porque su motor de ejecución aún no existe.
- El botón de repetir partido vuelve a abrir la preparación y no inicia un encuentro genérico.

Pendiente de implementación y validación:
- Modelos 3D representativos y valoración OVR de los equipos.
- Escudos/banderas y vistas previas de equipaciones.
- Selector de balón y vistas previas 3D de equipaciones y estadios; el selector de estadio ya dispone de tres entornos procedurales originales, pero todavía no hay vistas previas dentro de la pantalla.
- Detección de conflictos de equipación y reglas visuales de porteros.
- Persistencia de preferencias de amistosos.
- Pruebas de interfaz en Godot, diferentes resoluciones y dispositivos Android.

La selección de equipos y el once inicial no deben confundirse con una integración completa de perfiles, atributos, animaciones o apariencias: los actores del partido siguen usando la representación procedural del motor actual.

## Selección predeterminada del amistoso de muestra — 18 noviembre 2026

- Equipo local (izquierda): `FN-ESP-REAL-MADRID`, nombre original del juego **Albor Madrid**, referencia deportiva interna: Real Madrid.
- Equipo visitante (derecha): `FN-ESP-BARCELONA`, nombre original del juego **Litoral Barcelona**, referencia deportiva interna: FC Barcelona.
- La selección usa IDs estables, no búsquedas por texto visible; si falta uno de los clubes, se conserva una pareja alternativa válida y distinta.
- Los nombres, escudos, uniformes, modelos y demás elementos visuales deben seguir siendo originales de Fútbol Nova; las referencias no autorizan copiar marcas ni assets.
- Se añadió una prueba unitaria de la selección predeterminada y de su fallback en `tests/test_shared_foundation.gd`. La prueba debe ejecutarse en Godot 4.4.1 antes de marcarla como validada.

## Selector de estadios — 18 noviembre 2026

El selector de amistosos carga el catálogo offline de `scripts/stadiums/stadium_builder.gd` y transmite el ID del estadio al inicio del encuentro. El motor construye el entorno 3D correspondiente sin red:

- `nova_central` — Estadio Nova Central, capacidad registrada: 42.000.
- `bahia_arena` — Arena Bahía, capacidad registrada: 28.500.
- `aurora_park` — Parque Aurora, capacidad registrada: 19.000.

Los tres usan geometría procedural original, gradas, cubiertas, postes de iluminación visual y marcador. Cambiar de estadio no altera clubes ni datos de competición. La prueba `tests/test_stadium_builder.gd` comprueba catálogo, IDs, capacidad y construcción; `tests/test_friendly_match_runtime.gd` comprueba que el estadio elegido llegue al partido. La vista previa del selector, colisiones de gradas, iluminación dinámica y diseños arquitectónicos más diferenciados quedan pendientes.

## 1. Objetivo

Crear una pantalla previa al saque inicial que permita revisar el enfrentamiento y configurar visualmente el partido sin navegar por varios menús. Debe funcionar con clubes y selecciones, y adaptar sus controles al tipo de encuentro y al modo de origen.

La referencia orienta la composición y la jerarquía, pero Fútbol Nova tendrá identidad, recursos y componentes originales.

## 2. Composición de pantalla

- Cabecera con el tipo de encuentro (por ejemplo, Amistoso), acceso a ajustes y retorno.
- Equipo local a la izquierda y visitante a la derecha.
- En cada lado: modelo 3D representativo con la equipación seleccionada, escudo/bandera, nombre y valoración general OVR calculada desde la plantilla y el criterio del modo.
- Marcador central VS y controles para cambiar/seleccionar equipos cuando el modo lo permita.
- Selector visible del estadio, con nombre y vista previa; controles para recorrer estadios disponibles.
- Acceso de equipación independiente para local y visitante, con vista previa 3D inmediata.
- Acceso al selector de balón con vista previa.
- Botón principal para iniciar el partido, habilitado solo cuando equipos, plantillas, estadio, equipaciones y reglas superen las validaciones.

Los controles de aleatorizar o cambiar equipo, si se ofrecen, deberán distinguirse claramente de los controles de apariencia y nunca modificar una selección sin reflejarlo en pantalla.

## 3. Cambiar uniformes

- Abrir el selector correspondiente al equipo local o visitante sin perder la selección del otro.
- Mostrar las equipaciones realmente disponibles para ese equipo: local, visitante, alternativa y portero cuando aplique.
- Previsualizar simultáneamente el modelo 3D y los colores elegidos.
- Validar contraste entre ambos equipos y con los porteros; advertir y proponer una alternativa si hay conflicto visual.
- Permitir equipaciones personalizadas solo si pertenecen al catálogo/edición y cumplen validaciones.
- Guardar la elección para ese encuentro; no sobrescribir la equipación oficial del club ni los datos originales.

## 4. Cambiar balón

- Abrir un catálogo visual de balones disponibles y autorizados.
- Mostrar nombre/identificador y vista previa 3D.
- Aplicar el balón elegido al partido actual.
- En competiciones oficiales, usar el balón obligatorio de la competición si su reglamento o configuración lo fija; mostrarlo como selección bloqueada o informativa.
- No conceder ventajas de física por elegir una apariencia: las diferencias físicas solo existen si el diseño del balón y las reglas del juego las definen de forma legítima y equilibrada.

## 5. Cambiar estadio

- Recorrer estadios disponibles y mostrar nombre, vista previa y datos pertinentes (superficie y capacidad si están registrados).
- Aplicar el estadio seleccionado solo al encuentro actual.
- En partidos oficiales, respetar sede y estadio asignados por el calendario/reglamento. Si la competición admite sede alternativa, aplicar sus reglas.
- Si un estadio no está instalado o no es compatible con el modo, deshabilitarlo con una explicación; nunca sustituir silenciosamente una sede oficial.

## 6. Configuración del juego y clasificación de partidos

El acceso a configuración contextual de partido será editable únicamente en partidos no oficiales que permitan personalización, por ejemplo amistosos, exhibición, entrenamiento o partidos de torneo personalizado que el reglamento marque como configurables.

En partidos oficiales (liga, copa, supercopa, eliminatorias oficiales, partidos oficiales de selección y cualquier encuentro vinculado a una carrera/competición con reglamento obligatorio):
- Los ajustes incompatibles con las reglas estarán bloqueados.
- Los parámetros obligatorios vendrán del reglamento de la competición o del modo.
- Los ajustes generales de accesibilidad, volumen, gráficos y controles seguirán disponibles si no alteran la competición.
- No se podrá cambiar manualmente el resultado, la dificultad competitiva, las reglas, la sede, el balón obligatorio ni los parámetros protegidos por el reglamento.

En partidos no oficiales configurables, el panel puede incluir, según soporte del motor:
- Duración de cada tiempo y método del reloj.
- Dificultad de IA y velocidad de juego.
- Prórroga y tanda de penaltis.
- Manos, lesiones y sanciones disciplinarias.
- Número de sustituciones y límites amistosos.
- Árbitro, precisión arbitral y VAR.
- Clima/hora del día y otras condiciones de exhibición.
- Otras reglas de partido disponibles y probadas.

La pantalla debe indicar qué opciones se aplicarán, cuáles están bloqueadas y por qué. No mostrar controles sin efecto real. Los valores deben validarse y guardarse en la configuración del encuentro, sin contaminar ajustes globales ni carreras.

## 7. Precedencia de reglas

Resolver los valores efectivos en este orden:
1. Reglamento obligatorio de competición oficial.
2. Reglas del modo/carrera y estado del calendario.
3. Configuración permitida del tipo de partido.
4. Preferencias globales compatibles.

Un valor inferior nunca puede anular uno superior. La interfaz debe reflejar el valor efectivo, no solo el valor solicitado por el usuario.

## 8. Persistencia y datos

La configuración del encuentro debe registrar como mínimo:
- `match_id`, `match_type`, `mode_id`, `competition_id` cuando aplique.
- `home_team_id`, `away_team_id`, `stadium_id`, `ball_id`.
- `home_kit_id`, `away_kit_id`, variantes de portero.
- `requested_settings`, `effective_settings`, `locked_settings` y motivos de bloqueo.
- `ruleset_id`, `validation_status`, `schema_version`.

Las elecciones cosméticas de un amistoso no deben alterar los datos permanentes de clubes, equipaciones o competiciones. La selección puede recordarse como preferencia para amistosos, pero debe poder revisarse antes de iniciar cada partido.

## 9. Accesibilidad y adaptación Android

- Controles táctiles amplios y separados; iconos acompañados de etiquetas o ayudas accesibles.
- Mantener la información esencial legible en orientación y tamaños de pantalla compatibles.
- No depender exclusivamente del color para diferenciar local y visitante.
- Permitir navegación por mando/teclado además del tacto.
- Animaciones y modelos 3D deben tener niveles de calidad para dispositivos Android de distintas capacidades.

## 10. Pruebas de aceptación

1. La pantalla muestra simultáneamente local, visitante, escudos/banderas, OVR, VS, estadio y acceso a iniciar.
2. Cambiar la equipación local no modifica la visitante y viceversa; la vista previa 3D se actualiza.
3. Un conflicto de colores se detecta y se ofrece una equipación compatible.
4. Cambiar el balón afecta solo al partido actual y no modifica el catálogo ni el balón oficial de un torneo.
5. Cambiar el estadio afecta solo al encuentro configurable.
6. En un amistoso, las opciones permitidas se pueden modificar y el resumen muestra sus valores efectivos.
7. En un partido oficial, los parámetros reglamentarios aparecen bloqueados y no se pueden alterar mediante UI ni datos manipulados.
8. La precedencia del reglamento prevalece sobre preferencias globales y ajustes del usuario.
9. Un encuentro oficial mantiene el estadio, balón, reglas y sede establecidos por su competición.
10. Guardar/cargar una configuración mantiene las selecciones sin modificar clubes ni carreras.
11. Las opciones no soportadas o recursos ausentes aparecen deshabilitados con explicación.
12. El botón de inicio no permite lanzar un partido con datos inválidos o selecciones incompatibles.

**Límite actual:** el selector de equipos, el once inicial, las opciones básicas del amistoso y el selector de tres estadios procedurales ya están conectados al inicio del partido. Las vistas 3D de jugadores/estadios dentro de la preparación, OVR, escudos, equipaciones, balón, preferencias persistentes y la validación visual completa siguen pendientes. No se consideran terminados hasta superar CI Godot 4.4.1 y pruebas Android.


## Prioridad de validación: amistoso jugable y controles Android — 19 noviembre 2026

El modo Amistoso es ahora la ruta principal de aceptación del juego. La prueba automatizada `tests/test_friendly_match_runtime.gd` abre la escena principal y utiliza el mismo flujo de preparación e inicio que el jugador. Comprueba:

- Selección inicial de Real Madrid a la izquierda y Barcelona a la derecha, dos plantillas válidas, once titulares por lado y selección del estadio.
- Inicio real del controlador 11v11, creación de 22 futbolistas, jugador controlado correcto, nombres y marcador.
- Controles Android de extremo a extremo: joystick virtual que desplaza al futbolista, botón táctil PASE y botón táctil TIRO que impulsan el balón mediante el controlador real del jugador.
- Pausa y reanudación del partido, inmovilización/restauración del balón, reinicios después de gol y protección del marcador cuando el encuentro no está activo.
- Goles de ambos equipos, actualización del marcador, progreso de entrenamiento separado del amistoso, reloj, descanso, cambio de lado, segundo tiempo, final y descansos de prórroga.

La ejecución `44529962976` completó esta prueba de amistoso con éxito en Godot 4.4.1 antes de añadir la nueva cobertura de joystick/pase/tiro táctil. Esa ejecución completa falló después, en `tests/test_football_database.gd`, por inferencia de tipos en dos variables del test; ambas declaraciones se tiparon explícitamente. La siguiente ejecución debe validar de nuevo el amistoso con las nuevas interacciones táctiles y continuar hasta exportar APK.

**Criterio de aceptación:** no basta con abrir la escena o crear 22 nodos. El amistoso solo se considera validado cuando se puede iniciar desde la interfaz, mover al jugador, pasar, tirar, marcar, pausar/reanudar y completar los períodos sin errores. La prueba headless es necesaria, pero no sustituye la instalación y prueba manual de la APK en Android.

**Pendiente funcional visible:** los botones de repetición y tácticas del menú de pausa siguen deshabilitados; la tanda de penaltis está marcada en desarrollo y no tiene motor; las sustituciones reales, árbitro completo, faltas/reinicios y presentación visual completa de la pantalla previa siguen fuera del alcance de esta aceptación inicial.


## Corrección de posesión tras pase/tiro — 19 noviembre 2026

La aceptación de controles táctiles encontró un fallo real del motor: después de liberar la pelota, el controlador podía volver a asignar posesión al jugador/IA durante el mismo ciclo de física, antes de que el impulso del balón se integrara. Esto podía congelar la pelota justo después de un pase o tiro.

- El controlador 11v11 ahora aplica una ventana breve de protección de posesión tras un golpe (0,18 s), evitando que el balón vuelva a quedar fijado al futbolista antes de comenzar su trayectoria.
- La protección se aplica al pase/tiro del jugador, al despeje del portero y a los pases/despejes de la IA; se reinicia al iniciar o detener un partido.
- La prueba de amistoso adquiere posesión real con el jugador controlado, pulsa PASE/TIRO táctiles y verifica que el balón gana velocidad, permanece libre y no vuelve a congelarse inmediatamente.
- La prueba también verifica que la IA local y visitante se reposiciona según el balón y que el joystick virtual desplaza al jugador.


## Corrección de posesión tras pase/tiro — 19 noviembre 2026

La aceptación de controles táctiles encontró un fallo real del motor: después de liberar la pelota, el controlador podía volver a asignar posesión durante el mismo ciclo de física, antes de que el impulso se integrara. Esto podía congelar el balón justo después de un pase o tiro.

- El controlador 11v11 ahora aplica una protección breve de posesión tras un golpe (0,18 s), evitando que el balón vuelva a quedar fijado antes de comenzar su trayectoria.
- Se aplica a los golpes del jugador, despejes del portero y pases/despejes de la IA; se reinicia al iniciar o detener un partido.
- La prueba de amistoso adquiere posesión real con el jugador controlado, pulsa PASE/TIRO táctiles y verifica velocidad, balón libre y ausencia de congelación inmediata.
- La prueba también verifica el reposicionamiento de IA local/visitante y el movimiento del jugador con joystick virtual.


## Selector de equipos y equipaciones con presentación deportiva — 20 noviembre 2026

Se añade una pantalla dedicada inspirada en la presentación y navegación de FIFA 26, manteniendo recursos originales de Fútbol Nova. Dos paneles muestran local y visitante, escudo provisional/monograma, nombre, modelo 3D procedural y carrusel independiente de primera y segunda equipación. Los clubes se recorren con controles anterior/siguiente sin permitir duplicar el mismo equipo. La selección confirma IDs estables y los transmite al amistoso junto con `home_kit_id` y `away_kit_id`. El motor aplica los colores seleccionados a los futbolistas IA y una equipación diferenciada al portero. Los colores son una paleta procedural provisional; escudos definitivos, modelos humanos, patrones, patrocinadores autorizados y detección de conflictos cromáticos siguen pendientes. La tercera equipación no se expone hasta integrar correctamente la habilitación comercial por temporada.
