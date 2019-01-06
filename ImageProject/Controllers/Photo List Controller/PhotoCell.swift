//
//  PhotoCell.swift
//  ImageProject
//
//  Created by rasl on 22.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
	
	static let reuseIdentifier = String(describing: PhotoCell.self)
	
	@IBOutlet weak var photoImage: UIImageView!
	@IBOutlet weak var containerViewFirst: UIView!
	@IBOutlet weak var containerViewSecond: UIView!
	
	var photo: Photo? {
		didSet {
			configure(photo)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		roundedCorners()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		photoImage.image = nil
		
	}
	
	func configure(_ photo: Photo?) {
		photoImage.image =  photo?.image
		
	}
}

private extension PhotoCell {
	private func roundedCorners() {
		containerViewFirst.layer.cornerRadius = 9
		containerViewFirst.layer.shadowOpacity = 0.70
		containerViewFirst.layer.shadowOffset = CGSize(width: 0, height: 7)
		containerViewFirst.layer.shadowRadius = 7
		
		containerViewSecond.layer.cornerRadius = 9
		containerViewSecond.clipsToBounds = true
		
	}
}

extension Photo {
	var image: UIImage {
		if let image = self.imageData {
			return UIImage(data: image as Data)!
		}
		
		return UIImage()
	}
}

