function fedit --description "Pick file → open in micro"
    set -l file (fd --type f --hidden --exclude '*.vdi' | fzf --preview='bat --color=always --style=numbers --line-range :300 {}')
    test -n "$file"; and micro $file
end
