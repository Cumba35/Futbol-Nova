# Fútbol Nova — publicación temprana del APK de prueba

**Fecha:** 19-11-2026

Para acelerar la primera instalación real en Android, el workflow ahora exporta y publica `futbol-nova-android-debug` inmediatamente después de las pruebas esenciales del amistoso (base 11v11 y partido en vivo con goles/períodos), antes de las pruebas extendidas de porterías, estadios y regresiones.

Cambio aplicado en `873afbd19f62155cedacf579300bd5e6965f04c9` en `.github/workflows/futbol-nova-android-apk.yml`.

La compilación anterior 335 había completado las pruebas de controles táctiles, pantallas principales, vuelo del balón, base 11v11 y amistoso en vivo. Se quedó ejecutando la prueba de marcos físicos y redes antes de alcanzar el paso de exportación. Por ello todavía no había APK.

La nueva ordenación hace que la siguiente ejecución publique un APK de prueba antes de esas pruebas largas, sin eliminarlas ni marcarlas como superadas. Las regresiones continuarán después de publicar el artefacto. El APK se considera candidato de prueba, no versión terminada.

Pendiente:
- [ ] Confirmar que la nueva ejecución genera `FutbolNova-debug.apk`.
- [ ] Confirmar el artefacto `futbol-nova-android-debug`.
- [ ] Verificar dentro del APK la biblioteca `arm64-v8a`.
- [ ] Instalar y abrir en el Android del usuario.
- [ ] Completar amistoso 11 contra 11 en el teléfono.
