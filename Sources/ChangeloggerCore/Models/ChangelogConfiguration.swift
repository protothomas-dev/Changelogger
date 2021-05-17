//
//  ChangelogConfiguration.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import Foundation

struct ChangelogConfiguration: Decodable {
    let ticketURLScheme: String
    let ticketPrefix: String
}
