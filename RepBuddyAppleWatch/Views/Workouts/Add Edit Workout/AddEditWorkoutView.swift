//
//  AddEditWorkoutView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import SwiftUI

struct AddEditWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddEditWorkoutViewModel
    
    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        _viewModel = StateObject(wrappedValue: AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: workoutToEdit))
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Type", selection: $viewModel.workoutType) {
                    ForEach(WorkoutType.allCases) {
                        Text($0.rawValue)
                    }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.addEditWorkoutTypePicker)
            } footer: {
                Text("Workout date can only be altered via the iOS app.")
            }
            
            Button {
                viewModel.saveButtonTapped()
                dismiss()
            } label: {
                Text(viewModel.saveButtonText)
            }
            .foregroundColor(.blue)
            
            if viewModel.workoutToEdit != nil {
                Button("Delete Workout", role: .destructive) {
                    viewModel.deleteWorkoutAlertIsShowing.toggle()
                }
                .alert("Are You Sure?", isPresented: $viewModel.deleteWorkoutAlertIsShowing) {
                    Button("Yes", role: .destructive) { viewModel.deleteWorkout(); dismiss() }
                } message: {
                    Text(AlertConstants.deleteWorkoutMessage)
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

struct AddEditWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditWorkoutView(dataController: DataController.preview)
    }
}
