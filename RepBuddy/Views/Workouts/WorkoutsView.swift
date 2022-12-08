//
//  WorkoutsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject private var viewModel: WorkoutsViewModel
    
    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: WorkoutsViewModel(dataController: dataController))
    }
    
    var body: some View {
        // TODO: Try using a NavigationStack in a later update, bug with title size transition
        NavigationView {
            ZStack {
                switch viewModel.viewState {
                case .dataLoading:
                    ProgressView()

                case .dataLoaded:
                    List {
                        ForEach(viewModel.workouts) { workout in
                            NavigationLink {
                                WorkoutDetailsView(dataController: viewModel.dataController, workout: workout)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("Workout on \(workout.unwrappedDate.numericDateNoTime)")

                                    Text("\(workout.unwrappedType) workout")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteWorkout(at: indexSet)
                        }
                    }

                case .dataNotFound:
                    NoDataFoundView(message: NoDataFoundConstants.noWorkoutsFound)

                case .error:
                    EmptyView()

                default:
                    NoDataFoundView(message: "Invalid ViewState")
                }
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                
                ToolbarItem {
                    Button {
                        viewModel.addEditWorkoutSheetIsShowing.toggle()
                    } label: {
                        Image(systemName: "plus")
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
            .sheet(isPresented: $viewModel.addEditWorkoutSheetIsShowing) {
                AddEditWorkoutView(dataController: viewModel.dataController)
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView(dataController: DataController.preview)
    }
}
