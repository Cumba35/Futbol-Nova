# Fútbol Nova — catálogo consolidado de configuración y reconciliación

**Fecha:** 20-11-2026  
**Rama auditada:** `work/configuration-reconciliation-2026-11-20`  
**Rama de origen:** `work/friendly-match-stability-2026-11-20`  
**Proyecto maestro:** `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova/`

## 1. Alcance y autoridad de configuración

Se revisaron las ramas disponibles de `Cumba35/Futbol-Nova` y las ramas de integración/funciones de `Cumba35/Nova-Workspace`, incluyendo `main`, `feature/friendly-runtime-research-2026-11-20`, `feature/raymond-rosters-skills-2026-11-20`, `feature/futbol-nova-integracion-funciones-v3-2026-11-14`, `feature/futbol-nova-match-statistics-engine`, `feat/futbol-nova-career-progression-world-stats`, `feat/futbol-nova-achievements` y `feat/futbol-nova-nova-cosmetics`.

Reglas para leer este catálogo:

1. Los requisitos explícitos del diseño del juego prevalecen sobre referencias genéricas de otros juegos.
2. Los valores presentes en código/configuración y protegidos por pruebas se consideran valores runtime actuales.
3. Los valores que aparecen solo en documentos de diseño se marcan como definidos, pero pendientes de implementación.
4. Un archivo presente en otra rama no se considera integrado en la rama activa.
5. No se inventan valores predeterminados para opciones cuyo valor no está especificado.
6. No se publica ni se activa ningún módulo solo porque su código exista en el repositorio.

## 2. Juego base, navegación y distribución

### Juego base

La especificación de producto vigente en `docs/GAME_DESIGN.md`, `docs/MAIN_MENU_FOUR_SCREENS.md` y `data/game_modules_manifest.json` establece:

- Instalación base independiente y funcional sin conexión.
- Experiencia jugable incluida: amistosos locales.
- Ayuda y ajustes generales.
- Gestor/catálogo de módulos.
- La ausencia de módulos opcionales nunca debe impedir iniciar el juego base.
- No existe ni debe mostrarse **Ultimate Team**.

### Menú principal

Cuatro pantallas, en este orden:

1. Inicio.
2. Online (escaparate de módulo; no debe fingir que hay backend o salas activas).
3. Modos (catálogo de módulos; no inicia funciones no instaladas).
4. Configuración.

La navegación es horizontal, bidireccional y circular, con acceso táctil y mando. Online y Modos se identifican como contenido que requiere módulos.

### Catálogo de módulos

`data/optional_modules_catalog.json` contiene **21 fichas**. Ninguna está marcada como descargable actualmente. Hay fichas planificadas, en desarrollo y una de soporte de mando en pruebas. Los estados exactos deben leerse del catálogo; no deben mostrarse como funciones publicadas.

El manifiesto base exige funcionamiento offline, instalación atómica, HTTPS, SHA-256, compatibilidad, dependencias y comprobación de derechos antes de publicar un paquete. Los formatos actuales son JSON/ZIP; PCK queda como formato futuro.

## 3. Plataforma y exportación Android

Fuentes: `project.godot`, `export_presets.cfg` y `.github/workflows/futbol-nova-android-apk.yml`.

| Parámetro | Configuración verificada |
|---|---|
| Motor en CI | Godot 4.4.1 |
| Proyecto | Características Godot 4.4, GDScript |
| Renderizador | GL Compatibility, también en móvil |
| Texturas | Importación ETC2/ASTC habilitada |
| Plataforma prioritaria | Android ARM64-v8a |
| ABIs desactivadas | armeabi-v7a, x86, x86_64 |
| Paquete | `com.nova.futbolnova` |
| Nombre | Fútbol Nova |
| Versión exportada | 0.1.0, código 1 |
| Vista de referencia | 1280 × 720 |
| Escalado | `canvas_items` |
| Pantalla | Inmersiva; admite pantallas pequeñas |
| Mantener pantalla encendida | Sí |
| Permiso Internet | Desactivado |
| Permiso estado de red | Desactivado |

Una exportación APK correcta no sustituye la instalación y prueba manual en Android.

## 4. Configuración general

### Categorías confirmadas

`docs/MAIN_MENU_SETTINGS.md` y `scripts/ui/game_hub.gd` definen estas once categorías, en este orden:

