//
//  ExerciseSelectionViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData
import Foundation

final class ExerciseSelectionViewModel: NSObject, ObservableObject {
    @Published var allUserExercises = [Exercise]()
    @Published var selectedExercises = Set<Exercise>() {
        didSet {
            postExercisesSelectedNotification()
        }
    }
    
    let dataController: DataController
    var allUserExercisesController: NSFetchedResultsController<Exercise>!
    var selectedExercisesController: NSFetchedResultsController<Exercise>?
    
    init(dataController: DataController, selectedExercises: [Exercise]) {
        self.dataController = dataController
        self.selectedExercises = Set(selectedExercises)
        super.init()
        
        setUpAllUserExercisesController()
        getAllExercises()
    }
    
    func setUpAllUserExercisesController() {
        let fetchRequest = NSFetchRequest<Exercise>(entityName: CoreDataConstants.Exercise)
        fetchRequest.sortDescriptors = []
        
        allUserExercisesController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        allUserExercisesController.delegate = self
    }
    
    func setUpSelectedExercisesController() {
        let fetchRequest = NSFetchRequest<Exercise>(entityName: CoreDataConstants.Exercise)
        fetchRequest.sortDescriptors = []
    }
    
    func getAllExercises() {
        do {
            try allUserExercisesController.performFetch()
            allUserExercises = allUserExercisesController.fetchedObjects ?? []
        } catch {
            print(error)
        }
    }
    
    func postExercisesSelectedNotification() {
        NotificationCenter.default.post(name: .exercisesSelected, object: nil, userInfo: ["exercises": Array(selectedExercises)])
    }
}
