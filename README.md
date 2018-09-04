Linux Config-Laura's Version
===

Installation
---

This assumes a particular path for installation::

    mkdir ~/repos
    cd repos
    git clone https://github.com/esquires/linux-config.git
    cd linux-config
    bash ubuntu_install.sh

Manual steps:

* Put this in `~/.gitconfig`. See [here](https://github.com/neovim/neovim/issues/2377)

    ```
    [merge]
        tool = nvimdiff
    [difftool "nvimdiff"] 
        cmd = terminator -x nvim -d $LOCAL $REMOTE
    [user]
        name = your_name
        email = your_email
    ``` 

* Put this in `~/.zshrc`.

    ```
    source ~/repos/linux-config/.zshrc
    export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin
    ```

* Put this in `~/.bashrc`:

    ```
    source ~/repos/linux-config/.bashrc
    echo "PATH=$PATH:~/bin" >> ~/.bashrc
    export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin
    ```

* Put this in `~/.editrc`:

    ```
    bind -v
    ```

* nvim, run ``:UpdateRemotePlugins`` for deoplete to work

* open ``/etc/xdg/awesome/rc.lua`` and change the following:

    ```
    local layouts =
        awful.layout.suit.floating,
        awful.layout.suit.tile.left,
        awful.layout.suit.fair,
        awful.layout.suit.max,
        awful.layout.suit.magnifier
    }
    
    terminal = "terminator -x nvim -c term -c \"normal A\""
    ```

* see ``notes/.lldbinit`` and ``notes/.gdbinit`` for an init file. You can run
  debuggers linked linked to vim by hitting ``\d`` in vim and running in a terminal.

  ```lldb -x ~/.lldbinit -f binary```
  ```gdb -x .gdbinit -f binary```

  see [lvdb](https://github.com/esquires/lvdb) for details

* for clang static analysis, execute

  ```
  source ~/repos/CodeChecker/venv/bin/activate
  cd build
  rm CMakeCache.txt
  cmake .. -G Ninja
  CodeChecker log -b "ninja" -o compilation.json
  CodeChecker analyze compilation.json -o ./reports
  CodeChecker parse ./reports -i skipfile
  ```
  
* To use powerline for the Awesome status bar, do the following:
    
    ```
    sudo pip3 install powerline-status  # whichever python version is relevant, or both just in case
    sudo pip install powerline-status
    mkdir -p ${HOME}/.config/powerline
    cp /location/of/linux-config/powerline_wm_default.json ${HOME}/.config/powerline/wm_config.json
    ```

