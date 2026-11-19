# Prioridad de desarrollo: modo Amistosos

Fecha: 2026-11-19. Esta prioridad rige el siguiente ciclo de trabajo de Fútbol Nova.

## Decisión
El modo Amistosos es el único modo de juego prioritario hasta que pueda probarse un partido completo y estable en un teléfono Android. No se ampliarán Carrera, Manager, Ligas, Copas, TAS ni Online durante este ciclo, salvo que una dependencia sea imprescindible para el amistoso.

## Flujo de usuario que debe quedar operativo
1. Abrir Fútbol Nova sin conexión.
2. Entrar a Amistosos.
3. Elegir equipo local y visitante de las plantillas validadas.
4. Elegir estadio, duración por tiempo y perfil de partido (Auténtico/Competitivo).
5. Verificar alineaciones y formaciones.
6. Iniciar el partido 3D 11 contra 11.
7. Controlar al futbolista seleccionado con joystick y botones táctiles.
8. Jugar con balón, compañeros, rivales y porteros activos.
9. Ver reloj, marcador, eventos y pausas.
10. Marcar goles, reanudar desde el centro y completar los dos tiempos.
11. Mostrar resultado final y permitir revancha o volver al menú.

## Orden de implementación
### P0 — Bloqueadores de una prueba jugable
- Corregir orientación de cámara, controles, dirección de ataque y posesión.
- Implementar porteros con movimiento y colisiones reales.
- Completar pase, tiro, regate, robo, cambio de jugador y control defensivo.
- Mejorar IA de los 20 futbolistas sin control: apoyos, desmarques, marcaje, presión, repliegue y decisiones básicas.
- Reiniciar correctamente posiciones, saque y reloj tras goles y al descanso.
- Resolver goles, tiros fuera, saques de banda, esquina y saque de puerta.
- Evitar que el balón atraviese jugadores, postes o travesaño.
- Asegurar que el partido se puede pausar, reanudar, abandonar y reiniciar sin bloquear el renderizado.

### P1 — Partido de prueba completo
- Dos tiempos configurables con descanso y final.
- Selección de estadio funcional, aunque inicialmente haya pocos estadios.
- Formaciones y alineaciones visibles antes del inicio.
- Perfil Auténtico/Competitivo con reglas diferenciadas verificables.
- HUD: reloj, marcador, jugador controlado, energía y mensajes de eventos.
- Sustituciones básicas y cambio de futbolista.
- Estadísticas finales: posesión, tiros, tiros a puerta, faltas y pases.
- Guardado local del resultado y opción de revancha.

### P2 — Calidad visual y controles
- Sustituir blockout de primitivas por modelos 3D humanos originales de NOVA.
- Animaciones esqueléticas: quieto, correr, sprint, pase, tiro, cabeceo, entrada, caída y celebración.
- Cámara de retransmisión alternativa y ajustes de cámara.
- Mejorar iluminación, césped, redes, público, audio y rendimiento en móviles modestos.
- Opciones de accesibilidad y sensibilidad de controles.

## Criterios de aceptación para declarar Amistosos listo para pruebas
- Arranca sin conexión en Android ARM64 y no depende de Godot, Unity ni servicios remotos.
- Permite seleccionar dos plantillas distintas, ambas con 22 IDs únicos.
- Renderiza 22 jugadores y dos porteros en el campo.
- Joystick y botones responden correctamente en orientación horizontal y distintos tamaños.
- El jugador controlado puede correr, girar, pasar, tirar y regatear con balón cercano.
- Los compañeros y rivales se mueven con decisiones básicas; los porteros defienden ambas porterías.
- Los goles solo cuentan cuando el balón cruza completamente la línea dentro de los postes y bajo el travesaño.
- Reinicia saque, posiciones y reloj de forma correcta.
- Completa dos tiempos, presenta el resultado y permite jugar otra vez.
- No se bloquea ni pierde el contexto al pausar, reanudar o salir.
- La APK de CI contiene la biblioteca nativa ARM64 y se instala y prueba físicamente.

## Límites de alcance
No se considera terminado por mostrar una escena 3D o por compilar. La meta es jugar y completar el amistoso de principio a fin. Las pantallas y modos restantes quedan congelados hasta superar los criterios anteriores. Las referencias FIFA 23 y FC 26 orientan estructura y sensación; arte, código, nombres y recursos de Fútbol Nova serán originales.
