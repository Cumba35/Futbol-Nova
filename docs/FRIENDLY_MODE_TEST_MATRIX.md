# Fútbol Nova — matriz de validación del modo Amistosos

Fecha: 20-11-2026

## Objetivo de esta fase

Validar un partido amistoso local 11 contra 11, sin conexión y en Android ARM64. Este documento no declara el modo terminado: separa lo que se comprueba en CI de lo que exige un teléfono real.

## Pruebas automatizadas obligatorias

| Área | Prueba / comprobación | Condición de aceptación |
|---|---|---|
| Proyecto | Importación Godot 4.4.1 | Sin errores de parseo ni recursos ausentes |
| Android | Exportación debug ARM64 | APK exportada y biblioteca/recursos incluidos correctamente |
| Entrada | Acciones y limpieza táctil | Ninguna entrada queda atascada al soltar o esconder controles |
| Mandos | Visibilidad de indicaciones | Ocultas si el módulo está desactivado o no hay mando conectado |
| Equipos | Selección y plantillas | Dos equipos distintos; 22 jugadores por lado; IDs únicos |
| Partido | Fundación 11v11 | 22 futbolistas y dos porteros creados y posicionados |
| Balón | Vuelo, posesión y colisiones | Pases/tiros avanzan; el balón no atraviesa marcos ni red |
| IA | Pase, remate y dirección | Ambos equipos pueden atacar hacia la portería correcta, también tras cambiar de lado |
| Porteros | Posicionamiento y colisión | Ambos guardametas se desplazan dentro de su área y el balón interactúa con su cuerpo |
| Reglas | Goles y períodos | Gol válido, reinicio, descanso, cambio de lado y final coherentes |
| Estadio | Catálogo y geometría | Solo Estadio del Fénix en base; aforo de diseño exactamente 105000 |
| Identidad | Nova C35 | ID y relación con el Estadio del Fénix coherentes |

## Pruebas manuales obligatorias en Android

- [ ] Instalar la APK debug generada por una CI completamente satisfactoria.
- [ ] Abrir el juego en modo avión y entrar a Amistosos.
- [ ] Elegir dos equipos distintos y revisar alineaciones/equipaciones.
- [ ] Confirmar que el Estadio del Fénix carga y que la cámara no queda dentro de la grada ni del campo.
- [ ] Jugar con joystick y botones simultáneos; comprobar que ningún dedo interrumpe otro control.
- [ ] Moverse, girar, acelerar, pasar, tirar, regatear, cambiar jugador y realizar entradas.
- [ ] Comprobar que compañeros, rivales y ambos porteros toman decisiones durante el juego.
- [ ] Marcar y recibir goles; comprobar el saque central y el sentido correcto de ataque.
- [ ] Pausar, reanudar, completar el descanso y jugar el segundo tiempo.
- [ ] Finalizar el partido y comprobar resultado, estadísticas disponibles y revancha.
- [ ] Salir del partido sin bloqueo y volver a iniciar otro amistoso.
- [ ] Registrar FPS, temperatura, memoria, consumo y cualquier cierre inesperado durante una sesión prolongada.

## Estado al crear esta matriz

- Las pruebas automatizadas están definidas en el workflow del repositorio de distribución.
- La ejecución CI 44792124409 falló en Core test — controller hint visibility; las pruebas posteriores fueron omitidas. No se considera una validación del partido.
- Los cambios de tipado explícito y el refuerzo del test de mandos se guardaron en la rama ui/stadium-selector-reference-layout.
- La ejecución CI posterior a esos cambios debe completar la suite antes de considerar descargable una APK de prueba.
- La prueba física en Android todavía no está realizada.

## Bloqueos fuera del amistoso

Los tres clubes originales adicionales, sus identidades y sus plantillas quedan pendientes de las especificaciones del propietario. No se inventarán. La expansión de la Primera División a 20 clubes no bloquea la prueba técnica de un amistoso con dos equipos de prueba ya existentes; sí bloquea declarar completa la liga.

## Regla de cierre

No marcar Amistosos como terminado, no fusionar los PR y no publicar APK validada hasta que todas las pruebas automatizadas pasen y la lista manual de Android tenga evidencia registrada.
