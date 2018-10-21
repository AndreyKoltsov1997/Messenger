//
//  UserNameSavingOperation.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class UsernameSavingOperation: Operation {
    
    var userName: String?
    var isSuccess: Bool = true

    override func main() {
        if let userName = self.userName {
            self.isSuccess = FileOperation.save.text(text: userName, filename: FileName.username.rawValue)
        }
    }
}

