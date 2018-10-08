#!/usr/bin/env bash

PATCH=$PWD/patches/0001-open-tag-in-reverse_goto-when-indicated-by-switchbuf.patch
sudo apt update
sudo apt -y upgrade
sudo apt install -y \
    aptitude \
    awesome \
    ccache \
    cmake-curses-gui \
    curl \
    exuberant-ctags \
    flake8 \
    flawfinder \
    git \
    global \
    gnome-terminal \
    htop \
    ipython \
    ipython3 \
    libnotify-dev \
    mercurial \
    ninja-build \
    ntp \
    pcmanfm \
    python-dev \
    python3-dev \
    python-ipdb \
    python3-ipdb \
    python-pip \
    python3-pip \
    software-properties-common \
    terminator \
    xclip \
    zathura \
    zsh

curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

sudo python3 -m pip install matplotlib numpy pandas scipy jupyter

CONFIG_DIR="/home/$USER/repos/linux-config"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "source $CONFIG_DIR/.bashrc" >> ~/.bashrc
echo "PATH=$PATH:~/bin" >> ~/.bashrc
mkdir -p ~/bin
ln -v -s $CONFIG_DIR/glmb.sh /home/$USER/bin/glmb
ln -v -s $CONFIG_DIR/cpp_static_wrapper.py /home/$USER/bin
ln -v -s $CONFIG_DIR/cmd_monitor.py /home/$USER/bin/cmd_monitor

echo "export ZSH=~/.oh-my-zsh" >> ~/.zshrc
echo "source ${CONFIG_DIR}/.zshrc" >> ~/.zshrc

DOTVIM=${HOME}/.vim
VIMRC=${HOME}/.vimrc
INPUTRC=${HOME}/.inputrc

mkdir -p ${DOTVIM} 
mkdir -p ${DOTVIM}/{bundle,autoload,swaps,backups}

chown -R ${ME}:${ME} ${DOTVIM}

echo "source ${CONFIG_DIR}/.vimrc" >> ${VIMRC}
echo "set backup" >> ${VIMRC}
echo "set backupdir=${DOTVIM}/backups" >> ${VIMRC}
echo "set dir=${DOTVIM}/swaps" >> ${VIMRC}

echo "set keymap vi" >> ${INPUTRC}
echo "set editing-mode vi" >> ${INPUTRC}
echo "set bind-tty-special-chars off" >> ${INPUTRC}

VIMREPODIR=${HOME}/repos/vim
mkdir -p ${VIMREPODIR}
chown -R ${ME}:${ME} ${VIMREPODIR}
pushd ${VIMREPODIR}

#THEURL=https://github.com/scrooloose/syntastic.git
#REPONAME=syntastic
#clone_or_pull
#ln -sfn ${VIMREPODIR}/syntastic ${DOTVIM}/bundle/

mkdir -p ~/repos
cd ~/repos
sudo apt install -y libnotify-dev libgtk-3-dev
git clone https://github.com/valr/cbatticon.git
git pull
cd cbatticon
git pull
make PREFIX=/usr/local
sudo make PREFIX=/usr/local install

VIMREPODIR=~/repos/vim
BUNDLE_DIR=~/.vim/bundle
mkdir -p $VIMREPODIR
cd $VIMREPODIR

function add_vim_repo {
    NAME=$(echo $1 | rev | cut -d '/' -f 1 | rev)
    cd $VIMREPODIR
    git clone $1 $NAME
    cd $VIMREPODIR/$NAME
    pwd
    git pull
    ln -s $VIMREPODIR/$NAME $BUNDLE_DIR
    echo "Added repo ${NAME}"; }

git clone https://github.com/tpope/vim-pathogen.git
cd vim-pathogen
git pull
mkdir -p ~/.vim/autoload
ln -s $VIMREPODIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

