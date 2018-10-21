//
//  ImageSavingOperation.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class ImageSavingOperation: Operation {
    
    var image: UIImage?
    var isSuccess: Bool = true
    
    override func main() {
        if let image = self.image {
            self.isSuccess = FileOperation.SaveData.image(image: image, filename: FileName.image.rawValue)
        }
    }
}
