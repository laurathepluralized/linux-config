#!/usr/bin/env bash
#
# Usage: bash rhelconfig.sh

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

CONFIG_DIR=${HOME}"/repos/linux-config"

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

# THEURL=https://github.com/chrisbra/csv.vim.git
# REPONAME=csv.vim
# clone_or_pull
# ln -sfn ${DIR}/csv.vim ${DOTVIM}/bundle/
# ln -sfn ${CONFIG_DIR}/filetype.vim ${DOTVIM}/filetype.vim

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

# echo "Now changing the following user's default shell to zsh:"
# echo ${ME}

# chsh -s /usr/bin/zsh ${ME}

