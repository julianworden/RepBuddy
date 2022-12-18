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
        ZStack {
            switch viewModel.viewState {
            case .displayingView:
                ScrollView {
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(viewModel.workout.unwrappedType) Workout")
                                    .font(.largeTitle.bold())
                                    .multilineTextAlignment(.leading)

                                Label(viewModel.workout.formattedNumericDateTimeOmitted, systemImage: "calendar")
                            }

                            Spacer()

                            Image(viewModel.workout.unwrappedType)
                        }

                        Divider()

                        HStack {
                            Text("Exercises")
                                .font(.title)

                            Spacer()

                            Button {
                                sheetNavigator.addExerciseButtonTapped()
                            } label: {
                                Image(systemName: "plus")
                            }
                            .accessibilityIdentifier("Add Exercise")
                        }

                        ExercisesList(viewModel: viewModel, sheetNavigator: sheetNavigator)

                        Spacer()
                    }
                    .padding(.horizontal)
                }

            case .error, .dataDeleted:
                EmptyView()

            default:
                NoDataFoundView(message: "Invalid ViewState")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
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
