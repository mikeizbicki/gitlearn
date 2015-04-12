# what is gitlearn?

Gitlearn is an open source [learning management system](http://en.wikipedia.org/wiki/Learning_management_system) (similar to [ilearn/blackboard](http://www.blackboard.com/)).
The distinguishing feature of gitlearn is that classes and grades are stored in git repositories.

## installation

Installing is simple.
Just clone the repo and add the `scripts` folder to your `PATH` using the following commands:
```
$ git clone https://github.com/mikeizbicki/gitlearn
$ export PATH=$(pwd)/gitlearn/scripts:$PATH
```
In order for your `PATH` to remain across sessions you need to update your `~/.bashrc` (or similar):
```
$ echo "export PATH=$(pwd)/gitlearn/scripts:"'$PATH' >> $HOME/.bashrc
```

FIXME: add better install script
