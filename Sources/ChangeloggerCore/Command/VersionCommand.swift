//
//  VersionCommand.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 28.06.21.
//

import ArgumentParser
import Files
import Foundation

struct VersionCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(commandName: "version", abstract: "Shows the current version of the Changelogger")

    func run() throws {
        Log.message("0.9.0")
    }

}