1. Edición.
2. Módulos.
3. Música.
4. Juego.
5. Datos.
6. Controles.
7. Audio.
8. Gráficos.
9. Accesibilidad.
10. Administración.
11. Información.

Reglas: navegación de ida y vuelta sin perder contexto, valores reales, confirmación para restaurar o borrar datos, persistencia local y navegación táctil/mando.

### Idioma y audio

- Idioma predeterminado: español para interfaz, ayuda, mensajes, estadísticas y contenido dirigido al usuario.
- Música: se definió un único ajuste global para todas las pantallas; no debe reiniciarse ni duplicarse al cambiar de pantalla.
- Música, efectos, ambiente y comentarios deben tener volúmenes independientes cuando esos buses estén implementados.
- No mostrar pistas ni selectores de audio vacíos o sin derechos de uso.

### Preferencias que sí están implementadas

Fuente: `scripts/data/nova_preferences_service.gd`, prueba `tests/test_nova_preferences_service.gd`.

| Preferencia | Valor inicial | Rango | Persistencia |
|---|---:|---:|---|
| Volumen Master | 0.8 (80 %) | 0.0–1.0 | `user://futbol_nova_settings.cfg` |
| Silencio Master | false | true/false | Mismo archivo |
| Escala de interfaz | 1.0 (100 %) | 0.8–1.3 | Mismo archivo |

El volumen y el silencio se aplican al bus Master. La escala se aplica a los textos principales del Game Hub. Los buses separados de música/efectos/comentarios, el remapeo completo, perfiles gráficos desde el menú, contraste y lector de pantalla siguen pendientes. No se deben presentar como controles terminados.

## 5. Ajustes contextuales del partido

`docs/CONTEXTUAL_GAME_SETTINGS.md` define opciones que deben mostrarse solo si el modo y el estado las admiten.

### Partido

- Duración de cada tiempo.
- Dificultad y comportamiento/competitividad de la IA.
- Dificultad basada en el jugador, si existe.
- Perfil de atributos.
- Velocidad del juego.
- Reglas y condiciones del encuentro.

### Controles

- Perfil de mando y asignación de botones.
- Método de cambio/selección de jugador.
- Asistencia de pase raso, tiro, centros y pase elevado.
- Asistencia del portero.
- Sprint analógico.
- Bloqueo del receptor del pase.
- Vibración y sensibilidad, si el dispositivo las admite.

No hay valores predeterminados confirmados para todas estas opciones; las que no estén conectadas al motor deben permanecer ocultas o claramente identificadas como pendientes.

## 6. Configuración predeterminada del amistoso

Los valores iniciales se centralizaron en `NovaPreMatchSetup.get_default_friendly_match_settings()` y se protegen con `tests/test_match_configuration_defaults.gd`.

| Parámetro | Valor |
|---|---|
| Tipo | Amistoso |
| Local | Nova C35 — `FN-NOVA-C35` |
| Visitante | FC Río de Argenti — `FN-NOVA-RDA` |
| Formación de referencia | 4-3-3 |
| Plantilla mínima | 22 jugadores por club |
| Once inicial | 11 jugadores por club, IDs únicos |
| Jugador controlado con C35 local | Anier Cumbá — `NOVA-PLAYER-0035` |
| Jugador controlado con RDA local | Raymond Valdez — `NOVA-PLAYER-0037` |
| Fallback para otros clubes | Décimo ID del once inicial |
| Estadio inicial | `nova_central` |
| Duración inicial | 5 minutos por tiempo |
| Reloj inicial | Continuo |
| Prórroga inicial | Desactivada |
| Penaltis iniciales | Desactivados y bloqueados mientras el motor no exista |

El usuario puede cambiar los equipos local y visitante. La configuración identifica al jugador controlado según el equipo local; la pantalla todavía no ofrece un selector manual independiente de futbolista controlado.

### Criterios de selección del once

La prioridad posicional actual corresponde a 4-3-3: POR, LI, DFC, DFC, LD, MCD/MC, MC/MCO/interior, MCO/SD/MC, EI/MI/CAI, DC/SD y ED/MD/CAD. Se ordena la plantilla por valoración general y se evitan IDs repetidos; cuando falta una posición preferida, se usa el siguiente jugador disponible.

### Catálogo de estadios

Fuente: `scripts/stadiums/stadium_builder.gd`.

