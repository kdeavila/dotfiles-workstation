#!/usr/bin/env bash
# =============================================================================
#  Genera TODOS los temas desde ~/.config/theme/tokens.conf
#  Cromo monocromo · contenido con color. Ver tokens.conf.
# =============================================================================
set -euo pipefail
CONFIG_DIR="$HOME/.config"
source "$CONFIG_DIR/theme/tokens.conf"

# --- WAYBAR (antes quedaba fuera del sistema de tokens: causaba colores
#     indefinidos cuando algo sobreescribia current.css) -----------------------
cat > "$CONFIG_DIR/waybar/themes/current.css" <<EOF
/* GENERADO desde ~/.config/theme/tokens.conf — no editar a mano */
@define-color base          ${base};
@define-color surface       ${surface};
@define-color elevated      ${elevated};
@define-color text          ${text};
@define-color text_dim      ${text_dim};
@define-color text_faint    ${text_faint};
@define-color fill          ${fill};
@define-color on_fill       ${on_fill};
@define-color accent        ${accent};
@define-color on_accent     ${on_accent};
@define-color warning       ${warning};
@define-color urgent        ${urgent};
@define-color border        ${border};
@define-color border_active ${border_active};
EOF
echo "  waybar   -> themes/current.css"

# --- SWAYNC -------------------------------------------------------------------
cat > "$CONFIG_DIR/swaync/themes/current.css" <<EOF
/* GENERADO desde ~/.config/theme/tokens.conf — no editar a mano */
@define-color cc-bg                 ${base}F2;
@define-color noti-bg               ${surface};
@define-color noti-bg-hover         ${elevated};
@define-color bg-selected           ${accent};
@define-color text-color            ${text};
@define-color text-color-disabled   ${text_faint};
@define-color border-color          ${border};
EOF
echo "  swaync   -> themes/current.css"

# --- SWAYOSD ------------------------------------------------------------------
# Estilo macOS: píldora compacta sin borde, icono nítido, barra blanca fina
cat > "$CONFIG_DIR/swayosd/style.css" <<EOF
/* GENERADO desde ~/.config/theme/tokens.conf — no editar a mano */
@define-color base ${base};
@define-color surface ${surface};
@define-color elevated ${elevated};
@define-color text ${text};
@define-color text_dim ${text_dim};
@define-color accent ${accent};
@define-color urgent ${urgent};
@define-color border ${border};

* {
    outline-width: 0;
}

window#osd {
    border: none;
    background: alpha(@base, 0.88);
    border-radius: 999px;
    padding: 6px 10px;
}

window#osd #container {
    margin: 4px;
}

/* Icono: nítido, sin transformaciones que lo degraden */
window#osd image {
    color: @text;
    margin-right: 10px;
}

window#osd label {
    color: @text_dim;
    font-family: "SF Pro Display", sans-serif;
    font-size: 14px;
}

/* Barra fina tipo HUD de macOS */
window#osd progressbar,
window#osd segmentedprogress {
    min-height: 5px;
    min-width: 110px;
    border-radius: 999px;
    background: transparent;
    border: none;
}

window#osd trough,
window#osd segment {
    min-height: inherit;
    border-radius: inherit;
    border: none;
    background: alpha(@text, 0.22);
}

window#osd progress,
window#osd segment.active {
    min-height: inherit;
    border-radius: inherit;
    border: none;
    background: @text;
}

window#osd segment {
    margin-left: 5px;
}

window#osd segment:first-child {
    margin-left: 0;
}

window#osd progressbar:disabled,
window#osd image:disabled {
    opacity: 0.45;
}
EOF
echo "  swayosd  -> style.css"

# --- WLOGOUT ------------------------------------------------------------------
cat > "$CONFIG_DIR/wlogout/colors.css" <<EOF
/* GENERADO desde ~/.config/theme/tokens.conf — no editar a mano */
@define-color base      ${base};
@define-color surface   ${surface};
@define-color elevated  ${elevated};
@define-color text      ${text};
@define-color accent    ${accent};
@define-color border    ${border};
EOF
echo "  wlogout  -> colors.css"

