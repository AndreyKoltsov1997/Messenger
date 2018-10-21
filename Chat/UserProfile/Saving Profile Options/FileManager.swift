//
//  FileManager.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit


// MARK: Operation type: load or save data

enum OperaionType {
    case save
    case load
}

// MARK: Sender types

enum SenderType {
    case editProfileViewController
    case profileViewController
}

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
    
    class save {
        
        static func text(text: String, filename: String) -> Bool {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = dir.appendingPathComponent(filename)
            
            do {
                try text.write(to: url, atomically: false, encoding: .utf8)
            } catch { return false }
            
            return true
        }
        
        static func image(image: UIImage, filename: String) -> Bool {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = dir.appendingPathComponent(filename)
            
            if let data = UIImagePNGRepresentation(image) {
                do {
                    try data.write(to: url)
                } catch { return false }
            } else {
                return false
            }
            
            return true
        }
    }
    
    // MARK: Load from file
    
    class load {
        static func text(filename: String) -> String? {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = dir.appendingPathComponent(filename)
            
            do {
                let data = try String(contentsOf: url, encoding: .utf8)
                return data
            } catch { return nil }
        }
        
        static func image(filename: String) -> UIImage? {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = dir.appendingPathComponent(filename)
            
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch { return nil }
        }
    }
}

