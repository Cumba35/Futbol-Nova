# Fútbol Nova — punto de continuación para el siguiente chat

Fecha de cierre: 20-11-2026 18:21 UTC.

## Repositorios y rama
- Código fuente/distribución: https://github.com/Cumba35/Futbol-Nova
- Copia de trabajo en NOVA: https://github.com/Cumba35/Nova-Workspace/tree/ui/stadium-selector-reference-layout/proyectos/juegos/futbol-nova
- Rama activa en ambos: `ui/stadium-selector-reference-layout`
- PR de distribución: https://github.com/Cumba35/Futbol-Nova/pull/6
- PR de Workspace: https://github.com/Cumba35/Nova-Workspace/pull/27
- Ambos PR deben seguir abiertos y en draft; no fusionar ni publicar.

## Decisiones confirmadas
- Juego Android, Godot 4.4.1, foco en amistoso local 11v11 offline ARM64.
- El juego base contiene un solo estadio: **Estadio del Fénix**, sede de **Nova C35 (C35)**.
- Capacidad de diseño confirmada: **105 000 espectadores**. Es un objetivo de diseño; no significa que existan 105 000 modelos individuales ni que el rendimiento esté validado.
- Perfil C35: `data/nova_c35_club.json`, ID `CUB-S1-017`; paleta azul medianoche/cian/dorado provisional.
- El usuario creará los otros tres clubes originales. No inventar sus nombres, escudos, ciudades, colores, estadios ni plantillas.
- La Primera División sigue incompleta: catálogo operativo de 16 clubes; se necesitan C35 y tres clubes del usuario, cuatro plantillas completas de 22 jugadores y calendario de 38 jornadas.
- Selector de estadios en pantalla dedicada, vista previa 3D; selector de equipos/uniformes inspirado en calidad de presentación de FIFA 26, sin copiar recursos protegidos.
- No mostrar indicaciones de mandos si no hay un mando conectado.
- Jugadores y estadio actuales son prototipos procedurales; no son modelos humanos finales ni captura de movimiento.

## Último estado de CI verificado
- Run 44791101613 (run 409), commit `e64f9512c63bbcb5252668cc09639d8f6b7a9c67`: **failure**.
- Paso fallido: `Core test — controller hint visibility`; pruebas posteriores omitidas y artefacto APK validado no publicado.
- Errores de parseo GDScript:
  - `scripts/stadiums/stadium_builder.gd`: no se infiere tipo de `stand_x` (línea 143), `stand_z` (152), `shirt` (163).
  - `scripts/players/procedural_player_visual.gd`: no se infiere tipo de `current_position` (línea 64).
  - Errores dependientes en `team_kit_selection.gd`, `pre_match_setup.gd`, `football_data_service.gd`.
  - `game_hub.gd` informa identificador `FootballData` no encontrado debido a la carga fallida.
  - `test_controller_hint_visibility.gd` llama a `should_show_controller_hints`, que no existe en el script cargado; el paso terminó por timeout.
- Run: https://github.com/Cumba35/Futbol-Nova/actions/runs/44791101613
- Siguiente tarea: inspeccionar archivos y prueba, corregir tipos explícitos y resolver contrato de visibilidad de mandos; correr pruebas focalizadas y workflow completo en Godot 4.4.1. No declarar aprobadas las pruebas omitidas.

## Protocolo de trabajo obligatorio
1. Antes de cambios importantes, investigar alternativas públicas GitHub y revisar licencia, mantenimiento, seguridad y compatibilidad. No incorporar código/assets sin licencia comprobada.
2. Trabajar en la rama indicada y respetar la arquitectura/repositorio de distribución frente a Nova Workspace.
3. Guardar código, documentación y pruebas en Fútbol Nova; sincronizar a `proyectos/juegos/futbol-nova/` en Nova Workspace.
4. Después de cada escritura, releer y comparar SHA de contenido en ambos repositorios.
5. Mantener PR #6 y #27 abiertos/en draft. No fusionar ni publicar APK final mientras CI falle, haya pruebas pendientes o conflictos.
6. El usuario trabaja desde Android y no tiene PC; no exigir herramientas locales de escritorio. Usar GitHub y CI cuando sea posible.

## Archivos de referencia
- Estado completo: `docs/DEVELOPMENT_STATUS_2026-11-20.md`
- Diseño: `docs/GAME_DESIGN.md`
- Registro de pantallas: `docs/UI_SCREEN_IMPLEMENTATION_REGISTER.md`
- Dirección visual: `docs/FIFA23_FC26_VISUAL_DIRECTION_AND_BASE_GAME.md`
- Investigación: `docs/THIRD_PARTY_RESEARCH.md`

En el siguiente chat, continuar directamente con la inspección/corrección de los errores de CI descritos arriba.

## Continuación añadida — corrección de tipado y validación amistosos

- Rama de trabajo: `ui/stadium-selector-reference-layout` en ambos repositorios.
- PR abiertos/en borrador: Fútbol Nova #6 y Nova Workspace #27. No fusionar ni publicar.
- Cambios de código preparados en esta iteración:
  - `stadium_builder.gd`: tipos explícitos `float` para `stand_x`/`stand_z` y `Color` para `shirt`.
  - `procedural_player_visual.gd`: `current_position: Vector3`.
  - `test_controller_hint_visibility.gd`: casos de estado ausente y conteo de mandos negativo; se conserva la regla de ocultar indicadores sin mando conectado.
- La función `should_show_controller_hints` está presente en `game_hub.gd` en el HEAD inspeccionado y aplica la condición módulo activo + al menos un mando conectado.
- El test de estadio ya exige el aforo exacto de 105 000 espectadores.
- No crear datos para los tres clubes originales del propietario hasta recibir sus nombres, colores, estadios e identidades. No generar plantillas ficticias en su nombre.
- Siguiente prioridad: esperar CI posterior a los cambios; corregir cualquier error real; mantener el flujo de amistoso completo como principal objetivo de pruebas. Después validar en un Android físico (rendimiento, temperatura, memoria, controles y partido completo).
- Investigación pública revisada de nuevo: `awest813/League-Soccer` Apache-2.0 (desktop C++), `JoenTNT/godot_thumbstick_addon` MIT (Godot 4.4/GL Compatibility) y `HubbleCommand/mobile_controls` MIT (Godot 4.3). Se usan solo como referencias; no se incorporó código ni recursos externos.


## Matriz de pruebas

- Matriz detallada del modo Amistosos: `docs/FRIENDLY_MODE_TEST_MATRIX.md`.
- CI run 44792124409 (run 411) terminó en fallo en `Core test — controller hint visibility`; las pruebas posteriores se omitieron.
- CI run 44792711004 (run 413) está en curso para validar los cambios recientes; no se considera aprobada hasta que finalice.
- Se mantienen los PR #6 y #27 abiertos/en borrador, sin fusión ni APK final publicada.
