 ![](https://raw.githubusercontent.com/wiki/jguice/github-watch-manager/incomplete-300x300.jpg)

github-watch-manager (gwm)
======
Ruby commandline tool to mass watch/unwatch repositories.  For example a team could create a text file list of important repos that should be watched within a larger github org.  This tool could then be used to "apply" that list (unwatching repos that weren't in the list automatically).

This tool works for both private and public repositories and essentially provides a commandline ability to manage https://github.com/watching.


## Usage
```
$ git clone git@github.com:jguice/github-watch-manager.git
cd github-watch-manager
bundle install
bundle exec ./gwm
```

## Notes
To "reset" the app token you must remove it from github and delete the .token file present locally.

## TODO
- show what changes will be made and ask for confirmation
- turn this into a gem