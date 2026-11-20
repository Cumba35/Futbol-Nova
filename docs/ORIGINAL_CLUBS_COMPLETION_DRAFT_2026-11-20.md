# Fútbol Nova — finalización de clubes originales (borrador editable)

## Estadios: requisito del propietario (2026-11-20)
Los cuatro estadios originales tienen capacidad de diseño de **105.000 espectadores**. Su paleta arquitectónica debe derivarse de la primera equipación (home kit) de su club:
- Nova C35 — Estadio del Fénix: azul marino, cian, detalles plateados.
- FC Río de Argenti — Estadio Río de Argenti: azul río, plata y blanco; paleta provisional hasta cotejar visualmente el JPG local de Dropbox.
- Nova Génesis — Arena Nova Génesis: azul marino y blanco, con acentos rojos y verdes, conforme a la equipación local v2 aprobada.
- Sangre Galáctica — Estadio Sangre de Estrellas: morado y rojo dominantes, con detalles amarillos y blancos.

El catálogo de ejecución `scripts/stadiums/stadium_builder.gd` conserva los tres estadios base y añade estos cuatro estadios originales. La prueba `tests/test_stadium_builder.gd` comprueba el catálogo, la capacidad y que los colores sean válidos. La prueba debe ejecutarse en CI; el código guardado no equivale a prueba aprobada.

## Identidades y propuestas
Las cuatro identidades, escudos conceptuales, equipaciones y aficiones siguen descritas en `data/original_clubs_2026.json` y sus fichas individuales. Lo que no fue aprobado explícitamente sigue marcado como propuesta editable.

## Plantillas y traspasos
- Objetivo: 22 jugadores por club.
- Anier Cumbá (NOVA-PLAYER-0035) y Máximo Padilla (NOVA-PLAYER-0036) están asignados a Nova C35, conservando dorsales, atributos y estadísticas.
- Raymond continúa pendiente de identificar por ID único antes de moverlo a RDA.
- No se inventan 88 perfiles ni estadísticas ficticias para declarar completos los planteles.

## Recursos visuales
No se han incorporado todavía nuevos binarios de escudos/uniformes al árbol GitHub. La referencia de local RDA sigue en Dropbox; su paleta del estadio está identificada como provisional hasta cotejar la imagen de referencia. GEN v2 sigue siendo la propuesta visual local aprobada.
