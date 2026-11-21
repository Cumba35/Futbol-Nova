# Auditoría de referencias públicas para Fútbol Nova — 2026-11-21

## Alcance

Se revisaron repositorios públicos para identificar soluciones aprovechables para el modo Amistosos 11 contra 11, los controles táctiles y la ejecución en Android. El proyecto objetivo sigue siendo Godot 4.4.1, GDScript y exportación Android ARM64.

## Referencias revisadas

### 1. GameplayFootball — motor de fútbol de referencia

- Repositorio: https://github.com/vi3itor/GameplayFootball
- Licencia declarada: Apache-2.0.
- Interés técnico: simulación de fútbol, física del balón, jugadores, árbitro y sistemas de equipo.
- Evaluación: es una referencia de dominio valiosa, pero es un motor nativo independiente y no una dependencia lista para conectar a la escena actual de Godot.

### 2. Godotball — adaptación a Godot 4

- Repositorio: https://github.com/aliyavuzz/Godotball
- README: port de GameplayFootball a Godot 4.4 mediante GDExtension C++17; menciona física propia del balón, sistema de partido/árbitro y una IA inicial para 22 jugadores.
- Dependencias declaradas: godot-cpp y compilación SCons.
- Licencia: el README atribuye Apache-2.0 al proyecto fuente GameplayFootball, pero el repositorio Godotball no presenta una licencia declarada en los metadatos consultados. No copiar ni integrar archivos de ese repositorio hasta aclarar la licencia aplicable a sus aportaciones propias.
- Evaluación: la arquitectura híbrida C++/GDScript puede orientar una fase futura de rendimiento, pero introducir ahora GDExtension aumentaría la complejidad de compilación y de exportación Android.

### 3. Android Native Football

- Repositorio: https://github.com/blurz17/blurz-native-football-
- Arquitectura descrita: C++, SDL2, JNI, OpenGL ES y ODE, con controles móviles, joystick 360°, cámara relativa al jugador y gestión multitáctil.
- Licencia del archivo LICENSE revisado: GPL-3.0.
- Evaluación: útil para estudiar diseño de controles y cámara móvil; no integrar código en Fútbol Nova sin una decisión expresa sobre las obligaciones GPL-3.0 y una adaptación completa a Godot.

### 4. Virtual Joystick Godot — referencia de controles MIT

- Repositorio: https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot
- Licencia: MIT.
- Compatibilidad declarada: Godot 4.2+.
- Funciones relevantes: modos fijo, dinámico y de seguimiento; zona muerta; límite analógico; acciones InputMap y visibilidad condicionada a pantalla táctil.
- Evaluación: referencia apropiada para mejorar el joystick actual sin cambiar el motor de partido. La siguiente mejora recomendada es permitir que el joystick aparezca bajo el dedo en la zona izquierda, manteniendo multitáctil, liberación segura de acciones y pruebas de regresión.

### 5. Pipalo Lite — controles móviles modulares

- Repositorio: https://github.com/pnscripts/godot-pipalo-lite
- Licencia: MIT.
- README consultado: pruebas declaradas con Godot 4.7.1; no declara pruebas en un teléfono Android real.
- Evaluación: no adoptarlo directamente en Godot 4.4.1 sin una prueba de compatibilidad. Sus patrones de safe area, botones multitáctiles y joystick flotante son referencias para la evolución de la interfaz.

## Decisiones para el MVP de Amistosos

1. Mantener el motor actual en GDScript durante la estabilización del primer amistoso Android.
2. No incorporar por ahora GDExtension, SDL/JNI ni una segunda arquitectura física.
3. No copiar código de repositorios cuya licencia no esté clara. Respetar los avisos MIT o Apache si se adopta código en una fase posterior; evitar incorporar componentes GPL-3.0 sin autorización y revisión de compatibilidad.
4. Priorizar pruebas del flujo completo: preparar partido, crear 22 futbolistas, mover al jugador, cambiar entre los once, conseguir posesión, pasar, tirar, marcar, reanudar y terminar.
5. Tras estabilizar ese flujo, evaluar joystick dinámico, safe areas, rotación/orientación y ajuste de cámara en teléfono real.
6. Mantener IA ligera para móvil: decisiones tácticas limitadas por intervalo, posicionamiento de formación, selección del jugador más cercano, líneas de pase y portero predictivo; medir rendimiento antes de aumentar frecuencia o complejidad.

## Estado de integración

Esta auditoría no incorpora código externo ni recursos de terceros. Registra referencias, compatibilidad y límites de licencia para guiar mejoras posteriores sin comprometer la compilación Android ni la identidad del proyecto.
