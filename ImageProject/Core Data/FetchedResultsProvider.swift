//
//  FetchedResultsProvider.swift
//  ImageProject
//
//  Created by rasl on 22.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import Foundation
import CoreData

protocol FetchedResultsProviderDelegate : class {
	func fetchedResultsProviderDidInsert(indexPath :IndexPath)
	func fetchedResultsProviderDidDelete(indexPath :IndexPath)
}

class FetchedResultsProvider<T :NSManagedObject> : NSObject, NSFetchedResultsControllerDelegate where T: ManagedObjectType {
	
	weak var delegate :FetchedResultsProviderDelegate!
	var managedObjectContext: NSManagedObjectContext?
	var fetchedResultsController: NSFetchedResultsController<T>?
	var descriptor: String!
	
	init(managedObjectContext: NSManagedObjectContext, descriptor: String) {
		self.managedObjectContext = managedObjectContext
		self.descriptor = descriptor
		
		let request = NSFetchRequest<T>(entityName: T.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: descriptor, ascending: true)]
		fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
																													managedObjectContext: managedObjectContext,
																													sectionNameKeyPath: nil,
																													cacheName: nil)
		super.init()
		fetchedResultsController?.delegate = self
		
		do {
			try fetchedResultsController?.performFetch()
			
		} catch {
			print("fetch request failed")
		}
	}
	
	func delete(model: T) {
		guard let context = managedObjectContext else { return }
		context.delete(model)
		
		do {
			try context.save()
		} catch {
			fatalError("error")
		}
	}
	
	func numberOfSections() -> Int {
		return fetchedResultsController?.sections?.count ?? 0
	}
	
	func numberOfRowsInSection() -> Int {
		return fetchedResultsController?.fetchedObjects?.count ?? 0
		
	}
	
	
	func objectAtIndex(indexPath :IndexPath) -> T {
		
		return fetchedResultsController!.object(at: indexPath)
	}
	
	
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		if type == .insert {
			delegate.fetchedResultsProviderDidInsert(indexPath: newIndexPath!)
		} else if type == .delete {
			delegate.fetchedResultsProviderDidDelete(indexPath: indexPath!)
		}
	}
}


extension FetchedResultsProvider {
	var photos: [T] {
		guard let objects = fetchedResultsController?.sections?.first?.objects as? [T] else {
			return []
		}
		
		return objects
	}
}
