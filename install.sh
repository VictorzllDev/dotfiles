#!/bin/sh

#   ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗██╗██╗  ██╗
#  ██╔════╝██╔═══██╗██╔══██╗██╔═══██╗████╗  ██║██║╚██╗██╔╝
#  ██║     ██║   ██║██████╔╝██║   ██║██╔██╗ ██║██║ ╚███╔╝ 
#  ██║     ██║   ██║██╔══██╗██║   ██║██║╚██╗██║██║ ██╔██╗ 
#  ╚██████╗╚██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║██╔╝ ██╗
#   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
#  Author - VictorzllDev
#  Repo   - https://github.com/VictorzllDev/dotfiles
#
#  install.sh - Script to install my dotfiles

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

  printf "\n"
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

    printf "%s\n" "[${timestamp}] ERROR: ${error_msg}" >> "$ERROR_LOG"
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

# Initial Welcome
welcome() {
    clear
    print_logo "Welcome $USER"

    # Header with a styled title
    printf "%b\n" "${BLD}${CGR}Welcome to the Coronix Dotfiles Installer!${CNC}"
    printf "%b\n" "${BLD}${CGR}This script will perform the following actions on your system:${CNC}"
    
    # List of tasks the script will do
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Check for necessary dependencies and install them"
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Backup existing configurations (bspwm, polybar, etc.)"
    printf "\n  ${BLD}${CGR}[${CYE}✔${CGR}]${CNC} Install the custom configuration"

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

# Function to install dependencies
install_dependencies() {
    clear
    print_logo "Installing needed packages from official repositories..."
    sleep 2

    # List of dependencies
    dependencies=("earlyoom" "reflector" "base-devel" "brightnessctl" "bspwm" "git" "libwebp" "maim" "vim" "neovim" "unzip" "pavucontrol" "pamixer" "pacman-contrib" "nodejs-lts" "npm" "go" "rustup" "sxhkd" "tmux" "xclip" "yazi" "kitty" "firefox" "feh" "eza" "bat" "less" "ripgrep" "starship" "ttf-jetbrains-mono" "ttf-jetbrains-mono-nerd" "noto-fonts-emoji" "noto-fonts" "inter-font")

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
            printf "%b\n" "${BLD}${CYE}$pkg ${CRE}not installed${CNC}"
        else
            printf "%b\n" "${BLD}${CGR}$pkg ${CBL}already installed${CNC}"
        fi
    done

      # Install missing packages in bulk if necessary
    if [ "${#missing_pkgs[@]}" -gt 0 ]; then
        count=${#missing_pkgs[@]}
        printf "\n%b\n\n" "${BLD}${CYE}Installing $count packages, please wait...${CNC}"

        if sudo pacman -S --noconfirm "${missing_pkgs[@]}" > /dev/null 2>>"$ERROR_LOG"; then
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

    config_folders="bspwm kitty sxhkd tmux yazi"

    for folder in $config_folders; do
        backup_item d "$HOME/.config/$folder" "$folder"
    done


    single_files="$HOME/.bashrc"
    for item in $single_files; do
        backup_item f "$item" "$(basename "$item")"
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
    for dir in "$HOME/.config" "$HOME/.local/bin"; do
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

    config_source="$HOME/dotfiles/config"
    for config_dir in "$config_source"/*; do
        dir_name=$(basename "$config_dir")

        copy_files "$config_dir" "$HOME/.config/"
        sleep 0.3
    done

    # Copy miscellaneous components
    misc_items="asciiart bin"
    for item in $misc_items; do
        source_path="$HOME/dotfiles/misc/$item"
        target_path="$HOME/.local/share/"
        [ "$item" = "bin" ] && target_path="$HOME/.local/"

        copy_files "$source_path" "$target_path"
        sleep 0.3
    done

    # Copy remaining files
    for file in "$HOME/dotfiles/home/.bashrc"; do
        copy_files "$file" "$HOME/"
    done

    printf "\n%s%sDotfiles installed successfully!%s\n" "$BLD" "$CGR" "$CNC"
    sleep 3
} 

configure_services() {
    clear
    print_logo "Configuring Services"
    sleep 2

    # Enable EarlyOOM Service
    printf "%b\n" "${BLD}${CYE}Enabling user EarlyOOM service...${CNC}"
    if systemctl enable --now earlyoom >> "$ERROR_LOG" 2>&1; then
        printf "%b\n\n" "${BLD}${CGR}User EarlyOOM service activated successfully${CNC}"
    else
        log_error "Failed to enable user EarlyOOM service"
        printf "%b\n\n" "${BLD}${CRE}Failed to activate user EarlyOOM service${CNC}"
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

install_dependencies

backup_existing_config
install_dotfiles

configure_services

final_prompt
