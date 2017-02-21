sudo add-apt-repository 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main'

sudo apt update
sudo apt upgrade
sudo apt install -y \
	git \
	awesome \
	zsh \
	vim-gnome \
	mercurial \
    cmake \
    python-dev \
    python3-dev \
    clang-4.0 \
    libclang-4.0

	#vim-youcompleteme   # If this is installed with apt-get, it will install the version that requires clang-3.9+ but 
                         # that has clang-3.8 listed as a required dependency. Not sure what happened there. 

# NOTE: clang-4.0 is included here due to the most up-to-date version of YouCompleteMe available 
# for Ubuntu 16.04 requires clang-3.9 or later. The clang repository added earlier throws up a 
# bunch of unsigned repo warnings, but that repo is in fact the official way to install a later 
# libclang than Ubuntu's suggested version, so no worries.

#vam install youcompleteme

curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

CONFIG_DIR="~/repos/linux-config"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "source $CONFIG_DIR/.bashrc" >> ~/.bashrc
echo "PATH=$PATH:~/bin" >> ~/.bashrc
mkdir ~/bin
ln -s $CONFIG_DIR/glmb.sh ~/bin/glmb

echo "export ZSH=~/.oh-my-zsh" >> ~/.zshrc
echo "source $CONFIG_DIR/.zshrc" >> ~/.zshrc

mkdir ~/.vim
mkdir ~/.vim/{bundle,autoload,swaps,backups}
echo "source $CONFIG_DIR/.vimrc" >> ~/.vimrc
echo "set backup" >> ~/.vimrc
echo "set backupdir=~/.vim/backups" >> ~/.vimrc
echo "set dir=~/.vim/swaps" >> ~/.vimrc

echo "set keymap vi" >> ~/.inputrc
echo "set editing-mode vi" >> ~/.inputrc
echo "set bind-tty-special-chars off" >> ~/.inputrc

DIR=~/repos/vim
mkdir $DIR
cd $DIR

git clone https://github.com/tpope/vim-pathogen.git
ln -s $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

git clone https://github.com/milkypostman/vim-togglelist
ln -s $DIR/vim-togglelist ~/.vim/bundle/

git clone https://github.com/esquires/lvdb
ln -s $DIR/lvdb ~/.vim/bundle/

git clone https://github.com/esquires/tabcity
ln -s $DIR/tabcity ~/.vim/bundle

git clone https://github.com/esquires/vim-map-medley
ln -s $DIR/vim-map-medley ~/.vim/bundle/

git clone https://github.com/scrooloose/syntastic.git
ln -s $DIR/syntastic ~/.vim/bundle

hg clone https://bitbucket.org/ns9tks/vim-l9
ln -s $DIR/vim-l9 ~/.vim/bundle

hg clone https://bitbucket.org/ns9tks/vim-fuzzyfinder
ln -s $DIR/vim-fuzzyfinder ~/.vim/bundle

git clone https://github.com/derekwyatt/vim-fswitch.git
ln -s $DIR/vim-fswitch ~/.vim/bundle

# The next few lines, which install YouCompleteMe from source, assume
# that the version of vim installed was compiled to use python3, not python2.
git clone https://github.com/Valloric/YouCompleteMe.git
ln -s $DIR/vim-YouCompleteMe ~/.vim/bundle
cd YouCompleteMe
git submodule update --init --recursive
mkdir $HOME/ycm_build && cd $HOME/ycm_build # this is where our cmake-related files will go
# This should generate CMake files for clang-4.0 installed in default directory
# and for Vim compiled to use Python3 (since YCM has to use the same Python version)
cmake -G "Unix Makefiles" -DEXTERNAL_LIBCLANG_PATH=/usr/lib/x86_64-linux-gnu/libclang-4.0.so -DUSE_PYTHON2=OFF . $DIR/YouCompleteMe/third_party/ycmd/cpp 
# Now build YCM
cmake --build . --target ycm_core --config Release

# This may not be necessary, but let's cd back to the directory we ran this script from
cd $DIR

sudo chsh -s /usr/bin/zsh $USER


