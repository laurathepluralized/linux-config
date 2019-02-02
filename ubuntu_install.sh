
#!/usr/bin/env bash
sudo apt update
sudo apt -y upgrade
sudo apt install -y \
    acpi \
    aptitude \
    awesome \
    ccache \
    cmake \
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
    libgtk2.0-dev \
    libnotify-dev \
    libxdo3 \
    mercurial \
    ncurses-cmake-gui \
    ninja-build \
    notify-osd \
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
    xdotool \
    zathura \
    zsh
# installing xclip makes sure neovim enables the clipboard registers!

sudo apt-add-repository ppa:neovim-ppa/stable
sudo apt-get update && sudo apt-get install -y neovim

echo "Now updating vi, vim, and editor commands to point to neovim"

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
# next line just opens an interactive menu that allows user to choose from alternatives
# sudo update-alternatives --config vi 
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
# sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
# sudo update-alternatives --config editor
#
if [ ! -f ${HOME}/.config/nvim/init.vim ]; then
    echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" >> ~/.config/nvim/init.vim
    echo "let &packpath = &runtimepath" >> ~/.config/nvim/init.vim
    echo "set guicursor=" >> ~/.config/nvim/init.vim
    echo "source ~/.vimrc" >> ~/.config/nvim/init.vim
fi

sudo add-apt-repository 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main'
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
    #clang-4.0 clang-4.0-doc libclang-common-4.0-dev libclang-4.0-dev libclang1-4.0 libclang1-4.0-dbg libllvm-4.0-ocaml-dev libllvm4.0 libllvm4.0-dbg lldb-4.0 llvm-4.0 llvm-4.0-dev llvm-4.0-doc llvm-4.0-examples llvm-4.0-runtime clang-format-4.0 python-clang-4.0 lldb-4.0-dev lld-4.0 libfuzzer-4.0-dev libclang-4.0
yes | sudo apt-get update && sudo apt-get install libclang-4.0 libclang-4.0-dev liblldb-4.0 liblldb-4.0-dbg liblldb-4.0-dev
    #vim-youcompleteme   # If this is installed with apt or apt-get, it will install the version that requires clang-3.9+ but 
                         # that has clang-3.8 listed as a required dependency. Not sure what happened there. 

# NOTE: clang-4.0 is included here due to the most up-to-date version of YouCompleteMe available 
# for Ubuntu 16.04 requires clang-3.9 or later. The clang repository added earlier throws up a 
# bunch of unsigned repo warnings, but that repo is in fact the official way to install a later 
# libclang than Ubuntu's suggested version, so no worries.

CONFIG_DIR=${HOME}"/repos/linux-config"

curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

sudo python3 -m pip install matplotlib numpy pandas scipy jupyter

CONFIG_DIR="/home/$USER/repos/linux-config"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mkdir -p ~/bin
ln -v -s $CONFIG_DIR/glmb.sh /home/$USER/bin/glmb
ln -v -s $CONFIG_DIR/cpp_static_wrapper.py /home/$USER/bin
ln -v -s $CONFIG_DIR/cmd_monitor.py /home/$USER/bin/cmd_monitor

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
    # NAME=$(echo $1 | rev | cut -d '/' -f 1 | rev)
    NAME=$(basename $1 .git)
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
cd -

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
add_vim_repo 'https://github.com/vim-airline/vim-airline.git'
add_vim_repo 'https://github.com/vim-airline/vim-airline-themes.git'
add_vim_repo 'https://github.com/tpope/tpope-vim-abolish.git'
add_vim_repo 'https://github.com/tpope/vim-vinegar.git'
add_vim_repo 'https://github.com/wesQ3/vim-windowswap.git'
add_vim_repo 'https://github.com/neutaaaaan/iosvkem.git'
add_vim_repo 'https://github.com/vim-scripts/DoxygenToolkit.vim.git'
add_vim_repo 'https://github.com/inside/vim-search-pulse.git'
add_vim_repo 'https://github.com/inkarkat/vim-mark.git'
add_vim_repo 'https://github.com/vim-scripts/ingo-library.git'

