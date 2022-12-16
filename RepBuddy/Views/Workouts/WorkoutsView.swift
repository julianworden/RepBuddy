//
//  WorkoutsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct WorkoutsView: View {
    @State private var editMode = EditMode.inactive

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
                                    Text(workout.unwrappedDate.numericDateNoTime)

                                    Text("\(workout.unwrappedType) Workout")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteWorkout(at: indexSet)

                            if viewModel.workouts.isEmpty {
                                $editMode.wrappedValue = .inactive
                            }
                        }
                    }

                case .dataNotFound:
                    NoDataFoundView(message: "You haven't created any workouts. Use the plus button to create one!")
                        .padding(.horizontal)

                case .error:
                    EmptyView()

                default:
                    NoDataFoundView(message: "Invalid ViewState")
                }
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !viewModel.workouts.isEmpty {
                    ToolbarItem {
                        EditButton()
                    }
                }
                
                ToolbarItem {
                    Button {
                        viewModel.addEditWorkoutSheetIsShowing.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
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
