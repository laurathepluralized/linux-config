#!/bin/bash
#
# Usage: bash ubuntu_install.sh

# Borrowing technique from here for checking for rootness
# http://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script/21622456#21622456
# The sudo method they suggest may also be useful
if (( $EUID == 0 ))
    then echo "Please do not run this script as root"
    exit
else
    ME=`(whoami)`
    echo "Current user is ${ME}"
fi

sudo apt update
sudo apt upgrade
sudo apt install -y \
	awesome \
    cmake \
    curl \
    exuberant-ctags \
	git \
    global \
    htop \
    ipython \
    libgtk2.0-dev \
    libnotify-dev \
	mercurial \
    ncurses-cmake-gui \
    pcmanfm \
    python-dev \
    python3-dev \
    python-ipdb \
    terminator \
	vim-gnome \
	zsh

sudo add-apt-repository 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main'
    #clang-4.0 clang-4.0-doc libclang-common-4.0-dev libclang-4.0-dev libclang1-4.0 libclang1-4.0-dbg libllvm-4.0-ocaml-dev libllvm4.0 libllvm4.0-dbg lldb-4.0 llvm-4.0 llvm-4.0-dev llvm-4.0-doc llvm-4.0-examples llvm-4.0-runtime clang-format-4.0 python-clang-4.0 lldb-4.0-dev lld-4.0 libfuzzer-4.0-dev libclang-4.0
yes | sudo apt-get update && sudo apt-get install libclang-4.0 libclang-4.0-dev liblldb-4.0 liblldb-4.0-dbg liblldb-4.0-dev
	#vim-youcompleteme   # If this is installed with apt or apt-get, it will install the version that requires clang-3.9+ but 
                         # that has clang-3.8 listed as a required dependency. Not sure what happened there. 

# NOTE: clang-4.0 is included here due to the most up-to-date version of YouCompleteMe available 
# for Ubuntu 16.04 requires clang-3.9 or later. The clang repository added earlier throws up a 
# bunch of unsigned repo warnings, but that repo is in fact the official way to install a later 
# libclang than Ubuntu's suggested version, so no worries.
# TODO: actually download the correct key to verify clang-4.0 and related packages

CONFIG_DIR="~/repos/linux-config"

if [ ! sudo python3 -m pip install --user powerline-status ]; then
    # we're just going to do pretty much every font installation procedure powerline offers
    pushd ${CONFIG_DIR} && \
        git clone https://github.com/powerline/fonts.git --depth=1 \
        && pushd fonts \
        && ./install.sh \
        && popd && popd

    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
    FONTPATH=/usr/share/fonts/X11/misc/PowerlineSymbols.otf
    sudo mv PowerlineSymbols.otf ${FONTPATH}
    sudo fc-cache -vf ${FONTPATH}
    FONTCONFIGPATH=~/.config/fontconfig/conf.d
    mkdir -p ${FONTCONFIGPATH}
    mv 10-powerline-symbols.conf ${FONTCONFIGPATH}
    echo "For powerline's symbols to work correctly, restart x once this script finishes."
    sudo ln -s ${CONFIG_DIR}/laura_awesome /usr/share/awesome/themes/laura_awesome
    sudo mv /usr/local/lib/python3.5/dist-packages/powerline/config_fiiles/themes/wm/default.json /usr/local/lib/python3.5/dist-packages/powerline/config_fiiles/themes/wm/default.old
    sudo ln -s ${CONFIG_DIR}/powerline_wm_default.json /usr/local/lib/python3.5/dist-packages/powerline/config_fiiles/themes/wm/default.json
else
    echo "powerline already installed, so assuming fonts and themes are already configured"
fi

curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "source ${CONFIG_DIR}/.bashrc" >> ~/.bashrc
echo "PATH=${PATH}:~/bin" >> ~/.bashrc
mkdir ~/bin
ln -s ${CONFIG_DIR}/glmb.sh ~/bin/glmb

echo "export ZSH=~/.oh-my-zsh" >> ~/.zshrc
echo "source ${CONFIG_DIR}/.zshrc" >> ~/.zshrc

mkdir ~/.vim 
mkdir ~/.vim/{bundle,autoload,swaps,backups}

chown -R ${ME}:${ME} ~/.vim

echo "source ${CONFIG_DIR}/.vimrc" >> ~/.vimrc
echo "set backup" >> ~/.vimrc
echo "set backupdir=~/.vim/backups" >> ~/.vimrc
echo "set dir=~/.vim/swaps" >> ~/.vimrc

