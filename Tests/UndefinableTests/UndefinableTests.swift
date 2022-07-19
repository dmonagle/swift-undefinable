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
    
    func testConditionalAssignment() throws {
        let undefined = TestStruct(age: .undefined)
        
        var age: Int? = 18
        age ?= undefined.age
        XCTAssertEqual(age, 18)
        
        let twentyOne = TestStruct(age: 21)
        age ?= twentyOne.age
        XCTAssertEqual(age, 21)

        let null = TestStruct(age: nil)
        age ?= null.age
        XCTAssertNil(age)
    }

    struct TestStruct {
        var age: Undefinable<Int> = .undefined
    }
}
