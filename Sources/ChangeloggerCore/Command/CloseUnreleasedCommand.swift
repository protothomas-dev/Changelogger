//
//  CloseUnreleasedCommand.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 25.06.21.
//

import ArgumentParser
import Files
import Foundation

struct CloaseUnreleasedCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(commandName: "close-unreleased", abstract: "Rename the current 'Unreleased' section to the given version and build number and create a new 'Unreleased' section atop")

    @Argument(help: "The version number")
    private var versionNumber: String

    @Argument(help: "The build number")
    private var buildNumber: String

    @Argument(help: "The path to the changelog file. If set, the links within the unreleased changes will be resolved")
    private var changelog: String = "CHANGELOG.md"

    @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Show extra logging for debugging purposes")
    private var verbose: Bool

    @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Show result without saving it")
    private var dryRun: Bool

    func run() throws {
        Log.isVerbose = verbose

        var changelog = try Changelog(changelogPath: changelog)
        try changelog.createVersion(versionNumber: versionNumber, buildNumber: buildNumber)

        if dryRun {
            Log.message(changelog.text)
        } else {
            Log.debug(changelog.text)
            try changelog.save()
        }
    }

}
