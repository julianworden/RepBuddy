//
//  AddEditExerciseView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct AddEditExerciseView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddEditExerciseViewModel
    
    init(dataController: DataController, exerciseToEdit: Exercise? = nil) {
        _viewModel = StateObject(wrappedValue: AddEditExerciseViewModel(dataController: dataController, exerciseToEdit: exerciseToEdit))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name (required)", text: $viewModel.exerciseName)
                
                Section(viewModel.goalSectionHeaderText) {
                    TextField("Weight goal", value: $viewModel.exerciseWeightGoal, format: .number)

                    if viewModel.exerciseToEdit == nil {
                        Picker("Unit of measurement", selection: $viewModel.exerciseWeightGoalUnit) {
                            ForEach(WeightUnit.allCases) {
                                Text($0.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section {
                    Button(viewModel.saveButtonText) {
                        viewModel.saveButtonTapped()
                    }

                    if viewModel.exerciseToEdit != nil {
                        Button("Delete Exercise", role: .destructive) {
                            viewModel.deleteExerciseAlertIsShowing.toggle()
                        }
                        .alert(
                            "Are You Sure?",
                            isPresented: $viewModel.deleteExerciseAlertIsShowing,
                            actions: {
                                Button("Cancel", role: .cancel) { }
                                Button("Yes", role: .destructive) { viewModel.deleteExercise() }
                            },
                            message: {
                                Text(AlertConstants.deleteExerciseMessage)
                            }
                        )
                    }
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
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

struct AddEditExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditExerciseView(dataController: DataController.preview)
    }
}
