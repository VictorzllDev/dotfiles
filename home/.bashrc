#  ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#  ██████╔╝███████║███████╗███████║██████╔╝██║     
#  ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║     
#  ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#  Author - VictorzllDev
#  Repo   - https://github.com/VictorzllDev/dotfiles


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#  ┬  ┬┌─┐┬─┐┌─┐
#  └┐┌┘├─┤├┬┘└─┐
#   └┘ ┴ ┴┴└─└─┘
export VISUAL="${EDITOR}"
export EDITOR='nvim'
export BROWSER='firefox'
export HISTIGNORE="ls:cd:pwd:exit:sudo reboot:history:cd -:cd .."
export SUDO_PROMPT="Deploying root access for %u. Password pls: "
export BAT_THEME="base16"

# Add ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# Add Go binaries if Go is installed and bin exists
if command -v go >/dev/null 2>&1; then
  go_bin="$(go env GOPATH)/bin"
  if [ -d "$go_bin" ]; then
    PATH="$go_bin:$PATH"
  fi
fi

alias mirrors='sudo reflector --verbose --latest 5 --country 'Brazil' --age 6 --sort rate --save /etc/pacman.d/mirrorlist'
alias grep='grep --color=auto'
alias cat="bat --theme=base16"
alias ls='eza --icons=always --color=always -a'
alias ll='eza --icons=always --color=always -la'

eval "$(starship init bash)"

