//
//  IRequestManagerMock.swift
//  NetworkTests
//
//  Created by Andrey Koltsov on 09/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit
@testable import Chat

// NOTE: Interface for object which is testing ...
// ... whether the load function has been called or not 
protocol IRequestManagerMock: IRequestLoader {
    var loadingImage: UIImage? { get set }
    var hasLoadRequested: Bool { get set }
}
