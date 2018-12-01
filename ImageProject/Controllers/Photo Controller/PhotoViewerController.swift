//
//  PhotoViewerController.swift
//  ImageProject
//
//  Created by rasl on 23.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import UIKit

class PhotoViewerController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImage.image = photo.image
        
    }
}
