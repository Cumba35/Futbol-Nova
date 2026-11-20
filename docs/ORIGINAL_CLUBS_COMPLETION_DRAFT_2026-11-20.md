# Fútbol Nova — manifiesto de clubes originales (2026-11-20)

## Alcance
Registro de las cuatro identidades originales del juego. Las propuestas nuevas quedan etiquetadas como provisionales para revisión del propietario. No se consideran assets gráficos binarios creados ni integrados hasta que sus archivos reales estén guardados y releídos desde GitHub/Dropbox.

| Club | ID canónico | Estado visual | Estadio |
|---|---|---|---|
| Nova C35 (C35) | `nova-c35` / `FN-NOVA-C35` | Propuesta provisional | Estadio del Fénix, capacidad de diseño 105.000 |
| FC Río de Argenti (RDA) | `fc-rio-de-argenti` / `FN-NOVA-RDA` | Referencia local existente; resto provisional | Estadio Río de Argenti, capacidad pendiente |
| Nova Génesis (GEN) | `nova-genesis` / `FN-NOVA-GEN` | Local v2 aprobada; resto provisional | Arena Nova Génesis, capacidad pendiente |
| Sangre Galáctica (SAG) | `sangre-galactica` / `FN-NOVA-SAG` | Colores confirmados; propuesta provisional | Estadio Sangre de Estrellas, capacidad pendiente |

## Decisiones confirmadas
- Nova C35 es el club base de referencia. Estadio del Fénix conserva la capacidad de diseño de 105.000 registrada en la PR #6.
- Nova Génesis: se conserva la identidad de local v2 aprobada el 20-11-2026 (GEN entrelazado, blanco/navy con acentos rojos y verdes; shorts blanco/navy).
- Sangre Galáctica: rojo y morado dominantes; amarillo y blanco como acentos.
- FC Río de Argenti conserva la referencia de uniforme local existente en Dropbox; no se sustituye ni se sobrescribe.

## Propuestas editables
Los escudos, uniformes visitantes/alternativos/porteros, nombres y diseños de estadios, y apodos/cánticos de afición propuestos en `data/original_clubs_2026.json` son borradores creativos, no aprobaciones finales. Las capacidades de los tres estadios distintos del Fénix quedan sin fijar.

## Plantillas y traspasos
- Objetivo de estructura: 22 futbolistas por club.
- Anier Cumbá (NOVA-PLAYER-0035) y Máximo Padilla (NOVA-PLAYER-0036) quedan asignados a Nova C35; sus atributos, dorsales y estadísticas se conservan.
- Raymond está solicitado para FC Río de Argenti, pero su perfil único no se ha localizado en `data/custom_players.json`. No se cambia ningún otro registro ni se crea un duplicado. La asignación queda pendiente de resolver el ID correcto.
- No se inventan estadísticas de carrera o temporada; empiezan en cero/no disponibles según el esquema hasta registrar partidos.
- Los cuatro equipos todavía no tienen 22 perfiles individuales completos en este manifiesto. No declarar completa la liga de 20 equipos ni los cuatro planteles hasta importar/verificar los 88 perfiles.

## Estado de los archivos binarios
Las referencias de imagen se conservan como referencias descriptivas. Este commit no incorpora archivos PNG/JPG nuevos al árbol de GitHub. La imagen aprobada GEN v2 sigue identificada como adjunto de Dropbox Paper; falta su incorporación binaria independiente al repositorio. La referencia RDA sigue en Dropbox.

## Verificación requerida
Validar IDs únicos, relaciones club/jugador, 22 plazas por equipo, esquema de datos, importación en el juego, renderizado de escudos/equipaciones y pruebas de selector/amistoso. La documentación de diseño no acredita pruebas de motor ni Android.
