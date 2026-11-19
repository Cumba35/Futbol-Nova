

## Investigación complementaria de repositorios públicos — 19-11-2026

Se añadieron tres candidatos encontrados en la búsqueda pública de GitHub. Se revisó el README y, cuando estaba disponible, el archivo de licencia directamente desde sus repositorios.

| Repositorio | Evidencia verificada | Posible aprendizaje | Decisión para Fútbol Nova |
|---|---|---|---|
| [zocram4cc/GodotFootball](https://github.com/zocram4cc/GodotFootball) | README declara Godot 4.7, motor de partido AI-vs-AI derivado de GameplayFootball, GDExtension C++20, CMake/Ninja, SQLite/Boost y lectura de recursos desde una instalación propia de PES 2021. Se verificó LICENSE Apache-2.0. | Separación de simulación determinista, herramientas de inspección, documentación de formatos y límites claros entre motor y assets del usuario. | Referencia arquitectónica, no integración directa: Godot 4.7 no coincide con Godot 4.4.1; el stack C++20/GDExtension y las dependencias no son necesarios para el APK Android offline; exige recursos locales de PES 2021 y no concede derechos sobre ellos. No copiar modelos, texturas, animaciones, datos ni archivos del juego. |
| [richardschembri/GodotBasic3DFootball](https://github.com/richardschembri/GodotBasic3DFootball) | README describe una demo 3D básica de fútbol y enumera recursos externos; no se confirmó licencia reutilizable en el archivo revisado. | Referencia visual general de prototipos 3D y control local. | Solo estudio conceptual. No copiar código ni assets mientras no se confirme licencia y procedencia de cada recurso. |
| [christianperich/FootballManagerGodot](https://github.com/christianperich/FootballManagerGodot) | README consultado contiene únicamente el título del proyecto; no aporta documentación técnica suficiente ni licencia confirmada en esa lectura. | Sin evidencia suficiente para extraer una mejora concreta. | Candidato descartado por ahora; no integrar ni copiar código o recursos. |

### Resultado de adopción

- No se añade ninguna dependencia, extensión nativa ni recurso de terceros.
- Se conserva Godot 4.4.1, GDScript y el objetivo Android ARM64 offline.
- La referencia GodotFootball se limita a patrones de arquitectura y pruebas; Apache-2.0 no autoriza el uso de recursos de PES ni de materiales de terceros que el proyecto lea localmente.
- Antes de cualquier adopción futura, verificar licencia y avisos del commit exacto y de cada recurso/dependencia; después portar de forma explícita y ejecutar la suite completa de GitHub Actions.

### Validación GitHub Actions observada durante esta revisión

- Workflow: `Fútbol Nova - pruebas y APK Android`.
- Run: [#215 / 44446376927](https://github.com/Cumba35/Futbol-Nova/actions/runs/44446376927).
- Estado al consultar: `in_progress`; el paso de instalación de Godot 4.4.1 y sus export templates estaba ejecutándose.
- El empaquetado del proyecto fuente y la configuración de Java 17, Android SDK y paquetes Android habían terminado correctamente.
- Las pruebas de juego, regresiones y exportación del APK todavía estaban pendientes. Este estado no equivale a CI aprobado ni a APK generada.
