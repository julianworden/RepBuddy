//
//  AllExerciseRepSetsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/13/22.
//

import SwiftUI

struct AllExerciseRepSetsView: View {
    @StateObject var viewModel: AllExerciseRepSetsViewModel

    init(dataController: DataController, exercise: Exercise) {
        _viewModel = StateObject(wrappedValue: AllExerciseRepSetsViewModel(dataController: dataController, exercise: exercise))
    }

    var body: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                Section(workout.formattedNumericDateTimeOmitted) {
                    if workout.repSetsArray.isEmpty {
                        Text("No sets found for this workout.")
                    } else {
                        ForEach(workout.repSetsArray) { repSet in
                            if repSet.exercise == viewModel.exercise {
                                Text(repSet.formattedDescription)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("All Sets")
        .navigationBarTitleDisplayMode(.inline)
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
        .onAppear(perform: viewModel.setupExerciseController)
    }
}

struct AllExerciseRepSetsView_Previews: PreviewProvider {
    static var previews: some View {
        AllExerciseRepSetsView(dataController: DataController.preview, exercise: Exercise.example)
    }
}
