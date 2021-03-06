//
//  PhotoPickerManager.swift
//  ImageProject
//
//  Created by rasl on 22.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol PhotoPickerManagerDelegate: class {
	func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage)
}

class PhotoPickerManager: NSObject {
	private let imagePickerController = UIImagePickerController()
	private let presentingController: UIViewController
	weak var delegate: PhotoPickerManagerDelegate?
	
	init(presentingController: UIViewController) {
		self.presentingController = presentingController
		super.init()
		
		configure()
	}
	
	func presentPhotoPicker(animated: Bool) {
		presentingController.present(imagePickerController, animated: animated, completion: nil)
	}
	
	func dismissPhotoPicker(animated: Bool, completion: (() -> Void)?) {
		imagePickerController.dismiss(animated: animated, completion: completion)
	}
	
	private func configure() {
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			imagePickerController.sourceType = .camera
			imagePickerController.cameraDevice = .front
		} else {
			imagePickerController.sourceType = .photoLibrary
		}
		
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		
		imagePickerController.delegate = self
	}
}

extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController,
														 didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		delegate?.manager(self, didPickImage: image)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismissPhotoPicker(animated: true, completion: nil)
		
	}
}
