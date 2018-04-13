#!/bin/bash
#
# Usage: bash ubuntu_install.sh

clone_or_pull () {
    # THEURL is assumed to be the git url
    # REPONAME is name of repo
    # DIR is dir repos are contained in
    
    CURRENT_DIRECTORY=$(pwd)
    if cd ${DIR}/${REPONAME}; then
        git pull;
    else
        git clone ${THEURL} ${DIR}/${REPONAME};
    fi
    cd ${CURRENT_DIRECTORY}

    return 0
}

hg_clone_or_pull () {
    # THEURL is assumed to be the git url
    # REPONAME is name of repo
    # DIR is dir repos are contained in
    
    CURRENT_DIRECTORY=$(pwd)
    if cd ${DIR}/${REPONAME}; then
        hg pull;
    else
        hg clone ${THEURL} ${DIR}/${REPONAME};
    fi
    cd ${CURRENT_DIRECTORY}

    return 0
}

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

### TODO: Fix checking whether powerline is installed, or add command-line arg for whether 
#to do powerline font installation and such
# if [ ! sudo python3 -m pip install --user powerline-status ]; then
#     # we're just going to do pretty much every font installation procedure powerline offers
#     pushd ${CONFIG_DIR} && \
#         git clone https://github.com/powerline/fonts.git --depth=1 \
#         && pushd fonts \
#         && ./install.sh \
#         && popd && popd
# 
#     wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
#     wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
#     FONTPATH=/usr/share/fonts/X11/misc/PowerlineSymbols.otf
#     sudo mv PowerlineSymbols.otf ${FONTPATH}
#     sudo fc-cache -vf ${FONTPATH}
#     FONTCONFIGPATH=~/.config/fontconfig/conf.d
#     mkdir -p ${FONTCONFIGPATH}
#     mv 10-powerline-symbols.conf ${FONTCONFIGPATH}
#     echo "For powerline's symbols to work correctly, restart x once this script finishes."
#     sudo ln -sfn ${CONFIG_DIR}/laura_awesome /usr/share/awesome/themes/laura_awesome
#     sudo mv /usr/local/lib/python3.5/dist-packages/powerline/config_fiiles/themes/wm/default.json /usr/local/lib/python3.5/dist-packages/powerline/config_fiiles/themes/wm/default.old
#     sudo ln -sfn ${CONFIG_DIR}/powerline_wm_default.json /usr/local/lib/python3.5/dist-packages/powerline/config_fiiles/themes/wm/default.json
# else
#     echo "powerline already installed, so assuming fonts and themes are already configured"
# fi

curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "source ${CONFIG_DIR}/.bashrc" >> ~/.bashrc
echo "PATH=${PATH}:~/bin" >> ~/.bashrc
mkdir -p ~/bin
ln -sfn ${CONFIG_DIR}/glmb.sh ~/bin/glmb

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

DIR=${HOME}/repos/vim
mkdir -p ${DIR}
chown -R ${ME}:${ME} ${DIR}
pushd ${DIR}

THEURL=https://github.com/tpope/vim-pathogen.git
REPONAME=vim-pathogen
clone_or_pull
ln -sfn ${DIR}/vim-pathogen/autoload/pathogen.vim ${DOTVIM}/autoload/pathogen.vim

THEURL=https://github.com/milkypostman/vim-togglelist
REPONAME=vim-togglelist
clone_or_pull
ln -sfn ${DIR}/vim-togglelist ${DOTVIM}/bundle/

THEURL=https://github.com/esquires/lvdb
REPONAME=lvdb
clone_or_pull
ln -sfn ${DIR}/lvdb ${DOTVIM}/bundle/

THEURL=https://github.com/esquires/tabcity
REPONAME=tabcity
clone_or_pull
ln -sfn ${DIR}/tabcity ${DOTVIM}/bundle/

THEURL=https://github.com/esquires/vim-map-medley
REPONAME=vim-map-medley
clone_or_pull
ln -sfn ${DIR}/vim-map-medley ${DOTVIM}/bundle/

THEURL=https://github.com/scrooloose/syntastic.git
REPONAME=syntastic
clone_or_pull
ln -sfn ${DIR}/syntastic ${DOTVIM}/bundle/

THEURL=https://github.com/ctrlpvim/ctrlp.vim.git
REPONAME=ctrlp.vim
clone_or_pull
ln -sfn ${DIR}/ctrlp.vim ${DOTVIM}/bundle/

# From https://superuser.com/questions/219009/how-do-i-move-around-and-otherwise-rearrange-splits-in-vim
THEURL=https://github.com/wesQ3/vim-windowswap.git
REPONAME=vim-windowswap
clone_or_pull
ln -sfn ${DIR}/vim-windowswap ${DOTVIM}/bundle

THEURL=https://github.com/jsfaint/gen_tags.vim.git
REPONAME=gen_tags.vim
clone_or_pull
ln -sfn ${DIR}/gen_tags.vim ${DOTVIM}/bundle

THEURL=https://github.com/tpope/tpope-vim-abolish.git
REPONAME=tpope-vim-abolish
clone_or_pull
ln -sfn ${DIR}/tpope-vim-abolish ${DOTVIM}/bundle

THEURL=https://github.com/tpope/vim-fugitive.git
REPONAME=vim-fugitive
clone_or_pull
ln -sfn ${DIR}/vim-fugitive ${DOTVIM}/bundle

THEURL=https://github.com/tpope/vim-commentary.git
REPONAME=vim-commentary
clone_or_pull
ln -sfn ${DIR}/vim-commentary ${DOTVIM}/bundle

# Install my colorschemes
mkdir -p ${HOME}/.vim/colors
sudo ln -sfn ${CONFIG_DIR}/laura.vim ${HOME}/.vim/colors/laura.vim
sudo ln -sfn ${CONFIG_DIR}/laura_light.vim ${HOME}/.vim/colors/laura_light.vim

# # The next few lines, which install YouCompleteMe from source, assume
# # that the version of vim installed was compiled to use python3, not python2.
PRE_YCM_INSTALL_DIR=$(pwd)
THEURL=https://github.com/Valloric/YouCompleteMe.git
REPONAME=YouCompleteMe
clone_or_pull
ln -sfn ${DIR}/YouCompleteMe ${DOTVIM}/bundle
# Make sure we own all the stuff in ${DIR}
chown -R ${ME}:${ME} ${DIR}
pushd ${DIR}
pushd YouCompleteMe
git submodule update --init --recursive

# this is where YouCompleteMe's build files will go
mkdir -p ${HOME}/ycm_build && pushd ${HOME}/ycm_build
chown -R ${ME}:${ME} ${HOME}/ycm_build

# This should generate CMake files for clang-4.0 installed in default directory
# and for Vim compiled to use Python3 (since YCM has to use the same Python version Vim does)
cmake -G "Unix Makefiles" -DEXTERNAL_LIBCLANG_PATH=/usr/lib/x86_64-linux-gnu/libclang-4.0.so -DUSE_PYTHON2=OFF . ${DIR}/YouCompleteMe/third_party/ycmd/cpp

# Now build YCM
cmake --build . --target ycm_core --config Release

# go back to original directory
cd ${PRE_YCM_INSTALL_DIR}

echo "Now changing the following user's default shell to zsh:"
echo ${ME}

sudo chsh -s /usr/bin/zsh ${ME}

