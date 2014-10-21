export ZSH=~/.oh-my-zsh
plugins=(
  git
  command-not-found 
  wd
  history-substring-search
  last-working-dir)
ZSH_THEME="miloshadzic"
CASE_SENSITIVE="true"

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

# need this before source $ZSH/oh-my-zsh.sh in order to make it quit asking if I want to update
DISABLE_AUTO_UPDATE="true"
source $ZSH/oh-my-zsh.sh # this has to go after the theme

# Unify HOST and HOSTNAME
export HOSTNAME=$HOST

setopt sharehistory
setopt extendedhistory

export EDITOR=nvim

bindkey -v

function abcdefg {
    up-history 
    vi-cmd-mode
}

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward
bindkey '^u' backward-kill-line

# http://dougblack.io/words/zsh-vi-mode.html
# http://stackoverflow.com/a/3791786
function zle-line-init zle-keymap-select zle-history-line-set {
    VIM_NORMAL="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    VIM_INSERT="%{$fg_bold[green]%} [% INSERT]% %{$reset_color%}"
    # Per http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html,
    # I should be able to get visual and operation-pending modes, but haven't figured out the details yet
    # VIM_VISUAL="%{$fg_bold[orange]%} [% VISUAL]% %{$reset_color%}" # want this to do visual
    # VIM_OP_PENDING="%{$fg_bold[pink]%} [% PEND]% %{$reset_color%}" # want this to do viopp
    RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-history-line-set
export KEYTIMEOUT=1

# Put the time previous command executed on first line of prompt,
# then show status info, path, and allow new command input on next line
# (adapted from af-magic theme)
PROMPT='%{$FG[237]%}[%D{%Y-%m-%d} %*] ------------------------------------------------------------%{$reset_color%}
%{$FG[032]%}'$PROMPT

# From https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history/691603#691603
# Up and down keys scroll through terminal's local history
# ctrl-up/down go through global history
# With the rest of my config, this just kills global history. Apparently a conflict somewhere?
# bindkey "[1;5A" up-line-or-history    # [CTRL] + Cursor up
# bindkey "[1;5B" down-line-or-history  # [CTRL] + Cursor down

# bindkey "OA" up-line-or-local-history # up arrow, replaced ${key[Up]}
# bindkey "OB" down-line-or-local-history # down arrow, replaced ${key[Down]}

# up-line-or-local-history() {
    # zle set-local-history 1
    # zle up-line-or-history
    # zle set-local-history 0
# }
# zle -N up-line-or-local-history
# down-line-or-local-history() {
    # zle set-local-history 1
    # zle down-line-or-history
    # zle set-local-history 0
# }
# zle -N down-line-or-local-history

#git aliases
alias gs='git status'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gm='git merge'
alias gms='git merge -S'
alias ga='git add'
alias gcm='git commit'
alias gcms='git commit -S'
alias gco='git checkout'
alias gd='git difftool -y 2> /dev/null'
alias gb='git branch'
alias gba='git branch -a'
alias gh='git help'
alias gl='git log --pretty=format:"%C(yellow)%h %ad %Creset%s %C(red)%d %Cgreen[%an] %Creset" --decorate --date=short -10 --graph'
alias gu='git unstage'
compdef __git_branch_names glmb

#other aliases
alias grep='grep --color=auto'
alias find1='find -maxdepth 1 -mindepth 1'
alias CLR='for i in {1..99}; do echo; done; clear'

function git_pull_dirs {

    TEMP_OLDPWD=$OLDPWD

    for d in $(dirname $(find -name "\.git")); do
        cd $d
        git pull
        cd $OLDPWD
    done

    OLDPWD=$TEMP_OLDPWD

}

alias ld="git-latexdiff --quiet --ignore-latex-errors --bibtex --latexpand --makeatletter "
alias vim="nvim"
alias gvim="gnome-terminal -- nvim -p"
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
#see here: http://travisjeffery.com/b/2012/02/search-a-git-repo-like-a-ninja
git config --global grep.extendRegexp true
git config --global grep.lineNumber true
git config --global alias.g "grep --break --heading --line-number"
git config --global core.editor nvim
git config --global merge.tool nvimdiff
git config --global color.ui true
#git config --global core.whitespace trailing-space, space-before-tab


#stuff whose error I don't want to see
alias g='gnome-open 2>/dev/null'
alias evince='evince 2>/dev/null'

if [ -f ${HOME}/repos/linux-config/.zsh_aliases ]; then
    source ${HOME}/repos/linux-config/.zsh_aliases
fi

#other aliases and environment variables
if [ -f ${HOME}/.zsh_specific ]; then
    source ${HOME}/.zsh_specific
fi

# From comment on this article, how to properly set TERM:
# http://vim.wikia.com/wiki/256_colors_in_vim
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
            "XTerm(256)") TERM="xterm-256color" ;;
            "XTerm(88)") TERM="xterm-88color" ;;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="gnome-256color"
                COLORTERM="truecolor"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                ;;
        esac
    fi
fi
SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
            export TERM=screen-bce
            ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
            export TERM=xterm-88color
            ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
            export TERM=xterm-256color
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            echo "Unknown terminal $TERM. Falling back to 'xterm'."
            export TERM=xterm
            ;;
        rxvt*)
            echo "Unknown terminal $TERM. Falling back to 'rxvt'."
            export TERM=rxvt
            ;;
        screen*)
            echo "Unknown terminal $TERM. Falling back to 'screen'."
            export TERM=screen
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi

COLORTERM="truecolor"
