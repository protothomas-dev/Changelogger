# Changelogger

A command line tool to manage the changelog of the MyStore project.

```
$ Changelogger --help
OVERVIEW: A Swift command-line tool to manage the changelog

USAGE: changelogger <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  release                 Rename the current 'Unreleased' section to the given
                          version and build number and create a new
                          'Unreleased' section atop
  extract                 Extract the changes of current 'Unreleased' section
  resolve                 Resolve the provided ticket numbers to markdown links
                          to the corresponding URLs to the tickets

  See 'changelogger help <subcommand>' for detailed help.
```
