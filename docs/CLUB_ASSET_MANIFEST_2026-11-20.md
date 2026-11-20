# Fútbol Nova — manifiesto de activos de clubes (2026-11-20)

## Regla común de estadios
Los cuatro estadios originales deben tener capacidad de diseño de 105.000 espectadores y usar la paleta de la primera equipación del club. La implementación del catálogo está en `scripts/stadiums/stadium_builder.gd`.

| Club | Estadio | Capacidad | Paleta de la primera equipación |
|---|---|---:|---|
| Nova C35 (C35) | Estadio del Fénix | 105.000 | Azul marino y cian; plata secundaria |
| FC Río de Argenti (RDA) | Estadio Río de Argenti | 105.000 | Azul río, plata y blanco; provisional hasta inspeccionar visualmente el JPG original |
| Nova Génesis (GEN) | Arena Nova Génesis | 105.000 | Azul marino y blanco, acentos rojos y verdes; local v2 aprobada |
| Sangre Galáctica (SAG) | Estadio Sangre de Estrellas | 105.000 | Morado y rojo, detalles amarillos y blancos |

## Nova Génesis (GEN)
- La identidad local v2 fue aprobada por el propietario el 20-11-2026: letras GEN entrelazadas e irregulares; camiseta blanca con paneles geométricos/texturizados navy, acentos rojos y verdes y shorts blanco/navy.
- Foto original de referencia: https://paper-attachments.dropboxusercontent.com/attachment-426099076273329128066594_1795207204169_nova_genesis_reference_photo_2026-11-20.jpg
- Propuesta v2 aprobada: https://paper-attachments.dropboxusercontent.com/attachment-361855441170696076943187_1795207271649_nova_genesis_home_kit_proposal_03_GEN.jpg
- Los binarios siguen sin estar incorporados como archivos independientes al repositorio.

## FC Río de Argenti (RDA)
- Referencia local existente: `/Apps/Futbol Nova/Assets/Clubs/RDA/Kits/rda_home_kit_reference.jpg`; no sobrescribir.
- La paleta azul río/plata/blanco del estadio es provisional hasta verificar visualmente esa referencia.

## Nova C35 (C35)
- Estadio del Fénix conserva el nombre y capacidad 105.000 registrados previamente.
- Paleta derivada de la propuesta local azul marino/cian con plata secundaria.

## Sangre Galáctica (SAG)
- Colores confirmados: rojo y morado dominantes; amarillo y blanco como detalles.
- El estadio usa esa misma jerarquía cromática.

## Plantillas
- Anier Cumbá y Máximo Padilla asignados a Nova C35 sin alterar sus atributos, dorsales o estadísticas.
- Raymond sigue pendiente de ID único.
- Las plantillas de 22 jugadores por equipo no están completas.

## Verificación
Se amplió `tests/test_stadium_builder.gd` para exigir los cuatro estadios originales y su capacidad. El resultado de CI posterior a este commit queda pendiente. Los assets gráficos binarios aún no están todos en GitHub.
