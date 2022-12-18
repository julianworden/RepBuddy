//
//  AddEditWorkoutView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct AddEditWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddEditWorkoutViewModel
    
    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        _viewModel = StateObject(wrappedValue: AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: workoutToEdit))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Type", selection: $viewModel.workoutType) {
                        ForEach(WorkoutType.allCases) {
                            Text($0.rawValue)
                        }
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.addEditWorkoutTypePicker)

                    DatePicker("Date", selection: $viewModel.workoutDate, displayedComponents: .date)
                }
                
                Section {
                    Button(viewModel.saveButtonText) {
                        viewModel.saveButtonTapped()
                    }

                    if viewModel.workoutToEdit != nil {
                        Button("Delete Workout", role: .destructive) {
                            viewModel.deleteWorkoutAlertIsShowing.toggle()
                        }
                        .alert(
                            "Are You Sure?",
                            isPresented: $viewModel.deleteWorkoutAlertIsShowing,
                            actions: {
                                Button("Cancel", role: .cancel) { }
                                Button("Yes", role: .destructive) { viewModel.deleteWorkout() }
                            },
                            message: {
                                Text(AlertConstants.deleteWorkoutMessage)
                            }
                        )
                    }
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        viewModel.dismissView.toggle()
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
            .onChange(of: viewModel.dismissView) { _ in
                dismiss()
            }
        }
    }
}

struct AddEditWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditWorkoutView(dataController: DataController.preview)
    }
}
