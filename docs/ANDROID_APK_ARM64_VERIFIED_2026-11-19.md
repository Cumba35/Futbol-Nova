# Fútbol Nova — primer APK Android ARM64 verificado

**Fecha:** 19-11-2026  
**Ejecución GitHub Actions:** 337  
**Ejecución:** https://github.com/Cumba35/Futbol-Nova/actions/runs/44552178251  
**Artefacto:** `futbol-nova-android-debug`  
**Artifact ID:** `14544655238`

## Resultado

Se exportó correctamente `FutbolNova-debug.apk` y se publicó el artefacto de GitHub Actions antes de las regresiones extendidas.

Verificación local del APK extraído:
- Tamaño: 29,961,953 bytes.
- ZIP/APK íntegro: `unzip -t` sin errores.
- Incluye `AndroidManifest.xml`.
- Incluye `lib/arm64-v8a/libgodot_android.so`.
- Todas las bibliotecas nativas encontradas pertenecen a `arm64-v8a`.
- Incluye entradas de firma `META-INF/ANDROIDD.SF` y `META-INF/ANDROIDD.RSA`.
- SHA-256: `797c2a7e37ea581e20ef92bab16557eac039b42a620e282596c9ce2e4a91328e`.

## Estado

**APK de prueba ARM64 generado y verificado estructuralmente.** Todavía no está probado en el teléfono del usuario. La ejecución 337 sigue con pruebas posteriores a la exportación (en el último chequeo, marcos físicos de porterías y redes); no se declara terminada la validación del juego.

Pendiente:
- [ ] Instalar APK en el Android del usuario.
- [ ] Abrir y verificar que arranca.
- [ ] Jugar un amistoso local completo 11 contra 11.
- [ ] Revisar controles táctiles, rendimiento y estabilidad en el dispositivo.
