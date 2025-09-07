function fdir -d "Pick directory → cd into it"
    set -l dir (fd --type d --hidden | fzf --preview='eza -lha --icons --group-directories-first --level 3 {}')
    test -n "$dir"; and cd $dir
end
