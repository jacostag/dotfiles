function tvsed --description "Replace words on dinamically selected files using tv"
    sd -p "$argv[1]" "$argv[2]" $(tv)
end
