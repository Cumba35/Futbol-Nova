# Selector de equipos y uniformes — referencia FIFA 26

## Objetivo
Actualizar el flujo previo al amistoso con una pantalla de presentación deportiva de alta calidad, tomando FIFA 26 como referencia de jerarquía, composición y navegación; todos los modelos, uniformes, escudos, tipografías y recursos deben ser originales de Fútbol Nova o contar con autorización.

## Diseño e interacción
- Dos paneles simultáneos, local a la izquierda y visitante a la derecha, separados por VS.
- Cada panel muestra identidad del club, escudo/monograma, nombre y un jugador 3D con vista de cuerpo completo.
- Navegación independiente de equipos con botones anterior/siguiente; nunca permite elegir el mismo club en ambos lados.
- Carrusel independiente de equipaciones para cada club: local, visitante y portero. Tercera equipación solo si el contrato comercial del club la habilita para la temporada.
- Cada cambio actualiza el modelo 3D en tiempo real. La selección local no modifica la visitante.
- Confirmación transmite IDs estables de clubes y equipaciones a la configuración del partido. No altera el uniforme permanente del club.
- Diseño adaptable a Android horizontal y vertical, controles grandes, accesibilidad y fallback de calidad gráfica.

## Datos y derechos
- Los clubes actuales tienen identidad ficticia. No asumir que los colores reales de sus clubes de referencia pueden reutilizarse.
- El catálogo de uniformes debe evolucionar a recursos originales con colores, patrones, patrocinadores y escudos autorizados.
- No copiar modelos, escudos, kits, marcas, patrocinadores, fuentes ni capturas de FIFA/EA Sports.
- La primera iteración usa colores y maniquíes procedurales temporales claramente identificados; no se publican como kits finales de clubes.

## Investigación pública
- `modelence/open-soccer`: referencia de arquitectura para selección de equipos y kits local/visitante en un juego FIFA-style 11v11 web; su motor React/Canvas no es compatible directamente con Godot y no se copia código.
- `o-lino/football-club-tycoon`: referencia MIT para catálogo de cuatro equipaciones y personalización de camiseta, pantalón y medias; puede servir para estudiar la separación de datos y opciones cosméticas. No se importan recursos visuales.
- `yangedu/football-godot-edition`: referencia Godot con selección de selecciones nacionales y mecánicas de fútbol; es 2D y no aporta un selector 3D equivalente. MIT según README, pero no se integra código por diferencia de alcance.

## Criterios de aceptación
1. Cambiar el equipo local no cambia el visitante y viceversa.
2. No se puede confirmar el mismo club en ambos lados.
3. Cambiar la equipación local solo actualiza el modelo local.
4. Cambiar la equipación visitante solo actualiza el modelo visitante.
5. La selección confirma IDs de equipo y uniforme para el partido.
6. Los datos permanentes del club no se modifican.
7. Tercera equipación se bloquea si no hay derechos/contrato activo.
8. Las pruebas headless y la validación Android deben pasar antes de fusionar o publicar.

## Estado
Iteración inicial en desarrollo: pantalla y modelos procedurales temporales. Escudos reales, jugadores 3D definitivos, patrones licenciados, detección de conflictos de color y prueba en dispositivo Android quedan pendientes.



## Integración de identidad Nova C35 y vista previa de jugador — 20-11-2026
- La identidad inicial de Nova C35 se registra en `data/nova_c35_club.json` con colores originales azul medianoche/cian/dorado; el monograma mostrado es C35.
- La vista previa del selector ya utiliza `scripts/players/procedural_player_visual.gd`, en lugar de cápsulas sueltas. El mismo script se utiliza para los actores IA del partido.
- La silueta actual tiene articulaciones y locomoción procedural básica; sigue siendo un prototipo, no el modelo humano final ni una animación de captura.
- Nova C35 se incorporará al catálogo de clubes seleccionables cuando se complete su plantilla de 22 jugadores y la expansión de Primera División a 20 equipos.
