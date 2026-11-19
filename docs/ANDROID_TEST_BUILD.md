# Fútbol Nova — pruebas y APK Android

## Repositorio y proyecto

- Repositorio independiente: Cumba35/Futbol-Nova.
- Proyecto Godot: raíz del repositorio (archivo project.godot).
- Repositorio maestro NOVA: Cumba35/Nova-Workspace, carpeta proyectos/juegos/futbol-nova/. La copia original allí se conserva intacta.
- Motor fijado para CI: Godot 4.4.1.
- Plataforma: Android ARM64.
- Identificador: com.nova.futbolnova.
- Workflow: .github/workflows/futbol-nova-android-apk.yml.

## Desarrollo sin aplicaciones externas

El propietario trabaja exclusivamente con ChatGPT y GitHub. No debe requerírsele instalar Godot, Android Studio, Unity, editores o compiladores en Android. El motor, las plantillas y el SDK se instalan temporalmente dentro de GitHub Actions.

## Ejecución del workflow

El workflow se ejecuta al actualizar archivos de proyecto en main o ramas work/**, al abrir o actualizar un pull request hacia main y manualmente desde GitHub Actions.

1. Empaqueta y publica el ZIP del código fuente editable.
2. Instala Java 17, Android SDK y Godot 4.4.1 con sus plantillas dentro del runner temporal.
3. Importa recursos Godot en modo headless.
4. Ejecuta validaciones de nombres de clubes y archivo histórico.
5. Ejecuta pruebas de aceptación del hub, amistoso 11v11, marcador, colisiones de postes/larguero/red, cambio de lado, reloj y ciclo hasta el pitido final.
6. Comprueba el arranque de la escena.
7. Exporta la APK Android ARM64 de depuración.
8. Publica el artefacto futbol-nova-android-debug si las pruebas y exportación terminan correctamente.
9. Ejecuta después la regresión extendida.

Cada prueba Godot se ejecuta en un paso independiente con un límite de 180 segundos (smoke test: 120 segundos). Así GitHub Actions muestra exactamente cuál prueba está ejecutándose o falló, sin ocultar el progreso dentro de un único bloque largo.

## Descargar APK desde Android

1. Abre [Fútbol Nova — pruebas y APK Android](https://github.com/Cumba35/Futbol-Nova/actions/workflows/futbol-nova-android-apk.yml).
2. Selecciona la ejecución más reciente de main que tenga conclusión exitosa.
3. Abre Artifacts y descarga futbol-nova-android-debug.
4. Extrae el ZIP e instala FutbolNova-debug.apk.

## Estado de compilación

La primera importación del código fuente desde Web-Publica-Nova terminó correctamente. Una ejecución posterior detectó el uso del paquete Android SDK obsoleto tools; el workflow se actualizó a android-actions/setup-android@v4 y dejó de solicitar ese paquete. Las siguientes ejecuciones llegaron a la etapa de pruebas Godot, pero se cancelaron al actualizar el workflow. Se añadieron límites individuales y logs agrupados, y se ampliaron las pruebas del marcador y el cambio de lado.

El artefacto futbol-nova-godot-source conserva el código fuente editable. No se debe afirmar que la APK está generada ni que la suite ha pasado hasta que GitHub Actions publique futbol-nova-android-debug y la ejecución termine correctamente.

## Alcance funcional

La prueba de integración verifica inicio del amistoso, marcador de ambos equipos, rechazo de goles fuera de un partido activo, colisiones de postes/larguero/red, pausa, cambio de lado al descanso, reanudación, ciclo de prórroga y final del segundo tiempo. Esto no certifica por sí solo todas las mecánicas de juego, la física, la IA, las animaciones ni el equilibrio completo de un partido 11 contra 11.


### Último diagnóstico de CI — 18 noviembre 2026

La ejecución `44415238766` llegó a las pruebas de Godot y falló en `test_game_hub.gd`: el preload de `pre_match_setup.gd` resolvía `FootballData` como identificador global durante el modo SceneTree headless y la pantalla Ayuda se comprobaba antes de retirar nodos anteriores encolados para liberar. Se corrigió la resolución del autoload mediante `/root/FootballData`, se retiraron inmediatamente los nodos antiguos del contenedor y se añadieron comprobaciones por títulos de ayuda y un watchdog interno de 120 segundos. La validación previa de datos sí pasó: 519 nombres de clubes únicos y archivo histórico con 15 competiciones, 410 ediciones y 571 resultados. La siguiente ejecución debe confirmar estas correcciones y las pruebas de goles/porterías antes de exportar una APK.


### Diagnóstico adicional de UI y datos — 18 noviembre 2026

La ejecución `44416626883` confirmó que la resolución de `FootballData` y la retirada inmediata de nodos del hub ya permitieron avanzar más. Después encontró dos problemas adicionales: el catálogo internacional contiene `founding_year: null` en varias competiciones, por lo que una conversión directa `int(null)` fallaba; y la prueba esperaba una lista de jugadores dentro de Online aunque el juego base muestra correctamente Online como módulo descargable. Se añadió `_safe_int()` para valores nulos/mixtos y se ajustó la prueba para validar que Online siga siendo opcional. También se reforzó el aislamiento del registro local: solo se cargan jugadores con origen `user_created`, y se rechazan jugadores `nova_catalog` tanto al guardar como al seleccionar para Online.

La siguiente ejecución debe validar estos cambios; hasta entonces no se considera aprobada la suite ni generada una APK instalable.


### Corrección del módulo de realismo opcional — 18 noviembre 2026

La suite 11v11 detectó que `realism_module.gd` hacía referencia directa al autoload `ContentPackages` al compilarse como script aislado, impidiendo cargar el controlador y validar el perfil. El módulo ahora resuelve el servicio de forma dinámica desde `/root/ContentPackages` cuando existe; si no está disponible, desactiva el perfil y conserva el juego base. También valida tipos de `schema_version`, `profile` y valores numéricos antes de usarlos. Esto mantiene la regla de que el paquete de realismo es opcional y no debe impedir iniciar el juego base.


### Dependencia del módulo de realismo en pruebas headless — 18 noviembre 2026

La primera ejecución de la prueba de base 11v11 compiló el controlador y detectó que `realism_module.gd` aún referenciaba el autoload `ContentPackages` como identificador global. El módulo ahora resuelve el servicio desde `Engine.get_main_loop() as SceneTree` y accede a sus métodos dinámicamente; si el servicio no está disponible, el módulo opcional devuelve el perfil base desactivado. También valida tipos numéricos y rangos antes de habilitar el perfil. `validate_profile()` sí existe; el error de llamada observado era consecuencia del fallo de compilación de la dependencia. La próxima ejecución debe confirmar la compilación del controlador y la prueba de reglas.


### Progreso de CI — 18 noviembre 2026

- Ejecución `44417940711`: preparación Android/Godot, importación, validación de 519 nombres de clubes, validación de 15 competiciones/410 ediciones/571 resultados y prueba del hub pasaron. La prueba de base 11v11 falló porque ese commit aún contenía la referencia estática antigua a `ContentPackages`.
- Ejecución `44418906130`: usa el commit con el servicio de paquetes resuelto dinámicamente y vuelve a ejecutar la suite desde el inicio. Está en curso; aún no hay resultado de la prueba 11v11 ni APK.


## Robustez de las pruebas headless — 18 noviembre 2026

Las pruebas iniciadas con `godot --headless --script` no deben asumir que los autoloads están disponibles como identificadores globales al compilar scripts pre-cargados. La escena principal y la prueba runtime resuelven `FootballData` desde el árbol (`/root/FootballData` o `root.get_node_or_null("FootballData")`) y manejan el servicio ausente de forma explícita. La prueba de aceptación del amistoso se difiere con `call_deferred` después de crear el `SceneTree` y tiene un watchdog interno de 120 segundos; la prueba de base 11v11 también se difiere para ejecutar una vez inicializado el árbol. Esto evita falsos fallos de compilación y bloqueos silenciosos del runner. La validación final sigue dependiendo del resultado completo de GitHub Actions.


### Ajuste de expectativa del tiempo añadido — 18 noviembre 2026

La ejecución `44418906130` superó la compilación del módulo de realismo y llegó a las pruebas del reloj. Detectó que el test esperaba 30 segundos de añadido continuo, pero la regla del motor aplica un mínimo reglamentario de 60 segundos; el test ahora espera 60 y avanza 60 segundos hasta el descanso. Los fallos de descanso/espera eran consecuencia de la expectativa anterior, no de una transición defectuosa del estado. La prueba corregida está en el siguiente commit de main y se volverá a ejecutar.


### Corrección de MomentsService y carga de escena — 18 noviembre 2026

La prueba runtime detectó una referencia global directa a `MomentsService` en `main.gd`, que impedía compilar la escena al cargarla desde un test headless. El registro de goles ahora resuelve el servicio con `/root/MomentsService` y verifica que el método exista antes de invocarlo. La prueba de amistoso comprueba además que el script principal se haya cargado antes de acceder a sus propiedades, evitando esperar hasta el timeout ante un error de compilación.


### Validación 11v11 superada — 18 noviembre 2026

La ejecución `44419455179` pasó la preparación Android/Godot, importación, validaciones de clubes e histórico, prueba del hub y prueba de fundamentos 11v11. La prueba del reloj confirmó tiempo continuo/detenido, tiempo añadido mínimo de 60 segundos, descanso, pausa para decisión del usuario y continuación del segundo tiempo. La misma ejecución continúa con la prueba runtime del amistoso, goles y periodos; aún no hay resultado de APK.

Las pruebas de escena cargan ahora `scenes/main.tscn` de forma dinámica después de que el proyecto haya inicializado los autoloads. Esto evita compilar la escena durante el parseo del script de test, antes de registrar los nombres globales de los servicios.


### Dependencia de Momentos en la escena principal — 18 noviembre 2026

La ejecución `44419455179` pasó fundamentos 11v11, pero el test runtime detectó una referencia estática a `MomentsService` al compilar `scripts/main.gd`. La escena principal ya resuelve el autoload desde `/root/MomentsService` en el árbol activo, evitando la dependencia del identificador global en headless. El error secundario de acceso a `game_hub` provenía de que el script principal no llegó a compilar. La nueva ejecución debe confirmar la carga de la escena y el amistoso runtime.


### Diagnóstico y corrección del test runtime — 18 noviembre 2026

La ejecución `44419455179` pasó importación, validación de clubes, validación histórica, prueba del hub y fundamento 11v11, pero falló en `test_friendly_match_runtime.gd`: `scripts/main.gd` todavía contenía una referencia estática a `MomentsService`. El error de compilación provocó después un acceso inválido a `game_hub`; ese segundo error era consecuencia del primero.

Se portó al repositorio maestro la corrección que resuelve el servicio mediante `get_node_or_null("/root/MomentsService")`, junto con la lógica separada de goles de entrenamiento y amistosos. La prueba runtime se recuperó con carga de escena posterior a la inicialización de autoloads, watchdog, comprobación de progreso de Momentos y verificación del amistoso de muestra Albor Madrid vs Litoral Barcelona. Se declaró explícitamente el script de Momentos usado por la prueba para evitar identificadores no declarados.

El workflow maestro ahora se ejecuta automáticamente al cambiar archivos del proyecto en `main` o ramas `work/**`, en pull requests hacia `main` y manualmente. Se añadieron pruebas independientes de vuelo del balón y de colisiones/contención de porterías. **La nueva ejecución todavía no tiene un resultado CI confirmado; no se afirma que la suite haya pasado ni que exista una APK nueva.**


### Estadios procedurales — 18 noviembre 2026

El juego base incorpora tres estadios originales offline. La preparación transmite el ID elegido y la escena principal construye la geometría del estadio al iniciar el amistoso. El workflow incluye `test_stadium_builder.gd` y la prueba runtime comprueba que el estadio seleccionado se aplique. La vista previa dentro de la pantalla de preparación, la iluminación dinámica y la validación física de las gradas siguen pendientes.


### Corrección de liberación del balón por la IA — 19 noviembre 2026

La revisión del controlador 11v11 encontró que los futbolistas de IA y los porteros liberaban la posesión, pero no aplicaban el impulso previsto al balón. Se centralizó la operación en `apply_ai_kick()`: valida cuerpo, dirección y fuerza, descongela/despierta el balón y aplica el impulso. La prueba de fundamentos crea un `RigidBody3D` real y comprueba que el balón adquiere velocidad, además de rechazar una dirección nula. Esta corrección queda pendiente de confirmación por la siguiente ejecución de GitHub Actions; no certifica por sí sola el partido completo ni la APK.


### Diagnóstico CI y corrección de compilación headless — 19 noviembre 2026

La ejecución `44448995746` terminó con fallo en `Core test — live friendly match, goals and periods`. El log identificó dos causas primarias: `scripts/main.gd:502` no podía inferir el tipo de `active_match` en Godot 4.4.1; y `scripts/ui/pre_match_setup.gd` referenciaba el autoload `FootballData` como identificador global en un script pre-cargado por pruebas headless. El acceso inválido posterior a `game_hub` y el timeout eran consecuencias de que la escena principal no llegó a compilar.

Se corrigió `active_match` con tipo explícito `bool`. La pantalla de preparación ahora resuelve el servicio mediante `get_node_or_null("/root/FootballData")`, valida que el registro siga disponible antes de consultar plantillas y vuelve a comprobar que ambos equipos existan al iniciar. Se añadió una prueba de regresión en `test_shared_foundation.gd` para impedir referencias estáticas al autoload y exigir la resolución dinámica. Los cambios están guardados en el repositorio maestro y sincronizados en `Cumba35/Futbol-Nova`; ambos repositorios se releyeron y los seis archivos modificados quedaron idénticos. La incidencia solo se considerará resuelta cuando la siguiente ejecución CI confirme la compilación y las pruebas.


### Corrección de importación de datos fuente CSV — 19 noviembre 2026

La ejecución `44449744055` falló antes de ejecutar las pruebas: Godot 4.4.1 intentó importar los archivos de `data/imports/` como tablas de traducción. Esos CSV son datos tabulares de procedencia para herramientas Python, no recursos de localización: sus encabezados (`source_club_id`, `country_code`, etc.) no son códigos de idioma y `verified_player_squads.csv` contiene por ahora solo la cabecera. El importador produjo repetidamente `Condition "bucket_table_size == 0" is true` y el proceso terminó con aborto de memoria (código 134).

La corrección es añadir `data/imports/.gdignore` para excluir únicamente esa carpeta del escaneo/importación de recursos de Godot. Los archivos permanecen en GitHub y siguen disponibles para `tools/build_global_database.py` y las validaciones Python, que acceden al sistema de archivos directamente. El workflow ahora comprueba que el marcador y los tres CSV existan antes de importar el proyecto.

**Validación pendiente:** la siguiente ejecución debe superar `Import project resources` y continuar con las pruebas Godot. No se considera corregido hasta que el workflow completo termine correctamente; todavía no hay APK nueva confirmada.


### Ajuste de prueba de impulso físico — 19 noviembre 2026

La ejecución `44450427320` superó la importación de recursos, la validación de 519 nombres de clubes, el archivo histórico, la navegación del hub y el modelo de vuelo del balón. La prueba de fundamentos 11v11 falló al comprobar `linear_velocity` inmediatamente después de llamar a `apply_central_impulse()`, sin esperar el siguiente paso de física.

Se corrigió la prueba para crear un `RigidBody3D` con masa y colisión esférica equivalentes al balón del juego, aplicar el impulso y comprobar la velocidad después de un `physics_frame` adicional. La implementación del controlador no se cambió en esta revisión: primero se está validando que la prueba mida el resultado físico en el momento correcto. La ejecución `44450701630` debe confirmar el ajuste; si vuelve a fallar, se investigará el impulso del cuerpo real antes de modificar la mecánica.
