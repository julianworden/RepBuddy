//
//  RepSet+Helpers.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/30/22.
//

import Foundation

extension RepSet {
    var formattedWeight: String {
        guard let exercise else { return "" }

        return "\(weight) \(exercise.unwrappedGoalWeightUnit)"
    }

    var formattedDescription: String {
        return "\(reps) \(reps > 1 ? "reps" : "rep") at \(formattedWeight)"
    }
}
