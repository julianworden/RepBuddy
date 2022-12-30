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
            createWorkout()
        } else {
            updateWorkout()
        }
        
        dismissView.toggle()
    }
    
    func createWorkout() {
        do {
            _ = dataController.createWorkout(type: workoutType, date: workoutDate)
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func updateWorkout() {
        guard let workoutToEdit else { return }

        do {
            _ = dataController.updateWorkout(workoutToEdit: workoutToEdit, type: workoutType, date: workoutDate)
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func deleteWorkout() {
        guard let workoutToEdit else { return }

        do {
            dataController.deleteWorkout(workoutToEdit)
            try dataController.save()
            dismissView.toggle()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
