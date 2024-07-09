function frg --description "rg tui built with fzf and bat"
    set RG_PREFIX "rg --smart-case --column --color=always --line-number --no-heading"
    rg --smart-case --column --color=always --line-number --no-heading "$argv" |
        fzf --ansi \
            --disabled \
            --query "$argv" \
            --bind "start:reload:$RG_PREFIX {q}" \
            --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
            --bind 'ctrl-f:transform:[[ ! $FZF_PROMPT =~ fzf ]] &&
              echo "change-prompt(fzf> )+enable-search+clear-query" ||
              echo "change-prompt(rgrep> )+enable-search+clear-query"' \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter ':' \
            --preview "bat --color=always {1} --highlight-line {2}" \
            --prompt 'ripgrep> ' \
            --header 'CTRL-f: Switch between fzf/rgrep' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind "enter:become(nvim +{2} {1})"
end
