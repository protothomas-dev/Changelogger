//
//  ReleaseCommand.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import ArgumentParser
import Foundation

struct ReleaseCommand: ParsableCommand {
    
    public static let configuration = CommandConfiguration(commandName: "release", abstract: "Rename the current 'Unreleased' section to the given version and build number and create a new 'Unreleased' section atop")
    
    @Argument(help: "The version number")
    private var versionNumber: String
    
    @Argument(help: "The build number")
    private var buildNumber: String
    
    @Argument(default: "CHANGELOG.md", help: "The path to the changelog file")
    private var changelogPath: String
    
    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    @Flag(name: .shortAndLong, help: "Show result without saving it")
    private var dryRun: Bool
    
    func run() throws {
        Log.isVerbose = verbose
        
        var changelog = try Changelog(changelogPath: changelogPath)
        try changelog.createVersion(versionNumber: versionNumber, buildNumber: buildNumber)

        if dryRun {
            Log.message(changelog.text)
        } else {
            Log.debug(changelog.text)
            try changelog.save()
        }
    }

}
