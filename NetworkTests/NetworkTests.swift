//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by Andrey Koltsov on 09/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import XCTest
@testable import Chat


class NetworkTests: XCTestCase {

    // MARK: - Properties
    private var requestManagerMock: IRequestManagerMock?
    private var imageManager: IImageManagerService?
    private let TEST_IMAGE_NAME = Constants.PROFILE_PICTURE_PLACEHOLDER_IMAGE_NAME
    
    // MARK: - Lifecycle
    
    override func setUp() {
       super.setUp()
        
       let testingImage = UIImage(named: self.TEST_IMAGE_NAME)
        if let image = testingImage {
            self.requestManagerMock = RequestManagerMock(image: image)

        }
        
        if let requestManager = self.requestManagerMock {
            let testRequestSender = RequestSender()
             self.imageManager = PixabayAPIService(requestSender: testRequestSender, requestLoader: requestManager)
        }
        
    }

    override func tearDown() {
        super.tearDown()
        self.requestManagerMock = nil
        self.imageManager = nil
    }
    
    // MARK: - Tests

    func testRequestManagerCallOnImageDownload() {
        // given
        let apiURL = "test_url" // make the test connection-independent, so no need in ACTUAL working URL
        
        // when
        self.requestManagerMock?.load(url: apiURL, completion: {_ in })
        
        // then
        guard let hasRequestLoaded = self.requestManagerMock?.hasLoadRequested else {
            let hasTestPassed = false
            XCTAssertTrue(hasTestPassed)
            return
        }
        
        XCTAssertTrue(hasRequestLoaded)
    }

}
