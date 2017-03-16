import XCTest
@testable import Places

class PlacesTests: XCTestCase {
    func testPlace() {
        XCTAssertNil(Place().name)
    }

    static var allTests : [(String, (PlacesTests) -> () throws -> Void)] {
        return [
            ("testPlace", testPlace),
        ]
    }
}
