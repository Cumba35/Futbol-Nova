# Fútbol Nova — exportación APK antes de las pruebas de runtime

**Fecha:** 19-11-2026

Se adelanta el paso de exportación del APK ARM64 para que ocurra inmediatamente después de importar los recursos de Godot, antes de las pruebas de runtime que pueden tardar o bloquearse en CI.

Commit del workflow: `c97714abd6f7c674436f7de9916f4c2c96e40e97`.

El flujo mantiene todas las pruebas: el APK se publica como candidato de prueba primero y las pruebas de controles, partido 11v11, amistoso, porterías, estadios y regresiones continúan después. Esto no convierte el APK en versión final ni significa que las pruebas hayan pasado.

El proyecto ya incluye `textures/vram_compression/import_etc2_astc=true` en `project.godot` (commit `de1a8f6c407312303bcd4bbc760a0834b6dd074c`) y las rutas JDK/Android SDK están configuradas.

Ejecución anterior 337: las pruebas hasta la base 11v11 pasaron; el amistoso en vivo seguía ejecutándose y aún no había llegado al paso de exportación cuando se hizo el último chequeo.

## Pendiente
- [ ] Confirmar que el workflow exporta el APK.
- [ ] Descargar y verificar `futbol-nova-android-debug`.
- [ ] Confirmar que contiene `lib/arm64-v8a`.
- [ ] Instalarlo en Android y jugar un amistoso 11v11.
