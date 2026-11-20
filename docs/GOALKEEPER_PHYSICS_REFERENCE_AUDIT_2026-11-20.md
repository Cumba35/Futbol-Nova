# Auditoría de física del guardameta y referencias públicas — 20-11-2026

## Hallazgo de CI

La ejecución 44677788159 completó la exportación inicial del APK y las pruebas anteriores, pero falló en `Core test — friendly goalkeeper positioning`. Las regresiones posteriores y la subida del APK quedaron omitidas por la condición de éxito del workflow. No debe tratarse como una compilación validada.

## Corrección de la prueba

La prueba de integración ahora:
- espera un paso de física después de incorporar el cuerpo animable al árbol, para que el servidor de física registre el collider antes del disparo;
- verifica explícitamente `AnimatableBody3D.sync_to_physics`;
- activa el monitoreo de contactos del balón y comprueba una señal de contacto real con el guardameta;
- configura el rebote del balón de prueba con combinación MAX, para que la aserción mida el contacto y la respuesta física sin depender del material por defecto de una esfera recién creada;
- amplía la ventana de simulación a 30 pasos físicos y diferencia entre ausencia de contacto y contacto sin rebote.

Esta corrección mejora el diagnóstico: ya no confunde “no se registró contacto” con “hubo contacto pero no se produjo el rebote esperado”. Debe validarse en la siguiente ejecución Godot 4.4.1 CI.

## Referencias públicas revisadas

- Godot Engine, documentación oficial de [AnimatableBody3D](https://docs.godotengine.org/en/stable/classes/class_animatablebody3d.html): el cuerpo no recibe fuerzas externas; al moverlo manualmente estima velocidad y afecta cuerpos que se desplazan contra él. `sync_to_physics` sincroniza el movimiento con el paso de física. Es la clase adecuada para el collider móvil del portero, no un sustituto de una animación de atajada.
- [namelesssyf/soccer-box-game](https://github.com/namelesssyf/soccer-box-game): juego 3D Godot con balón rígido, rebotes, tackles y un portero IA. Se usa como referencia de arquitectura/funcionalidad; no se incorpora código porque la licencia del juego no está verificada.
- [aliyavuzz/Godotball](https://github.com/aliyavuzz/Godotball): referencia Godot 4.4 con física de balón, 22 jugadores y árbitro. No se integra su motor C++/GDExtension ni se copia código; el repositorio no declara una licencia verificable.
- Incidencia [godotengine/godot #101753](https://github.com/godotengine/godot/issues/101753): documentó un problema de `AnimatableBody3D.sync_to_physics` con Jolt en Godot 4.4 beta 1. Fútbol Nova usa Godot 4.4.1 y no declara Jolt en `project.godot`; se registra como riesgo histórico, no como causa confirmada del fallo actual.

## Decisiones

- Mantener `AnimatableBody3D` como collider móvil; no volver a `StaticBody3D`.
- Mantener 21 jugadores IA sin cuerpos físicos adicionales: el collider especial solo corresponde al portero para limitar el coste en Android.
- No importar addons, motores nativos ni assets de repositorios con licencia no confirmada.
- No afirmar que el guardameta ya realiza blocajes, estiradas o animaciones completas. La etapa actual cubre posicionamiento y bloqueo físico; las animaciones y decisiones de atajada siguen pendientes.

## Próximos criterios de aceptación

1. La prueba headless registra contacto con la cápsula y rebote del balón.
2. Las pruebas de marcos de portería, amistoso completo y regresiones restantes se ejecutan después de ella.
3. El APK ARM64 solo se publica como artefacto validado si todas las pruebas anteriores terminan correctamente.
4. La compilación debe instalarse y probarse en un teléfono Android real antes de marcar la entrega final como aceptada.
