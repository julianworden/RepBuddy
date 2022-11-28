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
    
    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: AddEditWorkoutViewModel(dataController: dataController))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Workout type", selection: $viewModel.workoutType) {
                        ForEach(WorkoutType.allCases) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        ExerciseSelectionView(dataController: viewModel.dataController, selectedExercises: viewModel.workoutExercises)
                    } label: {
                        Text("Select Exercises")
                    }
                    
                    if !viewModel.workoutExercises.isEmpty {
                        Text(viewModel.formattedWorkoutExercises)
                    }
                }
                
                Section {
                    Button("Save") {
                        viewModel.saveWorkout()
                    }
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        viewModel.dismissView.toggle()
                    }
                }
            }
            .onAppear {
                viewModel.addSelectedExercisesObserver()
            }
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
