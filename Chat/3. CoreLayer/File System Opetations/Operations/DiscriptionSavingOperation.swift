//
//  DiscriptionSavingOperation.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//


import UIKit

class DiscriptionSavingOperation: Operation {
    
    var discription: String?
    var isSuccess: Bool = true

    override func main() {
        if let discription = self.discription {
            self.isSuccess = FileSaver.saveText(text: discription, fileName: FileName.USER_DISCRIPTION_FILENAME.rawValue)
        }
    }
}

