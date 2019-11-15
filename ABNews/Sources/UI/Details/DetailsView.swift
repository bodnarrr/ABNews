//
//  DetailsView.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import Foundation
import UIKit

class DetailsView: View {
    
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton!
    
    // MARK: - Prepare
    override func prepare() {
        super.prepare()
        
        setupPhoto()
        setupContentLabelStyle()
    }
    
    private func setupPhoto() {
        photoImageView.backgroundColor = .clear
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = UIImage(named: "image_placeholder")
    }
    
    private func setupContentLabelStyle() {
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
    }
}
