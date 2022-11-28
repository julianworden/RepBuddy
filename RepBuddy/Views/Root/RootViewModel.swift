//
//  RootViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

final class RootViewModel: ObservableObject {
    let dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
}
