# Fútbol Nova — Configuración del menú principal

## Referencia visual
Archivo archivado: `assets/references/main-menu-settings-reference.jpg`. La captura es una referencia de composición; la interfaz final tendrá identidad propia.

## Dirección visual
- Fondo azul oscuro con iluminación ambiental y profundidad.
- Cuadrícula de paneles rectangulares con separación clara.
- Categoría seleccionada resaltada con color luminoso de alto contraste.
- Tipografía legible, iconos originales y navegación clara.
- Diseño adaptable a Android horizontal/vertical y mando compatible.

## Categorías confirmadas
1. Edición.
2. Módulos.
3. Música.
4. Juego.
5. Datos.
6. Controles.
7. Audio.
8. Gráficos.
9. Accesibilidad.
10. Administración.
11. Información.

## Comportamiento
- Cada categoría abre su propio submenú y conserva la selección al regresar.
- Mostrar solo funciones disponibles y opciones que tengan efecto real.
- Distinguir preferencias globales de ajustes específicos de modo, competición o partido.
- Aplicar cambios después de validarlos; indicar cuándo un cambio requiere reiniciar o iniciar el siguiente encuentro.
- Restaurar valores predeterminados requiere confirmación.
- Las acciones que puedan perder o sobrescribir datos requieren una alerta clara y confirmación.
- Guardar preferencias localmente y permitir exportación/importación cuando la función esté implementada.
- Navegación táctil y mando, con foco visible y objetivos táctiles amplios.

## Criterios de aceptación
1. Las once categorías aparecen en el orden confirmado.
2. Cada categoría abre y permite regresar sin perder el contexto.
3. No se muestran controles ficticios ni opciones sin efecto.
4. Las acciones destructivas y restauraciones solicitan confirmación.
5. La configuración persiste al cerrar y abrir el juego.
6. La interfaz mantiene legibilidad y accesibilidad en resoluciones compatibles.

## Propiedad intelectual
La captura se conserva como referencia interna. No se copiarán logotipos, marcas, iconografía ni recursos de terceros.


## Requisitos globales adicionales

### Idioma
- Idioma predeterminado: español.
- Todos los textos de la interfaz y el contenido dirigido al usuario deben estar en español, incluidos menús, submenús, botones, ayudas, tutoriales, instrucciones, mensajes, errores, confirmaciones, notificaciones, estadísticas, accesibilidad y textos de cada modo.
- No se permiten cadenas visibles en inglés ni mezclas accidentales. Los nombres propios y términos que deban conservar su denominación original no se traducen arbitrariamente.
- Las voces, narración y comentarios, cuando existan, deben tener español como idioma inicial; no mostrar opciones de idiomas de audio no disponibles.

### Música en todas las pantallas
- Un único ajuste global de música permite activarla o desactivarla para todo el juego.
- Si está activada, la música puede reproducirse en todas las pantallas y transiciones, incluidos menús, hubs, preparación, partido, pausa y resultados.
- Si está desactivada, permanece silenciada en todo el juego y la preferencia persiste al reiniciar.
- El volumen de música es independiente de efectos, ambiente y voces/comentarios.
- La reproducción no debe reiniciarse en cada cambio de pantalla ni duplicarse. La mezcla debe preservar la audibilidad de alertas y otros canales.
- Solo se ofrecen pistas realmente disponibles y con derechos de uso adecuados.


## Auditoría de implementación — 19-11-2026

La navegación muestra las once categorías, pero no todas tienen controles funcionales todavía. La revisión de `scripts/ui/game_hub.gd` confirma:

| Categoría | Estado observado |
|---|---|
| Controles | Vista de estado del módulo/mando y mapa de botones; remapeo y perfiles persistentes pendientes |
| Módulos | Información y acceso al catálogo |
| Datos | Tarjeta informativa; herramientas de exportación/importación y recuperación no están conectadas desde esta pantalla |
| Información | Información básica de versión/estado |
| Edición, Música, Juego, Audio, Gráficos, Accesibilidad y Administración | Aún muestran contenido reservado; no se deben presentar como ajustes operativos |

La pantalla debe considerarse **parcialmente implementada**, no terminada. Las siguientes mejoras prioritarias son un servicio local persistente de preferencias, controles de audio/volumen reales, perfiles gráficos Android, accesibilidad (escala/contraste), opciones de juego que se apliquen al amistoso y herramientas de datos con confirmación. Música solo se habilitará cuando haya pistas autorizadas disponibles; no se mostrará un selector vacío ni se fingirá reproducción.

Las opciones deben conservar el idioma español y guardar las preferencias en el dispositivo. Cada control deberá tener una prueba que verifique tanto su efecto como su persistencia tras reiniciar.


## Actualización — controles de audio persistentes (2026-11-19)

- Se añadió el servicio global NovaPreferences (scripts/data/nova_preferences_service.gd) como autoload.
- El volumen principal se puede ajustar desde Configuración → Audio (0–100 %) y el silencio global se activa/desactiva desde la misma pantalla.
- Los cambios se aplican inmediatamente mediante el bus Master de Godot y se guardan en user://futbol_nova_settings.cfg; se recuperan al iniciar el juego.
- La prueba tests/test_nova_preferences_service.gd verifica escritura, lectura en una segunda instancia y restauración del estado de audio.
- El workflow Android incluye esta prueba.
- Límite explícito: el proyecto aún no define buses separados para música, efectos y comentarios. La pantalla informa esa limitación y no presenta controles independientes ficticios.


- La regresión principal de Game Hub también comprueba ahora que el control deslizante modifica el volumen Master y que el interruptor aplica el silencio, restaurando al final el estado previo del test.
- La nueva prueba aislada de NovaPreferences verifica persistencia en una segunda instancia.
