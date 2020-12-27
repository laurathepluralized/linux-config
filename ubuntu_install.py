"""Install config compatible with (at least) Ubuntu 18.04."""
import argparse
import pandas as pd
import subprocess as sp
import os.path as op
import os
import pathlib
import sys
import re
import shutil

HOME = os.environ['HOME']


def install_git_bash_completion():
    """Install git bash completion from the url in url_base below."""
    url_base = \
        'https://raw.githubusercontent.com/git/git/master/contrib/completion/'
    files = [f for f in ['git-completion.bash', 'git-prompt.sh']
             if not op.isfile(op.join(HOME, '.' + f))]
    for f in files:
        sp.check_call(['curl', '-o', op.join(HOME, '.' + f), url_base + f])


def add_lines(fname, lines_to_add):
    """Append lines to a file only if they aren't already in the file."""
    pathlib.Path(fname).touch()  # make sure the file exists
    with open(fname, 'r') as f:
        lines = f.read().splitlines()

    if not set(lines).intersection(lines_to_add):
        lines += lines_to_add
        with open(fname, 'w') as f:
            f.write('\n'.join(lines))


def install_scripts():
    """Install the convenience scripts located in this repo's scripts dir."""
    bin_dir = op.join(HOME, 'bin')
    os.makedirs(bin_dir, exist_ok=True)
    p = op.join(os.getcwd(), 'scripts')
    files = [f for f in os.listdir(p)
             if op.isfile(op.join(p, f)) and
             not op.isfile(op.join(bin_dir, f))]
    for f in files:
        os.symlink(op.join(p, f), op.join(bin_dir, f))


def setup_vimrc(config_dir):
    """Set up base vimrc and source this repo's more comprehensive .vimrc."""
    for d in ['bundle', 'autoload', 'swaps', 'backups']:
        os.makedirs(op.join(HOME, ".vim", d), exist_ok=True)

    lines_to_add = [
        'source ' + op.join(config_dir, '.vimrc'),
        'set backup',
        'set backupdir=' + op.join(HOME, '.vim', 'backups'),
        'set dir=' + op.join(HOME, '.vim', 'swaps')]

    add_lines(op.join(HOME, '.vimrc'), lines_to_add)


def setup_inputrc():
    """Set up inputrc to use vi bindings in shells, etc. that use inputrc."""
    lines_to_add = [
        'set keymap vi',
        'set editing-mode vi']
    # the following line hasn't been recognized recently; I suspect it is
    # deprecated
    # 'set bind-tty-special-chars-off']
    add_lines(op.join(HOME, '.inputrc'), lines_to_add)


def run_apt():
    """Add apt ppas, run apt update, and upgrade and install packages."""
    sp.check_call(['sudo', 'add-apt-repository', '-y', 'ppa:git-core/ppa'])
    sp.check_call(['sudo', 'add-apt-repository', '-y',
                   'ppa:jonathonf/texlive'])
    sp.check_call(['sudo', 'add-apt-repository', '-y', 'ppa:smathot/cogscinl'])
    sp.check_call(['sudo', 'add-apt-repository', '-y', 'ppa:deadsnakes/ppa'])
    sp.check_call(['sudo', 'add-apt-repository', '-y',
                   'ppa:neovim-ppa/stable'])
    pkgs_df = pd.read_csv('apt_pkgs_to_install.csv', header=None)
    pkgs = pkgs_df[0].values.tolist()

    sp.check_call(['sudo', 'apt', 'update'])
    sp.check_call(['sudo', 'apt', '-y', 'upgrade'])
    sp.check_call(['sudo', 'apt', 'install', '-y'] + pkgs)


def setup_sleep_command():
    """Set up gotosleep command with screen lock, make it not require sudo."""
    pm_suspend_pth = op.join('/etc', 'sudoers.d', 'pm-suspend')
    if not op.exists(pm_suspend_pth):
        sp.check_call(['sudo', 'touch', pm_suspend_pth])

        # Since we need sudo to edit a sudoers.d file, we can't use add_lines
        # to edit /etc/sudoers.d/pm-suspend, so we just os.system append into
        # it.
        exc = shutil.which('pm-suspend')
        thecommand = 'echo "ALL ALL=NOPASSWD: ' + exc + \
            '" | (sudo su -c \'EDITOR="tee" visudo -f' + \
            pm_suspend_pth + '\')'
        # I could not get sp.check_call to actually execute the pipe in the
        # above command, so going with an alternate approach
        os.system(thecommand)


