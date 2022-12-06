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
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .dataLoading:
                    ProgressView()

                case .dataLoaded:
                    WorkoutsList(viewModel: viewModel)

                case .dataNotFound:
                    NoDataFoundView(message: "You haven't created any workouts. Use the plus button to create one!")

                case .error(let message):
                    EmptyView()
                        .onAppear {
                            print(message)
                        }
                }
            }
            .navigationTitle("Workouts")
            .scrollDisabled(viewModel.scrollDisabled)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.addWorkoutButtonTapped()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $viewModel.addWorkoutSheetIsShowing) {
                AddEditWorkoutView(dataController: viewModel.dataController)
            }
            .onAppear(perform: viewModel.setupWorkoutsController)
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
