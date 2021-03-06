


## Frequently-used directories:

## vim aliases:
alias svim="sudo vim"

## Source .bashrc
alias sbrc="source ~/.bashrc"
alias szrc="source ~/.zshrc"
alias zshrc="sudo vim ~/.zshrc && source ~/.zshrc"
alias bashrc="sudo vim ~/.bashrc && source ~/.bashrc"

## aliases aliases
alias aliasedit="svim ~/.bash_aliases && source ~/.bashrc"
alias aliases="svim ~/.bash_aliases && source ~/.bashrc"

## ls aliases and colorization
# Dont show . or .., but show hidden files.
alias lsa="ls --color=always -A"
# Show hidden files except .. and ., and show in column format with human-readable sizes.
alias lsl="ls --color=always -lhA"
alias ll="ls --color=always -lhA"
alias lf="ls --color=always -lhA"
# Like ls -lhA, but sorted by modification time.
alias lt="ls --color=always -lhAt"
# Like ls -lhA, but sorted by file extension.
alias lsx="ls --color=always -lhAX"
# Like ls -lhA, but sorted by file size.
alias lss="ls --color=always -lhAS"

## Grep colorization
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

## Apt-get update and upgrade
alias updall="sudo apt-get update && sudo apt-get upgrade"
alias dupdall="sudo apt-get update && sudo apt-get dist-upgrade"
alias uuu="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade"

## cd aliases
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
alias ......="cd ../../../../../"

## git aliases
alias gitkhere="gitk --all &"

# Do a git diff with meld on current file and its most recent commit
# Syntax: gd <filename> (Bug Kyle in old lab if this still doesn't work)
gd()
{
    yes | git difftool -t meld $1;
}

# Take everything in the current directory (not children) that matches the gitignore and remove it from the repo's cache. From http://stackoverflow.com/a/3262033
alias gnuke="(GIT_INDEX_FILE=some-non-existent-file  git ls-files --exclude-standard --others --directory --ignored -z) | xargs -0 git rm --cached -r --ignore-unmatch --"

## Take screenshot of area of screen
alias ssa="gnome-screenshot -a"

