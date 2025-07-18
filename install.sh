#!/bin/sh

#   ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗██╗██╗  ██╗
#  ██╔════╝██╔═══██╗██╔══██╗██╔═══██╗████╗  ██║██║╚██╗██╔╝
#  ██║     ██║   ██║██████╔╝██║   ██║██╔██╗ ██║██║ ╚███╔╝ 
#  ██║     ██║   ██║██╔══██╗██║   ██║██║╚██╗██║██║ ██╔██╗ 
#  ╚██████╗╚██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║██╔╝ ██╗
#   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
#
#	Author  -	gh0stzk
#	Repo  -	https://github.com/gh0stzk/dotfiles
# Modified by  - VictorzllDev
#
#	RiceInstaller - Script to install my dotfiles
#
# Copyright (C) 2021-2025 gh0stzk <z0mbi3.zk@protonmail.com>
# Licensed under GPL-3.0 license

# Colors
CRE=$(tput setaf 1)    # Red
CYE=$(tput setaf 3)    # Yellow
CGR=$(tput setaf 2)    # Green
CBL=$(tput setaf 4)    # Blue
BLD=$(tput bold)       # Bold
CNC=$(tput sgr0)       # Reset colors

# Global vars
backup_folder=$HOME/.CoronixBackup
ERROR_LOG="$HOME/CoronixError.log"