# orgmode and its dependencies
add_vim_repo 'https://github.com/jceb/vim-orgmode'
add_vim_repo 'https://github.com/vim-scripts/utl.vim'
add_vim_repo 'https://github.com/tpope/vim-repeat'
add_vim_repo 'https://github.com/tpope/vim-speeddating'
add_vim_repo 'https://github.com/chrisbra/NrrwRgn'
add_vim_repo 'https://github.com/mattn/calendar-vim'
add_vim_repo 'https://github.com/inkarkat/vim-SyntaxRange'

cd $VIMREPODIR/vimtex
git checkout master
git reset --hard origin/master
PATCH=$CONFIG_DIR/patches/0001-open-tag-in-reverse_goto-when-indicated-by-switchbuf.patch
git am -m "[PATCH] open tag in reverse_goto when indicated by switchbuf" -3 $PATCH

cd $VIMREPODIR/iosvkem
git pull
mkdir -p ~/.vim/colors
ln -s $VIMREPODIR/iosvkem/colors/Iosvkem.vim ~/.vim/colors/Iosvkem.vim
cd -

#install neovim
cd ~/repos
sudo apt-get install -y libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python-pip python3-pip

sudo apt install -y python{,3}-flake8 pylint{,3}
touch ~/.pylintrc

sudo pip3 install neovim cpplint pydocstyle neovim-remote
git clone https://github.com/neovim/neovim.git neovim
git fetch
cd neovim
git checkout v0.3.0
mkdir -p .deps
cd .deps && cmake ../third-party -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_BUILD_TYPE=Release && make
cd ..
mkdir -p build
cd build && cmake .. -G Ninja -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_BUILD_TYPE=Release && ninja &&  sudo ninja install

mkdir -p ~/.config/nvim
echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set guicursor=
source ~/.vimrc" > ~/.config/nvim/init.vim

# echo "Now updating vi, vim, and editor commands to point to neovim"
# This used to work; not sure why I have to alias vim to nvim now
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 60
sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/nvim 60
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 60

sudo chsh -s /usr/bin/zsh $USER

# cppcheck
PATCH=$CONFIG_DIR/patches/0001-add-ccache.patch
cd ~/repos
git clone https://github.com/danmar/cppcheck
cd cppcheck
git pull
git reset --hard origin/master
echo
git am -3 $PATCH
mkdir -p build
cd build
cmake .. -G Ninja -DCMAKE_CXX_FLAGS=" -march=native " -DCMAKE_BUILD_TYPE=Release
ninja
sudo ninja install

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
git config --global alias.g "grep --break --heading --line-number"
git config --global alias.rbc 'rebase --continue'
git config --global alias.rbs 'rebase --continue'
git config --global alias.rgrep "grep --break --heading --line-number --recurse-submodules"
git config --global alias.unstage 'reset HEAD --'
git config --global color.ui true
git config --global core.attributesfile '~/.gitattributes_global'
git config --global core.editor nvim
git config --global --replace-all core.pager "less -F -X"
git config --global core.excludesfile '~/.gitignore-global'
git config --global credential.helper 'cache'
git config --global grep.extendRegexp true
git config --global grep.lineNumber true
git config --global merge.tool nvimdiff
git config --global push.default 'simple'
#git config --global core.whitespace trailing-space, space-before-tab

# git-latexdiff
sudo apt-get install asciidoc
cd ~/repos
git clone https://gitlab.com/git-latexdiff/git-latexdiff.git git-latexdiff
cd git-latexdiff
git pull
sed -i -E 's:^gitexecdir = \$\{shell git --man-path\}$:gitexecdir = /usr/bin:' Makefile
# the above sed command never actually winds up replacing anything, as of Nov. 30, 2018
sudo make install-bin
# make install-doc and make git-latexdiff.1 aren't working for me, so just installing bin
#
#

function add_awesome_repo {
    # NAME=$(echo $1 | rev | cut -d '/' -f 1 | rev)
    NAME=$(basename $1 .git)
    cd $AWESOMEREPODIR
    git clone $1 $NAME
    cd $AWESOMEREPODIR/$NAME
    pwd
    git pull
    ln -s $AWESOMEREPODIR/$NAME $AWESOMECONFIGDIR
    echo "Added repo ${NAME}"; }

AWESOMEREPODIR=~/repos/awesome
mkdir -p ${AWESOMEREPODIR}
AWESOMECONFIGDIR=~/.config/awesome
mkdir -p ${AWESOMECONFIGDIR}
cd ${AWESOMEREPODIR}
add_awesome_repo 'https://github.com/echuraev/keyboard_layout.git'

