//
//  AddEditExerciseViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

class AddEditExerciseViewModel: ObservableObject {
    @Published var exerciseName = ""
    
    @Published var exerciseWeightGoal = 60
    @Published var exerciseWeightGoalUnit = WeightUnit.pounds

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

    @Published var dismissView = false
    @Published var deleteExerciseAlertIsShowing = false

    var exerciseToEdit: Exercise?
    
    let dataController: DataController

    var saveButtonText: String {
        exerciseToEdit == nil ? "Save Exercise" : "Update Exercise"
    }

    var formIsCompleted: Bool {
        !exerciseName.isReallyEmpty
    }
    
    init(dataController: DataController, exerciseToEdit: Exercise? = nil) {
        self.dataController = dataController
        self.exerciseToEdit = exerciseToEdit
        
        if let exerciseToEdit {
            self.exerciseName = exerciseToEdit.unwrappedName
            self.exerciseWeightGoal = Int(exerciseToEdit.goalWeight)
            self.exerciseWeightGoalUnit = WeightUnit(rawValue: exerciseToEdit.unwrappedGoalWeightUnit)!
        }
    }

    func saveButtonTapped() {
        exerciseToEdit == nil ? saveExercise() : updateExercise()

        dismissView.toggle()
    }
    
    func saveExercise() {
        guard formIsCompleted else {
            viewState = .error(message: FormValidationError.emptyFields.localizedDescription)
            return
        }

        do {
            _ = dataController.createExercise(
                name: exerciseName,
                goalWeight: exerciseWeightGoal,
                goalWeightUnit: exerciseWeightGoalUnit
            )
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func updateExercise() {
        guard let exerciseToEdit else {
            viewState = .error(message: UnknownError.unexpectedNilValue.localizedDescription)
            return
        }

        do {
            _ = dataController.updateExercise(
                exerciseToEdit: exerciseToEdit,
                name: exerciseName,
                goalWeight: exerciseWeightGoal,
                goalWeightUnit: exerciseWeightGoalUnit.rawValue
            )
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func deleteExercise() {
        guard let exerciseToEdit else { return }

        do {
            dataController.deleteExercise(exerciseToEdit)
            try dataController.save()
            dismissView.toggle()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
