//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libp2p open source project
//
// Copyright (c) 2022-2026 swift-libp2p project authors
// Licensed under MIT
//
// See LICENSE for license information
// See CONTRIBUTORS for the list of swift-libp2p project authors
//
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//

//
//  Deprecated.swift
//
//  Compatibility shims for the pre-0.3.0 API.
//

import Bases
import Foundation

extension BaseEncoding {

    // MARK: - Prefixes

    /// This base's multibase prefix as a byte.
    @available(*, deprecated, message: "Use `prefix` (a `Unicode.Scalar`) or `prefixBytes`.")
    public var bytePrefix: UInt8 {
        UInt8(truncatingIfNeeded: rawValue)
    }

    /// This base's multibase prefix as a `String`.
    @available(*, deprecated, message: "Use `prefix` (a `Unicode.Scalar`).")
    public var charPrefix: String {
        String(prefix)
    }

    /// Resolves a base from its multibase prefix byte.
    @available(*, deprecated, message: "Use `init?(prefix:)`, which takes a `Unicode.Scalar`.")
    public init?(prefixByte: UInt8) {
        self.init(prefix: Unicode.Scalar(prefixByte))
    }

    /// The table's `description` column for this encoding.
    @available(*, deprecated, renamed: "details")
    public var description: String? { details }

    // MARK: - Validation

    /// Whether every character of `string` can be decoded in this base.
    @available(*, deprecated, message: "Use `isValid(_:)`, which takes any byte collection.")
    public func isValid(_ string: String) -> Bool {
        isValid(string.utf8)
    }

    // MARK: - Encoding

    /// Encodes data in this base, prefixed with this base's multibase character.
    @available(*, deprecated, message: "Use `encode(_:withPrefix:)`, which takes any byte collection.")
    public func encode(data: Data) -> String {
        encode(data, withPrefix: true)
    }

    // MARK: - Decoding

    /// Decodes a multibase prefixed `String`.
    @available(*, deprecated, message: "Use `decode(_:)`, which returns `[UInt8]`.")
    public static func decode(_ d: String) throws -> (base: BaseEncoding, data: Data) {
        let (base, bytes) = try decode(prefixed: d.utf8)
        return (base: base, data: Data(bytes))
    }

    /// Decodes a `String` that carries no multibase prefix, in the base given.
    @available(*, deprecated, message: "Use `decode(_:as:)`, which returns `[UInt8]`.")
    public static func decode(
        _ encodedData: String,
        as base: BaseEncoding
    ) throws -> (base: BaseEncoding, data: Data) {
        (base: base, data: Data(try decode(encodedData.utf8, as: base)))
    }

    /// Decodes a multibase prefixed `String` and interprets the payload as a `String`.
    @available(
        *,
        deprecated,
        message: "Use `decode(_:)` and `String(decoding: bytes, as: UTF8.self)`."
    )
    public static func decodeIntoString(
        _ encodedData: String,
        using encoding: String.Encoding = .utf8
    ) throws -> (base: BaseEncoding, string: String) {
        let (base, bytes) = try decode(prefixed: encodedData.utf8)
        guard let string = String(bytes: bytes, encoding: encoding) else {
            throw MultibaseError.invalidStringEncoding
        }
        return (base: base, string: string)
    }
}

// MARK: - Strings

extension String {

    /// Decodes a base encoded string into plain text.
    @available(
        *,
        deprecated,
        message: "Use `BaseEncoding.decode(_:as:)` and `String(decoding: bytes, as: UTF8.self)`."
    )
    public init(
        decoding encodedString: String,
        as base: BaseEncoding,
        using stringEncoding: String.Encoding = .utf8
    ) throws {
        let bytes = try BaseEncoding.decode(encodedString.utf8, as: base)
        guard let str = String(bytes: bytes, encoding: stringEncoding) else {
            throw MultibaseError.invalidStringEncoding
        }
        self = str
    }

    /// The base this string's leading character names, or ``BaseEncoding/identity``.
    @available(
        *,
        deprecated,
        message: "Use `strippingMultibasePrefix()`, which reports an unknown prefix instead of guessing."
    )
    public var baseEncoding: BaseEncoding {
        guard let first = self.utf8.first else { return .identity }
        return BaseEncoding(prefix: Unicode.Scalar(first)) ?? .identity
    }

    /// Encodes this string's UTF-8 bytes in the given base.
    @available(*, deprecated, message: "Use `multibaseEncoded(_:)`.")
    public func encodeUTF8(base: BaseEncoding) -> String {
        base.encode(self.utf8, withPrefix: true)
    }

    /// Encodes this string's ASCII bytes in the given base.
    @available(*, deprecated, message: "Use `multibaseEncoded(_:)`, which encodes as UTF-8.")
    public func encodeASCII(base: BaseEncoding) -> String {
        base.encode(self.data(using: .ascii) ?? Data(), withPrefix: true)
    }

    /// Encodes this string in the given base, converting it with `encoding` first.
    @available(*, deprecated, message: "Use `multibaseEncoded(_:)`, which encodes as UTF-8.")
    public func encode(as base: BaseEncoding, using encoding: String.Encoding = .ascii) -> String {
        base.encode(self.data(using: encoding) ?? Data(), withPrefix: true)
    }
}

// MARK: - Foundation

extension Data {

    /// Decodes a base encoded string into its `Data` representation.
    @available(*, deprecated, message: "Use `BaseEncoding.decode(_:as:)`, which returns `[UInt8]`.")
    public init(decoding encodedString: String, as base: BaseEncoding) throws {
        self = Data(try BaseEncoding.decode(encodedString.utf8, as: base))
    }
}

extension Array where Element == UInt8 {

    /// Decodes a base encoded string into its byte representation.
    @available(*, deprecated, message: "Use `BaseEncoding.decode(_:as:)`.")
    public init(decoding encodedString: String, as base: BaseEncoding) throws {
        self = try BaseEncoding.decode(encodedString.utf8, as: base)
    }
}
