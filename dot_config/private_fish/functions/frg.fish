function frg --description "rg tui built with fzf and bat"
    set RG_PREFIX "rg --smart-case --column --color=always --line-number --no-heading"
    rg --smart-case --column --color=always --line-number --no-heading "$argv" |
        fzf --ansi \
            --multi \
            --disabled \
            --query "$argv" \
            --bind "start:reload:$RG_PREFIX {q}" \
            --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter ':' \
            --preview "bat --color=always {1} --highlight-line {2}" \
            --prompt 'ripgrep> ' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind "enter:become(nvim {1} +{2}),ctrl-y:execute-silent(echo {} | wl-copy -n)+abort"
end
