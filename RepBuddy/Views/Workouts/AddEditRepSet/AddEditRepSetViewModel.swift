//
//  AddEditRepSetViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Foundation

class AddEditRepSetViewModel: ObservableObject {
    @Published var repSetCount = ""
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
                errorAlertIsShowing.toggle()

            default:
                errorAlertText = "Invalid ViewState"
                errorAlertIsShowing.toggle()
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
        !repSetCount.isReallyEmpty && !repSetWeight.isReallyEmpty
    }

    var repSetCreationDate: Date? {
        let workoutDayDateComponents = Calendar.current.dateComponents(
            [.day, .year, .month],
            from: workout.unwrappedDate
        )
        let setCreationTimeDateComponents = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: Date.now
        )
        let repSetCreationDateComponents = DateComponents(
            year: workoutDayDateComponents.year,
            month: workoutDayDateComponents.month,
            day: workoutDayDateComponents.day,
            hour: setCreationTimeDateComponents.hour,
            minute: setCreationTimeDateComponents.minute,
            second: setCreationTimeDateComponents.second
        )

        return Calendar.current.date(from: repSetCreationDateComponents)
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
            repSetCount = String(repSetToEdit.reps)
            repSetWeight = String(repSetToEdit.weight)
        }
    }
    
    func confirmButtonTapped() {
        guard formIsCompleted else {
            viewState = .error(message: FormValidationError.emptyFields.localizedDescription)
            return
        }

        if repSetToEdit == nil {
            createRepSet()
        } else {
            updateRepSet()
        }
        
        dismissView.toggle()
    }
    
    func createRepSet() {
        do {
            _ = dataController.createRepSet(
                date: repSetCreationDate ?? Date.now,
                reps: Int(repSetCount) ?? 0,
                weight: Int(repSetWeight) ?? 0,
                exercise: exercise,
                workout: workout
            )
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func updateRepSet() {
        guard let repSetToEdit else {
            viewState = .error(message: "Something went wrong. Please restart Rep Buddy and try again.")
            return
        }
        
        do {
            _ = dataController.updateRepSet(
                repSetToEdit: repSetToEdit,
                date: repSetCreationDate ?? Date.now,
                reps: Int(repSetCount) ?? 0,
                weight: Int(repSetWeight) ?? 0
            )
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func deleteRepSet() {
        guard let repSetToEdit else {
            viewState = .error(message: UnknownError.unexpectedNilValue.localizedDescription)
            return
        }

        do {
            dataController.deleteRepSet(repSetToEdit)
            try dataController.save()
            dismissView.toggle()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