| ID | Estadio | Capacidad |
|---|---|---:|
| `nova_central` | Estadio Nova Central | 42.000 |
| `bahia_arena` | Arena Bahía | 28.500 |
| `aurora_park` | Parque Aurora | 19.000 |
| `nova_c35` | Estadio del Fénix | 105.000 |
| `rio_de_argenti` | Estadio Río de Argenti | 105.000 |
| `nova_genesis` | Arena Nova Génesis | 105.000 |
| `sangre_galactica` | Estadio Sangre de Estrellas | 105.000 |

Los entornos son procedurales y offline. La paleta del estadio Río de Argenti está marcada como provisional y requiere revisión visual. El selector empieza en `nova_central`; no se asigna silenciosamente un estadio de club por cambiar el equipo.

## 7. Reloj, períodos y reglas de partido

Fuentes: `scripts/gameplay/match_clock_rules.gd`, `scripts/gameplay/match_clock_state_machine.gd`, `docs/GAME_DESIGN.md` y `docs/MATCH_RULES_IMPLEMENTATION_AUDIT.md`.

### Duración de cada tiempo

Valores permitidos: **3, 5, 6, 8, 10, 15 y 20 minutos**. Predeterminado: 5 minutos. Siempre hay dos tiempos reglamentarios.

### Duración de prórroga por tiempo

| Tiempo reglamentario | Cada tiempo de prórroga |
|---:|---:|
| 3 min | 1 min |
| 5 min | 2 min |
| 6 min | 2 min |
| 8 min | 3 min |
| 10 min | 3 min |
| 15 min | 5 min |
| 20 min | 7 min |

La prórroga requiere empate y autorización del reglamento/competición.

### Tiempo añadido

- **Reloj detenido:** se detiene en interrupciones pertinentes; el añadido autónomo definido es de 1 a 3 minutos por período.
- **Reloj continuo:** el reloj sigue y el añadido compensa pérdidas reales; mínimo de 60 segundos y sin máximo fijo.
- La política actual de cálculo es determinista y preliminar; debe calibrarse con eventos reales de juego. No equivale a arbitraje completo.

### Sustituciones, lesiones y arbitraje definidos

- Partidos oficiales: 5 sustituciones en 3 ventanas; el descanso cuenta como ventana.
- Prórroga: una sustitución adicional y una ventana adicional.
- Amistosos: hasta 11 sustituciones.
- Una sustitución por lesión consume una sustitución.
- Lesiones: leves/moderadas pueden permitir continuar con penalización; graves impiden volver; se requiere atención y decisión contextual.
- Precisión arbitral: Perfecta, Realista o Variable. Perfecta no permite reclamaciones.
- Hasta 3 reclamaciones cuando el perfil y las reglas permiten errores arbitrales.
- Se definieron faltas, tarjetas, ventaja, penaltis, fuera de juego, VAR y reinicios; varias partes aún no están conectadas al árbitro en vivo.
- La tanda de penaltis todavía no tiene motor funcional y no debe habilitarse.

## 8. Controles de teclado, táctiles y mando

### Teclado

Fuente: `project.godot` y `tests/test_input_actions.gd`.

| Acción | Tecla |
|---|---|
| Mover izquierda | A |
| Mover derecha | D |
| Mover hacia delante | W |
| Mover hacia atrás | S |
| Pase | F |
| Disparo | Espacio |
| Técnica/habilidad | E |
| Presión | G |

### Pantalla táctil

Fuente: `scripts/input/touch_controls.gd`.

- Joystick izquierdo progresivo.
- Radio del joystick: 76 px.
- Zona muerta: 0.14.
- Radio visual de botones: 39 px.
- Centro del joystick: 16 % del ancho y 79 % de la altura.
- Botones: Pase (73 %, 70 %), Tiro (89 %, 79 %), Técnica (72 %, 91 %) y Presión (89 %, 94 %).
- Los controles liberan acciones al ocultar la capa o perder foco para evitar entradas pegadas.

La guía de técnicas también define carga de potencia, gestos direccionales y combos; el reconocimiento secuencial avanzado y sus animaciones/físicas siguen pendientes de integración.

### Mando externo

Fuentes: `modules/controller_support/controller_profiles.json` y `data/controller_modules_catalog.json`.

