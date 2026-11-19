# Diagnóstico Android — requisito de compresión ETC2/ASTC

**Fecha:** 19-11-2026  
**Godot:** 4.4.1  
**Ejecución:** 335 — https://github.com/Cumba35/Futbol-Nova/actions/runs/44551233214

La configuración de rutas Java/Android SDK y la instalación de plantillas ya completan correctamente. Las pruebas esenciales del partido 11v11 y amistoso en vivo también pasan. La exportación falló todavía con un mensaje vacío de configuración:

`Cannot export project with preset "Android" due to configuration errors:`

El proyecto usaba GL Compatibility pero no declaraba la importación de texturas ETC2/ASTC, requisito de compresión para exportación Android en Godot. Godot 4.4.1 puede omitir el detalle del error en modo headless; se documentó el problema equivalente en Godot upstream: https://github.com/godotengine/godot/issues/123504

## Corrección aplicada

Commit `de1a8f6c407312303bcd4bbc760a0834b6dd074c` en `project.godot`:

`textures/vram_compression/import_etc2_astc=true`

La configuración se añade dentro de la sección `[rendering]`, junto al método GL Compatibility. Esto activa la importación ETC2/ASTC que necesita la exportación Android.

## Próxima verificación

- [ ] Confirmar una nueva ejecución CI.
- [ ] Comprobar que el paso Export arm64 debug APK finaliza.
- [ ] Verificar que el artefacto `futbol-nova-android-debug` existe.
- [ ] Verificar la librería `lib/arm64-v8a` dentro del APK.
- [ ] Instalar en el teléfono y probar el amistoso 11v11.

La corrección anterior de rutas SDK/JDK se conserva. No se declara el APK listo hasta verificar el artefacto real.
