<p align="center">
  DOTFILES README (Bare Repo)
</p>


This repository uses the Git bare-repo method to manage dotfiles directly from
the home directory without storing a .git folder inside $HOME.

---------------------------------------
1. INITIAL SETUP (ONLY ONCE PER MACHINE)
---------------------------------------

Create a bare repo in your home directory:

    git init --bare $HOME/.dotfiles

---------------------------------------
Add the "config" alias

For ZSH users:
Add this line to ~/.zshrc:
    
        alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
        
Reload shell:

        source ~/.zshrc

For FISH users:
Add this line to ~/.config/fish/config.fish:
    
        alias config '/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

Reload shell:
    
        source ~/.config/fish/config.fish
        
---------------------------------------

Hide untracked files so your entire $HOME doesn't appear in `config status`:

    config config --local status.showUntrackedFiles no


-----------------------------
2. ADD FILES TO TRACK (ONE TIME)
-----------------------------

Example: add Neovim config:

    config add .config/nvim
    config commit -m "Add nvim config"
    config push

Example: add Hyprbar config:

    config add .config/hyprbar
    config commit -m "Add hyprbar config"
    config push

Example: add local fonts (recommended to use ~/.local/share/fonts):

    config add .local/share/fonts
    config commit -m "Add local fonts"
    config push


-----------------------------------------
3. DAILY WORKFLOW (TRACKED FILES ONLY)
-----------------------------------------

Modify files normally (example: ~/.config/nvim/init.lua)

Check what changed:

    config status

Commit changes:

    config commit -am "Describe the update"

Push to GitHub:

    config push

NOTE:
- You do NOT need `config add` again unless it's a NEW file.


-----------------------------------------
4. ADDING NEW FILES LATER
-----------------------------------------

Example:

    config add .config/tmux/tmux.conf
    config commit -m "Add tmux config"
    config push


-----------------------------------------
5. RESTORING DOTFILES ON NEW MACHINE
-----------------------------------------

Clone the bare repo:

    git clone --bare git@github.com:USERNAME/dotfiles.git $HOME/.dotfiles

Create the config alias temporarily:

    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

Backup conflicting files:

    mkdir -p $HOME/dotfiles-backup

Checkout dotfiles into $HOME:

    config checkout

If errors appear, move the conflicting files to dotfiles-backup then run again.

Hide untracked files:

    config config --local status.showUntrackedFiles no

Re-add the alias permanently in ~/.zshrc or ~/.config/fish/config.fish.


-----------------------------------------
6. USEFUL COMMANDS
-----------------------------------------

List tracked files:

    config ls-files

Remove file from Git but keep it on disk:

    config rm --cached <file>

View changes:

    config diff

-----------------------------------------
7. IMPORTANT NOTES
-----------------------------------------

- DO NOT track system directories like /usr/share/fonts.
  Instead, copy wanted fonts to:
      ~/.local/share/fonts

- Do not commit secrets such as:
      ~/.ssh/
      API keys
      tokens
