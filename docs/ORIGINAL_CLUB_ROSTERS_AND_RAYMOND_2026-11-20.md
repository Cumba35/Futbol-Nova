# Plantillas originales y perfil de Raymond — 2026-11-20

## Alcance

Se completan las plantillas de los dos primeros clubes originales usados por defecto en el amistoso:

- Nova C35: 22 plazas.
- FC Río de Argenti: 22 plazas.

Los dos futbolistas ya registrados en Nova C35 — Anier Cumbá (NOVA-PLAYER-0035) y Máximo Padilla (NOVA-PLAYER-0036) — se conservan. Se añadieron 20 perfiles ficticios generados para completar C35. En RDA se añadieron 20 perfiles, incluido Raymond Valdez.

## Raymond Valdez

- ID interno nuevo: NOVA-PLAYER-0037.
- Club: FN-NOVA-RDA — FC Río de Argenti.
- Dorsal: 5.
- Posición: DC, secundaria MCO.
- Nacimiento: 26/05/2007; edad de ficha: 19 años.
- Altura: 171 cm; peso: 63 kg.
- Media: 91; potencial: 96.
- Sus atributos visibles se basan en la ficha aportada por el propietario. Los contadores de carrera y temporada empiezan en cero.

### Estilo y habilidades

Perfil de juego original inspirado en rasgos generales asociados por el propietario a Messi y Neymar: control cercano, conducción, fintas corporales, cambios de ritmo/dirección, giros cortos, amagues, combinaciones rápidas y definición curva. No se incorporan clips, modelos, capturas ni movimientos extraídos de material protegido de esos jugadores.

Habilidades configuradas: close control, body feint, rapid direction change, elastic-style feint, nutmeg attempt, cut inside, tight turn, quick wall pass y curved finish.

### Celebración especial

ID: `raymond_messi_inspired_skyward_point`.

Secuencia de diseño original: frenar tras el gol, girar hacia cámara/gradas, elevar ambos brazos, señalar hacia arriba con ambos índices, mantener brevemente la pose y regresar con los compañeros. Es una especificación para animación; no se afirma que exista ya un clip 3D final.

## Integración técnica

- `data/original_club_players_2026.json`: 40 perfiles nuevos y referencias a 44 plazas totales entre ambos clubes.
- `data/original_clubs_2026.json`, `data/nova_c35_club.json`, `data/fc_rio_de_argenti_club.json`: estados de plantilla y listas de IDs.
- `scripts/ui/pre_match_setup.gd`: registra las plantillas originales en el registro de partido y permite validar el amistoso con ambos equipos.
- `modules/nova_3d_animation/nova_3d_animation.gd`: añade señales y métodos para solicitar habilidades y secuencias de celebración por perfil.

Los ganchos de animación permiten conectar clips originales cuando los rigs/recursos estén listos. No sustituyen la creación, retargeting y prueba visual de los clips 3D.

## Datos generados

Los 40 jugadores nuevos son ficticios y sus atributos son valores de juego, no afirmaciones sobre personas reales. Las estadísticas empiezan en cero; no se inventan partidos, goles, asistencias ni historial competitivo.

## Validación pendiente

- Ejecutar Godot headless y la suite de amistosos/plantillas.
- Confirmar que el registro principal carga ambos clubes y que cada uno devuelve 22 jugadores.
- Probar las transiciones en un rig 3D y producir los clips de habilidad/celebración.
- Revisar CI antes de fusionar cualquier PR.

