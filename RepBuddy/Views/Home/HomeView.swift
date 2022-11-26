//
//  ContentView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(dataController: dataController))
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
                        viewModel.addExerciseSheetIsShowing.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.addExerciseSheetIsShowing) {
                AddEditExerciseView(dataController: viewModel.dataController)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}
