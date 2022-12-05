//
//  AddEditWorkoutViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import Foundation

class AddEditWorkoutViewModel: ObservableObject {
    @Published var workoutType = WorkoutType.arms

    let dataController: DataController
    var workoutToEdit: Workout?

    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        self.dataController = dataController
        self.workoutToEdit = workoutToEdit
    }

    func saveButtonTapped() {
        saveWorkout()
    }

    func saveWorkout() {
        let newWorkout = Workout(context: dataController.moc)
        newWorkout.id = UUID()
        newWorkout.date = Date()
        newWorkout.type = workoutType.rawValue

        save()
    }

    func deleteWorkout() {
        guard let workoutToEdit else { return }

        dataController.moc.delete(workoutToEdit)
        save()
    }

    func save() {
        guard dataController.moc.hasChanges else { return }

        do {
            try dataController.moc.save()
        } catch {
            print("Failed to save")
        }
    }
}