echo "set keymap vi" >> ~/.inputrc
echo "set editing-mode vi" >> ~/.inputrc
echo "set bind-tty-special-chars off" >> ~/.inputrc

DIR=~/repos/vim
mkdir ${DIR}
chown -R ${ME}:${ME} $DIR
pushd $DIR

if [ ! git clone https://github.com/tpope/vim-pathogen.git ]; then
    pushd vim-pathogen && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
fi

if [ ! git clone https://github.com/milkypostman/vim-togglelist ]; then
    pushd vim-togglelist && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/vim-togglelist ~/.vim/bundle/
fi

if [ ! git clone https://github.com/esquires/lvdb ]; then
    pushd lvdb && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/lvdb ~/.vim/bundle/
fi

if [ ! git clone https://github.com/esquires/tabcity ]; then
    pushd tabcity && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/tabcity ~/.vim/bundle
fi

if [ ! git clone https://github.com/esquires/vim-map-medley ]; then
    pushd vim-map-medley && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/vim-map-medley ~/.vim/bundle/
fi

# if [ ! git clone https://github.com/scrooloose/syntastic.git ]; then
    # pushd syntastic.git && git stash && git pull origin master && git stash apply
    # popd
# else
    # ln -s $DIR/syntastic ~/.vim/bundle
# fi

if [ ! git clone https://github.com/scrooloose/syntastic.git ]; then
    pushd syntastic && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/syntastic ~/.vim/bundle
fi

if [ ! git clone https://github.com/ctrlpvim/ctrlp.vim.git ]; then
    pushd ctrlp.vim && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/ctrlp.vim ~/.vim/bundle
fi

# if [ ! git clone https://github.com/derekwyatt/vim-fswitch.git ]; then
    # pushd vim-fswitch && git stash && git pull origin master && git stash apply
    # popd
# else
    # ln -s $DIR/vim-fswitch ~/.vim/bundle
# fi

# From https://superuser.com/questions/219009/how-do-i-move-around-and-otherwise-rearrange-splits-in-vim
if [ ! git clone https://github.com/wesQ3/vim-windowswap.git ]; then
    pushd vim-windowswap && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/vim-windowswap ~/.vim/bundle
fi

if [ ! git clone https://github.com/scrooloose/nerdcommenter.git ]; then
    pushd nerdcommenter && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/nerdcommenter ~/.vim/bundle
fi

if [ ! git clone https://github.com/jsfaint/gen_tags.vim.git ]; then
    pushd gen_tags.vim && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/gen_tags.vim ~/.vim/bundle
fi

if [ ! git clone https://github.com/tpope/tpope-vim-abolish.git ]; then
    pushd tpope-vim-abolish && git stash && git pull origin master && git stash apply
    popd
else
    ln -s $DIR/tpope-vim-abolish ~/.vim/bundle
fi

# Install my colorschemes
sudo ln -s ${CONFIG_DIR}/laura.vim /usr/share/vim/vim74/colors/laura.vim
sudo ln -s ${CONFIG_DIR}/laura_light.vim /usr/share/vim/vim74/colors/laura_light.vim

# # The next few lines, which install YouCompleteMe from source, assume
# # that the version of vim installed was compiled to use python3, not python2.
if [ ! git clone https://github.com/Valloric/YouCompleteMe.git ]; then
    ln -s $DIR/vim-YouCompleteMe ~/.vim/bundle
    # Make sure we own all the stuff in $DIR
    chown -R ${ME}:${ME} ${DIR}
    pushd ${DIR}
    pushd YouCompleteMe
    git submodule update --init --recursive

    # this is where YouCompleteMe's build files will go
    mkdir ${HOME}/ycm_build && pushd ${HOME}/ycm_build
    chown -R ${ME}:${ME} ${HOME}/ycm_build

    # This should generate CMake files for clang-4.0 installed in default directory
    # and for Vim compiled to use Python3 (since YCM has to use the same Python version Vim does)
    cmake -G "Unix Makefiles" -DEXTERNAL_LIBCLANG_PATH=/usr/lib/x86_64-linux-gnu/libclang-4.0.so -DUSE_PYTHON2=OFF . $DIR/YouCompleteMe/third_party/ycmd/cpp

    # Now build YCM
    cmake --build . --target ycm_core --config Release

    # go back to original directory
    popd
    popd
    popd
fi

popd

echo "Now changing the following user's default shell to zsh:"
echo ${ME}

sudo chsh -s /usr/bin/zsh ${ME}

