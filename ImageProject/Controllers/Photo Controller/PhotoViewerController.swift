//
//  PhotoViewerController.swift
//  ImageProject
//
//  Created by rasl on 23.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit

class PhotoViewerController: UIViewController, AlertDisplayer {

	@IBOutlet weak var backgroungPhoto: UIImageView!
	@IBOutlet weak var photoImage: UIImageView!
	private var saveButton = UIButton()
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
			addBlurEffect()
			backgroungPhoto.image = photo.image
			photoImage.image = photo.image
			addSaveButton()
        
    }
	
	private func addSaveButton() {
		saveButton = UIButton(type: .system)
		saveButton.setImage(UIImage(named: "save"), for: .normal)
		saveButton.tintColor = .white
		saveButton.addTarget(self, action: #selector(saveButtonTapped(sender:)), for: .touchUpInside)
		view.addSubview(saveButton)
		
		saveButton.anchor(top: view.topAnchor, left: nil,  bottom: nil,
											right: view.rightAnchor,
											paddingTop: 20, paddingLeft: 0, paddingBottom: 0,
											paddingRight: 8, width: 36, height: 36)
		
	}

	@objc private func saveButtonTapped(sender: UIButton) {
		UIImageWriteToSavedPhotosAlbum(photoImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			displayAlert(with: "Save error", message: error.localizedDescription)
		} else {
		  displayAlert(with: "Saved!", message: "saved to your photos.")
		}
	}
	
	private func addBlurEffect() {
		let blurEffect = UIBlurEffect(style: .dark)
		let blurView = UIVisualEffectView(effect: blurEffect)
		blurView.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(blurView, at: 1)
		
		blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
		blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
	}
	
}
