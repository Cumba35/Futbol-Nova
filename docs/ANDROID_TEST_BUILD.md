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
