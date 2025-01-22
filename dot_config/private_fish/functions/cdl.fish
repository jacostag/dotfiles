function cdl --description "enter to a dir and list contents"
    builtin cd $argv[1]
    and begin
        echo "cd to directory: $PWD"
        timeout 1s eza -l --color=always --icons=always
    end
end
