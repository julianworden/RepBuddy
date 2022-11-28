//
//  Exercise+Helpers.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

extension Exercise {
    var unwrappedName: String {
        name ?? "Unknown Name"
    }
    
    var unwrappedMuscles: [String] {
        muscles ?? []
    }
    
    var unwrappedGoalWeightUnit: String {
        goalWeightUnit ?? "Pounds"
    }
    
    var workoutsArray: [Workout] {
        let set = workouts as? Set<Workout> ?? []
        return set.sorted {
            $0.unwrappedDate < $1.unwrappedDate
        }
    }
}
