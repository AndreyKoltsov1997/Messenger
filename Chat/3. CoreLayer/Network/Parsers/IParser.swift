//
//  IParser.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype ResponseModel
    
    func parse(data: Data) -> ResponseModel?
}

