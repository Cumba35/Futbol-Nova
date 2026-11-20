# Fútbol Nova — Menú de selección de camisetas

**Estado:** requisito de diseño registrado; mockup e implementación pendientes.

## Identidad visual

Tomar como referencia la captura aportada por el usuario: fondo negro profundo, título deportivo condensado en la parte superior, modelos 3D de cuerpo completo a izquierda y derecha, paneles centrales HOME/AWAY, panel seleccionado en tono crema claro y panel no seleccionado oscuro. Usar iluminación cinematográfica blanca sobre los modelos y acentos discretos en azul marino y naranja. Mantener identidad propia de Fútbol Nova: no copiar marcas, escudos, camisetas, logotipos ni recursos protegidos de la referencia.

## Selección mediante deslizamiento

- El usuario podrá cambiar una equipación deslizando el dedo horizontalmente **sobre la camiseta/panel de la equipación que desea cambiar**.
- Deslizar hacia la izquierda avanza a la siguiente camiseta disponible de ese equipo; deslizar hacia la derecha vuelve a la camiseta anterior. El orden exacto podrá invertirse si el carrusel visual se diseña con otra convención, pero debe mantenerse coherente y mostrarse con una transición clara.
- El gesto solo modifica el lado/panel sobre el que comenzó: deslizar sobre HOME cambia la camiseta local; deslizar sobre AWAY cambia la visitante. Nunca debe cambiar ambas equipaciones a la vez.
- El gesto se reconoce desde el área táctil del panel/camiseta, con umbral mínimo horizontal y tolerancia vertical para no confundirlo con un toque, desplazamiento accidental o gesto del sistema.
- Un deslizamiento corto o principalmente vertical no cambia la camiseta.
- Al cambiar, actualizar inmediatamente la miniatura/representación de la camiseta y la equipación del modelo 3D correspondiente. La transición debe ser suave y no bloquear la selección del otro equipo.
- Las flechas laterales pueden mantenerse como alternativa para mando, teclado o accesibilidad; no serán la única forma de cambiar la camiseta.
- La selección debe funcionar en pantallas táctiles Android, adaptarse a distintas relaciones de aspecto y mantener áreas táctiles suficientemente amplias.
- Si el usuario cambia de equipo o vuelve atrás, conservar la selección mientras siga dentro del flujo de preparación del mismo partido; al iniciar el partido, aplicar exactamente las equipaciones elegidas y validar que no sean visualmente indistinguibles.

## Criterios de aceptación

1. Deslizar horizontalmente sobre HOME cambia únicamente la equipación HOME.
2. Deslizar horizontalmente sobre AWAY cambia únicamente la equipación AWAY.
3. Izquierda/derecha recorren las opciones en sentidos opuestos y no producen saltos inesperados.
4. La camiseta mostrada y el modelo 3D se actualizan juntos.
5. Toques, gestos verticales y movimientos por debajo del umbral no cambian la equipación.
6. Las flechas y controles alternativos siguen funcionando.
7. La interfaz es usable en Android, con orientación y tamaños de pantalla compatibles.
8. Antes del partido se comprueba que las equipaciones elegidas permitan distinguir ambos equipos.

## Flujo de diseño

Antes de implementar esta pantalla, generar un mockup visual para revisión del usuario siguiendo el flujo definido en GAME_DESIGN.md. El mockup no se considerará implementación funcional.


## Implementación inicial conectada — 20 noviembre 2026

La pantalla `scripts/ui/team_kit_selection.gd` presenta ambos equipos simultáneamente, permite recorrer clubes sin repetir rival y cambiar primera/segunda equipación por separado. Usa vistas 3D procedurales temporales y una paleta determinista en `scripts/ui/team_kit_palette.gd`. La confirmación devuelve IDs de clubes y uniformes al flujo amistoso. Los controles se adaptan apilando paneles cuando el ancho es reducido. No se usan assets de FIFA/EA. El modelo 3D y la paleta son prototipos; el carrusel táctil por deslizamiento, patrones de camisetas, escudos definitivos, OVR y validación de contraste aún deben completarse.
