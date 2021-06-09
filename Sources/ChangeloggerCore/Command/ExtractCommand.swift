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
    
    public static let configuration = CommandConfiguration(commandName: "extract", abstract: "Extract the changes of current 'Unreleased' section")
    
    @Argument(default: "CHANGELOG.md", help: "The path to the changelog file")
    private var changelogPath: String
    
    @Option(name: .shortAndLong, help: "The path to the folder to which the extracted content should be saved to")
    private var outputPath: String?

    @Option(name: .shortAndLong, help: "The path to the changelog config file")
    private var configPath: String?
    
    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    @Flag(name: .shortAndLong, help: "Show result without saving it")
    private var dryRun: Bool
    
    func run() throws {
        Log.isVerbose = verbose
        
        let changelog = try Changelog(changelogPath: changelogPath, configPath: configPath)
        let unreleasedChanges = try changelog.unreleasedChanges()
        
        if dryRun {
            Log.message(unreleasedChanges)
        } else {
            Log.debug(unreleasedChanges)
            
            var path = ""
            
            if let filepath = outputPath {
                let folder = Folder.current
                let file = try folder.createFileIfNeeded(at: filepath)
                path = file.path
            } else {
                let folder = Folder.current
                let file = try folder.createFile(named: "CHANGES.md")
                path = file.path
            }
            
            try unreleasedChanges.write(toFile: path, atomically: true, encoding: .utf16)
        }
    }
    
}
