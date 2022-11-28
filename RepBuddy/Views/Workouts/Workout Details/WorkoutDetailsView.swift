//
//  WorkoutDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import SwiftUI

struct WorkoutDetailsView: View {
    @StateObject private var viewModel: WorkoutDetailsViewModel
    
    init(dataController: DataController, workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailsViewModel(dataController: dataController, workout: workout))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Exercises")
                    .font(.title.bold())
                
                Spacer()
            }
            
            ForEach(viewModel.workoutExercises) { exercise in
                HStack {
                    Text(exercise.unwrappedName)
                        .font(.title2)
                    
                    Spacer()
                    
                    Button("Add Set") {
                        viewModel.addSetButtonTapped(for: exercise)
                    }
                    .buttonStyle(.bordered)
                }
                
                if !exercise.repSetArray.isEmpty {
                    ExerciseRepsList(viewModel: viewModel, exercise: exercise)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.workout.formattedNumericDateTimeOmitted)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
        }
        .sheet(
            isPresented: $viewModel.addSetSheetIsShowing,
            onDismiss: { viewModel.repSetToEdit = nil },
            content: {
                if let exercise = viewModel.exercise {
                    NavigationStack {
                        AddEditRepSetView(
                            dataController: viewModel.dataController,
                            workout: viewModel.workout,
                            exercise: exercise,
                            repSetToEdit: viewModel.repSetToEdit
                        )
                    }
                }
            }
        )
    }
}

struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutDetailsView(dataController: DataController.preview, workout: Workout.example)
        }
    }
}
