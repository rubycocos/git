# Notes


## More Gitfiles tools

### Gitfile (Go)

_a (light-weight) package manager for installing and updating projects from git repos_

- <https://github.com/bradurani/Gitfile> by Brad Urani
  - <https://github.com/bradurani/Gitfile/blob/master/gitfile/gitfile.go>
- <http://fractalbanana.com/blog/2016/08/15/gitfile-a-package-manager-for-git-repos/>

``` yaml
- url: git://github.com/bradurani/bradrc.git
- url: https://github.com/thoughtbot/dotfiles.git
  path: thoughtbot/
- url: https://github.com/olivierverdier/zsh-git-prompt.git
  tag: v0.4
- url: https://github.com/tmux-plugins/tmux-battery.git
  path: ~/.tmux-plugins/
  branch: master
```


### Gitfile (Shell)

_download and manage multiple git repos_

- <https://github.com/Bobonium/gitfile>
  - <https://github.com/Bobonium/gitfile/blob/master/gitfile.sh>

Example:

``` yaml
gitfile:
    source: "https://github.com/Bobonium/gitfile.git"
    path: ~/workspace/github/Bobonium/
    version: master
```


## More Resources

- <https://github.com/topics/gitfile> - gitfile topic on github


