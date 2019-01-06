//
//  PhotoPageController.swift
//  ImageProject
//
//  Created by rasl on 23.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit

class PhotoPageController: UIPageViewController {
	
	var photos: [Photo] = []
	var indexPhoto: Int!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self
		
		if let photoViewerController = photoViewerController(with: photos[indexPhoto]) {
			setViewControllers([photoViewerController], direction: .forward, animated: false, completion: nil)
		}
	}
	
	private func photoViewerController(with photo: Photo) -> PhotoViewerController? {
		guard let photoViewerController = storyboard?.instantiateViewController(
			withIdentifier: "PhotoViewerController") as? PhotoViewerController else { return nil }
		photoViewerController.photo = photo
		
		return photoViewerController
	}
}

extension PhotoPageController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController,
													viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let photoVC = viewController as? PhotoViewerController,
			let index = photos.index(of: photoVC.photo) else { return nil }
		
		if index == photos.startIndex {
			return nil
		} else {
			let indexBefore = photos.index(before: index)
			let photo = photos[indexBefore]
			return photoViewerController(with: photo)
		}
		
	}
	
	func pageViewController(_ pageViewController: UIPageViewController,
													viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let photoVC = viewController as? PhotoViewerController,
			let index = photos.index(of: photoVC.photo) else { return nil }
		
		if index == photos.index(before: photos.endIndex) {
			return nil
		} else {
			let indexAfter = photos.index(after: index)
			let photo = photos[indexAfter]
			return photoViewerController(with: photo)
		}
	}
}
