//
//  AddEditExerciseViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

class AddEditExerciseViewModel: ObservableObject {
    @Published var exerciseName = ""
    
    @Published var exerciseWeightGoal = 20
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

    var formIsCompleted: Bool {
        !exerciseName.isReallyEmpty
    }
    
    init(dataController: DataController, exerciseToEdit: Exercise? = nil) {
        self.dataController = dataController
        if let exerciseToEdit {
            self.exerciseToEdit = exerciseToEdit
            self.exerciseName = exerciseToEdit.unwrappedName
            self.exerciseWeightGoal = Int(exerciseToEdit.goalWeight)
            self.exerciseWeightGoalUnit = WeightUnit(rawValue: exerciseToEdit.unwrappedGoalWeightUnit)!
        }
    }
    
    func saveExercise() {
        guard formIsCompleted else {
            viewState = .error(message: FormValidationError.emptyFields.localizedDescription)
            return
        }

        let newExercise = Exercise(context: dataController.moc)
        newExercise.id = UUID()
        newExercise.name = exerciseName
        newExercise.goalWeight = Int16(exerciseWeightGoal)
        newExercise.goalWeightUnit = exerciseWeightGoalUnit.rawValue

        save()

        dismissView.toggle()
    }

    func deleteExercise() {
        guard let exerciseToEdit else { return }

        dataController.moc.delete(exerciseToEdit)
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
}
