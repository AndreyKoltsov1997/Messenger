//
//  PixabayService.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

import UIKit


class PixabayAPIService: IImageManagerService {
    
    private let requestSender: IRequestSender
    private let requestLoader: IRequestLoader
    
    private var images: [PixelbayResponseModel]?
    
    init(requestSender: IRequestSender, requestLoader: IRequestLoader) {
        self.requestLoader = requestLoader
        self.requestSender = requestSender
    }
    
    func performRequest(completion: @escaping (Int) -> Void) {
        let requestConfiguration = RequestFactory.Pixabay.images()
        
        requestSender.send(requestConfiguration: requestConfiguration) { images in
            self.images = images
            guard let amountOfImages = images?.count else {
                let misleadingMsg = "No images has been found within the response"
                print(misleadingMsg)
                let emptyImagesAmount = 0
                completion(emptyImagesAmount)
                return
            }
            completion(amountOfImages)
           
        }
    }
    
    func getWebFormatURL(index: Int) -> String? {
        guard let imageURL = images?[index].webformatURL else {
            let misleadingMessage = "Unable to get web format URL from the response."
            print(misleadingMessage)
            return nil
        }
        
        return imageURL
    }
    
    func load(url: String, completion: @escaping (UIImage?) -> Void) {
        requestLoader.load(url: url) { imageBinaryData in
            guard let imageData = imageBinaryData else {
                let misleadingMsg = "Unable to convert loaded response to image."
                print(misleadingMsg)
                completion(nil)
                return
            }
            
            let actualImage = UIImage(data: imageData, scale: 1.0)
            completion(actualImage)
        }
    }
    
    
}
