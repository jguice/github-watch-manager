 ![](https://raw.githubusercontent.com/wiki/jguice/github-watch-manager/incomplete-300x300.jpg)

github-watch-manager
======
Ruby commandline tool to mass watch/unwatch repositories.  For example a team could create a text file list of important repos that should be watched within a larger github org.  This tool could then be used to "apply" that list (unwatching repos that weren't in the list automatically).


## Usage
```
$ git clone git@github.com:jguice/github-watch-manager.git
cd github-watch-manager
bundle install
bundle exec ./github-watch-manager
```

## Notes
To "reset" the app token you must remove it from github and delete the .token file present locally.

## TODO
- rspec tests for existing code (rearranging as-needed)
- subscribe/unsubscribe (tests first!)
- option to limit behavior to an org or list of orgs
- show what changes will be made and ask for confirmation