# --- GHOSTTY (CONTENIDO: conserva color para la sintaxis) ---------------------
cat > "$CONFIG_DIR/ghostty/theme.conf" <<EOF
# GENERADO desde ~/.config/theme/tokens.conf — no editar a mano
# Importar con:  config-file = theme.conf   (NO "@include", es invalido)
background = ${term_bg}
foreground = ${term_fg}
selection-background = ${elevated}
selection-foreground = ${text}
cursor-color = ${accent}
palette = 0=${term_black}
palette = 1=${term_red}
palette = 2=${term_green}
palette = 3=${term_yellow}
palette = 4=${term_blue}
palette = 5=${term_magenta}
palette = 6=${term_cyan}
palette = 7=${term_white}
palette = 8=${text_faint}
palette = 9=${term_red}
palette = 10=${term_green}
palette = 11=${term_yellow}
palette = 12=${term_blue}
palette = 13=${term_magenta}
palette = 14=${term_cyan}
palette = 15=${text}
EOF
echo "  ghostty  -> theme.conf"

# --- KITTY (CONTENIDO) --------------------------------------------------------
cat > "$CONFIG_DIR/kitty/theme.conf" <<EOF
# GENERADO desde ~/.config/theme/tokens.conf — no editar a mano
# Importar con:  include theme.conf
background ${term_bg}
foreground ${term_fg}
selection_background ${elevated}
selection_foreground ${text}
cursor ${accent}
color0 ${term_black}
color8 ${text_faint}
color1 ${term_red}
color9 ${term_red}
color2 ${term_green}
color10 ${term_green}
color3 ${term_yellow}
color11 ${term_yellow}
color4 ${term_blue}
color12 ${term_blue}
color5 ${term_magenta}
color13 ${term_magenta}
color6 ${term_cyan}
color14 ${term_cyan}
color7 ${term_white}
color15 ${text}
EOF
echo "  kitty    -> theme.conf"

# --- STARSHIP (prompt: paleta workstation) ------------------------------------
# Regenera SOLO [palettes.workstation] (los módulos y glifos son estáticos).
python3 - "$CONFIG_DIR/theme/tokens.conf" "$CONFIG_DIR/starship.toml" <<'PYEOF'
import re, sys, tomllib
tok = {}
for ln in open(sys.argv[1], encoding='utf-8'):
    m = re.match(r'^(\w+)="#([0-9a-fA-F]{6})"', ln.strip())
    if m: tok[m.group(1)] = '#' + m.group(2)
pal = {
    'color_fg0':       tok['on_fill'],
    'color_on_accent': tok['on_accent'],
    'color_fill':      tok['fill'],
    'color_surface':   tok['surface'],
    'color_elevated':  tok['elevated'],
    'color_border':    tok['border'],
    'color_text':      tok['text'],
    'color_dim':       tok['text_dim'],
    'color_accent':    tok['accent'],
    'color_green':     tok['term_green'],
    'color_red':       tok['term_red'],
    'color_yellow':    tok['term_yellow'],
    'color_purple':    tok['term_magenta'],
    'color_cyan':      tok['term_cyan'],
}
block = '[palettes.workstation]\n' + ''.join(f"{k} = '{v}'\n" for k, v in pal.items())
p = sys.argv[2]
src = open(p, encoding='utf-8').read()
new, n = re.subn(r'(?m)^\[palettes\.workstation\]\n[^\[]*', block, src, count=1)
assert n == 1, 'seccion [palettes.workstation] no encontrada'
tomllib.loads(new)
open(p, 'w', encoding='utf-8').write(new)
print('  starship -> palette workstation')
PYEOF

