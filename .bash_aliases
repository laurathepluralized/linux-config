
## Source .bashrc
alias sbrc="source ~/.bashrc"
alias szrc="source ~/.zshrc"

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

## cd aliases
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
alias ......="cd ../../../../../"


