#############################
#		Corona Theme		#
#############################
# Copyright (C) 2025 VictorzllDev 
# # https://github.com/VictorzllDev/dotfiles

# (Death Note L Style) colorscheme
bg="#212121"           # Fundo escuro (quase preto, como o tema sombrio de Death Note)
fg="#e0e0e0"           # Texto branco suave (alta legibilidade)

black="#424242"        # Cinza escuro
red="#ef5350"          # Vermelho (sangue, como os assassinatos de Kira)
green="#66bb6a"        # Verde suave (para contraste discreto)
yellow="#ffca28"       # Amarelo (destaque, como os olhos dos Shinigami)
blue="#42a5f5"         # Azul claro (para links ou elementos secundários)
magenta="#ab47bc"      # Roxo (pode representar o Death Note)
cyan="#26c6da"         # Ciano (para pequenos destaques)
white="#f5f5f5"        # Branco puro (texto importante)

blackb="#616161"       # Cinza médio
redb="#ff867c"         # Vermelho claro (destaque)
greenb="#98ee99"       # Verde claro
yellowb="#fff176"      # Amarelo brilhante
blueb="#80d6ff"        # Azul claro (destaque)
magentab="#ce93d8"     # Lilás (para elementos mágicos)
cyanb="#80deea"        # Ciano brilhante
whiteb="#ffffff"       # Branco total (máximo contraste)

accent_color="#424242" # Cinza escuro (para elementos ativos)
arch_icon="#bdbdbd"    # Ícones em cinza claro

# Bspwm options
BORDER_WIDTH="1"		# Bspwm border
TOP_PADDING="50"
BOTTOM_PADDING="1"
LEFT_PADDING="1"
RIGHT_PADDING="1"
NORMAL_BC="#616161"    # Cinza médio (bordas normais)
FOCUSED_BC="#f2f2f2"   # Branco puro (borda em foco, alto contraste)


# Terminal font & size
term_font_size="10"
term_font_name="JetBrainsMono Nerd Font"

# Picom options
P_FADE="true"			# Fade true|false
P_SHADOWS="true"		# Shadows true|false
SHADOW_C="#000000"		# Shadow color
P_CORNER_R="6"			# Corner radius (0 = disabled)
P_BLUR="false"			# Blur true|false
P_ANIMATIONS="@"		# (@ = enable) (# = disable)
P_TERM_OPACITY="1.0"	# Terminal transparency. Range: 0.1 - 1.0 (1.0 = disabled)

# Dunst
dunst_offset='(20, 60)'
dunst_origin='top-right'
dunst_transparency='0'
dunst_corner_radius='6'
dunst_font='JetBrainsMono NF Medium 9'
dunst_border='0'
dunst_frame_color="$accent_color"
dunst_icon_theme="TokyoNight-SE"
# Dunst animations
dunst_close_preset="fly-out"
dunst_close_direction="up"
dunst_open_preset="fly-in"
dunst_open_direction="up"

# Jgmenu colors
jg_bg="$bg"
jg_fg="$fg"
jg_sel_bg="$accent_color"
jg_sel_fg="$fg"
jg_sep="$blackb"

# Rofi menu font and colors
rofi_font="JetBrainsMono NF Bold 9"
rofi_background="$bg"
rofi_bg_alt="$accent_color"
rofi_background_alt="${bg}E0"
rofi_fg="$fg"
rofi_selected="$blue"
rofi_active="$green"
rofi_urgent="$red"

# Screenlocker
sl_bg="${bg}"
sl_fg="${fg}"
sl_ring="${black}"
sl_wrong="${red}"
sl_date="${fg}"
sl_verify="${green}"

# Gtk theme
gtk_theme="TokyoNight-zk"
gtk_icons="TokyoNight-SE"
gtk_cursor="Qogirr-Dark"
geany_theme="z0mbi3-TokyoNight"

# Wallpaper engine
# Available engines:
# - Theme	(Set a random wallpaper from rice directory)
# - CustomDir	(Set a random wallpaper from the directory you specified)
# - CustomImage	(Sets a specific image as wallpaper)
# - CustomAnimated (Set an animated wallpaper. "mp4, mkv, gif")
# - Slideshow (Change randomly every 15 minutes your wallpaper from Walls rice directory)
ENGINE="Theme"
CUSTOM_DIR="/path/to/dir"
CUSTOM_WALL="/path/to/image"
CUSTOM_ANIMATED="$HOME/.config/bspwm/src/assets/animated_wall.mp4"
