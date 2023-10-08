//
//  ExtractCommand.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import ArgumentParser
import Files
import Foundation

struct ExtractCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(commandName: "extract",
                                                           abstract:
                                                           """
                                                           Extract the changes of current 'Unreleased' section
                                                           """)

    @Argument(help: "The path to the changelog file")
    private var changelog: String = "CHANGELOG.md"

    @Option(name: .shortAndLong,
            help: "The path to the folder to which the extracted content should be saved to")
    private var output: String = "CHANGES.md"

    @Option(name: .shortAndLong,
            help: "The path to the changelog config file. If set, the links within the unreleased changes will be resolved")
    private var config: String?

    @Flag(name: .shortAndLong,
          inversion: .prefixedNo,
          help: "Show extra logging for debugging purposes")
    private var verbose: Bool

    @Flag(name: .shortAndLong,
          inversion: .prefixedNo,
          help: "Show result without saving it")
    private var dryRun: Bool

    func run() throws {
        Log.isVerbose = verbose

        let changelog = try Changelog(changelogPath: changelog, configPath: config)
        let unreleasedChanges = try changelog.unreleasedChanges()

        if dryRun {
            Log.message(unreleasedChanges)
        } else {
            Log.debug(unreleasedChanges)

            let folder = Folder.current
            let file = try folder.createFileIfNeeded(at: output)
            let path = file.path

            try unreleasedChanges.write(toFile: path, atomically: true, encoding: .utf8)
        }
    }

}
