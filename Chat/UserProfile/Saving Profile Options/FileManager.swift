//
//  FileManager.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

// MARK: Save alert messages

enum SaveResult {
    case usernameError
    case informationError
    case imageError
    case done
}

// MARK: Filenames

enum FileName: String {
    case username = "profileUsername"
    case information = "profileInformation"
    case image = "profileImage.png"
}

// MARK: File operation

class FileOperation {
    
    // MARK: Save to file
    class SaveData {
        
        static func text(text: String, filename: String) -> Bool {
            let url = Constants.DOCUMENT_DIRECTORY_PATH.appendingPathComponent(filename)
            
            do {
                try text.write(to: url, atomically: false, encoding: .utf8)
            } catch {
                print("An error has occured while saving text data onto the document.")

                return false
                
            }
            
            return true
        }
        
        static func image(image: UIImage, filename: String) -> Bool {
            let url = Constants.DOCUMENT_DIRECTORY_PATH.appendingPathComponent(filename)
            
            if let data = UIImagePNGRepresentation(image) {
                do {
                    try data.write(to: url)
                } catch {
                    print("An error has occured while saving image info onto the document.")
                    return false
                }
            } else {
                return false
            }
            
            return true
        }
    }
    
    
    class LoadData {
        static func text(filename: String) -> String? {
            let url = Constants.DOCUMENT_DIRECTORY_PATH.appendingPathComponent(filename)
            
            do {
                let data = try String(contentsOf: url, encoding: .utf8)
                return data
            } catch {
                print("An error has occured while loading text data from the document.")
                return nil
                
            }
        }
        
        static func image(filename: String) -> UIImage? {
            
            let url = Constants.DOCUMENT_DIRECTORY_PATH.appendingPathComponent(filename)
            
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch {
                print("An error has occured while loading image info from the document.")

                return nil
                
            }
        }
    }
}

