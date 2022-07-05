//
//  Undefinable.swift
//  
//
//  Created by David Monagle on 2/7/2022.
//

import Foundation

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
}

extension Undefinable : Equatable where Wrapped : Equatable {
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

// MARK - Expressible by literals

extension Undefinable : ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .defined(.none)
    }
}

extension Undefinable : ExpressibleByIntegerLiteral where Wrapped == Int {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension Undefinable : ExpressibleByBooleanLiteral where Wrapped == Bool {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

extension Undefinable : ExpressibleByFloatLiteral where Wrapped == Double {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

extension Undefinable : ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByStringLiteral, ExpressibleByUnicodeScalarLiteral where Wrapped == String {
    public typealias UnicodeScalarLiteralType = Wrapped
    public typealias ExtendedGraphemeClusterLiteralType = Wrapped
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
