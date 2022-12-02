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
        NavigationStack {
            List {
                ForEach(viewModel.workouts) { workout in
                    NavigationLink {
                        WorkoutDetailsView(dataController: viewModel.dataController, workout: workout)
                    } label: {
                        Text("\(workout.unwrappedType) workout on \(workout.formattedNumericDateTimeOmitted)")
                    }
                }
            }
            .navigationTitle("Workouts")
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
        }
        .onAppear(perform: viewModel.setupWorkoutsController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutsView(dataController: DataController.preview)
        }
    }
}
