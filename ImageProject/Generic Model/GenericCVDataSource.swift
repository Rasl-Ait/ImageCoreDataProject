//
//  GenericCVDataSource.swift
//  ImageProject
//
//  Created by rasl on 22.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit
import CoreData

class GenericCVDataSource<V: UICollectionViewCell, T: NSManagedObject>: NSObject, UICollectionViewDataSource, FetchedResultsProviderDelegate where T : ManagedObjectType  {
	
	var cellIdentifier: String!
	var fetchedResultsProvider: FetchedResultsProvider<T>?
	typealias CellConfiguration = (V, T) -> ()
	private let configureCell: CellConfiguration
	var collectionView : UICollectionView!
	
	init(cellIdentifier : String,collectionView :UICollectionView, fetchedResultsProvider :FetchedResultsProvider<T>, configureCell : @escaping CellConfiguration) {
		self.cellIdentifier = cellIdentifier
		self.fetchedResultsProvider = fetchedResultsProvider
		self.configureCell = configureCell
		self.collectionView = collectionView
		
		super.init()
		
		self.fetchedResultsProvider?.delegate = self
		
	}
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchedResultsProvider?.numberOfRowsInSection() ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: V = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! V
		if let model: T = fetchedResultsProvider?.objectAtIndex(indexPath: indexPath) {
			configureCell(cell, model)
		}
		return cell
	}
	
	func fetchedResultsProviderDidInsert(indexPath: IndexPath) {
		self.collectionView.insertItems(at: [indexPath])
	}
	
	func fetchedResultsProviderDidDelete(indexPath: IndexPath) {
		self.collectionView.deleteItems(at: [indexPath])
	}
}


