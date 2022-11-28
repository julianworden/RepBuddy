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
        NavigationStack {
            List {
                ForEach(viewModel.workouts) { workout in
                    NavigationLink {
                        
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
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem {
                    Button {
                        viewModel.addEditWorkoutSheetIsShowing.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.addEditWorkoutSheetIsShowing) {
                AddEditWorkoutView(dataController: viewModel.dataController)
            }
            .onAppear {
                print(viewModel.workouts)
            }
        }
    }
    
    struct WorkoutView_Previews: PreviewProvider {
        static var previews: some View {
            WorkoutsView(dataController: DataController.preview)
        }
    }
