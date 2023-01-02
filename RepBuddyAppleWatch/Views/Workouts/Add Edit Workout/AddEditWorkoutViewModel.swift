//
//  AddEditWorkoutViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import Foundation

class AddEditWorkoutViewModel: ObservableObject {
    @Published var workoutType = WorkoutType.arms
    @Published var deleteWorkoutAlertIsShowing = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var viewState = ViewState.dataLoading {
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

    var saveButtonText: String {
        workoutToEdit == nil ? "Save Workout" : "Update Workout"
    }

    let dataController: DataController
    var workoutToEdit: Workout?

    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        self.dataController = dataController
        self.workoutToEdit = workoutToEdit

        if let workoutToEdit {
            self.workoutType = WorkoutType(rawValue: workoutToEdit.unwrappedType)!
        }
    }

    func saveButtonTapped() {
        if workoutToEdit == nil {
            createWorkout()
        } else {
            updateWorkout()
        }
    }

    func createWorkout() {
        do {
            _ = dataController.createWorkout(type: workoutType, date: Date.now)
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func updateWorkout() {
        guard let workoutToEdit else { return }

        do {
            _ = dataController.updateWorkout(workoutToEdit: workoutToEdit, type: workoutType)
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
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
