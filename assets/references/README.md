# Fútbol Nova — Archivo de referencias visuales

Este inventario registra referencias visuales conservadas para orientar composición y usabilidad. Las imágenes de terceros son referencias internas únicamente; no son recursos aprobados para distribuir ni copiar dentro del juego.

## Referencias confirmadas en GitHub

| Archivo | Uso interno | Estado |
|---|---|---|
| `pause-menu-reference.jpg` | Menú de pausa durante el partido | Guardada |
| `kit-selection-reference.jpg` | Selector de equipaciones | Guardada |
| `legend-mode-home-reference.jpg` | Inicio del Modo Leyenda | Guardada |
| `main-menu-settings-reference.jpg` | Configuración | Guardada |
| `ultimate-team-main-menu-reference.jpg` | Captura antigua de FIFA 23 | Archivada; NO USAR en el producto |

## Exclusión expresa
Ultimate Team está excluido de Fútbol Nova. La miniatura `ultimate-team-main-menu-reference.jpg` se conserva solo por trazabilidad histórica y no debe utilizarse como referencia de Inicio, como pantalla, como modo ni en materiales de publicación. Véase [la nota de exclusión](../../docs/ULTIMATE_TEAM_MAIN_MENU.md).

## Referencias pendientes de transferencia
Algunas capturas originales y optimizadas se documentaron como disponibles localmente, pero no se consideran parte del repositorio hasta verificar su blob en GitHub. No declarar archivada ninguna imagen pendiente sin comprobar que el archivo existe y abre correctamente.

## Directriz visual global
FIFA 23 es una referencia funcional y visual para la jerarquía, navegación, organización de menús, estados, preparación de partidos, HUD, pausa, modos y configuración. Fútbol Nova debe mantener identidad propia: código, marca, iconos, tipografía, ilustraciones, equipos, jugadores, equipaciones, estadios, música y textos originales o debidamente licenciados.

## Menú principal vigente
El menú tiene exactamente cuatro pantallas:
1. **Inicio:** Continuar, Nueva partida, Amistosos y Entrenamiento.
2. **Online.**
3. **Modos:** Leyenda, Entrenador, Torneos, Ligas y Copas.
4. **Configuración:** Edición, Módulos, Música, Juego, Datos, Controles, Audio, Gráficos, Accesibilidad, Administración e Información.

La navegación horizontal funciona en ambos sentidos, es circular y conserva el estado de cada pantalla. La especificación completa está en [MAIN_MENU_FOUR_SCREENS.md](../../docs/MAIN_MENU_FOUR_SCREENS.md).

## Control de calidad de referencias
1. Confirmar que el blob existe en el árbol Git.
2. Recuperar el archivo desde GitHub y comprobar que abre.
3. Comparar visualmente con la fuente recibida.
4. Registrar dimensiones, tamaño y hash cuando sea posible.
5. Mantener separado el original de las versiones optimizadas.


## Relación con pantallas y estado de implementación — 19-11-2026

Las cuatro referencias visuales archivadas se usan exclusivamente para orientar composición, jerarquía, navegación y adaptación móvil:

- `pause-menu-reference.jpg` → pausa del partido; primera implementación en `scripts/ui/game_hub.gd`, con resumen y seis acciones. La alineación gráfica, tácticas y repetición siguen pendientes.
- `kit-selection-reference.jpg` → guía para un futuro selector de equipaciones; el flujo visual completo y la persistencia del selector siguen pendientes.
- `legend-mode-home-reference.jpg` → guía del inicio del módulo Modo Leyenda; mantener el modo detrás del catálogo hasta que el paquete esté instalado/publicado.
- `main-menu-settings-reference.jpg` → guía de la jerarquía visual de Configuración; las categorías y sus opciones deben terminarse y validarse individualmente.

Las mismas imágenes están archivadas en `Cumba35/Nova-Workspace/proyectos/juegos/futbol-nova/assets/references/` y en `Cumba35/Futbol-Nova/assets/references/`. No se copian logos, escudos, tipografías, equipaciones ni otros recursos protegidos de las capturas.

Los originales de mayor resolución y las capturas Manager, ajustes de partido y ajustes de mando siguen pendientes de transferencia. Mantener sus estados como pendientes hasta que sus blobs binarios estén presentes y verificados en ambos repositorios.
