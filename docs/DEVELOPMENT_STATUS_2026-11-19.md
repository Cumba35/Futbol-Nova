# Estado de desarrollo — Fútbol Nova — 19-11-2026

## Fuente canónica y distribución

- Distribución pública: [Cumba35/Futbol-Nova](https://github.com/Cumba35/Futbol-Nova).
- Maestro del ecosistema: [Cumba35/Nova-Workspace](https://github.com/Cumba35/Nova-Workspace/tree/main/proyectos/juegos/futbol-nova).
- Ruta canónica: `proyectos/juegos/futbol-nova/`.
- Motor: Godot 4.4.1; Android ARM64; modo local/offline.
- No editar el proyecto desde el teléfono ni pedir al propietario que instale herramientas: compilar y probar con GitHub Actions.

## Prioridad activa

Terminar y validar primero un amistoso local 11v11 jugable en Android y obtener el APK ARM64. No desplazar esta prioridad con modos de carrera/gestión ni con integración de motores externos.

## Estado CI más reciente comprobado

Ejecución 44551233214: las pruebas principales del partido y la escena Android pasaron; la exportación APK falló por configuración del preset Android. Se publicó el ZIP de código fuente, pero no el APK. El diagnóstico está en `docs/CI_44551233214_DIAGNOSIS.md`.

## Investigación externa

La nueva ronda de repositorios públicos está registrada en `docs/PUBLIC_GITHUB_RESEARCH_2026-11-19.md`. Se estudiaron separación de motor/render, simulación determinista, pruebas headless, snapshots y controles táctiles. No se copió código ni assets y no se añadieron dependencias.

## Próximos pasos

1. Obtener salida detallada de validación del preset Android.
2. Corregir la causa exacta de exportación sin alterar el diseño del juego.
3. Pasar regresiones extendidas.
4. Publicar y verificar APK ARM64.
5. Instalar y probar en Android: controles, posesión, pase, tiro, porteros, IA, goles, reloj, pausas y pitido final.
6. Solo después ampliar el alcance del desarrollo y cerrar el modo amistoso.

## Regla permanente de sincronización

Cada cambio del proyecto debe quedar registrado en GitHub, en el archivo y carpeta correspondientes. Los cambios de código y documentación que formen parte del producto se sincronizan en la ruta canónica de Nova Workspace. Después de escribir, volver a leer ambos archivos y comparar SHA de contenido; no afirmar que se guardó o sincronizó algo sin esa verificación.