def update_repo(url, parent_dir, sha=None):
    """Clones repo if we haven't already, otherwise fetches or pulls."""
    tail = url.split('/')[-1]
    if tail[-4:] == '.git':
        tail = tail[:-4]
    repo_dir = op.join(parent_dir, tail)
    if not op.isdir(repo_dir):
        sp.check_call(['git', 'clone', url], cwd=parent_dir)

    if sha:
        sp.check_call(['git', 'fetch'], cwd=repo_dir)
        sp.check_call(['git', 'checkout', sha], cwd=repo_dir)
    else:
        try:
            sp.check_call(['git', 'pull'], cwd=repo_dir)
        except sp.CalledProcessError:
            sp.check_call(['git', 'fetch'], cwd=repo_dir)


def install_cbatticon(repos_dir):
    """Install battery icon utility."""
    cbatticon_dir = op.join(repos_dir, 'cbatticon')
    sp.check_call(
        ['sudo', 'apt', 'install', '-y', 'libnotify-dev', 'libgtk-3-dev'])
    update_repo('https://github.com/valr/cbatticon.git', repos_dir)
    sp.check_call(['make', 'prefix=/usr/local'], cwd=cbatticon_dir)
    sp.check_call(['sudo', 'make', 'prefix=/usr/local', 'install'],
                  cwd=cbatticon_dir)


def install_vim_plugins(config_dir, repos_dir):
    """Install my preferred vim plugins."""
    vim_dir = op.join(repos_dir, 'vim')
    os.makedirs(vim_dir, exist_ok=True)
    os.makedirs(op.join(HOME, '.vim', 'autoload'), exist_ok=True)
    os.makedirs(op.join(HOME, '.vim', 'bundle'), exist_ok=True)
    update_repo('https://github.com/tpope/vim-pathogen.git', vim_dir)
    try:
        os.symlink(
            op.join(vim_dir, 'vim-pathogen', 'autoload', 'pathogen.vim'),
            op.join(HOME, '.vim', 'autoload', 'pathogen.vim'))
    except FileExistsError:
        pass

    def _update(repo, sha=None):
        update_repo(repo, vim_dir, sha)
        repo_name = repo.split('/')[-1]
        if repo_name.split('.')[-1] == 'git':
            repo_name = '.'.join(repo_name.split('.')[:-1])
        try:
            os.symlink(op.join(vim_dir, repo_name),
                       op.join(HOME, '.vim', 'bundle', repo_name))
        except FileExistsError:
            pass

    _update('https://github.com/milkypostman/vim-togglelist')
    _update('https://github.com/neomake/neomake')
    _update('https://github.com/tpope/vim-fugitive')
    _update('https://github.com/esquires/tabcity')
    _update('https://github.com/esquires/vim-map-medley')
    _update('https://github.com/ctrlpvim/ctrlp.vim')
    _update('https://github.com/majutsushi/tagbar')
    _update('https://github.com/tmhedberg/SimpylFold')
    _update('https://github.com/tomtom/tcomment_vim.git')
    _update('https://github.com/esquires/neosnippet-snippets')
    _update('https://github.com/Shougo/neosnippet.vim.git')
    _update('https://github.com/jlanzarotta/bufexplorer.git')
    _update('https://github.com/lervag/vimtex')
    _update('https://github.com/vim-airline/vim-airline')
    _update('https://github.com/vim-airline/vim-airline-themes.git')
    _update('https://github.com/Shougo/echodoc.vim.git')
    _update('https://github.com/tpope/vim-surround')
    _update('https://github.com/tpope/vim-repeat')
    _update('https://github.com/tpope/tpope-vim-abolish.git')
    _update('https://github.com/tpope/vim-vinegar.git')
    _update('https://github.com/neutaaaaan/iosvkem.git')
    _update('https://github.com/vim-scripts/DoxygenToolkit.vim.git')
    _update('https://github.com/inside/vim-search-pulse.git')
    _update('https://github.com/inkarkat/vim-mark.git')
    _update('https://github.com/vim-scripts/ingo-library.git')
    _update('https://github.com/mechatroner/rainbow_csv.git')
    os.makedirs(op.join(HOME, '.vim', 'colors'), exist_ok=True)
    try:
        os.symlink(op.join(vim_dir, 'iosvkem', 'colors', 'Iosvkem.vim'),
                   op.join(HOME, '.vim', 'colors', 'Iosvkem.vim'))
    except FileExistsError:
        pass

