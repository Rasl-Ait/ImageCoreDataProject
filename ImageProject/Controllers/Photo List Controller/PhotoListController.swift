//
//  PhotoListController.swift
//  ImageProject
//
//  Created by rasl on 22.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit
import CoreData

class PhotoListController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	private var fetchedResultsProvider: FetchedResultsProvider<Photo>!
	private var genericDataSource: GenericCVDataSource<PhotoCell, Photo>?
	private let minItemSpacing = 5
	
	let context = CoreDataManager.shared
	
	lazy var photoPickerManager: PhotoPickerManager = {
		let manager = PhotoPickerManager(presentingController: self)
		manager.delegate = self
		return manager
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initialized()
	}
	// MARK: - Actions
	
	@IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
		photoPickerManager.presentPhotoPicker(animated: true)
		
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showPhoto" {
			showPhoto(segue, sender: sender)
			
		}
	}
	
	private func showPhoto(_ segue: UIStoryboardSegue, sender: Any?) {
		guard let cell = sender as? UICollectionViewCell,
			let selectedIndex = collectionView.indexPath(for: cell),
			let pageViewController = segue.destination as? PhotoPageController else { return }
		
		pageViewController.photos = fetchedResultsProvider.photos
		pageViewController.indexPhoto = selectedIndex.row
	}
}

// MARK: - extension PhotoListController

extension PhotoListController {
	private func initialized() {
		configureCollectionView()
		dataSource()
		
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.contentInset =  UIEdgeInsets(top: 20, left: 2, bottom: 5, right: 2)
		
	}
	
	private func dataSource() {
		
		// generic fetched results provide
		fetchedResultsProvider = FetchedResultsProvider(
			managedObjectContext: context.managedObjectContext,
			descriptor: "creationDate"
		)
		
		// generic data source
		genericDataSource = GenericCVDataSource(cellIdentifier : PhotoCell.reuseIdentifier,
																						collectionView : self.collectionView,
																						fetchedResultsProvider : fetchedResultsProvider) { cell, model in
																							cell.photo = model
																							
																							
		}
		
		self.collectionView.dataSource = self.genericDataSource
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoListController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize.zero
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize.zero
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let factor = traitCollection.horizontalSizeClass == .compact ? 2:3
		let screenRect = collectionView.frame.size.width
		let screenWidth = screenRect - (CGFloat(minItemSpacing) * CGFloat(factor + 1))
		let cellWidth = screenWidth / CGFloat(factor)
		
		return CGSize(width: cellWidth, height: 160)
		
	}
}

// MARK: - PhotoPickerManagerDelegate

extension PhotoListController: PhotoPickerManagerDelegate {
	func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
		manager.dismissPhotoPicker(animated: true) {
			guard let photoFilterController = self.storyboard?.instantiateViewController(
				withIdentifier: String(describing: PhotoFilterController.self)) as? PhotoFilterController else {
					return
			}
			
			photoFilterController.selectedImage = image
			photoFilterController.delegate = self
			
			let navController = UINavigationController(rootViewController: photoFilterController)
			self.navigationController?.present(navController, animated: true, completion: nil)
		}
	}
}

// MARK: - PhotoFilterControllerDelegate

extension PhotoListController: PhotoFilterControllerDelegate {
	func updatePhoto(image: UIImage) {
		context.addPhoto(image)
	}
}
