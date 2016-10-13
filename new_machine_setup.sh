
# apt-get
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade

# install the essential utilities
sudo apt-get install vim vim-gnome terminator git meld synaptic zsh zsh-common mercurial

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

if [ ! -f $HOME/.inputrc ];
    then cp ./.inputrc $HOME/.inputrc
    else cat ./.inputrc >> $HOME/.inputrc
fi

echo "source ~/linux-config/.vimrc" >> ~/.vimrc
mkdir -p $HOME/.vim/
mkdir -p $HOME/.vim/backups
mkdir -p $HOME/.vim/swaps
echo "set backup" >> ~/.vimrc
echo "set backupdir=~/.vim/backups" >> ~/.vimrc
echo "set dir=~/.vim/swaps" >> ~/.vimrc


### vim plugins
mkdir -p $HOME/vim_plugins
DIR=$HOME/vim_plugins/
mkdir -p $HOME/.vim/autoload
mkdir -p $HOME/.vim/bundle

#pathogen:

    git clone https://github.com/tpope/vim-pathogen.git
    ln -sf $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

#togglelist:

    git clone https://github.com/milkypostman/vim-togglelist
    ln -sf $DIR/vim-togglelist ~/.vim/bundle/

#lvdb:

    git clone https://github.com/esquires/lvdb
    ln -sf $DIR/lvdb ~/.vim/bundle/

#tabcity:
    git clone https://github.com/esquires/tabcity
    ln -sf $DIR/tabcity ~/.vim/bundle

#vim-map-medley:

    git clone https://github.com/esquires/vim-map-medley
    ln -sf $DIR/vim-map-medley ~/.vim/bundle/

#syntastic:

    git clone https://github.com/scrooloose/syntastic.git
    ln -sf $DIR/syntastic ~/.vim/bundle

#vim-l9:
    # installed as a dependency for vim-fuzzyfinder
    hg clone https://bitbucket.org/ns9tks/vim-l9
    ln -sf $DIR/vim-l9 ~/.vim/bundle

#vim-fuzzyfinder:
    hg clone https://bitbucket.org/ns9tks/vim-fuzzyfinder
    ln -sf $DIR/vim-fuzzyfinder ~/.vim/bundle

#youcompleteme:
    # this is in the ubuntu packages under `vim-youcompleteme` or
    # arch linux in the aur
    # for ubuntu, do 
    sudo apt install vim-youcompleteme && vam install youcompleteme
    # vam = vim addons manager


source ~/.zshrc
