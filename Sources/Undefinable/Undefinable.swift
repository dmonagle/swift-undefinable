//
//  Undefinable.swift
//  
//
//  Created by David Monagle on 2/7/2022.
//

import Foundation

public enum Undefinable<Wrapped> : ExpressibleByNilLiteral {
    case undefined
    case defined(Wrapped?)
    
    public init() {
        self = .undefined
    }
    
    public init(nilLiteral: ()) {
        self = .defined(.none)
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
