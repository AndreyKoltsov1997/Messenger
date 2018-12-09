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
    // mocked image manager is goind to used mock of request manager
    private var mockedImageManager: IImageManagerService?
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
             self.mockedImageManager = PixabayAPIService(requestSender: testRequestSender, requestLoader: requestManager)
        }
        
    }

    override func tearDown() {
        super.tearDown()
        self.requestManagerMock = nil
        self.mockedImageManager = nil
    }
    
    // MARK: - Tests

    func testRequestManagerCallOnImageDownload() {
        // given
        let testApiURL = "test_url" // make the test connection-independent, so no need in ACTUAL working URL
        
        // when
        self.requestManagerMock?.load(url: testApiURL, completion: {_ in })
        
        // then
        guard let hasRequestLoaded = self.requestManagerMock?.hasLoadRequested else {
            let hasTestPassed = false
            XCTAssertTrue(hasTestPassed)
            return
        }
        
        XCTAssertTrue(hasRequestLoaded)
    }
    
    func testOnImageLoaderReturnsImage() {
        let currentTestName = "testOnImageLoaderReturnsImage"
        
        // given
        guard let imageLoader = self.mockedImageManager else {
            let misleadingMsg = "Image loader entity hasn't been found in tests."
            self.invalidateAssertTrueTest(reason: misleadingMsg, senderName: currentTestName)
            return
        }
        
        let testApiURL = "test_url" // NOTE: no need in actual URL since tests are netowrk-independent
        // NOTE: Using  because of the complition callback block
        let imageLoadingExpectation = self.expectation(description: currentTestName)
        
        // when
        var hasTestPassed: Bool = false
        imageLoader.load(url: testApiURL) { (loadedImage) in
            guard let image = loadedImage else {
                let misleadingMsg = "Image hasn't been loaded in test."
                print(misleadingMsg)
                let hasTestPassed = false
                XCTAssertTrue(hasTestPassed)
                return
            }
            let loadedImageBinaryData = image.pngData()
            
            let testImage = UIImage(named: self.TEST_IMAGE_NAME)
            guard let actualTestImage = testImage else {
                let misleadingMsg = "Unable to find image with name \(self.TEST_IMAGE_NAME)"
                self.invalidateAssertTrueTest(reason: misleadingMsg, senderName: currentTestName)
                return
            }
            
            guard let testImagebinaryData = self.getDecompressedImageData(for: actualTestImage) else {
                let misleadingMsg = "Unable to decompress test image"
                self.invalidateAssertTrueTest(reason: misleadingMsg, senderName: currentTestName)
                return
            }
            
            hasTestPassed = (loadedImageBinaryData == testImagebinaryData)
            imageLoadingExpectation.fulfill()
        }
        
        // NOTE: Default callback time has been calculated emperically
        let defaultCallbackTimeout = Double(6.5)
        waitForExpectations(timeout: defaultCallbackTimeout, handler: nil)
        
        // then
        XCTAssertTrue(hasTestPassed)
        
    }
    
    // MARK: - Private
    
    private func invalidateAssertTrueTest(reason message: String, senderName testName: String) {
        print(testName + ":" + message)
        XCTAssertTrue(false)
    }
    
    // NOTE: Empirically I've found out that Images are usually slightly compressed ...
    // ... when retreiving from memory in "Data" format. What function does is ...
    // ... decompressing in order to compare images correctly.
    private func getDecompressedImageData(for image: UIImage) -> Data? {
        let binaryImageData = image.pngData()
        guard let compressedData = binaryImageData else {
            let misleadingMsg = "Unable to get binary data of compressed image."
            print(misleadingMsg)
            return nil
        }
        let actualImage = UIImage(data: compressedData)
        let decompressedData = actualImage?.pngData()
        return decompressedData
    }

}
