import XCTest
@testable import Undefinable

final class UndefinableDecodingTests: XCTestCase {
    func testUndefined() throws {
        let test = decoded(for: #"{}"#)
        XCTAssertEqual(test.age, .undefined)
    }

    func testNil() throws {
        let test = decoded(for: #"{"age":null}"#)
        XCTAssertTrue(test.age.isDefined)
        XCTAssertNil(test.age.optionalValue)
    }

    func testValue() throws {
        let test = decoded(for: #"{"age":21}"#)
        XCTAssertEqual(test.age.optionalValue, 21)
    }
    
    private func decoded(for string: String) -> TestStruct {
        let data = string.data(using: .utf8)!
        return try! JSONDecoder().decode(TestStruct.self, from: data)
    }

    private struct TestStruct : Codable {
        var age: Undefinable<Int> = .undefined
    }
}
