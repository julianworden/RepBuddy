//
//  AddEditWorkoutViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

final class AddEditWorkoutViewModel: ObservableObject {
    @Published var workoutDate = Date()
    @Published var workoutType = WorkoutType.arms
    @Published var dismissView = false
    
    var workoutToEdit: Workout?
    
    var navigationTitle: String {
        workoutToEdit == nil ? "Add Workout" : "Edit Workout"
    }
    
    var saveButtonText: String {
        workoutToEdit == nil ? "Save Workout" : "Update Workout"
    }
    
    let dataController: DataController
    
    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        self.dataController = dataController
        self.workoutToEdit = workoutToEdit
        
        if let workoutToEdit {
            workoutDate = workoutToEdit.unwrappedDate
            workoutType = WorkoutType(rawValue: workoutToEdit.unwrappedType)!
        }
    }
    
    func saveButtonTapped() {
        if workoutToEdit == nil {
            saveWorkout()
        } else {
            updateWorkout()
        }
        
        dismissView.toggle()
    }
    
    func saveWorkout() {
        let newWorkout = Workout(context: dataController.moc)
        newWorkout.id = UUID()
        newWorkout.date = workoutDate
        newWorkout.type = workoutType.rawValue

        save()
    }
    
    func updateWorkout() {
        guard let workoutToEdit else { return }
        
        workoutToEdit.date = workoutDate
        workoutToEdit.type = workoutType.rawValue

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
