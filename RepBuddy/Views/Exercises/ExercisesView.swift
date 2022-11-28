//
//  ContentView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI
import CoreData

struct ExercisesView: View {
    @StateObject private var viewModel: ExercisesViewModel
    
    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: ExercisesViewModel(dataController: dataController))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.exercises) { exercise in
                    VStack(alignment: .leading) {
                        Text(exercise.unwrappedName)
                        Text("\(exercise.goalWeight) \(exercise.unwrappedGoalWeightUnit)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        viewModel.deleteExercise(at: indexSet)
                    }
                }
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.addEditExerciseSheetIsShowing.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.addEditExerciseSheetIsShowing) {
                AddEditExerciseView(dataController: viewModel.dataController)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(dataController: DataController.preview)
    }
}