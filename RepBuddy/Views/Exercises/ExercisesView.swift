//
//  ContentView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI
import CoreData

struct ExercisesView: View {
    @State private var editMode = EditMode.inactive

    @StateObject private var viewModel: ExercisesViewModel
    
    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: ExercisesViewModel(dataController: dataController))
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
                        ForEach(viewModel.exercises) { exercise in
                            NavigationLink {
                                ExerciseDetailsView(dataController: viewModel.dataController, exercise: exercise)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(exercise.unwrappedName)
                                        Text("Goal: \(exercise.formattedGoalWeight)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.trailing)

                                    ExercisesViewGoalProgressView(dataController: viewModel.dataController, exercise: exercise)
                                        .padding(.trailing)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteExercise(at: indexSet)

                            if viewModel.exercises.isEmpty {
                                $editMode.wrappedValue = .inactive
                            }
                        }
                    }

                case .dataNotFound:
                    NoDataFoundView(message: "You haven't created any exercises. Use the plus button to create one!")
                        .padding(.horizontal)

                case .error:
                    EmptyView()

                default:
                    NoDataFoundView(message: "Invalid ViewState")
                }
            }
            .navigationTitle("Exercises")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !viewModel.exercises.isEmpty {
                    ToolbarItem {
                        EditButton()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.addEditExerciseSheetIsShowing.toggle()
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
