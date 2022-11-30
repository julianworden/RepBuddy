//
//  Workout+Helpers.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

extension Workout {
    var unwrappedId: UUID {
        id ?? UUID()
    }
    
    var unwrappedDate: Date {
        date ?? Date()
    }
    
    var formattedNumericDateTimeOmitted: String {
        unwrappedDate.numericDateNoTime
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
    
    static var example: Workout {
        let controller = DataController.preview
        let moc = controller.container.viewContext
        
        let workout = Workout(context: moc)
        workout.date = Date()
        workout.type = WorkoutType.arms.rawValue
        workout.exercises = NSSet(array: [Exercise.example])
        
        return workout
    }
}
