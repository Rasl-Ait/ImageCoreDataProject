//
//  PhotoFilterCollectionCell.swift
//  ImageProject
//
//  Created by rasl on 23.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit

class PhotoFilterCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: PhotoFilterCell.self)
    
    @IBOutlet weak var filterPhoto: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedCorners()
    }
}

extension PhotoFilterCell {
    func roundedCorners () {
        filterPhoto.layer.cornerRadius = 9
        filterPhoto.clipsToBounds = true
    }
}
