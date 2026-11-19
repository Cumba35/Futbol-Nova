# Migración de Fútbol Nova a motor propio nativo

Fecha: 2026-11-19. Rama de trabajo: `work/native-3d-engine`.

## Decisión vinculante
Fútbol Nova deja de depender de Godot o de cualquier otro motor externo. El juego se desarrollará con código propio: Java para el ciclo de vida y la superficie Android; C++17 para simulación y renderizado; OpenGL ES 3.0 para dibujar directamente en Android. Android SDK, NDK y CMake son herramientas de compilación/API de plataforma, no motores de juego.

## Evidencia visual revisada
1. Partido: cámara elevada, futbolistas diminutos y sin modelos anatómicos/animaciones modernas.
2. Inicio: aparece la pantalla de marca de Godot.
3. Selector de clubes: lista desplegable invade la ventana, oculta información y no se adapta bien al espacio disponible.

## Arquitectura objetivo
- Renderizador propio OpenGL ES 3.0: mallas, shaders, materiales, cámara, iluminación, sombras y niveles de detalle.
- Simulación C++: partido 11v11, estados, reglas, árbitro, reloj, posesión, colisiones, balón y porteros.
- Animación procedural/esquelética propia: locomoción, carrera, giro, pase, tiro, regate, entrada, salto y parada.
- IA táctica local: formación, líneas, marcaje, desmarque, presión, cobertura y transición.
- Interfaz Android nativa: menús, selector de clubes, controles multitáctiles y escalado por relación de aspecto.
- Datos deportivos y guardados offline; integración gradual de los catálogos existentes.

## Primera base añadida
`native-android/` es un proyecto Android independiente, con ABI arm64-v8a, Java 17, C++17, CMake y OpenGL ES 3.0. Incluye una escena 3D generada por código, 22 marcadores corporales procedurales, cámara en perspectiva, joystick táctil y movimiento/impulso básico del balón. Es un prototipo de renderizado, no un partido terminado ni un APK validado.

## Fases obligatorias
1. Compilar el shell nativo y validar arranque ARM64.
2. Sustituir primitivas por futbolistas articulados, animaciones y equipaciones.
3. Completar balón, colisiones, porterías, redes, goles, árbitro y reglas.
4. Implementar IA de los 22 jugadores y porteros.
5. Corregir UI responsive, selección de equipos, pausa y HUD.
6. Portar los sistemas de carrera, ligas, datos y guardado que correspondan.
7. Pruebas automatizadas, APK ARM64, instalación y amistoso completo en teléfono.

## Criterio de migración
No eliminar ni sobrescribir todavía el proyecto histórico Godot ni sus datos. La migración se trabaja en esta rama y se valida por fases. La distribución final no incluirá Godot, su splash ni bibliotecas Godot. No declarar finalizada la migración hasta que el APK nativo compile, arranque y permita jugar un amistoso 11v11 en Android.
