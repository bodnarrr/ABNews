//
//  NewsCell.swift
//  ABNews
//
//  Created by Andrii Bodnar on 3/19/19.
//  Copyright © 2019 abodnar. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var imageLoadingTask: URLSessionDataTask?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupTitleStyle()
        setupDescriptionStyle()
        setupPhoto()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageLoadingTask?.cancel()
        photoImageView.image = UIImage(named: "image_paceholder")
    }
    
    private func setupTitleStyle() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
    }
    
    private func setupDescriptionStyle() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
    }
    
    private func setupPhoto() {
        photoImageView.backgroundColor = .clear
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = UIImage(named: "image_placeholder")
    }
    
    // MARK: - Public
    func fillWithModel(_ model: NewsEntity) {
        model.imagePath.map { [weak self] in
            guard let self = self else { return }
            self.imageLoadingTask = self.photoImageView.setCachedImage(urlString: $0)
        }
        titleLabel.text = model.title
        descriptionLabel.text = model.descript
    }
}
