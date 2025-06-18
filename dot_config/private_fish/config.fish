set -g fish_key_bindings fish_vi_key_bindings
set -gx TERM xterm-256color
set -g fish_greeting
set -gx EDITOR nvim
set -gx VISUAL nvim
#set -gx PAGER moar
set -gx PAGER ov
set -gx MANPAGER "nvim +Man!"
#set -gx MANPAGER ov
set -gx SHELL /usr/bin/fish
set -gx ATUIN_NOBIND true

set -x CLOUDSDK_PYTHON_SITEPACKAGES 1

if status is-interactive
    fzf --fish | source
    zoxide init fish | source
    direnv hook fish | source
    starship init fish | source
    navi widget fish | source
    atuin init fish | source
    set -gx BAT_THEME "Catppuccin Mocha"
    set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"
    set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    fzf_key_bindings
end

set -g fish_key_bindings fish_vi_key_bindings
