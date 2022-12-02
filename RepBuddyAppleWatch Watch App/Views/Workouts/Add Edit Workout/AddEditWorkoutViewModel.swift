//
//  AddEditWorkoutViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import Foundation

class AddEditWorkoutViewModel: ObservableObject {
    @Published var workoutType = WorkoutType.arms

    @Published var dismissView = false

    let dataController: DataController
    var workoutToEdit: Workout?

    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        self.dataController = dataController
        self.workoutToEdit = workoutToEdit
    }

    func saveButtonTapped() {
        saveWorkout()
        dismissView.toggle()
    }

    func saveWorkout() {
        let newWorkout = Workout(context: dataController.moc)
        newWorkout.id = UUID()
        newWorkout.date = Date()
        newWorkout.type = workoutType.rawValue

        save()
    }

    func save() {
        do {
            try dataController.moc.save()
        } catch {
            print("Failed to save")
        }
    }
}
