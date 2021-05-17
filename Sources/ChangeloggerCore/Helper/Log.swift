//
//  Log.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import Foundation

enum Log {
    static var isVerbose: Bool = false

    static func debug(_ message: String) {
        guard isVerbose else { return }
        print(message)
    }

    static func message(_ message: String) {
        print(message)
    }
}
