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

    var exerciseToEdit: Exercise?
    let dataController: DataController

    var formIsCompleted: Bool {
        !exerciseName.isReallyEmpty
    }

    var navigationTitle: String {
        exerciseToEdit == nil ? "Add Exercise" : "Edit Exercise"
    }

    var saveButtonText: String {
        exerciseToEdit == nil ? "Save Exercise" : "Update Exercise"
    }

    var goalSectionHeaderText: String {
        exerciseToEdit == nil ? "What's your goal?" : "What's your goal? (\(exerciseToEdit!.unwrappedGoalWeightUnit))"
    }
    
    init(dataController: DataController, exerciseToEdit: Exercise?) {
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

        let newExercise = Exercise(context: dataController.moc)
        newExercise.id = UUID()
        newExercise.name = exerciseName
        newExercise.goalWeight = Int16(exerciseWeightGoal)
        newExercise.goalWeightUnit = exerciseWeightGoalUnit.rawValue

        save()
    }

    func updateExercise() {
        guard let exerciseToEdit else {
            viewState = .error(message: UnknownError.unexpectedNilValue.localizedDescription)
            return
        }

        exerciseToEdit.name = exerciseName
        exerciseToEdit.goalWeight = Int16(exerciseWeightGoal)
        exerciseToEdit.goalWeightUnit = exerciseWeightGoalUnit.rawValue

        save()
    }

    func save() {
        guard dataController.moc.hasChanges else {
            print("moc has no changes, save not performed")
            return
        }

        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
