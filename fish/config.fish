# Fastfetch
if status is-interactive
   set -g fish_greeting ""	
   fastfetch
end

# Variables
set -gx MICRO_TRUECOLOR 1

# Alias
alias ls='eza --icons -lha --group-directories-first'
alias cat='bat --color=always'
alias lzd='lazydocker'
alias dck='docker'

# FZF Default Style
set -gx FZF_DEFAULT_OPTS "\
   --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
   --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
   --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
   --color=selected-bg:#45475A \
   --color=border:#6C7086,label:#CDD6F4 \
   --style full"
