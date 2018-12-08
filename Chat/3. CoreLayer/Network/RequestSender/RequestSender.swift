//
//  RequestSender.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation


class RequestSender: IRequestSender {
    
    private let session = URLSession.shared
    
    func send<Parser>(requestConfiguration: RequestConfiguration<Parser>, completion: @escaping (Parser.ResponseModel?) -> Void) where Parser : IParser {
        guard let urlRequest = requestConfiguration.request.urlRequest else {
            let misleadingMsg = "Unable to get the URL Request configuration"
            print(misleadingMsg)
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let misleadingMessage = "An error has occured while trying to fetch data from the server:"
                print(misleadingMessage + error.localizedDescription)
                completion(nil)
            }
            guard let fetchedData = data,
                let parsedModel: Parser.ResponseModel = requestConfiguration.parser.parse(data: fetchedData) else {
                    print("Unable to parse response from the server.")
                    completion(nil)
                    return
            }
            completion(parsedModel)
        }
        task.resume()
    }
}
