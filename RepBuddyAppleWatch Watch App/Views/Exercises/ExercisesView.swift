//
//  ExercisesView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import SwiftUI

struct ExercisesView: View {
    @StateObject private var viewModel: ExercisesViewModel

    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: ExercisesViewModel(dataController: dataController))
    }

    var body: some View {
        // NavigationView is necessary or else .scrollDisabled won't work after all exercises are deleted
        NavigationStack {
            ZStack {
                switch viewModel.viewState {
                case .dataLoading:
                    ProgressView()

                case .dataLoaded:
                    List {
                        ForEach(viewModel.exercises) { exercise in
                            NavigationLink {
                                ExerciseDetailsView(dataController: viewModel.dataController, exercise: exercise)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(exercise.unwrappedName)
                                    Text("\(exercise.goalWeight) \(exercise.unwrappedGoalWeightUnit)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }

                case .dataNotFound:
                    NoDataFoundView(message: NoDataFoundConstants.noExercisesFound)

                case .error(let message):
                    EmptyView()
                        .onAppear {
                            print(message)
                        }

                default:
                    NoDataFoundView(message: "Invalid ViewState")
                }
            }
            .navigationTitle("Exercises")
            .scrollDisabled(viewModel.scrollDisabled)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.addEditExerciseSheetIsShowing.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            // Altering viewState in onDismiss to keep first
            .sheet(isPresented: $viewModel.addEditExerciseSheetIsShowing) {
                AddEditExerciseView(dataController: viewModel.dataController)
            }
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(dataController: DataController.shared)
    }
}