print_logo() {
  text="$1"
  banner_width=60
  text_length=${#text}
  spaces=$(( (banner_width - text_length - 4) / 2 ))
  padding=$(printf "%-${spaces}s" " ")

  printf "%b\n" "${BLD}${CGR}   ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗██╗██╗  ██╗${CNC}"
  printf "%b\n" "${BLD}${CGR}  ██╔════╝██╔═══██╗██╔══██╗██╔═══██╗████╗  ██║██║╚██╗██╔╝${CNC}"
  printf "%b\n" "${BLD}${CGR}  ██║     ██║   ██║██████╔╝██║   ██║██╔██╗ ██║██║ ╚███╔╝ ${CNC}"
  printf "%b\n" "${BLD}${CGR}  ██║     ██║   ██║██╔══██╗██║   ██║██║╚██╗██║██║ ██╔██╗ ${CNC}"
  printf "%b\n" "${BLD}${CGR}  ╚██████╗╚██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║██╔╝ ██╗${CNC}"
  printf "%b\n" "${BLD}${CGR}   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝${CNC}"
  printf "\n"

  printf "${padding}${BLD}${CRE}[ ${CYE}${text} ${CRE}]${CNC}\n\n"
}

# Handle errors
log_error() {
    error_msg=$1
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    printf "%s" "[${timestamp}] ERROR: ${error_msg}\n" >> "$ERROR_LOG"
    printf "%s%sERROR:%s %s\n" "${CRE}" "${BLD}" "${CNC}" "${error_msg}" >&2
}

# Initial Checks
initial_checks() {
    # Verify root user
    if [ "$(id -u)" -eq 0 ]; then
        log_error "Please run this script as a regular user, not as root."
        exit 1
    fi

    # Check HOME directory
    if [ "$PWD" != "$HOME" ]; then
        log_error "Please make sure you are in your HOME directory ($HOME) before running this script."
        exit 1
    fi
}

# Internal verification function
is_installed() {
    pacman -Qq "$1" >/dev/null 2>&1
}

is_reflector() {
    # Check if reflector is installed
    if ! command -v reflector >/dev/null 2>&1; then
        # Reflector is not installed, try to install it
        printf "\t%b\n" "${BLD}${CBL}Installing reflector to get the best mirrors...${CNC}"
        
        # Update the package database first
        if ! sudo pacman -Syy 2>&1 | tee -a "$ERROR_LOG" >/dev/null; then
            log_error "Failed to update package database."
            exit 1
        fi
        
        # Install reflector
        if ! sudo pacman -S reflector --noconfirm 2>&1 | tee -a "$ERROR_LOG" >/dev/null; then
            log_error "Failed to install reflector."
            exit 1
        fi
    fi
}

update_mirrorlist() {
  printf "%b\n\n" "${BLD}${CGR}Getting the 5 best and fastest mirrors${CNC}"
  sudo reflector --verbose --age 12 --fastest 10 --score 10 --protocol https --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
  sudo pacman -Syy
}

# Function to verify if packages were installed correctly
verify_installation() {
    failed_pkgs=()
    for pkg in "$@"; do
        if ! is_installed "$pkg"; then
            failed_pkgs+=("$pkg")
            log_error "Failed to install: $pkg"
        fi
    done

    # Show final results
    if [ "${#failed_pkgs[@]}" -eq 0 ]; then
        printf "%b\n\n" "${BLD}${CGR}All packages installed successfully!${CNC}"
    else
        fail_count=${#failed_pkgs[@]}
        printf "%b\n" "${BLD}${CRE}Failed to install $fail_count packages:${CNC}"
        printf "%b\n\n" "  ${BLD}${CYE}$(printf "%s " "${failed_pkgs[@]}")${CNC}"
    fi
}




welcome() {
    clear
    print_logo "Welcome $USER"

    # Header with a styled title
    printf "%b\n" "${BLD}${CGR}Welcome to the Coronix Dotfiles Installer!${CNC}"
    printf "%b\n" "${BLD}${CGR}This script will perform the following actions on your system:${CNC}"
    
    # List of tasks the script will do
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Install repositories, including ${CBL}Chaotic-AUR${CNC}"
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Check for necessary dependencies and install them"
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Download dotfiles to ${HOME}/dotfiles"
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Backup existing configurations (bspwm, polybar, etc.)"
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Install the custom configuration"
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Change your default shell to ${CGR}zsh${CNC}"

    # Important warning
    printf "\n\n  ${BLD}${CGR}[${CRE}!${CGR}]${CNC} ${BLD}${CRE}This script will NOT modify any of your system configurations${CNC}"
    printf "\n  ${BLD}${CGR}[${CRE}!${CGR}]${CNC} ${BLD}${CRE}This script does NOT have the potential to break your system.${CNC}"

    # Ask user for confirmation to continue
    while :; do
        printf "\n%b" "${BLD}${CGR}Do you wish to continue?${CNC} [${CYE}y${CNC}/${CYE}N${CNC}]: "
        read -r yn
        case "$yn" in
            [Yy])  # If user presses Y or y
                printf "\n%b\n" "${BLD}${CGR}Starting the installation...${CNC}"
                break ;;
            [Nn]|"")  # If user presses N or n
                printf "\n%b\n" "${BLD}${CYE}Operation cancelled. Exiting...${CNC}"
                exit 0 ;;
            *)  # If user enters anything other than Y or N
                printf "\n%b\n" "${BLD}${CRE}Error:${CNC} Please enter '${BLD}${CYE}y${CNC}' to continue or '${BLD}${CYE}n${CNC}' to cancel." ;;
        esac
    done
}