- Perfil: `generic_gamepad`.
- Zona muerta izquierda/derecha: 0.18.
- Sensibilidad de ejes: 1.
- Vibración: desactivada por defecto.
- Ejes 0/1 para movimiento.
- Botones 0/1/2/3 para pase/tiro/técnica/presión.
- Módulo en estado `testing`, no descargable; falta prueba física en Android con mandos Bluetooth/USB.

## 9. Técnicas, atributos y habilidades

Fuente: `docs/IN_GAME_CONTROLS_GUIDE.md`, `docs/TOUCH_CONTROLS_AND_SKILLS.md`, `data/skills/skill_catalog.json` y `scripts/player_skill_system.gd`.

Atributos en escala 1–99. Umbrales mínimos definidos:

| Técnica | Regate | Otros mínimos |
|---|---:|---|
| Auto pase | 25 | Control 30 |
| Sombrerito | 58 | Control 55, Agilidad 48 |
| Hueca/caño | 52 | Control 50, Agilidad 45 |
| Elástica | 78 | Control 72, Agilidad 68, Equilibrio 60 |
| Bicicleta | 48 | Control 45, Agilidad 50 |
| Marsellesa | 68 | Control 65, Equilibrio 58, Agilidad 62 |
| Elástica aérea | 86 | Control 80, Agilidad 78, Equilibrio 70 |
| Ruleta con caño | 74 | Control 70, Equilibrio 65, Agilidad 68 |
| Croqueta | 62 | Control 60, Agilidad 58, Equilibrio 52 |
| Finta de cuerpo | 40 | Agilidad 48, Equilibrio 42 |
| Arrastre atrás y salida | 38 | Control 45, Equilibrio 42 |
| Giro de protección | 45 | Control 42, Equilibrio 55, Fuerza 52 |
| Amago de disparo | 43 | Control 45, Compostura 40 |

Habilidades avanzadas:
- Espacios por OVR: menos de 70 = 0; 70–79 = 1; 80–90 = 2; 91–99 = 3.
- Estrellas: 1–2 estrellas desde nivel 70; 3–4 desde 80; 5 desde 90.
- Máximo 3 activaciones por jugador y partido, compartidas entre habilidades equipadas.
- Solo se seleccionan habilidades equipadas, elegibles y sin enfriamiento.
- Los umbrales y el catálogo existen; el reconocimiento de gestos avanzados, animaciones y validación completa en partido todavía necesita pruebas.

## 10. Cámaras, gráficos y realismo

### Cámaras definidas

El diseño contempla cámaras táctica (elevada), dinámica, cercana, de jugador y cinematográfica. Se definieron ajustes de altura, distancia/zoom, ángulo y velocidad de seguimiento, con cambios contextuales y preferencias por modo. La configuración completa de cámaras todavía no se expone como menú persistente validado.

### Perfiles gráficos

Fuente: `modules/graphics_enhancements/graphics_profiles.json`. El módulo no está publicado y los perfiles no deben anunciarse como selección funcional del menú.

- Predeterminado del módulo: `mobile_balanced` — exposición 1.0, luz ambiente 0.66, sol 1.22, sombras activadas, bias 0.06 y normal bias 1.2.
- `high_quality` — exposición 1.04, ambiente 0.72, sol 1.28, sombras activadas; pendiente de pruebas por hardware.
- `battery_saver` — exposición 0.98, ambiente 0.58, sol 1.05, sombras dinámicas desactivadas.

### Realismo

Fuente: `data/modules/realism/realism_profile.json`.

- Perfil: `realism_balanced`.
- Fatiga: activada en la primera integración del módulo.
- Pérdida de resistencia por movimiento: 0.10 por segundo.
- Recuperación: 0.16 por segundo.
- Multiplicador mínimo de velocidad: 0.78.
- Los indicadores de lesiones, arbitraje, física detallada del balón e IA táctica son ampliaciones futuras; no se activan solo porque sus campos estén a true.
- El paquete Realista permanece en desarrollo y no es descargable.

## 11. Pausa y guardados

### Menú de pausa

Fuente: `docs/PAUSE_MENU.md`.

1. Reanudar partido.
2. Repetición instantánea.
3. Entrenador / Tácticas.
4. Datos del partido.
5. Configuración.
6. Abandonar partido.

La simulación, reloj, IA y balón deben detenerse durante la pausa. Repetición, tácticas y datos solo se habilitan cuando sus sistemas reales están disponibles. Abandonar requiere confirmación.

### Guardados

Fuente: `docs/SAVE_SYSTEM.md`.

