//
//  Exercise+Helpers.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

extension Exercise {
    var unwrappedId: UUID {
        id ?? UUID()
    }
    
    var unwrappedName: String {
        name ?? "Unknown Name"
    }
    
    var unwrappedGoalWeightUnit: String {
        goalWeightUnit ?? "pounds"
    }

    var formattedGoalWeight: String {
        "\(goalWeight) \(unwrappedGoalWeightUnit.capitalized)"
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

    var workoutsCountDescription: String {
        "\(workoutsArray.count) \(workoutsArray.count != 1 ? "Workouts" : "Workout")"
    }

    var repSetsCountDescription: String {
        "\(repSetArray.count) \(repSetArray.count != 1 ? "Sets" : "Set")"
    }
    
    var repSetArray: [RepSet] {
        let set = repSets as? Set<RepSet> ?? []
        return set.sorted {
            $0.unwrappedDate < $1.unwrappedDate
        }
    }
    
    var repSetCountArray: [Int] {
        repSetArray.map { Int($0.reps) }
    }

    var highestRepSetWeight: Int? {
        if let maximumRepSet = repSetArray.max(by: { $0.weight < $1.weight }) {
            return Int(maximumRepSet.weight)
        } else {
            return nil
        }
    }

    var distanceFromGoalWeight: Int? {
        guard let highestRepSetWeight,
              highestRepSetWeight < goalWeight else {
            return nil
        }

        return Int(goalWeight) - highestRepSetWeight
    }
    
    static var example: Exercise {
        let controller = DataController.preview
        let moc = controller.container.viewContext
        
        let exercise = Exercise(context: moc)
        let workout = Workout(context: moc)
        let repSet = RepSet(context: moc)
        
        repSet.reps = 10
        repSet.weight = 50
        repSet.exercise = exercise

        workout.date = Date.now
        workout.type = WorkoutType.arms.rawValue

        exercise.name = "Decline Press"
        exercise.goalWeight = 100
        exercise.goalWeightUnit = WeightUnit.kilograms.rawValue
        exercise.addToRepSets(repSet)
        exercise.addToWorkouts(workout)
        
        return exercise
    }
}