add_chaotic_repo() {
    clear
    print_logo "Add chaotic-aur repository"
    repo_name="chaotic-aur"
    key_id="3056513887B78AEB"
    sleep 2

    # Mensaje de configuración del repositorio
    printf "%b\n" "${BLD}${CYE}Installing ${CBL}${repo_name}${CYE} repository...${CNC}"

    # Verificar si ya existe la sección en pacman.conf
    if grep -q "\[${repo_name}\]" /etc/pacman.conf; then
        printf "%b\n" "\n${BLD}${CYE}Repository already exists in pacman.conf${CNC}"
        sleep 3
        return 0
    fi

    # Gestión de clave GPG
    if ! pacman-key -l | grep -q "$key_id"; then
        printf "%b\n" "${BLD}${CYE}Adding GPG key...${CNC}"
        if ! sudo pacman-key --recv-key "$key_id" --keyserver keyserver.ubuntu.com 2>&1 | tee -a "$ERROR_LOG" >/dev/null; then
            log_error "Failed to receive GPG key"
            return 1
        fi

        printf "%b\n" "${BLD}${CYE}Signing key locally...${CNC}"
        if ! sudo pacman-key --lsign-key "$key_id" 2>&1 | tee -a "$ERROR_LOG" >/dev/null; then
            log_error "Failed to sign GPG key"
            return 1
        fi
    else
        printf "\n%b\n" "${BLD}${CYE}GPG key already exists in keyring${CNC}"
    fi

    # Instalación de paquetes requeridos
    chaotic_pkgs="chaotic-keyring chaotic-mirrorlist"
    for pkg in $chaotic_pkgs; do
        if ! pacman -Qq "$pkg" >/dev/null 2>&1; then
            printf "%b\n" "${BLD}${CYE}Installing ${CBL}${pkg}${CNC}"
            if ! sudo pacman -U --noconfirm "https://cdn-mirror.chaotic.cx/chaotic-aur/${pkg}.pkg.tar.zst" 2>&1 | tee -a "$ERROR_LOG" >/dev/null; then
                log_error "Failed to install ${pkg}"
                return 1
            fi
        else
            printf "%b\n" "${BLD}${CYE}${pkg} is already installed${CNC}"
        fi
    done

    # Agregar configuración del repositorio
    printf "\n%b\n" "${BLD}${CYE}Adding repository to pacman.conf...${CNC}"
    if ! printf "\n[%s]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n" "$repo_name" \
       | sudo tee -a /etc/pacman.conf >/dev/null 2>> "$ERROR_LOG"; then
        log_error "Failed to add repository configuration"
        return 1
    fi

    printf "%b\n" "\n${BLD}${CBL}${repo_name} ${CGR}Repository configured successfully!${CNC}"
    sleep 3
}