- Cinco espacios por modo.
- Espacio 1 reservado al autoguardado.
- Espacios 2–5 para guardados manuales/copias.
- Cuatro grupos de modos previstos; máximo 20 espacios.
- Mantener pulsado abre Renombrar, Copiar y Borrar.
- Sobrescribir/borrar requiere confirmación.
- No copiar entre modos incompatibles.
- Guardado versionado, integridad y escritura segura para conservar el último estado válido.

**Estado:** reglas de producto definidas; integración completa en el motor y validación de recuperación siguen pendientes.

## 12. Datos de ligas y selecciones

### Ligas

Fuentes: `data/league_content_manifest.json` y `data/global_league_selection_100.json`.

- Temporada de selección global: 2026–27.
- Objetivo: 100 ligas; 10 entradas base y 90 adicionales.
- Países base: Inglaterra, España, Brasil, Italia, Alemania, Francia, Portugal, Argentina, Cuba y Estados Unidos.
- El catálogo global conserva más de 100 entradas en reserva sin instanciarlas todas.
- El orden regional definido es Europa, Sudamérica, Norte/Centroamérica y Caribe, África, Asia y Oceanía.
- La presencia de una liga en la selección significa prioridad de investigación/creación; no demuestra que sus plantillas, derechos o jugabilidad estén validados.

### Selecciones nacionales

Fuente: `data/national_teams_manifest.json`.

- Directorio objetivo: 211 asociaciones.
- Confederaciones: AFC 46, CAF 54, CONCACAF 35, CONMEBOL 10, OFC 11, UEFA 55.
- Los nombres y la asignación de confederaciones están registrados; las plantillas nacionales todavía no están construidas ni publicadas.
- El módulo debe funcionar offline después de instalarse y no debe bloquear el juego base.
- Equipos juveniles y femeninos requieren paquetes separados y verificación propia; no se presumen incluidos.

## 13. Funciones definidas en otras ramas, no integradas en esta rama

Estas ramas se inspeccionaron para recuperar configuraciones previas. No se copiaron automáticamente porque contienen arquitecturas/versiones de archivos divergentes y requieren integración y pruebas propias.

### Integración de partido v3

Rama Workspace: `feature/futbol-nova-integracion-funciones-v3-2026-11-14`.

Incluye versiones de `match_session`, `match_clock`, `match_rules_engine`, `match_career_bridge`, grabación/reproducción de repeticiones, IA de formación/decisión, joystick virtual, reglas de reinicio y pruebas de portero. Varias de estas funciones tienen equivalentes más recientes o distintos en la rama actual. Deben compararse por comportamiento y contratos antes de integrar; no fusionar scripts completos a ciegas.

### Estadísticas, carrera, logros y cosméticos

Ramas Workspace:
- `feature/futbol-nova-match-statistics-engine`
- `feat/futbol-nova-career-progression-world-stats`
- `feat/futbol-nova-achievements`
- `feat/futbol-nova-nova-cosmetics`

La rama de carrera/progresión contiene `data/achievements.json`, `data/nova_cosmetics.json`, `career_progression_service.gd`, `world_statistics_service.gd`, `achievement_manager.gd`, `nova_cosmetics_manager.gd` y pruebas. Se identifican 12 logros de Leyenda y 12 de Manager en su prueba. Estas funciones no están registradas como autoload en el `project.godot` de la rama activa y no deben considerarse disponibles hasta integrarlas y validar persistencia, aislamiento por modo y recompensas.

La rama de estadísticas aporta un modelo táctico de partido, pero sus versiones modifican múltiples archivos de la base y no son una fuente segura para reemplazo directo.

## 14. Conflictos y decisiones pendientes

### Conflicto de distribución de ligas

Hay dos reglas explícitas que no coinciden:

- `docs/GAME_DESIGN.md`, `docs/MAIN_MENU_FOUR_SCREENS.md` y `data/game_modules_manifest.json` dicen que el APK base incluye amistosos locales y que ligas/carreras/torneos son módulos opcionales.
- `data/league_content_manifest.json` describe diez ligas como incluidas en el juego base con `download_required=false`.

No se cambió este manifiesto automáticamente porque eso alteraría una decisión de distribución. Hasta que se resuelva, el paquete base debe seguir la regla de juego base offline de amistosos definida por el documento principal; las diez ligas no deben incluirse en el APK base por inferencia ni anunciarse como jugables.

