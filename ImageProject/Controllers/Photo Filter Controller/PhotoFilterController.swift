//
//  PhotoFilterController.swift
//  ImageProject
//
//  Created by rasl on 23.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit
import CoreData

protocol PhotoFilterControllerDelegate {
    func updatePhoto(image: UIImage)
}

class PhotoFilterController: UIViewController {
    
    @IBOutlet weak var filterPhoto: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var context = CIContext(options: nil)
    var delegate: PhotoFilterControllerDelegate?
    var selectedImage: UIImage!
    
     private let minItemSpacing = 7
    
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        initialized()

    }
    
    // MARK: - Acrionts
    
    @objc func saveButtonPressed(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        delegate?.updatePhoto(image: self.filterPhoto.image!)
    }
    
    @objc func cancelButtonPressed(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

extension PhotoFilterController {
    func initialized() {
        setupNavigation()
        setupCollectionView()
        
        filterPhoto.image = selectedImage
    }
    
    private func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 2, bottom: 20, right: 2)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
   private func setupNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoFilterController.cancelButtonPressed(sender:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(PhotoFilterController.saveButtonPressed(sender:)))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    // MARK: - Method
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension PhotoFilterController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CIFilterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoFilterCell.reuseIdentifier,
                                                      for: indexPath) as! PhotoFilterCell
        let newImage = resizeImage(image: selectedImage, newWidth: 150)
        let ciImage = CIImage(image: newImage)
        let filter = CIFilter(name: CIFilterNames[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredImage, from: filteredImage.extent)
            cell.filterPhoto.image = UIImage(cgImage: result!)
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = CIImage(image: selectedImage)
        let filter = CIFilter(name: CIFilterNames[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredImage, from: filteredImage.extent)
            self.filterPhoto.image = UIImage(cgImage: result! )
        }
    }
}

extension PhotoFilterController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
                        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
                        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let factor = traitCollection.horizontalSizeClass == .compact ? 3:4
        let screenRect = collectionView.frame.size.width
        let screenWidth = screenRect - (CGFloat(minItemSpacing) * CGFloat(factor + 1))
        let cellWidth = screenWidth / CGFloat(factor)
        
        return CGSize(width: cellWidth, height: 170)
        
    }
}
