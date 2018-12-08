//
//  IRequestLoader.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol IRequestLoader {
    func load(url: String, completion: @escaping (Data?) -> Void)
    func cancel()
}