def apply_patch(patch_file, patch_msg, d):
    """Apply the patch defined in patch_file to the repo in directory d."""
    sp.check_call(['git', 'checkout', '-f', 'master'], cwd=d)
    sp.check_call(['git', 'reset', '--hard', 'origin/master'], cwd=d)
    sp.check_call(['git', 'am', '-3', patch_file], cwd=d)


def install_neovim(repos_dir):
    """Install neovim from source."""
    apt_pkgs = [
        'libtool',
        'libtool-bin',
        'autoconf',
        'automake',
        'cmake',
        'g++',
        'pkg-config',
        'unzip',
        'python-pip',
        'python3-pip',
        'python3-flake8',
        'pylint3']

    sp.check_call(['sudo', 'apt', 'install', '-y'] + apt_pkgs)
    sp.check_call(['touch', op.join(HOME, '.pylintrc')])

    pip_packages = ['neovim', 'cpplint', 'pydocstyle', 'neovim-remote']
    sp.check_call(['sudo', 'pip3', 'install'] + pip_packages)
    update_repo('https://github.com/neovim/neovim.git', repos_dir)
    neovim_dir = op.join(repos_dir, 'neovim')
    sp.check_call(['git', 'checkout', 'v0.3.0'], cwd=neovim_dir)

    deps_dir = op.join(neovim_dir, '.deps')
    os.makedirs(deps_dir, exist_ok=True)
    sp.check_call([
        'cmake', '../third-party', "-DCMAKE_CXX_FLAGS='-march=native'",
        '-DCMAKE_BUILD_TYPE=Release'], cwd=deps_dir)
    sp.check_call(['make'], cwd=deps_dir)

    build_dir = op.join(neovim_dir, 'build')
    os.makedirs(build_dir, exist_ok=True)
    sp.check_call([
        'cmake', '..', '-G', 'Ninja', "-DCMAKE_CXX_FLAGS='-march=native'",
        '-DCMAKE_BUILD_TYPE=Release'], cwd=build_dir)
    sp.check_call(['ninja'], cwd=build_dir)
    sp.check_call(['sudo', 'ninja', 'install'], cwd=build_dir)

    os.makedirs(op.join(HOME, '.config', 'nvim'), exist_ok=True)
    lines_to_add = [
        'set runtimepath^=~/.vim runtimepath+=~/.vim/after',
        'let &packpath = &runtimepath',
        'set guicursor=',
        'source ~/.vimrc']
    add_lines(op.join(HOME, '.config', 'nvim', 'init.vim'), lines_to_add)


def install_cppcheck(config_dir, repos_dir):
    """Install cppcheck."""
    update_repo('https://github.com/danmar/cppcheck', repos_dir)

    cppcheck_dir = op.join(repos_dir, 'cppcheck')
    patch_msg = '[PATCH] add ccache'
    patch_file = op.join(config_dir, 'patches', '0001-add-ccache.patch')
    apply_patch(patch_file, patch_msg, cppcheck_dir)

    build_dir = op.join(cppcheck_dir, 'build')
    os.makedirs(build_dir, exist_ok=True)
    sp.check_call([
        'cmake', '..', '-G', 'Ninja', "-DCMAKE_CXX_FLAGS='-march=native'",
        '-DCMAKE_BUILD_TYPE=Release'], cwd=build_dir)
    sp.check_call(['ninja'], cwd=build_dir)
    sp.check_call(['sudo', 'ninja', 'install'], cwd=build_dir)


