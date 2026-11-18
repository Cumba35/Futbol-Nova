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
