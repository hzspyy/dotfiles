
bindkey -s "^y" "y\n"

# Widgets
function vi-yank-wrapped {
  local last_key="$KEYS[-1]"
  local ori_buffer="$CUTBUFFER"

  zle vi-yank
  if [[ "$last_key" = "Y" ]] then
    echo -n "$CUTBUFFER" | clipcopy -i
    CUTBUFFER="$ori_buffer"
  fi
}
zle -N vi-yank-wrapped

# Trim trailing spaces from pasted text
# Ref: https://unix.stackexchange.com/questions/693118
qc-trim-paste() {
    zle .$WIDGET && LBUFFER=${LBUFFER%%[[:space:]]#}
}
zle -N bracketed-paste qc-trim-paste

# Change `...` to `../..`
# Ref: https://grml.org/zsh/zsh-lovers.html#_completion
qc-rationalize-dot() {
    if [[ $LBUFFER == *.. ]] {
        LBUFFER+='/..'
    } else {
        LBUFFER+='.'
    }
}
zle -N qc-rationalize-dot
bindkey -M viins "." qc-rationalize-dot             # 插入模式 . = 补全点
bindkey '\E.' self-insert-unmeta  # [Alt+.] insert dot


# [Ctrl+L] Clear screen but keep scrollback
# Ref: https://superuser.com/questions/1389834
qc-clear-screen() {
    local prompt_height=$(print -n ${(%%)PS1} | wc -l)
    local lines=$((LINES - prompt_height))
    printf "$terminfo[cud1]%.0s" {1..$lines}  # cursor down
    printf "$terminfo[cuu1]%.0s" {1..$lines}  # cursor up
    zle .reset-prompt
}
zle -N qc-clear-screen

# Menu
bindkey -rpM menuselect ""
bindkey -M menuselect "^I"        complete-word
bindkey -M menuselect "^["        send-break
bindkey -M menuselect "^K"        up-line-or-history
bindkey -M menuselect "^J"        down-line-or-history
bindkey -M menuselect "^H"        backward-char
bindkey -M menuselect "^[[105;5u" forward-char  # Ctrl+i in CSI u, configured in kitty.conf and tmux.conf both

# Command
bindkey -rpM command ""
bindkey -M command "^[" send-break    # Esc
bindkey -M command "^M" accept-line   # Enter

# Normal mode
bindkey -rpM vicmd ""
bindkey -M vicmd "^W"        backward-delete-word
bindkey -M vicmd "^L"        qc-clear-screen
bindkey -M vicmd "^M"        accept-line
bindkey -M vicmd "k"         up-line
bindkey -M vicmd "j"         down-line
bindkey -M vicmd "h"         vi-backward-char
bindkey -M vicmd "H"         vi-first-non-blank
bindkey -M vicmd "^H"        vi-insert-bol
bindkey -M vicmd "l"         vi-forward-char
bindkey -M vicmd "L"         vi-end-of-line
bindkey -M vicmd "^[[105;5u" vi-add-eol         # Ctrl+i in CSI u, configured in kitty.conf and tmux.conf both
bindkey -M vicmd "^[[44;5u"  edit-command-line  # Ctrl+, in CSI u, configured in kitty.conf and tmux.conf both

bindkey -M vicmd "b" vi-backward-word
bindkey -M vicmd "B" vi-backward-blank-word
bindkey -M vicmd "n" vi-forward-word-end
bindkey -M vicmd "N" vi-forward-blank-word-end
bindkey -M vicmd "w" vi-forward-word
bindkey -M vicmd "W" vi-forward-blank-word
bindkey -M vicmd "a" vi-add-next
bindkey -M vicmd "A" vi-add-eol
bindkey -M vicmd "i" vi-insert
bindkey -M vicmd "I" vi-insert-bol
bindkey -M vicmd "m" vi-open-line-below
bindkey -M vicmd "M" vi-open-line-above

bindkey -M vicmd "d" vi-delete
bindkey -M vicmd "D" vi-kill-eol
bindkey -M vicmd "c" vi-change
bindkey -M vicmd "C" vi-change-eol
bindkey -M vicmd "x" vi-delete-char
bindkey -M vicmd "X" vi-backward-delete-char
bindkey -M vicmd "r" vi-replace-chars
bindkey -M vicmd "R" vi-replace

bindkey -M vicmd "y" vi-yank-wrapped
bindkey -M vicmd "Y" vi-yank-wrapped
bindkey -M vicmd "p" vi-put-after
bindkey -M vicmd "P" vi-put-before

bindkey -M vicmd "v" visual-mode
bindkey -M vicmd "V" visual-line-mode
bindkey -M vicmd "u" undo
bindkey -M vicmd "U" redo

# bindkey -M vicmd ";"  execute-named-cmd
bindkey -M vicmd "."  vi-repeat-change
bindkey -M vicmd ","  edit-command-line
bindkey -M vicmd "\-" vi-repeat-search
bindkey -M vicmd "="  vi-rev-repeat-search

bindkey -M vicmd "0"-"9" digit-argument
bindkey -M vicmd "<"     vi-unindent
bindkey -M vicmd ">"     vi-indent
bindkey -M vicmd "J"     vi-join

bindkey -M vicmd "gk" vi-down-case
bindkey -M vicmd "gK" vi-up-case
bindkey -M vicmd "gs" vi-swap-case
bindkey -M vicmd "gj" vi-backward-word-end
bindkey -M vicmd "gJ" vi-backward-blank-word-end
bindkey -M vicmd "gg" beginning-of-buffer-or-history
bindkey -M vicmd "fb" vi-match-bracket

# Insert mode
bindkey -M viins "^?"        backward-delete-char  # Backspace
bindkey -M viins "^W"        backward-delete-word
bindkey -M viins "^H"        vi-insert-bol
bindkey -M viins "^[[105;5u" vi-add-eol            # Ctrl+i in CSI u, configured in kitty.conf
bindkey -M viins "^[[44;5u"  edit-command-line     # Ctrl+, in CSI u, configured in kitty.conf and tmux.conf both

# Visual mode
bindkey -rpM visual ""
bindkey -M visual "^["   deactivate-region  # Esc
bindkey -M visual "k"    up-line
bindkey -M visual "j"    down-line
bindkey -M visual "aw"   select-a-word
bindkey -M visual "aW"   select-a-blank-word
bindkey -M visual "aa"   select-a-shell-word
bindkey -M visual "iw"   select-in-word
bindkey -M visual "iW"   select-in-blank-word
bindkey -M visual "ii"   select-in-shell-word
bindkey -M visual "x"    vi-delete
bindkey -M visual "p"    put-replace-selection

# Operator pending mode
bindkey -rpM viopp ""
bindkey -M viopp "^[" vi-cmd-mode
bindkey -M viopp "k"  up-line
bindkey -M viopp "j"  down-line
bindkey -M viopp "aw" select-a-word
bindkey -M viopp "aW" select-a-blank-word
bindkey -M viopp "aa" select-a-shell-word
bindkey -M viopp "iw" select-in-word
bindkey -M viopp "iW" select-in-blank-word
bindkey -M viopp "ii" select-in-shell-word

