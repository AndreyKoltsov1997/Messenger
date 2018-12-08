//
//  RequestLoader.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class RequestLoader: IRequestLoader {
    
    private let session = URLSession.shared
    private var task: URLSessionDataTask?
    
    
    func load(url: String, completion: @escaping (Data?) -> Void) {
        guard let targetURL = URL(string: url) else {
            let misleadingMessage = "URL \(url) is not reachable."
            print(misleadingMessage)
            completion(nil)
            return
        }
        task = session.dataTask(with: targetURL) { (data, response, error) in
            let isResponseCorrect = (error == nil)
            let fetchedData = isResponseCorrect ? data : nil
            completion(fetchedData)
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}

