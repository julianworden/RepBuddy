//
//  AddEditRepSetViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Foundation

class AddEditRepSetViewModel: ObservableObject {
    @Published var repCount = 10
    @Published var repSetWeight = 60

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

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

    @Published var deleteAlertIsShowing = false

    let dataController: DataController
    let workout: Workout
    let exercise: Exercise
    var repSetToEdit: RepSet?

    var saveButtonText: String {
        repSetToEdit == nil ? "Create Set" : "Update Set"
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
            repCount = Int(repSetToEdit.reps)
        }
    }
    
    func confirmButtonTapped() {
        if repSetToEdit == nil {
            saveRepSet()
        } else {
            updateRepSet()
        }
    }
    
    func saveRepSet() {
        let repSet = RepSet(context: dataController.moc)

        repSet.date = Date.now
        repSet.reps = Int16(repCount)
        repSet.weight = Int16(repSetWeight)
        repSet.exercise = exercise
        repSet.workout = workout
        
        save()
    }
    
    func updateRepSet() {
        guard let repSetToEdit else {
            viewState = .error(message: UnknownError.unexpectedNilValue.localizedDescription)
            return
        }
        
        repSetToEdit.reps = Int16(repCount)
        repSetToEdit.weight = Int16(repSetWeight)
        repSetToEdit.exercise = exercise

        save()
    }
    
    func deleteRepSet() {
        guard let repSetToEdit else {
            viewState = .error(message: UnknownError.unexpectedNilValue.localizedDescription)
            return
        }
        
        dataController.moc.delete(repSetToEdit)
        
        save()
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