# Function to install dependencies
install_dependencies() {
    clear
    print_logo "Installing needed packages from official repositories..."
    sleep 2

    # Ensure reflector is installed and update mirrorlist
    is_reflector
    update_mirrorlist

    # List of dependencies
    dependencies=("base-devel" "bluez" "bluez-utils" "bat" "brightnessctl" "bspwm" "clipcat" "dunst" "eza" "feh" "fzf" "thunar" "tumbler" "firefox" "git" "less" "ripgrep" "imagemagick" "jq" "kitty" "libwebp" "maim" "neovim" "pavucontrol" "pamixer" "pacman-contrib" "papirus-icon-theme" "gtk-engine-murrine" "gtk-engines" "picom" "polybar" "lxsession-gtk3" "python-gobject" "redshift" "rofi" "rustup" "sxhkd" "tmux" "xclip" "xdg-user-dirs" "xdo" "xdotool" "xsettingsd" "xorg-xdpyinfo" "xorg-xkill" "xorg-xprop" "xorg-xrandr" "xorg-xsetroot" "xorg-xwininfo" "yazi" "zsh" "zsh-autosuggestions" "zsh-history-substring-search" "zsh-syntax-highlighting" "ttf-inconsolata" "ttf-jetbrains-mono" "ttf-jetbrains-mono-nerd" "ttf-terminus-nerd" "ttf-ubuntu-mono-nerd" "webp-pixbuf-loader")

    clear
    print_logo "Installing needed packages from official repositories..."

    # Display status
    printf "\n%b\n\n" "${BLD}${CBL}Checking for required packages...${CNC}"
    sleep 2

     # Detect missing packages
    missing_pkgs=()
    for pkg in "${dependencies[@]}"; do
        if ! is_installed "$pkg"; then
            missing_pkgs+=("$pkg")
            printf "%b\n" " ${BLD}${CYE}$pkg ${CRE}not installed${CNC}"
        else
            printf "%b\n" "${BLD}${CGR}$pkg ${CBL}already installed${CNC}"
        fi
    done

      # Install missing packages in bulk if necessary
    if [ "${#missing_pkgs[@]}" -gt 0 ]; then
        count=${#missing_pkgs[@]}
        printf "\n%b\n\n" "${BLD}${CYE}Installing $count packages, please wait...${CNC}"

        if ! sudo pacman -S --noconfirm "${missing_pkgs[@]}" > /dev/null 2>>"$ERROR_LOG"; then
            # Verify installation success
            verify_installation "${missing_pkgs[@]}"
        else
            log_error "Critical error during batch installation"
            printf "%b\n" "${BLD}${CRE}Installation failed! Check log for details${CNC}"
            return 1
        fi
    else
        printf "%b\n" "\n${BLD}${CGR}All dependencies are already installed!${CNC}"
    fi

    sleep 3
}

install_chaotic_dependencies() {
    clear
    print_logo "Installing needed packages from chaotic repository..."
    sleep 2

    # List of dependencies
    chaotic_dependencies=("paru" "eww-git" "i3lock-color" "fzf-tab-git")

    printf "%b\n\n" "${BLD}${CBL}Checking for required packages...${CNC}"
    sleep 2

    # Check for missing packages
    missing_chaotic_pkgs=()
    for pkg in "${chaotic_dependencies[@]}"; do
        if ! is_installed "$pkg"; then
            missing_chaotic_pkgs+=("$pkg")
            printf "%b\n" " ${BLD}${CYE}$pkg ${CRE}not installed${CNC}"
        else
            printf "%b\n" "${BLD}${CGR}$pkg ${CBL}already installed${CNC}"
        fi
    done


    # Install missing packages in batch
    if [ ${#missing_chaotic_pkgs[@]} -gt 0 ]; then
        count=${#missing_chaotic_pkgs[@]}
        printf "\n%b\n\n" "${BLD}${CYE}Installing $count packages, please wait...${CNC}"

        if sudo pacman -S --noconfirm "${missing_chaotic_pkgs[@]}" 2>&1 | tee -a "$ERROR_LOG" >/dev/null; then
            # Verify the installation
            verify_installation "${missing_chaotic_pkgs[@]}"
        else
            log_error "Critical error during batch installation"
            printf "%b\n" "${BLD}${CRE}Installation failed! Check log for details${CNC}"
            return 1
        fi
    else
        printf "\n%b\n" "${BLD}${CGR}All dependencies are already installed!${CNC}"
    fi

    sleep 3
}

install_aur_dependencies() {
    clear
    print_logo "Installing AUR dependencies..."
    sleep 2

    # AUR Package List
    aur_apps=("xqp" "xwinwrap-0.9-bin" "qogir-gtk-theme")

    # Display status
    printf "%b\n\n" "${BLD}${CBL}Checking for required AUR packages...${CNC}"
    sleep 2

    # Detect missing AUR packages
    missing_aur=()
    for pkg in "${aur_apps[@]}"; do
        if ! is_installed "$pkg"; then
            missing_aur+=("$pkg")
            printf "%b\n" " ${BLD}${CYE}$pkg ${CRE}not installed${CNC}"
        else
            printf "%b\n" "${BLD}${CGR}$pkg ${CBL}already installed${CNC}"
        fi
    done

     # Install missing AUR packages in bulk if necessary
    if [ "${#missing_aur[@]}" -gt 0 ]; then
        count=${#missing_aur[@]}
        printf "\n%b\n\n" "${BLD}${CYE}Installing $count AUR packages, please wait...${CNC}"

        aur_failed=()
        for pkg in "${missing_aur[@]}"; do
            printf "%b\n" "${BLD}${CBL}Processing: ${pkg}${CNC}"

            if paru -S --skipreview --noconfirm "$pkg" >> "$ERROR_LOG" 2>&1; then
                printf "%b\n" "  ${BLD}${CGR}Successfully installed!${CNC}"
            else
                aur_failed+=("$pkg")
                log_error "AUR package installation failed: $pkg"
                printf "%b\n" "  ${BLD}${CRE}Installation failed!${CNC}"
            fi
            sleep 0.5
        done

        # Verify installation success
        verify_installation "${aur_failed[@]}"
    else
        printf "%b\n\n" "${BLD}${CGR}All AUR dependencies are already installed!${CNC}"
    fi

    sleep 3
}

backup_existing_config() {
    clear
    print_logo "Backup files"
    date=$(date +%Y%m%d-%H%M%S)
    sleep 2

    mkdir -p "$backup_folder" 2>> "$ERROR_LOG"
    printf "\n%b\n\n" "${BLD}${CYE}Backup directory: ${CBL}$backup_folder${CNC}"
    sleep 2

    backup_item() {
        type=$1
        path=$2
        target=$3
        base_name=$(basename "$path")
        exists=0

        if [ "$type" = "d" ] && [ -d "$path" ]; then
            exists=1
        elif [ "$type" = "f" ] && [ -f "$path" ]; then
            exists=1
        fi

        if [ "$exists" -eq 1 ]; then
            if mv "$path" "$backup_folder/${target}_${date}" 2>> "$ERROR_LOG"; then
                printf " %s%s %sbackup successful%s\n" "$BLD" "$base_name" "$CBL" "$CNC"
            else
                log_error "Error backup: $base_name"
                printf " %s%s %sbackup failed%s\n" "$BLD$CRE" "$base_name" "$CYE" "$CNC"
            fi
            sleep 0.5
        else
            printf " %s%s %snot found%s\n" "$BLD$CYE" "$base_name" "$CBL" "$CNC"
            sleep 0.3
        fi
    }

    config_folders="bspwm clipcat picom rofi eww sxhkd dunst kitty polybar gtk-3.0 yazi tmux zsh paru"

    for folder in $config_folders; do
        backup_item d "$HOME/.config/$folder" "$folder"
    done


    single_files="$HOME/.zshrc $HOME/.gtkrc-2.0 $HOME/.icons"
    for item in $single_files; do
        case "$item" in
            *".icons") backup_item d "$item" ".icons" ;;
            *) backup_item f "$item" "$(basename "$item")" ;;
        esac
    done

    printf "\n%b\n\n" "${BLD}${CGR}Backup completed!${CNC}"
    sleep 3
}

install_dotfiles() {
    clear
    print_logo "Installing dotfiles.."
    printf "%s%s Copying files to respective directories...%s\n\n" "$BLD" "$CBL" "$CNC"
    sleep 2

    # Create required directories
    for dir in "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir" 2>> "$ERROR_LOG" && \
            printf "%s%sCreated directory: %s%s%s\n" "$BLD" "$CGR" "$CBL" "$dir" "$CNC"
        fi
    done

    # Generic function to copy files
    copy_files() {
        source="$1"
        target="$2"
        item_name=$(basename "$source")

        if cp -R "$source" "$target" 2>> "$ERROR_LOG"; then
            printf "%s%s %scopied successfully!%s\n" "$BLD" "$CYE$item_name" "$CGR" "$CNC"
            return 0
        else
            log_error "Failed to copy: $item_name"
            printf "%s%s %scopy failed!%s\n" "$BLD" "$CYE$item_name" "$CRE" "$CNC"
            return 1
        fi
    }

    config_source="$HOME/dotfiles/.config"
    for config_dir in "$config_source"/*; do
        dir_name=$(basename "$config_dir")

        copy_files "$config_dir" "$HOME/.config/"
        sleep 0.3
    done

    # Copy miscellaneous components
    for item in asciiart fonts bin; do
        source_path="$HOME/dotfiles/misc/$item"
        target_path="$HOME/.local/share/"
        [ "$item" = "bin" ] && target_path="$HOME/.local/"

        copy_files "$source_path" "$target_path"
        sleep 0.3
    done

    # Copy remaining files
    for file in "$HOME/dotfiles/home/.zshrc" "$HOME/dotfiles/home/.gtkrc-2.0" "$HOME/dotfiles/home/.icons"; do
        copy_files "$file" "$HOME/"
    done

    # Update font cache
    if fc-cache -rv >/dev/null 2>&1; then
        printf "\n%s%sFont cache updated successfully!%s\n" "$BLD" "$CGR" "$CNC"
    else
        log_error "Failed to update font cache"
    fi

    # Generate xdg dirs
    if [ ! -e "$HOME/.config/user-dirs.dirs" ]; then
        if xdg-user-dirs-update >/dev/null 2>&1; then
            printf "%s%sXdg dirs generated successfully!%s\n" "$BLD" "$CGR" "$CNC"
        else
            log_error "Failed to generate xdg dirs"
        fi
    fi

    # Copying polybar-update.hook
    if [ ! -d /etc/pacman.d/hooks ]; then
        sudo mkdir -p /etc/pacman.d/hooks
    fi

    if sudo cp $HOME/dotfiles/misc/pacman-hooks/*.hook /etc/pacman.d/hooks; then
        printf "%s%sPacman hook copied successfully!%s\n" "$BLD" "$CGR" "$CNC"
    else
        log_error "Failed to copy pacman hook :("
    fi

    printf "\n%s%sDotfiles installed successfully!%s\n" "$BLD" "$CGR" "$CNC"
    sleep 3
}

configure_services() {
    clear
    print_logo "Configuring Services"
    sleep 2

    # User-level ArchUpdates
    printf "%b\n" "${BLD}${CYE}Enabling user ArchUpdates service...${CNC}"
    if systemctl --user enable --now ArchUpdates.timer >> "$ERROR_LOG" 2>&1; then
        printf "%b\n\n" "${BLD}${CGR}User ArchUpdates service activated successfully${CNC}"
    else
        log_error "Failed to enable user ArchUpdates service"
        printf "%b\n\n" "${BLD}${CRE}Failed to activate user ArchUpdates service${CNC}"
    fi

    # Enabling Bluetooth
    printf "%b\n" "${BLD}${CYE}Enabling Bluetooth service...${CNC}"
    if sudo systemctl enable bluetooth.service >> "$ERROR_LOG" 2>&1; then
        printf "%b\n\n" "${BLD}${CGR}Bluetooth service enabled successfully.${CNC}"
    else
        log_error "Failed to enable Bluetooth service"
        printf "%b\n\n" "${BLD}${CRE}Failed to enable Bluetooth service.${CNC}"
    fi

    sleep 3
}

change_default_shell() {
    clear
    print_logo "Changing default shell to zsh"
    zsh_path=$(command -v zsh)
    sleep 3

    if [ -z "$zsh_path" ]; then
        log_error "Zsh binary not found"
        printf "%b\n\n" "${BLD}${CRE}Zsh is not installed! Cannot change shell${CNC}"
        return 1
    fi

    if [ "$SHELL" != "$zsh_path" ]; then
        printf "%b\n" "${BLD}${CYE}Changing your shell to Zsh...${CNC}"

        if chsh -s "$zsh_path"; then
            printf "%b\n" "\n${BLD}${CGR}Shell changed successfully!${CNC}"
        else
            printf "%b\n\n" "\n${BLD}${CRE}Error changing shell!{CNC}"
        fi
    else
        printf "%b\n\n" "${BLD}${CGR}Zsh is already your default shell!${CNC}"
    fi

    sleep 3
}

final_prompt() {
    clear
    print_logo "Installation Complete"

    printf "%b\n" "${BLD}${CGR}Installation completed successfully!${CNC}"
    printf "%b\n\n" "${BLD}${CRE}You ${CBL}MUST ${CRE}restart your system to apply changes${CNC}"

    while :; do
        printf "%b" "${BLD}${CYE}Reboot now?${CNC} [y/N]: "
        read -r yn
        case "$yn" in
            [Yy]) printf "\n%b\n" "${BLD}${CGR}Initiating reboot...${CNC}"
                sleep 1
                sudo reboot
                break ;;
            [Nn]|"") printf "\n%b\n\n" "${BLD}${CYE}You really need to reboot bro!!${CNC}"
                    break ;;
            *) printf " %b%bError:%b write 'y' or 'n'\n" "${BLD}" "${CRE}" "${CNC}" ;;
        esac
    done
}


initial_checks
welcome
add_chaotic_repo

install_dependencies
install_chaotic_dependencies
install_aur_dependencies

backup_existing_config
install_dotfiles

configure_services

change_default_shell
final_prompt
