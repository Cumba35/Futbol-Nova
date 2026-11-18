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

Cada prueba Godot tiene un límite individual de 180 segundos (smoke test: 120 segundos) y aparece agrupada en los logs para facilitar el diagnóstico. Si una prueba se bloquea, falla con un límite claro y no deja el job indefinidamente detenido.

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