### Funciones todavía no operativas

- La mayoría de las once categorías de Configuración son páginas reservadas; Audio y escala de interfaz tienen controles funcionales.
- La música global está especificada, pero no hay pistas ni buses separados listos para ofrecer.
- Los ajustes contextuales de dificultad IA, velocidad, perfil de atributos y asistencias aún no están todos conectados.
- No hay remapeo completo persistente del mando.
- La tanda de penaltis no está implementada.
- El sistema de guardados tiene reglas definidas, pero no integración completa.
- Las técnicas avanzadas tienen catálogo/umbrales, pero falta completar reconocimiento de gestos y animaciones.
- El menú previo no permite escoger manualmente otro jugador controlado; selecciona Anier/Raymond según el local y usa fallback en otros clubes.
- La validación final del amistoso requiere CI completa y prueba física en Android.

## 15. Investigación pública de alternativas en GitHub

Se revisaron repositorios públicos como referencias de diseño, no como dependencias:

| Repositorio | Licencia verificada por metadatos GitHub | Stack / actividad observada | Decisión |
|---|---|---|---|
| `fff1045-git/soccer11` | Sin licencia declarada por la API | TypeScript; último push 2026-08-25 | Referencia de controles y modos; no copiar. |
| `nemanjamicic87/football-match-simulator` | Sin licencia declarada por la API | TypeScript/React; último push 2026-11-18 | Referencia de separación motor/UI y persistencia; no copiar. |
| `aliyavuzz/Godotball` | Sin licencia declarada por la API; README menciona Apache-2.0, pero no se acreditó archivo LICENSE raíz | Godot/GDScript; último push 2026-05-03 | Solo lectura conceptual; no integrar código/assets. |
| `erengaygusuz/fotbiler-football` | Apache-2.0 | C++; último push 2026-09-06 | No integrar el motor nativo; stack distinto y no necesario para la configuración actual. |

No se importaron código, assets ni dependencias de estos proyectos.

## 16. Fuentes canónicas que deben mantenerse sincronizadas

- `project.godot`, `export_presets.cfg`
- `data/game_modules_manifest.json`, `data/optional_modules_catalog.json`
- `data/league_content_manifest.json`, `data/global_league_selection_100.json`, `data/national_teams_manifest.json`
- `data/modules/realism/realism_profile.json`
- `modules/controller_support/controller_profiles.json`, `modules/graphics_enhancements/graphics_profiles.json`
- `data/skills/skill_catalog.json`, `data/skills/common_gesture_techniques.json`
- `scripts/data/nova_preferences_service.gd`
- `scripts/ui/pre_match_setup.gd`
- `scripts/gameplay/match_clock_rules.gd`, `scripts/gameplay/match_clock_state_machine.gd`
- `scripts/input/touch_controls.gd`, `scripts/stadiums/stadium_builder.gd`
- `docs/GAME_DESIGN.md`, `docs/MAIN_MENU_FOUR_SCREENS.md`, `docs/MAIN_MENU_SETTINGS.md`, `docs/CONTEXTUAL_GAME_SETTINGS.md`
- `docs/IN_GAME_CONTROLS_GUIDE.md`, `docs/TOUCH_CONTROLS_AND_SKILLS.md`, `docs/PRE_MATCH_TEAM_SELECTION.md`
- `docs/MATCH_RULES_IMPLEMENTATION_AUDIT.md`, `docs/PAUSE_MENU.md`, `docs/SAVE_SYSTEM.md`
- `docs/TECHNICAL_ARCHITECTURE.md`

## 17. Validación añadida en esta revisión

- Se centralizaron IDs predeterminados de clubes, estadio, formación, plantilla mínima, once inicial y valores de amistoso en `NovaPreMatchSetup`.
- `NovaMatchClockStateMachine` toma los valores iniciales de duración y reloj desde `NovaMatchClockRules`, evitando duplicar los defaults.
- Se corrigió la documentación de preparación del amistoso para reflejar C35–RDA, las 22 plazas por club y los siete estadios.
- Se corrigió la documentación técnica para reflejar Godot 4.4.1 y el objetivo Android ARM64.
- Se añadió `tests/test_match_configuration_defaults.gd` al workflow Android.
- Pendiente: ejecutar la nueva CI completa, resolver el conflicto de distribución de las diez ligas sin alterar silenciosamente la política del usuario, y validar el APK/partido en Android.


