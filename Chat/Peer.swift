//
//  Peer.swift
//  Chat
//
//  Created by Andrey Koltsov on 27/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

struct Peer  {
    let identifier: String
    let name: String
    
    private static var peerIdentifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        peerIdentifierFactory += 1
        return Peer.peerIdentifierFactory
    }
    
    init(name: String) {
        self.name = name
        // NOTE: I'm generating STRING identifier because the homework text defined the Peer structure. I'm not sure ...
        // ... if I can edit types so enjoy the encoded unique identifier. :)
        let rawIdentifier = String(Peer.getUniqueIdentifier()) + self.name
        self.identifier = rawIdentifier.data(using: .utf8)!.base64EncodedString()
    }
}
