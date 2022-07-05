import XCTest
@testable import Undefinable

final class UndefinableEncodingTests: XCTestCase {
    func testUndefined() throws {
        let test = TestStruct(name: .undefined)
        XCTAssertEqual(encodedJsonString(for: test), #"{}"#)
    }

    func testNil() throws {
        let test = TestStruct(name: nil)
        XCTAssertEqual(encodedJsonString(for: test), #"{"name":null}"#)
    }

    func testValue() throws {
        let test = TestStruct(name: "David")
        XCTAssertEqual(encodedJsonString(for: test), #"{"name":"David"}"#)
    }
    
    private func encodedJsonString(for test: TestStruct) -> String {
        let encoded = try! JSONEncoder().encode(test)
        let string = String(data: encoded, encoding: .utf8)!
        return string
    }

    private struct TestStruct : Codable {
        var name: Undefinable<String>
    }
}
