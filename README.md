Linux Config-Laura's Version
===

Installation
---

Put this in `~/.gitconfig`. See [here](https://github.com/neovim/neovim/issues/2377):
    
    [merge]
        tool = nvimdiff
    [difftool "nvimdiff"] 
        cmd = terminator -x nvim -d $LOCAL $REMOTE
    [user]
        name = your_name
        email = your_email

Installation:

    mkdir ~/repos
    cd repos
    sudo apt install git
    git clone https://github.com/esquires/linux-config.git
    cd linux-config
    python3 ubuntu_install.py . ..

    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # default to zsh
    sudo chsh -s /usr/bin/zsh $USER

Manual steps:

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


# Mouse Settings
If the fix-trackpad script doesn't work off-the-bat, run the following:

```
sudo mkdir /etc/X11/xorg.conf.d
sudo nvim /etc/X11/xorg.conf.d/90-synaptics.conf
```

and then place the following into the newly-created file:

```
# Example xorg.conf.d snippet that assigns the touchpad driver
# to all touchpads. See xorg.conf.d(5) for more information on
# InputClass.
# NOTE: The original location of this file, which said to not change
# it in-place, is /usr/share/X11/xorg.conf.d/70-synaptics.conf.
# I put this modified version here to hopefully override the clickpad driver
# selected by the OS.
# Additional options may be added in the form of
#   Option "OptionName" "value"
#
Section "InputClass"
        Identifier "touchpad catchall"
        Driver "synaptics"
        MatchIsTouchpad "on"
# This option is recommend on all Linux systems using evdev, but cannot be
# enabled by default. See the following link for details:
# http://who-t.blogspot.com/2010/11/how-to-ignore-configuration-errors.html
      MatchDevicePath "/dev/input/event*"
      Option "Tapping" "off"
EndSection

Section "InputClass"
        Identifier "touchpad ignore duplicates"
        MatchIsTouchpad "on"
        MatchOS "Linux"
        MatchDevicePath "/dev/input/mouse*"
        Option "Ignore" "on"
EndSection

# This option enables the bottom right corner to be a right button on clickpads
# and the right and middle top areas to be right / middle buttons on clickpads
# with a top button area.
# This option is only interpreted by clickpads.
Section "InputClass"
        Identifier "Default clickpad buttons"
        MatchDriver "synaptics"
        Option "SoftButtonAreas" "50% 0 82% 0 0 0 0 0"
        Option "SecondarySoftButtonAreas" "58% 0 0 15% 42% 58% 0 15%"
EndSection

# This option disables software buttons on Apple touchpads.
# This option is only interpreted by clickpads.
Section "InputClass"
        Identifier "Disable clickpad buttons on Apple touchpads"
        MatchProduct "Apple|bcm5974"
        MatchDriver "synaptics"
        Option "SoftButtonAreas" "0 0 0 0 0 0 0 0"
EndSection
```

Then reboot and try running `fix-trackpad` again.
Basically, we want to override the OS's loading of the libinput driver for the 
clickpad so that it will load the Synaptics driver instead.
To encourage this, we give our 90-synaptics.conf file a higher-value initial 
number than the version Ubuntu 18.04 puts in 
`/usr/share/X11/xorg.conf.d/70-synaptics.conf`.
It is possible that simply changing 
`/usr/share/X11/xorg.conf.d/70-synaptics.conf` to 
`/usr/share/X11/xorg.conf.d/90-synaptics.conf` would have the same effect, but
I don't want to rock the boat on my main local research machine now that my
clickpad settings are to my liking.

