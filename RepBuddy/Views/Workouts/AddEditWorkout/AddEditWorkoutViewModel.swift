//
//  AddEditWorkoutViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

final class AddEditWorkoutViewModel: ObservableObject {
    @Published var workoutDate = Date.now
    @Published var workoutType = WorkoutType.arms

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""
    @Published var deleteWorkoutAlertIsShowing = false
    @Published var dismissView = false

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing.toggle()

            default:
                errorAlertText = "Invalid ViewState"
                errorAlertIsShowing.toggle()
            }
        }
    }
    
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
        guard dataController.moc.hasChanges else { print("moc has no changes, save not performed"); return }

        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func deleteWorkout() {
        guard let workoutToEdit else { return }

        dataController.moc.delete(workoutToEdit)
        save()

        dismissView.toggle()
    }
}
