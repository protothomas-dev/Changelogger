# Changelogger

A command line tool to manage a changelog.

This tool is written in swift using the [swift argument parser](https://github.com/apple/swift-argument-parser) from apple. Instead of writing it in a script I decided to create a cli tool for this because that way I don't have to be concerned about all kinds of dependency issues, especially on CI environments you don't have control about. Also it was a fun little experiment to use swift for something like this.

## Prerequisite

Before you can use the command line tool, you first have to make sure the changeloge you want to manage has a certain structure.
The changelog has to be written in markdown. This is important to remember, because at the core this tool uses regular expressions based that consider markdown codes.
The structure is loosely following the [conventinal commits specification](https://www.conventionalcommits.org/en/v1.0.0/) by grouping the changes into several catagories.

The changelog should have a structure like this

```
# Changelog

All notable changes to this project will be documented in this file.

## Unreleased // A section containing all unreleased changes to the project

### <Kind of change> // A headline to group changes

- <Ticket with description>

#### <Noteworthy dependency version info> // One or more lines of versions of important dependency
    
--- // Seperates the different versions
    
## Version 1.0.0 (1) // A section containing all changes to a specific version

### Improved

### <Kind of change>

- <Ticket with description>

#### <Noteworthy dependency version info>

---

...

```

The tickets have to have a certain format as well, if you want to take advantage of the changelogger's feature to add weblinks to each specific ticket in your project management system.

```
// Jira ticket
- [TICKET-123]: short description
// -> - [TICKET-123](https://jira.atlassian.com/browse/TICKET-123): short description

// Github issue
- [#123]: short description
// -> [#123](https://github.com/username/project/issues/123): short description
```

## How to start

First you have to create a binary using the command line. Open the terminal and navigate to the repo. From within the root folder, execute the following command

```
swift build --configuration release
```
You can find the binary in `.build/release`. If you want to use the tool on your machine, you should copy it into your local binary folder
```
cp -f .build/release/Changelogger /usr/local/bin/changelogger
```
If you want to use it on a CI server, simple copy the binary into your project folder.

## How to use

### Make a release

If you want to release a new version of your project and you want to close the unreleased section in you changelog, you can use the `release` command:

```
changelogger release <version-number> <build-number>
```
This will close the previous unreleased serction and mark it with the provided version and build number. And it will create a new and empty unreleased section with the previous dependency info.

### Extract unreleased changes

If you want to get all the unreleased changes, for example to generate a version specific changelog for Testflight releases, you can use the `extract` command:
```
changelogger extract
```
By using this command the changelogger will generate a `CHANGES.md` file containing all changes of the unreleased section.

### Resolve weblinks

To resolve the provided ticket numbers to markdown links to the corresponding weblinks of the tickets, use the command `resolve`:
```
changelogger extract <config-file-path>
```

## Further information

For more information, see the help section

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
