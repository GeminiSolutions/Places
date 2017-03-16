import XCTest
@testable import Places

class PlacesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Places().text, "Hello, World!")
    }


    static var allTests : [(String, (PlacesTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
