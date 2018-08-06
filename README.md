# Vikram's Dotfiles

Dotfiles are a way of backing up and syncing my settings the my setup across multiple machines. This way I can keep the settings and programs that I love and keep any tidbits/gems that I pickup along the way.

As of right now, I am using [this](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) convenient nice strategy to manage my configuration files for my development environments. I first found this idea in [a HackerNews post](https://news.ycombinator.com/item?id=11070797).


## Computers

Right now, the configuration for each computer is managed using a seperate branch

1. `mac/tintinux`: Personal Laptop
    - **Make**: Apple
    - **Model** "13-inch MacBook Air (2017)
    - **Operating System**: macOS High Sierra
    - **Processor:** 1.8 GHz Intel Core i5
    - **Memory:** 8 GB 1600 MHz DDR3
    - **Graphics**: Intel HD Graphics 6000 1536 MB
    - **Storage**: 120 GB Flash storage, expanded by another 120GB

2. `mac/ecobee-web`: Work Laptop


## Getting setup on a new machine

To get started:

```bash
$ alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
$ git clone --bare https://github.com/Viktree/my_dotfiles.git $HOME/.cfg
$ alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
$ config checkout
$ config config --local status.showUntrackedFiles no
```

- When starting off, rip a new branch from a branch that has relatively similar settings.
- Instead of using `git`, use `config` when you want to control the dotfiles repo
