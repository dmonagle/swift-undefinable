import XCTest
@testable import Undefinable

final class UndefinableTests: XCTestCase {
    func testUndefined() throws {
        let test = TestStruct()
        XCTAssertEqual(test.age, .undefined)
        XCTAssertNil(test.age.optionalValue)
    }

    func testExplicitlyUndefined() throws {
        let test = TestStruct(age: .undefined)
        XCTAssertEqual(test.age, .undefined)
        XCTAssertNil(test.age.optionalValue)
    }

    func testNil() throws {
        let test = TestStruct(age: nil)
        XCTAssertNotEqual(test.age, .undefined)
        XCTAssertNil(test.age.optionalValue)
    }

    func testValue() throws {
        let test = TestStruct(age: 21)
        XCTAssertNotEqual(test.age, .undefined)
        XCTAssertEqual(test.age, 21)
    }

    struct TestStruct {
        var age: Undefinable<Int> = .undefined
    }
}
