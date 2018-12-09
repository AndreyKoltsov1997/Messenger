//
//  PixelbayImageRequest.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

struct PixelbayImagesRequestConstants {
    // Configuration
    static let BASE_API_URL: String = "https://pixabay.com/api/"
    // Images JSON Response
    static let KEY = "key"
    static let REQUESTED_ITEMS = "q" // A URL encoded search term. If omitted, all videos are returned. This value may not exceed 100 characters. E.g.: "yellow+flower"
    static let REQUESTED_ITEMS_DELIMITER = "+"
    static let REQUESTED_IMAGES_PER_PAGE = "per_page"
    static let REQUEST_ALL_IMAGES_PARAM = "" // Parameter for "request items" ("q"). The server return all images it it's empty
    
}

class PixabayImagesRequest: IRequest {
    
    private var amountOfImagesPerPage = 200

    private var question: String
    private let apiKey: String
    
    private var getParameters: [String: String] {
        // Configuring Pixelbay JSON Response values
        let key: String = PixelbayImagesRequestConstants.KEY
        let requestedItems: String = PixelbayImagesRequestConstants.REQUESTED_ITEMS
        let requestedItemsDelimiter: String = PixelbayImagesRequestConstants.REQUESTED_ITEMS_DELIMITER
        let imagesPerPage: String = PixelbayImagesRequestConstants.REQUESTED_IMAGES_PER_PAGE
        
        let basicDelimiter: String = " "
        
        return [key: apiKey,
                requestedItems: question.replacingOccurrences(of: basicDelimiter, with: requestedItemsDelimiter),
                imagesPerPage : String(self.amountOfImagesPerPage)]
    }
    
    // MARK: - Public
    
    public func changeAmountOfImagesPerPage(to amount: Int) {
        self.amountOfImagesPerPage = amount
    }
    
    // MARK: - Private
    
    private var url: String {
        let urlParamsSeparator = "&"
        let parameters = getParameters.map({ "\($0.key)=\($0.value)"}).joined(separator: urlParamsSeparator)
        let startOfQueryMark = "?"
        return PixelbayImagesRequestConstants.BASE_API_URL + startOfQueryMark + parameters
    }
    
    var urlRequest: URLRequest? {
        if let url = URL(string: url) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initializer
    
    init(apiKey: String, question: String = "") {
        self.apiKey = apiKey
        self.question = question
    }
    
}
