//
//  PixelbayAPI.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

struct PixelbarApiResponse: Codable {
    let hits: [PixelbayResponseModel]?
}

struct PixelbayResponseModel: Codable {
    let id: Int?
    let previewURL: String?
    let webformatURL: String?
    let largeImageURL: String?
    let fullHDURLL: String?
    let imageURL: String?
}

class PixabayImagesParser: IParser {
    typealias ResponseModel = [PixelbayResponseModel]
    
    func parse(data: Data) -> [PixelbayResponseModel]? {
        do {
            let response = try JSONDecoder().decode(PixelbarApiResponse.self, from: data)
            return response.hits
        } catch {
            let misleadingMsg = "An error has occured while trying to fetch images from Pixelbay service: "
            print(misleadingMsg + error.localizedDescription)
            return nil
        }
    }
}

