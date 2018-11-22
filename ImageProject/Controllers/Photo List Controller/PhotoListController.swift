//
//  ViewController.swift
//  ImageProject
//
//  Created by rasl on 22.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit
import CoreData

class PhotoListController: UIViewController {
    
   @IBOutlet weak var collectionView: UICollectionView!
    
   let dataTask = CoreDataManager.shared
    
   private var fetchedResultsProvider: FetchedResultsProvider<Photo>!
   private var genericDataSource: GenericCVDataSource<PhotoCell,Photo>?
    
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
}

// MARK: - extension PhotoListController

extension PhotoListController {
    private func initialized() {
        dataSource()
        
    }
    
    private func dataSource() {
        
        // generic fetched results provide
        fetchedResultsProvider = FetchedResultsProvider(managedObjectContext: dataTask.managedObjectContext, descriptor: "creationDate")
        
        // generic data source
        genericDataSource = GenericCVDataSource(cellIdentifier : PhotoCell.reuseIdentifier,collectionView : self.collectionView, fetchedResultsProvider : fetchedResultsProvider) { cell, model in
            guard let image = model.imageData else { return }
            cell.photoImage.image = UIImage(data:image)
            
        }
        
        collectionView.dataSource = self.genericDataSource
    }
}

// MARK: - PhotoPickerManagerDelegate

extension PhotoListController: PhotoPickerManagerDelegate {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
        dataTask.addPhoto(image)
        manager.dismissPhotoPicker(animated: true, completion:
            nil)
        
    }
}
