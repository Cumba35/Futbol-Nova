# Dirección visual de Fútbol Nova — FIFA 23 / FIFA 26 como referencias

**Fecha:** 20-11-2026  
**Plataforma prioritaria:** Android ARM64, orientación horizontal para partido.  
**Identidad propia:** Fútbol Nova / club Nova C35 (C35).

## 1. Referencias estudiadas y límites

FIFA 23 se toma como referencia para la presentación de jornada, pantallas de preparación, superficies del césped, sombras, cámaras de retransmisión, redes 3D, celebraciones y grada con movimiento. EA describió para FIFA 23 paneles y meg pantallas animadas, tifos/banderas animados, Crowd Cards con movimiento, mejoras de humo VIP y redes con mayor realismo.

FIFA 26 se toma como referencia complementaria para animación contextual/volumétrica, variación de movimientos según velocidad y ángulo, posicionamiento más inteligente, reacciones del portero, rebotes, autenticidad del partido, presentación de estadios y accesibilidad.

Fuentes oficiales:
- FIFA 23 Matchday Experience: https://www.ea.com/ea-play/news/pitch-notes-fifa-23-fut-deep-dive
- FIFA 23 Matchday Experience Deep Dive: https://www.youtube.com/watch?v=N4RnZdWIOzo
- EA SPORTS FC 26 Features: https://www.ea.com/games/ea-sports-fc/fc-26/features
- FC 26 Gameplay: https://www.ea.com/games/ea-sports-fc/fc-26/features/fc-26-gameplay
- FC 26 Stadiums: https://www.ea.com/games/ea-sports-fc/fc-26/news/fc-26-all-new-stadiums-list
- FC 26 Accessibility: https://www.ea.com/able/resources/ea-sports-fc/fc-26

Las referencias sirven para definir calidad, jerarquía, ritmo y comportamiento. No se copian pantallas exactas, código, marcas, escudos, uniformes, rostros, animaciones, texturas, audio ni estadios de EA.

## 2. Juego base: un único estadio

El juego base incluye exclusivamente:
- **Estadio del Fénix**, casa de Nova C35.
- Capacidad provisional de diseño: 35 000 espectadores; pendiente de confirmación del propietario.
- Gradas en cuatro lados y varios niveles, cubierta, soportes, torres de iluminación, marcador, paneles LED, túnel, banquillos, zona técnica y público instanciado.
- Paleta del estadio: azul medianoche, cian Nova y detalles dorados.
- El selector del amistoso solo muestra Estadio del Fénix. Otros estadios futuros se ofrecerán mediante paquetes opcionales descargables y no aparecerán en el juego base.

La primera implementación del constructor ya reemplaza el catálogo de tres estadios por un único estadio base. Se añadieron multitudes instanciadas con variación de color y movimiento sutil por shader, paneles LED, marcador, túnel, banquillos y estructura de cubierta. La geometría sigue siendo procedural de primera iteración; no equivale a un modelo arquitectónico final de alta fidelidad.

## 3. Nova C35

