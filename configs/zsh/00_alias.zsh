#alias g='XDG_CONFIG_HOME="$HOME/.config" lazygit'
#alias gs="git status"
#alias ga="git add -A"
#alias gc="git commit -v"
#alias gc!="git commit -v --amend --no-edit"
#alias gl="git pull"
#alias gp="git push"
#alias gp!="git push --force"
#alias gcl="git clone --depth 1 --single-branch"
#alias gf="git fetch --all"
#alias gb="git branch"
#alias gr="git rebase"
#alias gt='cd "$(git rev-parse --show-toplevel)"'
alias l='eza -lah --group-directories-first --git --time-style=long-iso'
alias lt='l -TI .git'
alias clc='clipcopy'
alias clp='clippaste'
alias pb='curl -F "c=@-" "http://fars.ee/?u=1"'
alias sc='sudo systemctl'
alias scu='systemctl --user'
alias sudo='sudo '

alias -g :n='>/dev/null'
alias -g :nn='&>/dev/null'
alias -g :bg='&>/dev/null &!'
alias -g :h='--help 2>&1 | bat -pl help'

if [[ $OSTYPE == linux* ]] {
    alias open='xdg-open'
}

if [[ "$TERM" == "xterm-kitty" || -n "$KITTY_WINDOW_ID" ]]; then
    alias ssh="kitty +kitten ssh"
fi
