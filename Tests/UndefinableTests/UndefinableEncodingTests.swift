import XCTest
@testable import Undefinable

final class UndefinableEncodingTests: XCTestCase {
    func testUndefined() throws {
        let test = TestStruct()
        XCTAssertEqual(encodedJsonString(for: test), #"{}"#)
    }

    func testNil() throws {
        let test = TestStruct(age: nil)
        XCTAssertEqual(encodedJsonString(for: test), #"{"age":null}"#)
    }

    func testValue() throws {
        let test = TestStruct(age: .defined(21))
        XCTAssertEqual(encodedJsonString(for: test), #"{"age":21}"#)
    }
    
    private func encodedJsonString(for test: TestStruct) -> String {
        let encoded = try! JSONEncoder().encode(test)
        let string = String(data: encoded, encoding: .utf8)!
        return string
    }

    private struct TestStruct : Codable {
        var age: Undefinable<Int> = .undefined
    }
}
