//
//  ViewState.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/6/22.
//

import Foundation

enum ViewState: Equatable {
    case dataLoading
    case dataLoaded
    case dataNotFound
    case dataDeleted
    case error(message: String)
}
