//
//  Send2KodiTests.swift
//  Send2KodiTests
//
//  Created by Erwan Lacoste on 11/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import XCTest
@testable import Send2Kodi

class Send2KodiTests: XCTestCase {

    var service: KodiService?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        service = .init(config: .init())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegexOk() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var url: String
        url = "https://w.youtube.com/watch?v=my-_id"
        XCTAssertEqual("my-_id", service!.extractYoutubeId(url))
        url = "https://w.youtube.com/watch?v=my-_id&wathever=is here"
        XCTAssertEqual("my-_id", service!.extractYoutubeId(url))
        url = "https://youtu.be/my-_id"
        XCTAssertEqual("my-_id", service!.extractYoutubeId(url))
        url = "my-_id"
        XCTAssertEqual("my-_id", service!.extractYoutubeId(url))
    }
    func testRegexKo() {
        var url: String
        url = "http://www.w3s.org/code"
        XCTAssertNil(service!.extractYoutubeId(url))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
