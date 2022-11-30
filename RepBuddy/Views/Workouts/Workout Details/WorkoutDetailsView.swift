//
//  WorkoutDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import SwiftUI

struct WorkoutDetailsView: View {
    @StateObject private var viewModel: WorkoutDetailsViewModel
    @StateObject private var sheetNavigator: WorkoutDetailsViewSheetNavigator
    
    init(dataController: DataController, workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailsViewModel(dataController: dataController, workout: workout))
        _sheetNavigator = StateObject(wrappedValue: WorkoutDetailsViewSheetNavigator(dataController: dataController, workout: workout))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Exercises")
                    .font(.title.bold())
                
                Spacer()

                Button {
                    sheetNavigator.addExerciseButtonTapped()
                } label: {
                    Image(systemName: "plus")
                }
            }

            ExercisesList(viewModel: viewModel, sheetNavigator: sheetNavigator)
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.workout.formattedNumericDateTimeOmitted)
        .toolbar {
            ToolbarItem {
                Button("Edit") {
                    sheetNavigator.editWorkoutButtonTapped()
                }
            }
        }
        .sheet(
            isPresented: $sheetNavigator.presentSheet,
            content: { sheetNavigator.sheetView() }
        )
        .onAppear {
            viewModel.setupWorkoutController()
        }
    }
}

struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutDetailsView(dataController: DataController.preview, workout: Workout.example)
        }
    }
}
