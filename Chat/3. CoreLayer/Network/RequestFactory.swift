//
//  RequestFactory.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

import Foundation

struct RequestFactory {
    
    struct Pixabay {
        private static let API_KEY = "10935276-a3bc3bbe5ccd30fbab2213bf6"
        
        static func images(question: String = PixelbayImagesRequestConstants.REQUEST_ALL_IMAGES_PARAM) -> RequestConfiguration<PixabayImagesParser> {
            
            let request = PixabayImagesRequest(apiKey: API_KEY, question: question)
            
            return RequestConfiguration<PixabayImagesParser>(request: request, parser: PixabayImagesParser())
        }
    }
    
}
