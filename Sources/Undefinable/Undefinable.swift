//
//  Undefinable.swift
//
//
//  Created by David Monagle on 2/7/2022.
//

/// A type that represents either a defined optional value or undefined, the
/// absence of value.
///
/// The purpose of this is to wrap a value within a `Codable` struct so when
/// encoded and decoded, it can be determined whether it was:
/// * set to a value = `.defined(.some(value))`
/// * set to nil = `.defined(.none)`
/// * not defined at all = `.undefined`
public enum Undefinable<Wrapped> {
    case undefined
    case defined(Wrapped?)

    static var null: Self {
        .defined(.none)
    }

    public init() {
        self = .undefined
    }

    public init(_ defined: Wrapped) {
        self = .defined(.some(defined))
    }

    /// `nil` if `.undefined` or the wrapped optional value if `.defined`
    public var optionalValue: Wrapped? {
        switch self {
        case .undefined: return nil
        case .defined(let value): return value
        }
    }

    public var isDefined: Bool {
        if case .undefined = self {
            return false
        }
        return true
    }
    
    
    /// Executes the operation with the optional wrapped value if `.defined`
    /// - Parameter operation: The operation to execute
    public func unwrap(_ operation: (Wrapped?) throws -> ()) rethrows {
        switch self {
        case .undefined:
            return
        case .defined(let wrapped):
            try operation(wrapped)
        }
    }
}

// MARK: - Operators

infix operator ?=
func ?=<T>(lhs: inout T?, rhs: Undefinable<T>) {
    rhs.unwrap {
        lhs = $0
    }
}

// MARK: - CustomDebugStringConvertible

extension Undefinable: CustomDebugStringConvertible {
  /// A textual representation of this instance, suitable for debugging.
  public var debugDescription: String {
    switch self {
    case .defined(let value):
        return "Undefinable(\(value.debugDescription)"
    case .undefined:
      return "undefined"
    }
  }
}

// MARK: - CustomReflectable

extension Undefinable: CustomReflectable {
  public var customMirror: Mirror {
    switch self {
    case .defined(let value):
      return Mirror(
        self,
        children: [ "defined": value.customMirror ],
        displayStyle: .optional)
    case .undefined:
      return Mirror(self, children: [:], displayStyle: .optional)
    }
  }
}

// MARK: - Equatable and Comparison

extension Undefinable: Equatable where Wrapped: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.defined(let l), .defined(let r)):
            return l == r
        case (.undefined, .undefined):
            return true
        default:
            return false
        }
    }
}

// MARK: - Hashable

extension Undefinable: Hashable where Wrapped: Hashable {
  /// Hashes the essential components of this value by feeding them into the
  /// given hasher.
  ///
  /// - Parameter hasher: The hasher to use when combining the components
  ///   of this instance.
  @inlinable
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .undefined:
      hasher.combine(0 as UInt8)
    case .defined(let wrapped):
      hasher.combine(1 as UInt8)
      hasher.combine(wrapped)
    }
  }
}

// MARK: - Expressible by Literals

extension Undefinable: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .defined(.none)
    }
}

extension Undefinable: ExpressibleByIntegerLiteral where Wrapped == Int {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension Undefinable: ExpressibleByBooleanLiteral where Wrapped == Bool {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

extension Undefinable: ExpressibleByFloatLiteral where Wrapped == Double {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

extension Undefinable: ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByStringLiteral, ExpressibleByUnicodeScalarLiteral where Wrapped == String {
    public typealias UnicodeScalarLiteralType = Wrapped
    public typealias ExtendedGraphemeClusterLiteralType = Wrapped

    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
