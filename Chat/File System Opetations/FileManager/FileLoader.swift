//
//  FileLoader.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class FileLoader {
    static func getImage(fileName: String) -> UIImage? {
        let url = Constants.DOCUMENT_DIRECTORY_PATH.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            // TODO: Handle situation when device hasn't had any saved info - it's not an error
            print("An error has occured while loading image info from the document.")
            return nil
        }
    }
    
    static func getText(fileName: String) -> String? {
        let url = Constants.DOCUMENT_DIRECTORY_PATH.appendingPathComponent(fileName)
        do {
            let data = try String(contentsOf: url, encoding: .utf8)
            return data
        } catch {
            print("An error has occured while loading text data from the document.")
            return nil
        }
    }
}
