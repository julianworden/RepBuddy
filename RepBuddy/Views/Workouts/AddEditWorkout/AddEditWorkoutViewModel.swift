//
//  AddEditWorkoutViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

final class AddEditWorkoutViewModel: ObservableObject {
    @Published var workoutDate = Date()
    @Published var workoutExercises = [Exercise]()
    @Published var workoutType = WorkoutType.arms
    
    var formattedWorkoutExercises: String {
        let exerciseNamesArray = workoutExercises.map { $0.unwrappedName }
        return exerciseNamesArray.joined(separator: ", ")
    }
    
    let dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func saveWorkout() {
        let newWorkout = Workout(context: dataController.moc)
        newWorkout.id = UUID()
        newWorkout.date = workoutDate
        newWorkout.type = workoutType.rawValue
        newWorkout.exercises = NSSet(array: workoutExercises)
        
        do {
            try dataController.moc.save()
        } catch {
            print("Failed to save new workout.")
        }
    }
    
    func addSelectedExercisesObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(exercisesSelected(_:)), name: .exercisesSelected, object: nil)
    }
    
    @objc func exercisesSelected(_ notification: Notification) {
        if let workoutExercises = notification.userInfo?[NotificationConstants.exercises] as? [Exercise] {
            self.workoutExercises = workoutExercises
        }
    }
}
