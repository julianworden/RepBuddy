//
//  FormValidationError.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/7/22.
//

import Foundation

enum FormValidationError: Error, LocalizedError {
    case emptyFields

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "The form is incomplete. Please ensure you've filled all required fields"
        }
    }
}
