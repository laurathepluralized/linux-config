
# apt-get
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade

# install the essential utilities
sudo apt-get install vim vim-gnome terminator synaptic zsh zsh-common

mkdir -p ~/.config/terminator
cp ./config ~/.config/terminator

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cp ~/linux-config/.zshrc ~/.zshrc

if [ ! -f $HOME/.bash_aliases ]; 
    then cp ./.bash_aliases $HOME/.bash_aliases
    else cat ./.bash_aliases >> $HOME/.bash_aliases
fi
if [ ! -f $HOME/.zsh_aliases ]; 
    then cp ./.zsh_aliases $HOME/.zsh_aliases
    else cat ./.bash_aliases >> $HOME/.bash_aliases
fi

echo "source ~/linux-config/.vimrc" >> ~/.vimrc
mkdir -p $HOME/.vim/
mkdir -p $HOME/.vim/backups
mkdir -p $HOME/.vim/swaps
echo "set backup" >> ~/.vimrc
echo "set backupdir=~/.vim/backups" >> ~/.vimrc
echo "set dir=~/.vim/swaps" >> ~/.vimrc

