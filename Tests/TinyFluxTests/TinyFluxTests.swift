import XCTest
@testable import TinyFlux

final class TinyFluxTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TinyFlux().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
