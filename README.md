# dotfiles

This dotfiles repo is my preferred way to back up and syncing my settings/configurations across multiple machines. I often discover helpful settings or programming gems while toying around and it's great to have them nestled within the confines of this repo.

## branches, machines and naming structure

I have my configurations for each computer/account managed using a separate branch.Branches are named using either `<os>/<hostname>` or `<os>/<hostname>`. To avoid ambiguities, I've referred to `osx` as `mac` in the branch names.

I've based the `$HOSTNAME` of my personal computers off the characters from [The Adventures of Tintin](https://en.wikipedia.org/wiki/The_Adventures_of_Tintin).

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/en/e/ed/Tintin-mainSupportingCharacters.png">
</p>

### Active development environments

1. [mac/sponz](https://github.com/viktree/dotfiles/tree/mac/sponz) My personal m1 mac book air that I use for most things.

2. [mac/ecobee-mbp-2019](https://github.com/viktree/dotfiles/tree/mac/ecobee-mbp-2019) My ecobee work laptop

### No longer in use

1. [mac/tintinux](https://github.com/viktree/dotfiles/tree/mac/tintinux) was my previous personal machine

2. [arch/pv-workstation](https://github.com/viktree/dotfiles/tree/arch/pv-workstation), [ubuntu/pv-laptop](https://github.com/viktree/dotfiles/tree/ubuntu/pv-laptop) and [mac/ecobee-web](https://github.com/viktree/dotfiles/tree/mac/ecobee-web-pey) are my previous work laptops from Per Vices and ecobee respectively.

3. [uoftcs/wolf](https://github.com/viktree/dotfiles/tree/uoftcs/wolf) Some of the configuration files from U of T's computer science server. Not quite sure why it was called wolf.

4. [arch/haddock](https://github.com/viktree/dotfiles/tree/arch/haddock) and [arch/rastapopoulos](https://github.com/viktree/dotfiles/tree/arch/rastapopoulos) are some of my dabblings in archlinux before my current setup

5. [ubuntu/alcazar](https://github.com/viktree/dotfiles/tree/ubuntu/jetson-nano) This is a nvidia jetson that I used to have sitting on my desk at home.

## Setting up a new computer

Of the many possible ways to manage dotfiles, I came across a framework I like outlined in [this hacker news post](https://news.ycombinator.com/item?id=11070797) and then elaborated on [in this atlassian blog entry](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/). Unlike many of the other options, this strategy doesn't depend on having symbolic links or bulky programs (the only prerequisite is git)!

I used this for the first little while and then I started to peek over at [yadm](https://yadm.io/), which is a program that pretty much does the same thing under the hood and comes with a couple of other nice features. We are still only using a glorified git repo.

### Settings up a new machine without yadm

```bash
# ssh version: git@github.com:viktree/dotfiles.git
git clone --bare https://github.com/viktree/dotfiles.git $HOME/.cfg

# Keep this in a bashrc or an equivalent file
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

config checkout  -b <descriptive-branch-name>
config config --local status.showUntrackedFiles no
config add <file-to-backup>
config commit -m "initial commit"
config push --set-upstream origin <descriptive-branch-name>
```

### Settings up a new machine with yadm

First download [yadm](https://yadm.io) from source (without a package manager)

```bash
git clone https://github.com/TheLocehiliosan/yadm.git ~/.config/yadm
ln -s ~/.config/yadm ~/bin/yadm
```

Then we need to point it at this repo

```bash
# ssh version: git@github.com:viktree/dotfiles.git
yadm remote add origin https://github.com/viktree/dotfiles
yadm pull
```

We can setup the machine by running bootstrap

```
yadm bootstrap
```

Finally, we cut a new branch and push the files

```
yadm checkout -b <descriptive-branch-name>
yadm add <file-to-backup>
yadm commit -m "initial commit"
yadm push --set-upstream origin <descriptive-branch-name>
```

### After branch creation

Here's a checklist of things to go over

- [ ] add machine specs to the `README.md` file of the branch
- [ ] add entry to this file on the master branch
- [ ] make sure to commit to the branch frequently

---

[Link to how these files are setup and the configuration files for my other machines](https://github.com/viktree/dotfiles)
