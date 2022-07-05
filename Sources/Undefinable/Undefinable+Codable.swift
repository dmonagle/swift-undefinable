//
//  Undefinable+Codable.swift
//  
//
//  Created by David Monagle on 5/7/2022.
//

import Foundation

// MARK: Encoding

extension Undefinable : Encodable where Wrapped : Encodable {
    public func encode(to encoder: Encoder) throws {
        if case .defined(let optionalValue) = self {
            var container = encoder.singleValueContainer()
            try container.encode(optionalValue)
        }
    }
}

extension KeyedEncodingContainer {
    public mutating func encode<T>(_ value: Undefinable<T>, forKey key: KeyedEncodingContainer<K>.Key) throws where T : Encodable {
        if value.isDefined {
            try self.encode(value.optionalValue, forKey: key)
        }
    }
}

// MARK: - Decoding

extension Undefinable : Decodable where Wrapped : Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .defined(.none)
        }
        else {
            let value = try container.decode(Wrapped.self)
            self = .defined(value)
        }
    }
}

extension KeyedDecodingContainer {
    public func decode<T>(_ type: Undefinable<T>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Undefinable<T> where T : Decodable {
        // If the container contains the key, it will not be undefined
        if contains(key) {
            return try decodeIfPresent(Undefinable<T>.self, forKey: key) ?? nil
        }
        return .undefined
    }
}