- Nombre: **Nova C35**.
- Abreviatura: **C35**.
- Competición objetivo: Primera División de Cuba — Fútbol Nova.
- Objetivo de liga solicitado: 20 clubes.
- Estadio local: Estadio del Fénix.
- Identidad visual inicial propuesta: azul medianoche (#14213d), cian (#27c9e8) y dorado (#f4c95d).
- Escudo original: ave fénix geométrica que integra C35.
- Equipación local: azul medianoche con detalles cian/dorados.
- Visitante: blanco hielo con detalles azul/cian.
- Portero: dorado con detalles azul medianoche.
- Tercera equipación bloqueada hasta contrato comercial y derechos aprobados.

Los colores y el concepto del escudo son una propuesta provisional y editable. El perfil del club está guardado en `data/nova_c35_club.json`. El catálogo de Primera División actual contiene 16 clubes y 16 plantillas completas de 22 jugadores; por tanto, la inscripción completa en una liga de 20 equipos requiere incorporar tres clubes más y las cuatro plantillas que faltan (incluida la de C35). No se debe declarar terminada la liga de 20 mientras falten esos datos.

## 4. Pantallas del juego

### Inicio / hub
- Fondo deportivo original, con imagen/escena del Estadio del Fénix y C35.
- Tarjeta principal de Partido amistoso.
- Accesos a Online y Modos solo como catálogo de módulos, según la arquitectura del juego base.
- Configuración accesible sin instalar módulos.

### Preparación del amistoso
- Selección local/visitante con escudos originales, nombre, valoración y modelo 3D.
- Equipaciones local, visitante y portero con vista previa real.
- Selector de estadio de una sola tarjeta: Estadio del Fénix.
- Resumen de partido y botón de inicio.

### Partido
- Cámara de retransmisión con encuadre estable, seguimiento contextual y alternativas de cámara.
- Marcador, reloj, indicador del jugador, radar y controles táctiles legibles.
- Césped con bandas de corte, líneas reglamentarias, sombras y desgaste localizado a medida que se complete la física.
- Redes 3D con deformación por impacto; celebraciones, repeticiones y sonido ambiental progresivos.

### Pausa y final
- Panel translúcido de pausa con continuar, ajustes del encuentro y salir.
- Final con resultado, goleadores y estadísticas realmente medidas; no mostrar métricas no calculadas.

## 5. Futbolistas

El objetivo visual final es un futbolista humano 3D con anatomía legible y animación contextual:
- Variación de altura, proporciones, rostro, tono de piel, peinado y accesorios mediante datos originales.
- Camiseta, pantalón, medias, botas y guantes separados para permitir equipaciones completas.
- Esqueleto/articulaciones para locomoción, aceleración, frenada, giro, carrera, pase, tiro, control, entrada, salto, caída, levantarse, celebración y acciones de portero.
- Mezcla de animaciones por velocidad, dirección, orientación corporal, distancia al balón y estado del partido.
- Reacción física al contacto, aterrizajes, bloqueos y rebotes con límites para evitar movimientos imposibles.
- Apariencia y atributos deben ser independientes: cambiar un kit no cambia el jugador ni su valoración.
- Modelos y rostros de personas reales requieren autorización; el contenido por defecto será original.

La iteración actual sustituye las cápsulas de IA por un maniquí procedural articulado con torso, cabeza, brazos, antebrazos, manos/guantes, piernas, medias y botas. Incluye oscilación básica de extremidades basada en el desplazamiento del actor. Es un prototipo de silueta y locomoción, no un modelo humano final ni captura de movimiento.

## 6. Aficionados y ambiente

- Multitud de alta densidad instanciada, con variación de colores de ropa y movimiento sutil.
- Reacción sincronizada con ocasiones, goles, atajadas, faltas y pitido final.
- Banderas y tifos originales; animación por oleadas y momentos de partido.
- Audio de grada en capas (ambiente, cánticos, celebración, tensión), sin depender de conexión.
- Densidad escalable: alta/media/baja, con reducción de sombras y animaciones en Android de menor rendimiento.
- La multitud nunca debe consumir una llamada de dibujo por aficionado; preferir MultiMesh y materiales compartidos.

## 7. Calidad y rendimiento Android

- Godot 4.4.1, renderer GL Compatibility, Android ARM64 y juego offline.
- Mantener LOD por distancia, instancing, materiales compartidos y texturas comprimidas.
- Limitar actualizaciones de animación de la grada y detalles secundarios fuera de cámara.
- Probar con 22 jugadores, crowd, luces y SubViewport activo; medir FPS, memoria, temperatura y tiempos de carga en dispositivos reales.
- Los efectos avanzados deben poder degradarse sin perder legibilidad ni jugabilidad.

## 8. Investigación pública adicional

- `khlsvr/League-Soccer`: Apache-2.0; C++17, arquitectura de simulación, estadio OpenGL, crowd/audio y modelos segmentados de futbolista. Su stack desktop no se integra directamente en Godot 4.4.1 Android. Solo referencia conceptual.
- `kendrekaran/striker-3d`: Three.js, jugadores animados, grada instanciada y estadio procedural. El repositorio no declara licencia de código en los metadatos revisados; no copiar código. Su archivo de personaje cita un recurso Quaternius, pero cualquier uso requeriría revisar y conservar la licencia específica del asset.
- `Wilberforcedev/FC2026-MOD-Apk`: Unity 6 y datos de fútbol móvil ficticios; tecnología distinta y no se adopta.
- No se añade dependencia externa ni asset de terceros en esta iteración.

## 9. Orden de implementación

1. Estadio del Fénix como único estadio base, identidad C35 y multitud procedural.
2. Modelo humano procedural inicial para IA y pruebas de movimiento.
3. Mejorar animación, proporciones y materiales de los jugadores; sustituir el prototipo por modelo rigged original/licenciado.
4. Completar la interfaz visual de Inicio, preparación, partido, pausa y final.
5. Reacciones de grada, banderas/tifos y audio ambiental.
6. Integrar la liga cubana de 20 equipos y plantillas completas de 22 jugadores.
7. Pruebas headless, CI Godot 4.4.1, prueba de APK e instalación/medición en Android real.

## 10. Estado honesto

Implementado en esta iteración: estadio único, geometría procedural más rica, multitud instanciada animada de forma sutil, paneles LED, túnel/banquillos, identidad inicial C35, paleta de uniformes C35 y modelo procedural articulado para jugadores IA. Pruebas automatizadas añadidas. Pendiente de CI y validación en Android. Los modelos humanos finales, animaciones de calidad de captura, crowd reactivo/audio y liga de 20 equipos no se consideran terminados.
