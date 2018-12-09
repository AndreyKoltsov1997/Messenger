//
//  ImageDownloaderService.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import UIKit

protocol IImageManagerService {
    
    func performRequest(completion: @escaping (Int) -> Void)
    func getWebFormatURL(index: Int) -> String?
    func load(url: String, completion: @escaping (UIImage?) -> Void)
    
}

