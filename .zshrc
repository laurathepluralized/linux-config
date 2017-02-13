ZSH_THEME="miloshadzic" # my favorite
source $ZSH/oh-my-zsh.sh # this has to go after the theme
plugins=(git bundler osx rake ruby history-substring-search)
CASE_SENSITIVE="true"

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

setopt sharehistory
setopt extendedhistory

export EDITOR=vim

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
PROMPT='$FG[237][%*]------------------------------------------------------------%{$reset_color%}
$FG[032]'$PROMPT

#git aliases
alias gs='git status'
alias ggs='git status'
alias gf='git fetch'
alias gm='git merge'
alias gms='git merge -S'
alias ga='git add'
alias gcm='git commit'
alias gcms='git commit -S'
alias gco='git checkout'
alias gd='git difftool -y 2> /dev/null'
alias gb='git branch'
alias gh='git help'
alias gl='git log --pretty=format:"%C(yellow)%h %ad %Creset%s %C(red)%d %Cgreen[%an] %Creset" --decorate --date=short -10 --graph'
git config --global alias.unstage 'reset HEAD --'
git config --global --replace-all core.pager "less -F -X"
alias gu='git unstage'

#see here: http://travisjeffery.com/b/2012/02/search-a-git-repo-like-a-ninja
git config --global grep.extendRegexp true
git config --global grep.lineNumber true
git config --global alias.g "grep --break --heading --line-number"
git config --global core.editor vim
git config --global merge.tool vimdiff
git config --global color.ui true
#git config --global core.whitespace trailing-space, space-before-tab

#other aliases
alias grep='grep --color=auto'
alias find1='find -maxdepth 1 -mindepth 1'
alias CLR='for i in {1..99}; do echo; done; clear'

function git_fetch_dirs {

    TEMP_OLDPWD=$OLDPWD

    for d in $(dirname $(find -name "\.git")); do
        cd $d
        echo "fetching " $d
        git fetch
        cd $OLDPWD
    done

    OLDPWD=$TEMP_OLDPWD

}

#stuff whose error I don't want to see
alias gvim="gvim -p 2>/dev/null"
alias gvimdiff="gvimdiff 2> /dev/null"
alias g='gnome-open 2>/dev/null'
