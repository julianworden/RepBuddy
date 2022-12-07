//
//  AddEditRepSetViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Foundation

class AddEditRepSetViewModel: ObservableObject {
    @Published var repCount = ""
    @Published var repSetWeight = ""
    @Published var dismissView = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var deleteRepSetAlertIsShowing = false

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing = true

            default:
                errorAlertText = "Invalid ViewState"
                errorAlertIsShowing = true
            }
        }
    }
    
    let dataController: DataController
    let workout: Workout
    let exercise: Exercise
    var repSetToEdit: RepSet?
    
    var navigationBarTitleText: String {
        repSetToEdit == nil ? "Create Set" : "Update Set"
    }

    var saveButtonText: String {
        repSetToEdit == nil ? "Create Set" : "Update Set"
    }

    var formIsCompleted: Bool {
        !repCount.isReallyEmpty && !repSetWeight.isReallyEmpty
    }
    
    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSetToEdit: RepSet? = nil
    ) {
        self.dataController = dataController
        self.workout = workout
        self.exercise = exercise
        self.repSetToEdit = repSetToEdit
        
        if let repSetToEdit {
            repCount = String(repSetToEdit.reps)
            repSetWeight = String(repSetToEdit.weight)
        }
    }
    
    func confirmButtonTapped() {
        guard formIsCompleted else {
            viewState = .error(message: FormValidationError.emptyFields.localizedDescription)
            return
        }

        if repSetToEdit == nil {
            saveRepSet()
        } else {
            updateRepSet()
        }
        
        dismissView.toggle()
    }
    
    func saveRepSet() {
        let repSet = RepSet(context: dataController.moc)

        repSet.date = Date.now
        repSet.reps = Int16(repCount) ?? 0
        repSet.weight = Int16(repSetWeight) ?? 0
        repSet.exercise = exercise
        repSet.workout = workout
        
        save()
    }
    
    func updateRepSet() {
        guard let repSetToEdit else {
            viewState = .error(message: "Something went wrong. Please restart Rep Buddy and try again.")
            return
        }
        
        repSetToEdit.reps = Int16(repCount) ?? 0
        repSetToEdit.weight = Int16(repSetWeight) ?? 0
        repSetToEdit.exercise = exercise

        save()
    }
    
    func deleteRepSet() {
        guard let repSetToEdit else {
            viewState = .error(message: UnknownError.unexpectedNilValue.localizedDescription)
            return
        }
        
        exercise.removeFromRepSet(repSetToEdit)
        dataController.moc.delete(repSetToEdit)
        
        save()
        
        dismissView.toggle()
    }
    
    func save() {
        guard dataController.moc.hasChanges else { print("No changes detected for save"); return }
        
        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