# --- VSCODE (CONTENIDO: sintaxis con la paleta de contenido) -------------------
mkdir -p "$CONFIG_DIR/../.vscode/extensions/keyner.workstation-theme/themes"
cat > "$HOME/.vscode/extensions/keyner.workstation-theme/themes/workstation-color-theme.json" <<EOF
// GENERADO desde ~/.config/theme/tokens.conf — no editar a mano
{
    "name": "Workstation",
    "type": "dark",
    "colors": {
        "editor.background": "${base}",
        "editor.foreground": "${text}",
        "editor.lineHighlightBackground": "${surface}80",
        "editor.selectionBackground": "${elevated}",
        "editor.findMatchBackground": "${accent}40",
        "editor.findMatchHighlightBackground": "${accent}25",
        "editorCursor.foreground": "${accent}",
        "editorWhitespace.foreground": "${text_faint}40",
        "editorRuler.foreground": "${border}",
        "editorIndentGuide.background1": "${border}60",
        "editorIndentGuide.activeBackground1": "${border_active}",
        "editorLineNumber.foreground": "${text_faint}",
        "editorLineNumber.activeForeground": "${text}",
        "editorWidget.background": "${surface}",
        "editorWidget.border": "${border}",
        "editorSuggestWidget.background": "${surface}",
        "editorSuggestWidget.selectedBackground": "${elevated}",
        "editorHoverWidget.background": "${surface}",
        "editorGutter.background": "${base}",
        "editorError.foreground": "${urgent}",
        "editorWarning.foreground": "${warning}",
        "editorBracketMatch.background": "${accent}30",
        "editorBracketMatch.border": "${accent}",
        "sideBar.background": "${base}",
        "sideBarSectionHeader.background": "${surface}",
        "sideBarTitle.foreground": "${text_dim}",
        "activityBar.background": "${base}",
        "activityBar.foreground": "${text}",
        "activityBar.inactiveForeground": "${text_faint}",
        "activityBarBadge.background": "${accent}",
        "activityBarBadge.foreground": "${on_accent}",
        "titleBar.activeBackground": "${base}",
        "titleBar.activeForeground": "${text_dim}",
        "titleBar.inactiveBackground": "${base}",
        "statusBar.background": "${surface}",
        "statusBar.foreground": "${text_dim}",
        "statusBar.noFolderBackground": "${surface}",
        "statusBar.debuggingBackground": "${urgent}",
        "statusBarItem.remoteBackground": "${accent}",
        "statusBarItem.remoteForeground": "${on_accent}",
        "tab.activeBackground": "${surface}",
        "tab.activeForeground": "${text}",
        "tab.inactiveBackground": "${base}",
        "tab.inactiveForeground": "${text_faint}",
        "tab.activeBorderTop": "${accent}",
        "tab.border": "${base}",
        "editorGroupHeader.tabsBackground": "${base}",
        "panel.background": "${base}",
        "panel.border": "${border}",
        "panelTitle.activeForeground": "${text}",
        "terminal.background": "${base}",
        "terminal.foreground": "${text}",
        "terminalCursor.foreground": "${accent}",
        "terminal.ansiBlack": "${term_black}",
        "terminal.ansiRed": "${term_red}",
        "terminal.ansiGreen": "${term_green}",
        "terminal.ansiYellow": "${term_yellow}",
        "terminal.ansiBlue": "${term_blue}",
        "terminal.ansiMagenta": "${term_magenta}",
        "terminal.ansiCyan": "${term_cyan}",
        "terminal.ansiWhite": "${term_white}",
        "terminal.ansiBrightBlack": "${text_faint}",
        "terminal.ansiBrightRed": "${term_red}",
        "terminal.ansiBrightGreen": "${term_green}",
        "terminal.ansiBrightYellow": "${term_yellow}",
        "terminal.ansiBrightBlue": "${term_blue}",
        "terminal.ansiBrightMagenta": "${term_magenta}",
        "terminal.ansiBrightCyan": "${term_cyan}",
        "terminal.ansiBrightWhite": "${text}",
        "list.activeSelectionBackground": "${elevated}",
        "list.activeSelectionForeground": "${text}",
        "list.hoverBackground": "${surface}",
        "list.focusOutline": "${accent}",
        "list.highlightForeground": "${accent}",
        "input.background": "${surface}",
        "input.border": "${border}",
        "input.foreground": "${text}",
        "dropdown.background": "${surface}",
        "dropdown.border": "${border}",
        "button.background": "${accent}",
        "button.foreground": "${on_accent}",
        "button.hoverBackground": "${accent}CC",
        "secondaryButton.background": "${elevated}",
        "badge.background": "${accent}",
        "badge.foreground": "${on_accent}",
        "focusBorder": "${accent}",
        "border": "${border}",
        "scrollbarSlider.background": "${elevated}80",
        "scrollbarSlider.hoverBackground": "${border_active}80",
        "scrollbarSlider.activeBackground": "${border_active}",
        "gitDecoration.modifiedResourceForeground": "${warning}",
        "gitDecoration.deletedResourceForeground": "${urgent}",
        "gitDecoration.untrackedResourceForeground": "${term_green}",
        "gitDecoration.conflictingResourceForeground": "${urgent}",
        "notifications.background": "${surface}",
        "notifications.border": "${border}",
        "notificationCenterHeader.background": "${elevated}",
        "notificationToast.border": "${border}",
        "extensionButton.prominentBackground": "${accent}",
        "extensionButton.prominentForeground": "${on_accent}",
        "peekView.border": "${accent}",
        "peekViewEditor.background": "${surface}",
        "peekViewResult.background": "${surface}",
        "minimap.background": "${base}",
        "debugToolBar.background": "${surface}",
        "walkThrough.embeddedEditorBackground": "${base}",
        "settings.headerForeground": "${text}",
        "settings.dropdownBackground": "${surface}",
        "settings.dropdownBorder": "${border}",
        "welcomePage.background": "${base}",
        "breadcrumb.background": "${base}",
        "breadcrumb.foreground": "${text_faint}",
        "breadcrumbPicker.background": "${surface}"
    },
    "tokenColors": [
        {
            "name": "Comentarios",
            "scope": ["comment", "punctuation.definition.comment"],
            "settings": {"foreground": "${text_faint}", "fontStyle": "italic"}
        },
        {
            "name": "Cadenas",
            "scope": ["string", "string.quoted"],
            "settings": {"foreground": "${term_green}"}
        },
        {
            "name": "Regex y escapes",
            "scope": ["string.regexp", "constant.character.escape"],
            "settings": {"foreground": "${term_magenta}"}
        },
        {
            "name": "Números y constantes",
            "scope": ["constant.numeric", "constant.language", "constant.other"],
            "settings": {"foreground": "${term_yellow}"}
        },
        {
            "name": "Palabras clave",
            "scope": ["keyword", "keyword.control", "storage", "storage.type"],
            "settings": {"foreground": "${accent}"}
        },
        {
            "name": "Operadores",
            "scope": ["keyword.operator"],
            "settings": {"foreground": "${text_dim}"}
        },
        {
            "name": "Funciones",
            "scope": ["entity.name.function", "support.function", "meta.function-call"],
            "settings": {"foreground": "${term_cyan}"}
        },
        {
            "name": "Tipos y clases",
            "scope": ["entity.name.type", "entity.name.class", "support.type", "support.class"],
            "settings": {"foreground": "${term_yellow}"}
        },
        {
            "name": "Variables",
            "scope": ["variable.other", "variable.other.property"],
            "settings": {"foreground": "${text}"}
        },
        {
            "name": "Parámetros",
            "scope": ["variable.parameter"],
            "settings": {"foreground": "${term_white}"}
        },
        {
            "name": "this/self/super",
            "scope": ["variable.language"],
            "settings": {"foreground": "${urgent}"}
        },
        {
            "name": "Tags HTML/XML",
            "scope": ["entity.name.tag"],
            "settings": {"foreground": "${urgent}"}
        },
        {
            "name": "Atributos HTML",
            "scope": ["entity.other.attribute-name"],
            "settings": {"foreground": "${term_yellow}"}
        },
        {
            "name": "CSS propiedades y unidades",
            "scope": ["support.type.property-name.css", "support.constant.unit"],
            "settings": {"foreground": "${term_cyan}"}
        },
        {
            "name": "Decoradores",
            "scope": ["meta.decorator", "storage.modifier"],
            "settings": {"foreground": "${term_yellow}"}
        },
        {
            "name": "Puntuación",
            "scope": ["punctuation.separator", "punctuation.terminator", "meta.brace"],
            "settings": {"foreground": "${text_dim}"}
        },
        {
            "name": "Inválido",
            "scope": ["invalid"],
            "settings": {"foreground": "${urgent}", "fontStyle": "underline"}
        }
    ]
}
EOF
echo "  vscode   -> Workstation theme"

# --- HYPRLAND (bordes: solidos, sin degradado) --------------------------------
cat > "$CONFIG_DIR/hypr/themes/current.conf" <<EOF
# GENERADO desde ~/.config/theme/tokens.conf — no editar a mano
# Bordes SOLIDOS: un solo color, sin gradiente de 45deg (eso era rice)
\$active_border_1 = rgb(${border_active#\#})
\$active_border_2 = rgb(${border_active#\#})
\$inactive_border = rgb(${border#\#})
\$shadow_color = rgba(0000001a)
\$rounding = 6
\$gaps_in = 6
\$gaps_out = 12
EOF
echo "  hyprland -> themes/current.conf"

echo
echo "Listo. Recarga:  hyprctl reload && killall -SIGUSR2 waybar && swaync-client -rs"
