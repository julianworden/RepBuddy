//
//  AddEditRepSetView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import SwiftUI

struct AddEditRepSetView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddEditRepSetViewModel
    
    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSetToEdit: RepSet? = nil
    ) {
        _viewModel = StateObject(
            wrappedValue: AddEditRepSetViewModel(
                dataController: dataController,
                workout: workout,
                exercise: exercise,
                repSetToEdit: repSetToEdit
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("How many reps?") {
                    Stepper("\(viewModel.repCount)", value: $viewModel.repCount)
                        .accessibilityIdentifier("Rep Count Stepper")
                }

                Section("How Heavy? (\(viewModel.exercise.unwrappedGoalWeightUnit))") {
                    Stepper("\(viewModel.repSetWeight)", value: $viewModel.repSetWeight, step: 5)
                }

                Button(viewModel.saveButtonText) {
                    viewModel.confirmButtonTapped()
                    dismiss()
                }
                .foregroundColor(.blue)

                if viewModel.repSetToEdit != nil {
                    Button("Delete Set", role: .destructive) {
                        viewModel.deleteAlertIsShowing.toggle()
                    }
                    .alert("Are You Sure?", isPresented: $viewModel.deleteAlertIsShowing) {
                        Button("Yes", role: .destructive) { viewModel.deleteRepSet(); dismiss() }
                    } message: {
                        Text(AlertConstants.deleteRepSetMessage)
                    }
                }
            }
            .alert(
                "Error",
                isPresented: $viewModel.errorAlertIsShowing,
                actions: {
                    Button("OK") { }
                },
                message: {
                    Text(viewModel.errorAlertText)
                }
            )
        }
    }
}

struct AddEditRepSetView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditRepSetView(dataController: DataController.preview, workout: Workout.example, exercise: Exercise.example)
    }
}
