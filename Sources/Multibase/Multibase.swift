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

import Bases

// MARK: - Byte Collections

extension Collection<UInt8> {

    /// Encodes these bytes in the given base, prefixed with the base's multibase character.
    ///
    /// ```swift
    /// Array("Hello".utf8).multibaseEncoded(.base16)   // "f48656c6c6f"
    /// ```
    ///
    /// - Parameters:
    ///   - base: The `base` to encode these bytes into.
    ///   - withPrefix: Wether or not to include the multibase prefix.
    /// - Returns: The multibase encoded string in the specified `base`.
    public func multibaseEncoded(_ base: BaseEncoding, withPrefix: Bool = true) -> String {
        base.encode(self, withPrefix: withPrefix)
    }

    /// Encodes these bytes in the given base, prefixed with that base's multibase character.
    ///
    /// - Parameters:
    ///   - base: The `base` to encode these bytes into
    ///   - withPrefix: Wether or not to include the multibase prefix.
    /// - Returns: The encoded characters as UTF-8 bytes.
    public func multibaseEncodedBytes(_ base: BaseEncoding, withPrefix: Bool = true) -> [UInt8] {
        base.encodedBytes(self, withPrefix: withPrefix)
    }

    /// The base this buffer is prefixed with, and the decoded payload.
    ///
    /// ```swift
    /// let (base, bytes) = try buffer.multibase()
    /// ```
    ///
    /// - Returns: The base this buffer is prefixed with, and the decoded payload.
    /// - Throws:
    ///   - ``MultibaseError/unknownBase`` if the buffer is empty or its leading character isn't in the table.
    ///   - ``MultibaseError/reservedPrefix(_:)`` if the table reserves that character.
    ///   - ``MultibaseError/decodingFailed(_:)`` if the base's decoder rejects the payload.
    public func multibase() throws(MultibaseError) -> (base: BaseEncoding, bytes: [UInt8]) {
        try BaseEncoding.decode(prefixed: self)
    }

    /// The base this buffer is prefixed with, and the still-encoded payload.
    ///
    /// - Returns: The base, and a *slice* of this buffer without the prefix, no copy, and nothing decoded.
    /// - Throws:
    ///   - ``MultibaseError/unknownBase`` if the buffer is empty or its leading character isn't in the table.
    ///   - ``MultibaseError/reservedPrefix(_:)`` if the table reserves that character.
    public func strippingMultibasePrefix() throws(MultibaseError) -> (base: BaseEncoding, body: SubSequence) {
        try BaseEncoding.split(prefixed: self)
    }

    /// The multibase prefix character at the front of this buffer, whether or not a base goes by it.
    ///
    /// - Throws:
    ///   - ``MultibaseError/unknownBase`` if the buffer is empty or doesn't begin with
    ///   a valid UTF-8 character.
    public func multibasePrefix() throws(MultibaseError) -> Unicode.Scalar {
        guard let first = self.first else { throw MultibaseError.unknownBase }
        if first < 0x80 { return Unicode.Scalar(first) }
        guard
            let width = utf8SequenceWidth(first),
            let end = index(startIndex, offsetBy: width, limitedBy: endIndex),
            let scalar = String(decoding: self[startIndex..<end], as: UTF8.self).unicodeScalars.first,
            scalar != "\u{FFFD}"
        else { throw MultibaseError.unknownBase }
        return scalar
    }
}

// MARK: - Strings

extension StringProtocol {

    /// The base this string is prefixed with, and the decoded payload.
    ///
    /// ```swift
    /// let (base, bytes) = try "f48656c6c6f".multibase()
    /// ```
    ///
    /// - Returns: The base this string is prefixed with, and the decoded payload.
    /// - Throws:
    ///   - ``MultibaseError/unknownBase`` if the buffer is empty or its leading character isn't in the table.
    ///   - ``MultibaseError/reservedPrefix(_:)`` if the table reserves that character.
    ///   - ``MultibaseError/decodingFailed(_:)`` if the base's decoder rejects the payload.
    public func multibase() throws(MultibaseError) -> (base: BaseEncoding, bytes: [UInt8]) {
        try BaseEncoding.decode(prefixed: self.utf8)
    }

    /// Encodes this string's UTF-8 bytes in the given base.
    ///
    /// ```swift
    /// "Hello".multibaseEncoded(.base16)   // "f48656c6c6f"
    /// ```
    ///
    /// - Parameters:
    ///   - base: The `base` to encode this string into.
    ///   - withPrefix: Wether or not to include the multibase prefix.
    /// - Returns: The string representation of the encoded UTF-8 bytes in the specified base.
    public func multibaseEncoded(_ base: BaseEncoding, withPrefix: Bool = true) -> String {
        base.encode(self.utf8, withPrefix: withPrefix)
    }
}
