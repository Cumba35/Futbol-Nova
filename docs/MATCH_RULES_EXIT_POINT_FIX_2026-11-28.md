# Fútbol Nova — corrección del punto real de salida del balón

## Problema

Cuando un balón cruzaba la línea de meta y después continuaba fuera del terreno antes del siguiente paso de física, la clasificación comprobaba la posición final del balón. Eso podía convertir un gol válido en saque de puerta/córner si el balón terminaba más allá de la línea lateral o por encima del larguero. Los saques de banda también podían colocarse usando la posición final, lejos del punto donde salió el balón.

## Cambio

`NovaMatchRules.classify_ball_exit` ahora interpola el punto de cruce usando la posición anterior y la actual:
- Si el balón supera dos límites en el mismo paso, decide cuál línea cruzó primero y calcula el punto exacto de salida.
- Evalúa la validez del gol usando la coordenada horizontal y vertical en el cruce de la línea de meta.
- Calcula la posición del saque de banda desde el cruce real de la línea lateral.
- Mantiene el resultado `ambiguous_exit` cuando faltan datos anteriores para resolver una salida simultánea.

## Regresiones añadidas

- Un balón que cruza la línea de meta entre los postes y por debajo del larguero, pero termina fuera de la línea lateral y alto, debe contar como gol.
- Un balón que cruza la línea lateral durante el paso físico debe colocar el saque de banda en el punto de cruce interpolado.

## Validación

Los casos se añadieron a `tests/test_match_11v11_foundation.gd`. No se ejecutó Godot en esta sesión; la suite debe ejecutarse con la versión del proyecto antes de integrar la rama en `main`.
