# Fútbol Nova — integración del runtime nativo con los datos existentes

Fecha: 2026-11-19. Rama: `work/native-3d-engine`.

## Integración incorporada

- `data/native_runtime_manifest.json` define el contrato de fuentes canónicas, navegación, motor, reglas de habilitación de plantillas y políticas visuales.
- `native-android/app/build.gradle` empaqueta el directorio `data/` como assets offline de la aplicación.
- `CanonicalDataRepository.java` carga el manifiesto, perfiles personalizados, catálogo de módulos, ligas, clubes, archivos de plantillas cubanas, catálogo de habilidades, técnicas y balones.
- Las plantillas solo se habilitan si tienen exactamente 22 jugadores con IDs no vacíos y únicos.
- Los perfiles personalizados se indexan por ID estable. Solo se aplican a una plaza de plantilla cuando el ID del jugador coincide; no se asignan jugadores a clubes arbitrariamente.
- El selector del amistoso utiliza equipos procedentes de las plantillas que pasan la validación. En esta fase las fuentes con plantillas completas son primera y segunda división cubanas (16+16 plantillas en los archivos actuales).
- La pantalla raíz incluye Inicio, Online, Modos y Configuración. Los modos opcionales muestran el estado real del catálogo y no se anuncian como instalados si siguen planificados, en desarrollo o en pruebas.

## Motor 3D nativo

- Java 17 para la aplicación Android e interfaz adaptativa.
- C++17 y OpenGL ES 3.0 para renderizado y simulación inicial.
- Formación 4-3-3 procedural para 22 futbolistas.
- Cámara de tercera persona, más baja, que sigue la posición y orientación del futbolista controlado.
- Campo, líneas, estructuras de grada simplificadas y marcos de portería.
- Blockout corporal mejorado con torso, cabeza, brazos, muslos, piernas y movimiento procedural.
- Atributos de altura, GRL, ritmo, regate y defensa procedentes de los datos de la plantilla.
- Controles táctiles con zonas corregidas para movimiento, pase, tiro, regate y presión; se corrigió el desajuste entre coordenadas dibujadas y zonas táctiles en pantallas panorámicas.
- Movimiento de balón condicionado a la proximidad del jugador, toque de regate y presión defensiva aplicada al equipo controlado.
- Reloj de partido, marcador actualizado, detección básica de gol entre los postes y reinicio del saque en el centro después de marcar.
- IA inicial que desplaza las líneas y acompaña la acción; todavía no equivale a una IA táctica completa.

## Límites que se mantienen deliberadamente

- El archivo `data/base_league_clubs_2026.json` registra 451 clubes de referencia; `global_clubs.generated.json` contiene un lote generado de 68. No se deben sumar ni anunciar como clubes jugables. El catálogo de nombres de clubes no equivale a plantillas validadas.
- Las demás ligas/temporadas y las selecciones nacionales siguen sujetas a sus estados de verificación, procedencia y validación del motor. Estar empaquetadas como JSON no las convierte en contenido jugable.
- Los modelos de jugadores siguen siendo un blockout procedural de primitivas, no modelos humanos de alta fidelidad ni equivalentes visuales a FIFA/FC.
- Los menús de carrera, entrenador, ligas, copas, TAS y entrenamiento están representados en el catálogo, pero sus sistemas de juego aún deben construirse y probarse.
- El reloj y marcador básicos ya están conectados al motor, existe detección inicial de goles y el saque se reinicia en el centro; todavía faltan árbitro, sustituciones, faltas, fueras de juego, porteros funcionales, animaciones esqueléticas, repetición y pruebas completas en teléfono.
- Los estadios listados en la especificación de producto aún deben convertirse en escenarios 3D reales; las gradas y porterías actuales son primitivas de prueba.

## Pruebas y publicación

La compilación de CI debe completar `:app:assembleDebug`, verificar el APK y comprobar que contiene `lib/arm64-v8a/libfutbolnova.so`. La compilación correcta no sustituye la instalación y prueba del partido en un dispositivo Android real. El workflow ahora también se dispara cuando cambia el directorio canónico `data/`. No publicar el APK como versión terminada mientras falten los criterios de aceptación.
