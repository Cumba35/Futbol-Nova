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

1. Importa recursos Godot en modo headless.
2. Ejecuta validaciones de nombres de clubes y archivo histórico.
3. Ejecuta pruebas de aceptación del hub, amistoso 11v11 y ciclo de reloj hasta el final.
4. Comprueba el arranque de la escena.
5. Exporta la APK Android ARM64 de depuración.
6. Publica el artefacto futbol-nova-android-debug si las pruebas y exportación terminan correctamente.
7. Cada prueba Godot tiene un límite individual de 180 segundos (smoke test: 120 segundos) y aparece agrupada en los logs para facilitar el diagnóstico.
7. Ejecuta después la regresión extendida.

También publica el ZIP futbol-nova-godot-source para conservar el proyecto editable en caso de que una etapa Android posterior falle.

## Descargar APK desde Android

1. Abre [Fútbol Nova — pruebas y APK Android](https://github.com/Cumba35/Futbol-Nova/actions/workflows/futbol-nova-android-apk.yml).
2. Selecciona la ejecución más reciente de main.
3. Abre Artifacts y descarga futbol-nova-android-debug.
4. Extrae el ZIP e instala FutbolNova-debug.apk.

## Estado de la primera ejecución

La importación del proyecto desde Web-Publica-Nova terminó correctamente. En la primera ejecución del workflow de APK, la creación del ZIP de código y la configuración de Java terminaron correctamente, pero la acción Android SDK v3 falló al solicitar el paquete obsoleto tools (Google ya no publica ese paquete). El workflow se actualizó a android-actions/setup-android@v4 y se eliminó esa dependencia obsoleta.

La corrección debe verificarse con una nueva ejecución. No se debe afirmar que la APK está generada hasta que exista un artefacto descargable y la ejecución de exportación haya terminado correctamente.

## Alcance funcional

La prueba de integración verifica el ciclo del reloj del amistoso a través del controlador: primer tiempo, descanso, continuación y final del segundo tiempo. Esto no certifica por sí solo todas las mecánicas de juego, la física, la IA, las animaciones ni el equilibrio completo de un partido 11 contra 11.
