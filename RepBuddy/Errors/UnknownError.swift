//
//  UnknownError.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/7/22.
//

import Foundation

enum UnknownError: Error, LocalizedError {
    case unexpectedNilValue
    case coreData(systemError: String)

    var errorDescription: String? {
        switch self {
        case .unexpectedNilValue:
            return "Something went wrong. Please restart Rep Buddy and try again."
        case .coreData(let systemError):
            return "Something went wrong. Please restart Rep Buddy and try again. System Error: \(systemError)"
        }
    }
}
