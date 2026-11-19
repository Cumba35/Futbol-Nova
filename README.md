# Fútbol Nova

Repositorio independiente del videojuego **Fútbol Nova**. Contiene la copia del proyecto publicada anteriormente dentro de Cumba35/Web-Publica-Nova/futbol-nova.

## Desarrollo y compilación

El desarrollo se administra mediante **ChatGPT y GitHub**. No es necesario instalar Godot, Android Studio, Unity ni otro editor en el teléfono. Las pruebas y exportaciones se ejecutan en GitHub Actions. El flujo de pruebas y APK Android está en [Fútbol Nova — pruebas y APK](https://github.com/Cumba35/Futbol-Nova/actions/workflows/futbol-nova-android-apk.yml).

- Proyecto Godot: project.godot
- Documentación del juego: GAME_README.md y docs/
- Datos, clubes y jugadores: data/
- Escenas y scripts: scenes/ y scripts/
- Pruebas: tests/
- Investigación de repositorios públicos y política de reutilización: [docs/THIRD_PARTY_RESEARCH.md](docs/THIRD_PARTY_RESEARCH.md).

## Repositorio maestro NOVA

La copia original y el historial principal del proyecto se conservan en el repositorio privado Cumba35/Nova-Workspace, en proyectos/juegos/futbol-nova/.

Este repositorio es la distribución independiente de Fútbol Nova. Los cambios no se sincronizan automáticamente hacia Nova Workspace: se revisan primero para evitar sobrescribir el proyecto maestro.

## Origen de esta importación

La importación copia el contenido de Cumba35/Web-Publica-Nova/futbol-nova/ desde la rama main. El repositorio público de origen no se elimina ni se modifica.


## Investigación técnica

Las alternativas públicas, sus licencias, compatibilidad Android y decisiones de reutilización se registran en [la auditoría de repositorios públicos](docs/PUBLIC_GITHUB_RESEARCH_2026-11-18.md).


## Estado de validación — 18-11-2026

- Se corrigió la referencia global `ManagerCareer` que impedía compilar la prueba headless del perfil de Máximo Padilla; detalle en [CI_44450991327_FIX.md](docs/CI_44450991327_FIX.md).
- La corrección está sincronizada con `Cumba35/Nova-Workspace`; la nueva ejecución CI `44453253855` debe terminar antes de declarar aprobada la corrección o la APK.
- Godot 4.4.1, funcionamiento offline y Android ARM64 se mantienen como requisitos.


## Estado CI — 19-11-2026

La ejecución 44453253855 detectó una segunda referencia global a FootballDatabase en el servicio de carrera durante compilación headless. Se corrigieron las llamadas de guardado y carga mediante búsqueda de /root/FootballDatabase; la corrección está sincronizada con Nova Workspace. CI nueva 44507868982 pendiente. Ver docs/CI_44450991327_FIX.md. No declarar APK validada antes de completar la CI.


## Corrección CI — 19-11-2026

Se corrigió el aislamiento headless de la prueba de Máximo Padilla: la física se desactiva antes de añadir el nodo al árbol. Los detalles y la sincronización están en [CI_44507868982_DIAGNOSIS.md](docs/CI_44507868982_DIAGNOSIS.md). La nueva ejecución debe pasar las regresiones y generar el APK antes de declarar la versión validada.
