//
//  CodableMessage.swift
//  Chat
//
//  Created by Andrey Koltsov on 28/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
struct CodableMessage: Codable {
    var eventType: String
    var messageID: String
    var text: String
}

