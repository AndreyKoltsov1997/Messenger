//
//  LoadingImage.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit


import UIKit

class LoadingImage: UIImageView {
    
    static let IMAGE_PLACEHOLDER = "Image"
    private lazy var loader: IRequestLoader = RequestLoader()
    private var targetURL: String?
    
    func loadImage(from url: String) {
        DispatchQueue.main.async { [weak self] in
            self?.image = UIImage(named: LoadingImage.IMAGE_PLACEHOLDER)
        }
        
        
        loader.cancel()
        self.targetURL = url
        loader.load(url: url) { (data) in
            guard let data = data else {
                let misleadingMessage = "Image hasn't been loaded properly."
                print(misleadingMessage)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                // NOTE: In some cases, when the user scrolls collection view very fast, the reusable ...
                // ... cell could be initialized with an old url, so I'm checking it via "isUrlActual"
                let isUrlActual = (self?.targetURL == url)
                if isUrlActual {
                    self?.image = UIImage(data: data)
                }
            }
        }
    }
    
}
