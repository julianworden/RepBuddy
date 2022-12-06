//
//  RepSetsListViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import CoreData
import Foundation

extension RepSetsListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchRepSet(in: exercise, and: workout)
    }
}