def install_cppclean(repos_dir):
    """Install cppclean."""
    cppclean_dir = op.join(repos_dir, 'cppclean')
    update_repo('https://github.com/myint/cppclean.git', repos_dir)
    sp.check_call(['sudo', 'pip3', 'install', '-e', '.'], cwd=cppclean_dir)


def install_cmd_monitor(repos_dir):
    """Install equires's cmd_monitor."""
    cmd_monitor_dir = op.join(repos_dir, 'cmd_monitor')
    update_repo('https://github.com/esquires/cmd_monitor', repos_dir)
    sp.check_call(['sudo', 'pip3', 'install', '-e', '.'], cwd=cmd_monitor_dir)


def setup_ipython():
    """Set up IPython and make terminal shell use vi mode."""
    sp.check_call(['ipython', 'profile', 'create'])
    config = op.join(HOME, '.ipython', 'profile_default', 'ipython_config.py')
    add_lines(config, ["c.TerminalInteractiveShell.editing_mode =  'vi'"])


def install_awesome(config_dir):
    """Install awesome-wm window manager."""
    sp.check_call(['sudo', 'apt', 'install', '-y', 'awesome'])
    awesome_dir = op.join(HOME, '.config', 'awesome')
    os.makedirs(awesome_dir, exist_ok=True)

    awesome_version = \
        sp.Popen(['awesome', '-v'], stdout=sp.PIPE).communicate()[0].decode()
    awesome_version = int(re.search(r' v(\d+).\d+', awesome_version).group(1))
    rc_lua = 'rc4.lua' if awesome_version == 4 else 'rc.lua'
    try:
        os.symlink(
            op.join(config_dir, rc_lua), op.join(awesome_dir, 'rc.lua'))
    except FileExistsError:
        pass


def install_pip_packages():
    """Install specific pip packages."""
    sp.check_call(["sudo", "pip3", "install", "flawfinder", "pandas",
                   "hashtable"])


def install_latexdiff(repos_dir, config_dir):
    """Get latexdiff source, change install dir, and install from source.

    The patch applied here just changes the install directory to /usr/bin.
    """
    update_repo('https://gitlab.com/git-latexdiff/git-latexdiff', repos_dir)
    d = op.join(repos_dir, 'git-latexdiff')
    patch = \
        op.join(config_dir, 'patches', '0001-adjust-install-location.patch')
    apply_patch(patch, 'adjust install loc', d)
    sp.check_call(['sudo', 'make', 'install'], cwd=d)


def main():
    """Run config installer."""
    parser = argparse.ArgumentParser()
    parser.add_argument('config_dir')
    parser.add_argument('repos_dir')
    args = parser.parse_args()

    args.config_dir = op.abspath(args.config_dir)
    args.repos_dir = op.abspath(args.repos_dir)

    os.makedirs(op.join(HOME, 'repos'), exist_ok=True)

    # run_apt()
    # install_latexdiff(args.repos_dir, args.config_dir)
    install_git_bash_completion()
    # install_pip_packages()
    install_scripts()
    # setup_sleep_command()
    setup_vimrc(args.config_dir)
    setup_inputrc()
    # install_cbatticon(args.repos_dir) # no
    # install_neovim(args.repos_dir) # no
    install_vim_plugins(args.config_dir, args.repos_dir)
    # install_cppcheck(args.config_dir, args.repos_dir) # no
    # install_cppclean(args.repos_dir)
    # install_cmd_monitor(args.repos_dir)
    # setup_ipython()
    # install_awesome(args.config_dir)
    # sp.check_call(['sudo', 'chsh', '-s', '/usr/bin/zsh', '$USER'])
    sp.check_call(['chsh', '-s', '/usr/bin/zsh', '$USER'])

    # os.makedirs(op.join(HOME, ".config", "tilix", "schemes"), exist_ok=True)
    # try:
        # os.symlink(op.join(args.config_dir, "tilix_profile.json"),
                   # op.join(HOME, ".config", "tilix", "schemes",
                           # "tilix_profile.json"))
    # except FileExistsError:
        # pass


if __name__ == '__main__':
    """Run the main function that runs our config installer."""
    main()
