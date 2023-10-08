//
//  Changelogger.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import Foundation
import ArgumentParser

public struct Changelogger: ParsableCommand {
    
    public static let configuration = CommandConfiguration(commandName: "changelogger", abstract: "A Swift command-line tool to manage the changelog", subcommands: [ReleaseCommand.self, ExtractCommand.self, ResolveCommand.self, CloseUnreleasedCommand.self, VersionCommand.self])
    
    public init() { }
    
}