### Diferencia preservada entre la copia de distribución y Workspace

- `project.godot` de Workspace no tenía inicialmente `textures/vram_compression/import_etc2_astc=true`; se sincronizó para igualar el ajuste de importación comprimida del proyecto de distribución.
- `docs/ANDROID_GODOT_EDITOR.md` de Workspace no contenía el aviso actualizado de que el flujo vigente es ChatGPT + GitHub y que no se debe instalar el editor Android para este proyecto; se sincronizó el aviso.
- Se añadió `docs/REPOSITORY_ORIGIN.md` al espejo Workspace para conservar la procedencia y la política de no sobrescritura automática.
- Se conserva intencionalmente una diferencia en `modules/nova_3d_animation/nova_3d_animation.gd`: Workspace tiene señales y métodos adicionales para perfiles de animación, habilidades y celebraciones; la rama de distribución aún no. No se reemplazó la versión Workspace ni se copió la extensión al juego distribuible porque no se encontró un catálogo de perfiles ni una conexión runtime/prueba que justifique activarla. Queda como integración pendiente, no como configuración perdida.


### Contrato exacto de gestos táctiles

Fuentes: `data/skills/common_gesture_techniques.json`, `docs/IN_GAME_CONTROLS_GUIDE.md` y `docs/TOUCH_CONTROLS_AND_SKILLS.md`.

- Botón de técnica: secuencias direccionales ordenadas; el orden importa.
- Cambio mínimo de dirección: 55°.
- Duración de cada dirección: 70–420 ms.
- Ventana total de gesto: 850 ms.
- Cancelar por interrupción táctil o pérdida de posesión.
- Ejecutar solo al completar la secuencia; no convertir una secuencia incompleta en una acción de una sola dirección.
- Croqueta: arriba → derecha.
- Finta de cuerpo: arriba → izquierda.
- Arrastre atrás y salida: abajo → derecha.
- Giro de protección: abajo → izquierda.
- Amago de disparo: derecha → arriba.
- Botón de tiro: mantener para cargar; izquierda/derecha pide recorte y tiro posterior; arriba pide tiro picado.
- Botón de pase: mantener para pase raso cargado; arriba pase elevado; izquierda/derecha recorte y pase; abajo pase de tacón.
- Botón de presión: toque para presión normal; mantener y deslizar arriba durante 1 segundo solicita ayuda del compañero cercano.
- Gesto circular cerrado alrededor del botón de técnica solicita una habilidad avanzada aleatoria que esté equipada, elegible y sin enfriamiento; máximo tres activaciones por jugador y partido.

Los parámetros están definidos en JSON/documentación; el reconocimiento secuencial completo, carga progresiva y conexión con animaciones y físicas continúan pendientes.

### Persistencia contextual

`docs/CONTEXTUAL_GAME_SETTINGS.md` define que las preferencias globales, los ajustes por modo, los ajustes por competición y los ajustes por encuentro deben mantenerse separados. Los cambios que exijan reinicio se aplican al siguiente encuentro; restaurar valores requiere confirmación; salir sin guardar debe poder descartarlos. No se han fijado valores para dificultad IA, competitividad, perfil de atributos, velocidad de juego o asistencias que aún no estén implementadas.

`docs/SAVE_SYSTEM.md` define cinco espacios por modo (1 autoguardado, 2–5 manuales), veinte espacios para los cuatro grupos previstos, copia solo entre espacios manuales del mismo modo, confirmación al sobrescribir/borrar, formato versionado y recuperación segura. El documento no define nuevos desencadenantes de autoguardado: deben conservarse los ya establecidos en el proyecto y no inventarse otros.


### Verificación de espejo al cierre de esta revisión

Se compararon los árboles de ambos repositorios para 207 rutas relevantes (configuración del proyecto, datos, módulos, documentos, preferencias, controles, estadios, reloj, preparación de amistoso, prueba de defaults, prueba de Máximo y su modelo). Todas están presentes en el espejo Workspace. Sus SHA coinciden salvo una diferencia intencional y documentada: `modules/nova_3d_animation/nova_3d_animation.gd`, que conserva funciones extra en Workspace para perfiles de animación, habilidades y celebraciones. No se detectaron otras diferencias en ese conjunto.


## 18. Reglamentos de competiciones, cantera y estadísticas

### Reglas comunes de liga

Fuente: `data/cuban_competition_rules.json`.

