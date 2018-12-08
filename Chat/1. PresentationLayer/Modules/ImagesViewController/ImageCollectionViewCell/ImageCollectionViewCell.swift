//
//  ImageCollectionViewCell.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    private var loadingImage: LoadingImage? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: - Private
    private func configure() {
        self.configureLoadingImage()
        guard let image = self.loadingImage else {
            let misleadingMsg = "Loading image hasn't been set. Nothing to configure."
            print(misleadingMsg)
            return
        }
        
        addSubview(image)
        
        addConstraint(NSLayoutConstraint(item: image, attribute: .centerX,
                                         relatedBy: .equal, toItem: self, attribute: .centerX,
                                         multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: image, attribute: .centerY,
                                         relatedBy: .equal, toItem: self, attribute: .centerY,
                                         multiplier: 1, constant: 0))
    }
    
    private func configureLoadingImage() {
        let image = LoadingImage()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        
        self.loadingImage = image
        
    }
}
