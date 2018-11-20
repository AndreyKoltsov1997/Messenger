//
//  Peer.swift
//  Chat
//
//  Created by Andrey Koltsov on 27/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct Peer: Hashable  {
    let identifier: MCPeerID
    let name: String
 
    
    init(name: String, id: MCPeerID) {
        self.name = name
        // NOTE: I'm generating STRING identifier because the homework text defined the Peer structure. I'm not sure ...
        // ... if I can edit types so enjoy the encoded unique identifier. :)
        self.identifier = id
    }
    
    static func ==(lhs: Peer, rhs: Peer) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
