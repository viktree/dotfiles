# Vikram's Dotfiles

Dotfiles are a way of backing up and syncing my settings the my setup across multiple machines. This way I can keep the settings for programs that I love, as well as any tidbits/gems that I pickup along the way.



## My machines

Right now, the configuration for each computer is managed using a separate branch. I try and name my machines using characters from [The Adventures of Tintin](https://en.wikipedia.org/wiki/The_Adventures_of_Tintin) and the branches accordingly.

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/en/e/ed/Tintin-mainSupportingCharacters.png">
</p>


### Active development environments

1. [mac/tintinux](https://github.com/viktree/dotfiles/tree/mac/tintinux) The main operating system on my personal macbook that I use for most things

2. [arch/haddock](https://github.com/viktree/dotfiles/tree/arch/haddock) some dabblings in archlinux

3. [arch/pv-workstation](https://github.com/viktree/dotfiles/tree/arch/pv-workstation) and [ubuntu/pv-laptop](https://github.com/viktree/dotfiles/tree/ubuntu/pv-laptop) are machines I use for work

4. [ubuntu/alcazar](https://github.com/viktree/dotfiles/tree/ubuntu/jetson-nano) This is a nvidia jetson that I have sitting on my desk at home.



### No longer in use

1. [mac/ecobee-web](https://github.com/viktree/dotfiles/tree/mac/ecobee-web) This was the laptop I was using while at ecobee

2. [uoftcs/wolf](https://github.com/viktree/dotfiles/tree/uoftcs/wolf) Some of the configuration files from U of T's computer science server. Not quite sure why it was called wolf.


## Setting up a new computer

There are many different programs for managing dotfiles, but one idea that seemed really slick was mentioned in this [a HackerNews post](https://news.ycombinator.com/item?id=11070797) and then elaborated on [here](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/). Unlike many of the other options, this strategy doesn't depend on having symbolic links or bulky programs (you really only need git)!



I used this for the first little while and then I started to peek over at [yadm](https://yadm.io/), which is a program that pretty much does the same thing under the hood and comes with a couple of other nice features. We are still only using a glorified git repo.



### With yadm

First we will need to download yadm

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



### Without yadm

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



### After branch creation

Just a few reminders:

- [ ] add machine specs to the README.md file of the branch
- [ ] add entry to this file on the master branch
- [ ] make sure to commit to the branch frequently


---

[Here's a link to how these files are setup and the configuration files for my other machines](https://github.com/viktree/dotfiles)

