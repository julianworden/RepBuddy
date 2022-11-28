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
    
    var formattedMuscles: String {
        unwrappedMuscles.joined(separator: ", ")
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
    
    var workoutNamesArray: [String] {
        workoutsArray.map { $0.formattedNumericDateTimeOmitted }
    }
    
    static var example: Exercise {
        let controller = DataController.preview
        let moc = controller.container.viewContext
        
        let exercise = Exercise(context: moc)
        exercise.name = "Decline Press"
        exercise.muscles = ["Pectoralis, Triceps"]
        exercise.goalWeight = 100
        exercise.goalWeightUnit = WeightUnit.pounds.rawValue
        exercise.notes = "This exercise is lit!"
        
        return exercise
    }
}
