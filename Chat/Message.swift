//
//  Message.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

struct Message {
    enum `Type`: String {
        case textMessage = "TextMessage"
    }
    let identifier: String
    let text: String
    let isRecived: Bool
    let date: Date
}


