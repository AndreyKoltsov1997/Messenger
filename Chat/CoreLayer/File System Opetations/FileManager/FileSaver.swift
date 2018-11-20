//
//  FileSaver.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class FileSaver {
    static func saveImage(image: UIImage, fileName: String) -> Bool {
        var EXIT_FLAG = true
        let url = Constants.DOCUMENT_DIRECTORY_PATH.appendingPathComponent(fileName)
        
        if let data = UIImagePNGRepresentation(image) {
            do {
                try data.write(to: url)
            } catch {
                print("An error has occured while saving image info onto the document.")
                EXIT_FLAG = false
            }
        } else {
            print("An error has occured while trying to acces the data at within " + fileName)
            EXIT_FLAG = false
        }
        return EXIT_FLAG
    }
    
    static func saveText(text: String, fileName: String) -> Bool {
        var EXIT_FLAG = true
        let url = Constants.DOCUMENT_DIRECTORY_PATH.appendingPathComponent(fileName)
        do {
            try text.write(to: url, atomically: false, encoding: .utf8)
        } catch {
            print("An error has occured while saving text data onto the document: " + fileName)
            EXIT_FLAG = false
        }
        return EXIT_FLAG
    }
    
    
}
