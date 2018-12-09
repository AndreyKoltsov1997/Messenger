//
//  RequestManagerMock.swift
//  NetworkTests
//
//  Created by Andrey Koltsov on 09/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit
@testable import Chat

class RequestManagerMock: IRequestManagerMock {
    public static let TAG = String(describing: RequestManagerMock.self)
    
    // MARK: - Properties
    var loadingImage: UIImage?
    var hasLoadRequested: Bool
    
    // MARK: - Constructor
    init(image: UIImage) {
        self.loadingImage = image
        self.hasLoadRequested = false
    }
    
    
    // NOTE: Requesting load of the image
    func load(url: String, completion: @escaping (Data?) -> Void) {
        self.hasLoadRequested = true
       
        guard let image = self.loadingImage else {
            let misleadingMsg = RequestManagerMock.TAG + " loading image hasn't been found, returning nil."
            print(misleadingMsg)
            completion(nil)
            return
        }
        let imageBinaryRepresentation = image.pngData()
        completion(imageBinaryRepresentation)
        
    }
    
    // NOTE: Cancelling the load of an image
    func cancel() {
        let misleadingMsg = RequestManagerMock.TAG + "loading has been cancelled"
        print(misleadingMsg)
    }
    
    
}
