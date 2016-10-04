

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade

sudo apt-get install vim vim-gnome terminator synaptic

mkdir ~/.config/terminator
cp ./config ~/.config/terminator

if [ ! -f $HOME/.bash_aliases ]; 
    then cp ./.bash_aliases $HOME/.bash_aliases
    else cat ./.bash_aliases >> $HOME/.bash_aliases
fi
if [ ! -f $HOME/.zsh_aliases ]; 
    then cp ./.zsh_aliases $HOME/.zsh_aliases
    else cat ./.bash_aliases >> $HOME/.bash_aliases
fi

echo "source ~/linux-config/.vimrc" >> ~/.vimrc
echo "set backup" >> ~/.vimrc
echo "set backupdir=~/.vim/backups" >> ~/.vimrc
echo "set dir=~/.vim/swaps" >> ~/.vimrc

