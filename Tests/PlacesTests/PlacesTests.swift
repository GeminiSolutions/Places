import XCTest
@testable import Places

class PlacesTests: XCTestCase {
    func testPlace() {
        XCTAssertNil(Place().name)
    }

    static var allTests = [
        ("testPlace", testPlace),
    ]
}