echo "Adding vim repos"
add_vim_repo 'https://github.com/milkypostman/vim-togglelist'
add_vim_repo 'https://github.com/esquires/lvdb'
add_vim_repo 'https://github.com/Shougo/deoplete.nvim'
add_vim_repo 'https://github.com/neomake/neomake'
add_vim_repo 'https://github.com/tpope/vim-fugitive'
add_vim_repo 'https://github.com/esquires/tabcity'
add_vim_repo 'https://github.com/esquires/vim-map-medley'
add_vim_repo 'https://github.com/ctrlpvim/ctrlp.vim'
add_vim_repo 'https://github.com/majutsushi/tagbar'
add_vim_repo 'https://github.com/tmhedberg/SimpylFold'
add_vim_repo 'https://github.com/ludovicchabant/vim-gutentags'
add_vim_repo 'https://github.com/tomtom/tcomment_vim.git'
add_vim_repo 'https://github.com/esquires/neosnippet-snippets'
add_vim_repo 'https://github.com/Shougo/neosnippet.vim.git'
add_vim_repo 'https://github.com/jlanzarotta/bufexplorer.git'
add_vim_repo 'https://github.com/lervag/vimtex'
add_vim_repo 'https://github.com/tpope/tpope-vim-abolish.git'
add_vim_repo 'https://github.com/tpope/vim-vinegar.git'
add_vim_repo 'https://github.com/wesQ3/vim-windowswap.git'
add_vim_repo 'https://github.com/vim-airline/vim-airline.git'
add_vim_repo 'https://github.com/vim-airline/vim-airline-themes.git'
add_vim_repo 'https://github.com/neutaaaaan/iosvkem.git'
# add_vim_repo 'https://github.com/inside/vim-search-pulse.git'
# The following enables a Pulse command and somehow hasn't been approved for merging
add_vim_repo 'https://github.com/iamFIREcracker/vim-search-pulse'

cd $VIMREPODIR/vimtex
git checkout master
git reset --hard origin/master
git am -3 $PATCH

#install neovim
cd ~/repos
sudo apt-get install -y libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python-pip python3-pip

sudo apt install -y python{,3}-flake8 pylint{,3}
touch ~/.pylintrc

sudo pip3 install neovim cpplint pydocstyle neovim-remote
git clone https://github.com/neovim/neovim.git
git fetch
cd neovim
git checkout origin/master # v0.2.2 has a lua build error. This is a later commit where the build worked but prior to v0.2.3 which has not been released yet
mkdir -p .deps
cd .deps && cmake ../third-party -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_BUILD_TYPE=Release && make
cd ..
mkdir -p build
cd build && cmake .. -G Ninja -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_BUILD_TYPE=Release && ninja &&  sudo ninja install

# mkdir -p -p ~/.config/nvim
# echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after
# let &packpath = &runtimepath
# set guicursor=
# source ~/.vimrc" > ~/.config/nvim/init.vim

echo "Now updating vi, vim, and editor commands to point to neovim"
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 60
sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/nvim 60
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 60

# cppcheck
cd ~/repos
git clone https://github.com/danmar/cppcheck
cd cppcheck
git pull
make -j $(($(nproc --all) - 1)) SRCDIR=build CFGDIR=/usr/local/share/cppcheck/cfg HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function -march=native"
sudo install cppcheck /usr/local/bin
sudo mkdir -p /usr/local/share/cppcheck/cfg -p
sudo install -D ./cfg/* /usr/local/share/cppcheck/cfg

# cppclean
cd ~/repos
git clone https://github.com/myint/cppclean.git
cd cppclean
git pull
sudo pip3 install -e .

# setup python (and setup vim bindings for the shell)
ipython profile create
sed -i "s/#\(c.TerminalInteractiveShell.editing_mode = \)'emacs'/\1 'vi'/" ~/.ipython/profile_default/ipython_config.py

cd ~/repos/vim/lvdb/python
sudo python setup.py develop
sudo python3 setup.py develop

#see here: http://travisjeffery.com/b/2012/02/search-a-git-repo-like-a-ninja
git config --global alias.unstage 'reset HEAD --'
git config --global --replace-all core.pager "less -F -X"
git config --global grep.extendRegexp true
git config --global grep.lineNumber true
git config --global alias.g "grep --break --heading --line-number"
git config --global core.editor nvim
git config --global merge.tool nvimdiff
git config --global color.ui true
#git config --global core.whitespace trailing-space, space-before-tab

# CodeChecker
sudo apt-get install clang build-essential curl doxygen gcc-multilib \
  git python-virtualenv python-dev thrift-compiler
cd ~/repos
git clone https://github.com/Ericsson/CodeChecker.git
cd CodeChecker
git pull
make venv

make package
echo 'export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin' >> ~/.zshrc
echo 'export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin' >> ~/.bashrc

ln -v -s $CONFIG_DIR/run_clang.py /home/$USER/bin/run_clang
