//
//  ReleaseCommand.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import ArgumentParser
import Files
import Foundation

struct ReleaseCommand: ParsableCommand {
    
    public static let configuration = CommandConfiguration(commandName: "release", abstract: "Extracts the unreleased changes and closes the current 'Unreleased' section by renaming the section to the given version and build number and create a new 'Unreleased' section atop")
    
    @Argument(help: "The version number")
    private var versionNumber: String
    
    @Argument(help: "The build number")
    private var buildNumber: String
    
    @Argument(default: "CHANGELOG.md", help: "The path to the changelog file. If set, the links within the unreleased changes will be resolved")
    private var changelogPath: String

    @Option(name: .shortAndLong, default: "CHANGES.md", help: "The path to the folder to which the extracted content should be saved to")
    private var outputPath: String

    @Option(name: .shortAndLong, help: "The path to the changelog config file. If set, the links within the unreleased changes will be resolved")
    private var configPath: String?
    
    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    @Flag(name: .shortAndLong, help: "Show result without saving it")
    private var dryRun: Bool
    
    func run() throws {
        Log.isVerbose = verbose

        // If configPath is set,
        var changelog = try Changelog(changelogPath: changelogPath, configPath: configPath)
        try changelog.updateAllTicketLinks()
        let unreleasedChanges = try changelog.unreleasedChanges()
        try changelog.createVersion(versionNumber: versionNumber, buildNumber: buildNumber)

        if dryRun {
            Log.message("Changelog: \(changelog.text)")
            Log.message("Unreleased: \(unreleasedChanges)")
        } else {
            Log.debug("Changelog: \(changelog.text)")
            Log.debug("Unreleased: \(unreleasedChanges)")
            try changelog.save()

            let folder = Folder.current
            let file = try folder.createFileIfNeeded(at: outputPath)
            let path = file.path

            try unreleasedChanges.write(toFile: path, atomically: true, encoding: .utf16)
        }
    }

}
