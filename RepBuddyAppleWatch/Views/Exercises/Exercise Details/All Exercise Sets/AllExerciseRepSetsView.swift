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
        ZStack {
            switch viewModel.viewState {
            case .dataLoading:
                ProgressView()

            case .dataLoaded:
                List {
                    ForEach(viewModel.workouts) { workout in
                        Section(workout.formattedNumericDateTimeOmitted) {
                            if viewModel.getRepSets(in: viewModel.exercise, and: workout).isEmpty {
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

            case .dataNotFound:
                NoDataFoundView(message: NoDataFoundConstants.noWorkoutsFoundForExercise)

            case .error:
                EmptyView()

            default:
                NoDataFoundView(message: "Invalid ViewState")
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
        .onAppear(perform: viewModel.setupWorkoutsController)
    }
}

struct AllExerciseRepSetsView_Previews: PreviewProvider {
    static var previews: some View {
        AllExerciseRepSetsView(dataController: DataController.preview, exercise: Exercise.example)
    }
}
