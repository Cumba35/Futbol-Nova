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
5. Ejecuta pruebas de aceptación del hub, amistoso 11v11, marcador, cambio de lado, reloj y ciclo hasta el pitido final.
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

La prueba de integración verifica inicio del amistoso, marcador de ambos equipos, rechazo de goles fuera de un partido activo, pausa, cambio de lado al descanso, reanudación, ciclo de prórroga y final del segundo tiempo. Esto no certifica por sí solo todas las mecánicas de juego, la física, la IA, las animaciones ni el equilibrio completo de un partido 11 contra 11.



## Física de porterías y goles tras el descanso

El proyecto incluye colisiones físicas para postes, larguero y paneles de red (fondo, laterales y techo). La prueba `tests/test_goal_frame_physics.gd` comprueba que el balón rebota en el poste y el larguero, queda contenido por la red y no recibe un gol falso al entrar desde detrás. También se prueba que la atribución del gol y el saque de puerta respeten el cambio de extremos del segundo tiempo y de la prórroga.

Esta cobertura es automatizada en GitHub Actions; no sustituye la prueba visual de una APK instalada en un dispositivo Android real.



## Correcciones de la última ejecución CI

La primera ejecución completa con Godot detectó errores de análisis estático antes de exportar:

- `pre_match_setup.gd` hacía referencia directa al singleton `FootballData`; se sustituyó por una resolución explícita del nodo `/root/FootballData` y comprobación de su registro.
- `test_friendly_match_runtime.gd` ahora declara tipos explícitos para valores que se leen de propiedades dinámicas de la escena.
- `test_game_hub.gd` acumula las comprobaciones fallidas y termina con código 1, evitando que un `assert` detenga la función sin cerrar el proceso hasta el timeout.

Estas correcciones se vuelven a comprobar en la ejecución actual. La prueba no se considera aprobada hasta que Actions marque el paso como exitoso.