- Puntos: victoria 3, empate 1, derrota 0.
- Duración reglamentaria oficial: 90 minutos.
- Sustituciones: máximo 5 en 3 ventanas; el descanso no cuenta como ventana.
- Sin playoff de descenso.
- Los desempates varían por formato:
  - Doble vuelta con dos equipos empatados: puntos, diferencia de goles particular, diferencia general, goles a favor, puntos disciplinarios ascendentes y sorteo.
  - Doble vuelta con tres o más: puntos, puntos entre empatados, diferencia particular, diferencia general, goles a favor, disciplina ascendente y sorteo.
  - Una vuelta: puntos, diferencia general, goles a favor, puntos particular, diferencia particular, disciplina ascendente y sorteo.

La duración de 90 minutos es el reglamento de competición; el amistoso de prueba usa un reloj comprimido seleccionable de 3–20 minutos por tiempo. No son dos valores que deban sustituirse uno por otro.

### Pirámide cubana definida

- Primera: 16 clubes, grupo único a doble vuelta, 30 jornadas; descienden 3 a Segunda.
- Segunda: 16 clubes, grupo único a doble vuelta, 30 jornadas; ascienden directamente 2 y los puestos 3–6 juegan semifinales y final a doble partido por el tercer ascenso; descienden 3 a Tercera.
- Tercera: 20 clubes, 2 grupos regionales de 10, 9 jornadas a una vuelta; ascienden directamente los dos campeones de grupo y los segundos juegan una eliminatoria a doble partido por el tercer ascenso.

### Copa y Supercopa de Cuba

- Copa: todos los clubes elegibles de Primera, Segunda y Tercera; eliminatorias a partido único salvo semifinales a doble partido; el club de división inferior recibe al superior; si son de la misma división, se sortea localía; final única en sede neutral.
- Rondas previstas: preliminar si es necesaria, dieciseisavos si el cuadro lo requiere, treintaidosavos, octavos, cuartos, semifinales a doble partido y final.
- Empates: prórroga y penaltis en eliminatorias a partido único y final.
- Los participantes de la Supercopa entran en la Copa en treintaidosavos si el tamaño del cuadro lo permite.
- Sorteos tempranos por proximidad geográfica y después sorteo abierto.
- Supercopa: campeón y subcampeón de liga más campeón y subcampeón de Copa; si hay duplicados, entra el siguiente mejor clasificado de liga no clasificado.
- Formato final four: semifinales y final a partido único, sede neutral, sin partido por tercer puesto; empate se resuelve directamente por penaltis, sin prórroga. Evitar repetir emparejamientos de semifinales cuando sea posible.

### Cantera

Fuente: `data/youth_academy_rules.json`.

- Cantera automática incluida hasta Primera División.
- Divisiones 2–6 empiezan sin cantera automática.
- Para crear cantera desde Segunda: licencia de asociación, instalaciones o contrato, personal cualificado, protección de menores aprobada, plan de desarrollo, fondos iniciales y liquidez operativa.
- Cobertura mínima de operación: 6 meses; reserva mínima: 2 meses.
- Sin cantera no se generan juveniles automáticamente.

### Estadísticas de jugadores

Fuente: `data/player_statistics_schema.json`.

- Todos los valores sin partidos empiezan en cero; tasas indefinidas son `null).
- Nunca inferir eventos de partido a partir de atributos.
- Cada registro requiere `match_id`; IDs duplicados se rechazan.
- Mantener totales por temporada y carrera.
- Categorías: participación, resultados colectivos, ataque, creación/pase, regate, defensa, disciplina, portería, rendimiento/premios e indicadores derivados.
- Incluye apariciones, titularidades, suplencias, minutos, victorias/empates/derrotas, goles, asistencias, tiros, penaltis, pases, pases clave, ocasiones, regates, entradas, intercepciones, recuperaciones, faltas, tarjetas, paradas, porterías a cero, MVP y valoración media.
- Los indicadores derivados se calculan desde eventos registrados; no deben inventarse partidos ni estadísticas anteriores.

### Balones oficiales

Fuente: `data/league_official_balls.json`.

- `nova_classic_white` — Nova Classic.
- `nova_cuba_tropical` — Cuba Tropical.
- Ambos son recursos originales y usan el perfil físico `standard_match_ball`.
- La liga nacional cubana comparte Cuba Tropical entre sus divisiones.
