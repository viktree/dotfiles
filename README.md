# dotfiles

This repository contains my personal dotfiles - settings files for various tools. To make it easy to keep environments isolated but consistent, each machine/account has its own branch

## Branch naming convention

- Format: `<os>/<hostname>`  
- I use `mac` instead of `osx` for clarity.  
- Hostnames are named after characters from [*The Adventures of Tintin*](https://en.wikipedia.org/wiki/The_Adventures_of_Tintin).  

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/en/e/ed/Tintin-mainSupportingCharacters.png">
</p>

---

## Active machines

- [mac/sponz](https://github.com/viktree/dotfiles/tree/mac/sponz) — Personal M1 MacBook Air  

## Retired machines

- [mac/ecobee-mbp-2019](https://github.com/viktree/dotfiles/tree/mac/ecobee-mbp-2019) — Previous work laptop (ecobee)  
- [mac/tintinux](https://github.com/viktree/dotfiles/tree/mac/tintinux) — Previous personal Mac  
- [arch/pv-workstation](https://github.com/viktree/dotfiles/tree/arch/pv-workstation), [ubuntu/pv-laptop](https://github.com/viktree/dotfiles/tree/ubuntu/pv-laptop), [mac/ecobee-web](https://github.com/viktree/dotfiles/tree/mac/ecobee-web-pey) — Old work laptops (Per Vices & ecobee)  
- [uoftcs/wolf](https://github.com/viktree/dotfiles/tree/uoftcs/wolf) — U of T CS server configs  
- [arch/haddock](https://github.com/viktree/dotfiles/tree/arch/haddock), [arch/rastapopoulos](https://github.com/viktree/dotfiles/tree/arch/rastapopoulos) — Arch Linux experiments  
- [ubuntu/jetson-nano](https://github.com/viktree/dotfiles/tree/ubuntu/jetson-nano) — Old NVIDIA Jetson dev board  

---

## Quick start

Two options for managing these dotfiles:

### Option 1: Minimal (bare repo)

```bash
git clone --bare https://github.com/viktree/dotfiles.git $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

config checkout -b <branch>
config config --local status.showUntrackedFiles no
config add <file>
config commit -m "initial commit"
config push --set-upstream origin <branch>
```

### Option 2: Using yadm

yadm is [yet another dotfiles manager](https://yadm.io/)

```bash
git clone https://github.com/TheLocehiliosan/yadm.git ~/.config/yadm
ln -s ~/.config/yadm ~/bin/yadm

yadm remote add origin https://github.com/viktree/dotfiles
yadm pull
yadm bootstrap

yadm checkout -b <branch>
yadm add <file>
yadm commit -m "initial commit"
yadm push --set-upstream origin <branch>
```

## Helpful things to do after adding a branch

Here's a checklist of things to go over

 - [ ] add machine specs to the README.md file of the branch
 - [ ] add entry to this file on the master branch
 - [ ] make sure to commit to the branch frequently

---

[Link to how these files are setup and the configuration files for my other machines](https://github.com/viktree/dotfiles)
