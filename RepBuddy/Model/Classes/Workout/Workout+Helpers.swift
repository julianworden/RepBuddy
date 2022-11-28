//
//  Workout+Helpers.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

extension Workout {
    var unwrappedDate: Date {
        date ?? Date()
    }
    
    var unwrappedType: String {
        type ?? "Unknown Type"
    }
    
    var exercisesArray: [Exercise] {
        let set = exercises as? Set<Exercise> ?? []
        return set.sorted {
            $0.unwrappedName < $1.unwrappedName
        }
    }
}
