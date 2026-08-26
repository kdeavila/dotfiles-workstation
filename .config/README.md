# Dotfiles — Estación de trabajo (Arch + Hyprland)

Setup "estación de trabajo": cromo monocromo + un acento, blur solo en capas
flotantes, barra de cristal pegada al borde. Fuente única de verdad de la
paleta: `~/.config/theme/tokens.conf` — un solo comando regenera TODO:

```bash
~/.config/theme/apply-theme.sh
```

## Contenido versionado

| Ruta | Qué es |
| :--- | :--- |
| `.config/hypr/` | Hyprland: binds, reglas, hypridle, hyprlock, wallpapers, scripts |
| `.config/theme/` | `tokens.conf` (paleta) + `apply-theme.sh` (generador) |
| `.config/waybar/` | Barra (config.jsonc, style.css, tema generado) |
| `.config/swaync/` | Notificaciones |
| `.config/swayosd/` | OSD volumen/brillo estilo macOS (generado) |
| `.config/wlogout/` | Menú de sesión (layout propio + CSS por tokens) |
| `.config/starship.toml` | Prompt Jetpack con paleta workstation (generada) |
| `.config/ghostty/` `.config/kitty/` | Terminales (tema generado desde tokens) |
| `.config/spotify-launcher.conf` | Spotify vía Wayland nativo (Ozone) |
| `.config/spicetify/config-xpui.ini` | Spicetify: tema text + esquema Workstation |
| `.spicetify/Themes/text/color.ini` | Sección `[Workstation]` (tokens de Spotify) |
| `.config/Code/User/settings.json` | VS Code (fuente JetBrainsMono, tema Workstation) |
| `.vscode/extensions/keyner.workstation-theme/` | Tema local de VS Code (generado) |

## Paquetes (Arch)

```bash
# repos oficiales
sudo pacman -S --needed hyprland hypridle hyprlock waybar swaync swayosd \
  wlogout swaybg starship ghostty kitty cliphist wl-clipboard grim \
  playerctl dolphin brave-bin spotify-launcher ttf-jetbrains-mono-nerd

# AUR (con tu helper, p.ej. paru)
paru -S --needed apple-fonts vicinae

# spicetify: instalador oficial (no está en pacman)
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
```

Extras que el setup asume: `polkit-kde-authentication-agent`, NetworkManager,
`sudo systemctl enable --now NetworkManager`.

## Replicar en otra máquina

```bash
# 1. clonar el repo bare
git clone --bare <remote-o-ruta-del-repo> ~/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# 2. hacer checkout (mueve o borra antes los configs que choquen)
config checkout
config config --local status.showUntrackedFiles no
config config --local core.excludesFile "$HOME/.cfg/gitignore"

# 3. regenerar todo desde tokens y aplicar
~/.config/theme/apply-theme.sh
hyprctl reload && killall -SIGUSR2 waybar && swaync-client -rs

# 4. spotify parchado (repetir tras cada actualización del cliente)
~/.spicetify/spicetify apply
```

## Uso diario

```bash
config add .config/hypr/hyprland.conf && config commit -m "..."
config push   # si añades remote: config remote add origin <url>
```

Los archivos marcados "GENERADO — no editar a mano" salen de `tokens.conf`;
cámbialos tocando los tokens, nunca a mano.
