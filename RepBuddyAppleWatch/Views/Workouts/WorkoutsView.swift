//
//  ContentView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import SwiftUI

struct WorkoutsView: View {
    @StateObject private var viewModel: WorkoutsViewModel
    
    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: WorkoutsViewModel(dataController: dataController))
    }
    
    var body: some View {
        // NavigationView is necessary or else .scrollDisabled won't work after all workouts are deleted
        NavigationView {
            ZStack {
                switch viewModel.viewState {
                case .dataLoading:
                    ProgressView()
                    
                case .dataLoaded:
                    WorkoutsList(viewModel: viewModel)
                        .toolbar {
                            ToolbarItem {
                                Button("Create Workout") {
                                    viewModel.addWorkoutSheetIsShowing.toggle()
                                }
                                .tint(.blue)
                            }
                        }

                case .dataNotFound:
                    VStack {
                        NoDataFoundView(message: "You haven't created any workouts.")

                        Button("Create Workout") {
                            viewModel.addWorkoutSheetIsShowing.toggle()
                        }
                        .tint(.blue)
                    }
                    
                case .error:
                    EmptyView()
                    
                default:
                    NoDataFoundView(message: "Invalid ViewState")
                }
            }
            .navigationTitle("Workouts")
            .scrollDisabled(viewModel.scrollDisabled)
            .sheet(isPresented: $viewModel.addWorkoutSheetIsShowing) {
                AddEditWorkoutView(dataController: viewModel.dataController)
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
            .onAppear {
                viewModel.setupWorkoutsController()
                viewModel.getWorkouts()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutsView(dataController: DataController.preview)
        }
    }
}
