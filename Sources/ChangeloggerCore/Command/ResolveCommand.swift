//
//  ResolveCommand.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import ArgumentParser
import Foundation

struct ResolveCommand: ParsableCommand {
    
    public static let configuration = CommandConfiguration(commandName: "resolve", abstract: "Resolve the provided ticket numbers to markdown links to the corresponding URLs to the tickets")
    
    @Argument(help: "The path to the changelog file")
    private var changelogPath: String = "CHANGELOG.md"
    
    @Argument(help: "The path to the changelog config file")
    private var configPath: String = "CHANGELOGGERCONFIG"
    
    @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Show result without saving it")
    private var dryRun: Bool
    
    func run() throws {
        Log.isVerbose = verbose
        
        var changelog = try Changelog(changelogPath: changelogPath, configPath: configPath)
        try changelog.updateAllTicketLinks()

        if dryRun {
            Log.message(changelog.text)
        } else {
            Log.debug(changelog.text)
            try changelog.save()
        }
    }
    
}
