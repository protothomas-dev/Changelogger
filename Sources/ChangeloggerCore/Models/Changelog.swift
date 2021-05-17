//
//  Changelog.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import Foundation

struct Changelog {
    
    // MARK: - Properties
    
    var text: String
    private let changelogPath: String
    private let config: ChangelogConfiguration?
    
    // MARK: - Init
    
    init(changelogPath: String, configPath: String? = nil) throws {
        self.text = try String(contentsOfFile: changelogPath)
        self.changelogPath = changelogPath
        
        guard let configPath = configPath else {
            config = nil
            return
        }
        
        let configData = try Data(contentsOf: URL(fileURLWithPath: configPath))
        let decoder = JSONDecoder()
        self.config = try decoder.decode(ChangelogConfiguration.self, from: configData)
    }
    
    // MARK: - Public
    
    mutating func updateTicketLinks() throws {
        guard let config = config else {
            throw ChangelogError.noConfiguration
        }
        
        var newText = text
        
        let ticketNumberRegex = try NSRegularExpression(pattern: "\\[\(config.ticketPrefix)\\-(\\d*)\\][^\\(]")
        var range = NSRange(location: 0, length: newText.utf16.count)
        
        while let match = ticketNumberRegex.firstMatch(in: newText, options: [], range: range) {
            guard let ticketNumberRange = Range(match.range(at: 1), in: newText),
                let fullRange = Range(match.range, in: newText) else {
                    Log.debug("No unresolved ticket number found")
                    return
            }
            let ticketNumber = String(newText[ticketNumberRange])
            
            Log.debug("Found unresolved ticket number \(ticketNumber)")
            
            newText = newText.replacingCharacters(in: fullRange, with: "[\(config.ticketPrefix)-\(ticketNumber)](\(config.ticketURLScheme)\(config.ticketPrefix)-\(ticketNumber)):")
            range = NSRange(location: 0, length: newText.utf16.count)
        }
        
        self.text = newText
    }
    
    public mutating func createVersion(version: String, build: String) throws {
        guard let dependencies = try dependencyVersionsBlock() else { return }
        
        text = text.replacingOccurrences(of: "## Unreleased", with: """
        ## Unreleased
            
        \(dependencies)
            
        ---
            
        ## Version \(version) (\(build))
        """)
    }
    
    func unreleasedChanges() throws -> String {
        let changesRegex = try NSRegularExpression(pattern: "Unreleased\\X\\X(?<unreleased>[\\s\\S]*?)\\-\\-\\-")
        let range = NSRange(location: 0, length: text.utf16.count)

        if let firstMatch = changesRegex.firstMatch(in: text, options: [], range: range),
            let range = Range(firstMatch.range(withName: "unreleased"), in: text) {
            return String(text[range])
        } else {
            throw ChangelogError.noChanges
        }
    }
    
    func save() throws {
        try text.write(toFile: changelogPath, atomically: true, encoding: .utf16)
    }
    
    // MARK: - Internal
    
    private func dependencyVersionsBlock() throws -> String? {
        let unreleasedChanges = try unreleasedChanges()

        let sdkVersionRegEx = try! NSRegularExpression(pattern: "(#{4}[A-Za-z0-9.\\s]+)")
        let regexRange = NSRange(location: 0, length: unreleasedChanges.utf16.count)

        let matches = sdkVersionRegEx.matches(in: unreleasedChanges, options: [], range: regexRange)
            .map { Range($0.range, in: unreleasedChanges) }
            .compactMap { $0 }
            .map { (range: Range) -> String in
                return String(unreleasedChanges[range]).replacingOccurrences(of: "\n", with: "")
            }

        guard !matches.isEmpty else { return nil }

        return matches.joined(separator: "\n")
    }
    
}

enum ChangelogError: Error {
    case noConfiguration
    case noChanges
    case noSDKVersion
}
