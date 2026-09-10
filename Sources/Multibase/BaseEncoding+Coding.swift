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

// MARK: - Encoding

extension BaseEncoding {

    /// Encodes bytes in this base, prefixed with this base's multibase character.
    ///
    /// ```swift
    /// BaseEncoding.base16.encode(Array("Hello".utf8))   // "f48656c6c6f"
    /// ```
    ///
    /// - Parameters:
    ///   - bytes: The bytes to encode. Any byte collection, a `Data`, an `[UInt8]`, or a
    ///     slice of either.
    ///   - withPrefix: Whether to include the multibase prefix character.
    /// - Note: ``identity`` renders non-UTF8 payloads lossily here, because the result is a
    ///   `String`. Use ``encodedBytes(_:withPrefix:)`` for a lossless round-trip.
    public func encode(_ bytes: some Collection<UInt8>, withPrefix: Bool = true) -> String {
        String(decoding: encodedBytes(bytes, withPrefix: withPrefix), as: UTF8.self)
    }

    /// Encodes bytes in this base, prefixed with this base's multibase character.
    ///
    /// - Returns: The encoded characters as UTF-8 bytes. Lossless for every base,
    ///   including ``identity``.
    public func encodedBytes(_ bytes: some Collection<UInt8>, withPrefix: Bool = true) -> [UInt8] {
        let body = encodedBody(bytes)
        guard withPrefix else { return body }
        let prefix = prefixBytes
        var prefixed = [UInt8]()
        prefixed.reserveCapacity(prefix.count + body.count)
        prefixed.append(contentsOf: prefix)
        prefixed.append(contentsOf: body)
        return prefixed
    }

    /// The encoded payload, without a prefix.
    ///
    /// An exhaustive switch on purpose, uncommenting a row of the table is a compile error
    /// until it's implemented here.
    private func encodedBody(_ bytes: some Collection<UInt8>) -> [UInt8] {
        switch self {
        case .identity: Array(bytes)
        case .base2: Base2.encode(bytes)
        case .base8: Base8.encode(bytes, pad: .unpadded)
        case .base10: BaseX.encode(bytes, into: .base10Decimal)
        case .base16: BaseX.encode(bytes, into: .base16Hex)
        case .base16Upper: BaseX.encode(bytes, into: .base16HexUpper)
        case .base32: Base32.encode(bytes, letterCase: .lower, pad: .unpadded)
        case .base32Upper: Base32.encode(bytes, letterCase: .upper, pad: .unpadded)
        case .base32Pad: Base32.encode(bytes, letterCase: .lower, pad: .padded)
        case .base32PadUpper: Base32.encode(bytes, letterCase: .upper, pad: .padded)
        case .base32Hex: Base32.encode(bytes, variant: .hex, letterCase: .lower, pad: .unpadded)
        case .base32HexUpper: Base32.encode(bytes, variant: .hex, letterCase: .upper, pad: .unpadded)
        case .base32HexPad: Base32.encode(bytes, variant: .hex, letterCase: .lower, pad: .padded)
        case .base32HexPadUpper: Base32.encode(bytes, variant: .hex, letterCase: .upper, pad: .padded)
        case .base32z: Base32.encode(bytes, variant: .z, letterCase: .lower, pad: .unpadded)
        case .base36: BaseX.encode(bytes, into: .base36)
        case .base36Upper: BaseX.encode(bytes, into: .base36Upper)
        case .base58btc: BaseX.encode(bytes, into: .base58BTC)
        case .base58flickr: BaseX.encode(bytes, into: .base58Flickr)
        case .base64: Base64.encode(bytes, variant: .standard, pad: .unpadded)
        case .base64Pad: Base64.encode(bytes, variant: .standard, pad: .padded)
        case .base64Url: Base64.encode(bytes, variant: .url, pad: .unpadded)
        case .base64UrlPad: Base64.encode(bytes, variant: .url, pad: .padded)
        }
    }
}

// MARK: - Decoding

extension BaseEncoding {

    /// Splits a multibase prefixed buffer into its base and its payload, without decoding.
    ///
    /// ```swift
    /// let (base, body) = try BaseEncoding.split(prefixed: buffer)
    /// ```
    ///
    /// - Parameter bytes: The prefixed bytes to split.
    /// - Returns: The base the buffer is prefixed with, and a slice of the buffer holding
    ///   everything after the prefix.
    /// - Throws:
    ///   - ``MultibaseError/unknownBase`` if the buffer is empty or its leading character isn't in the table.
    ///   - ``MultibaseError/reservedPrefix(_:)`` if the table reserves that character.
    public static func split<Bytes: Collection<UInt8>>(
        prefixed bytes: Bytes
    ) throws(MultibaseError) -> (base: BaseEncoding, body: Bytes.SubSequence) {
        guard let first = bytes.first else { throw MultibaseError.unknownBase }

        let scalar: Unicode.Scalar
        let width: Int
        if first < 0x80 {
            // Every prefix currently implemented is ASCII, so this is the only path taken.
            scalar = Unicode.Scalar(first)
            width = 1
        } else {
            guard
                let sequenceWidth = utf8SequenceWidth(first),
                let end = bytes.index(bytes.startIndex, offsetBy: sequenceWidth, limitedBy: bytes.endIndex),
                let decoded = String(decoding: bytes[bytes.startIndex..<end], as: UTF8.self).unicodeScalars.first,
                decoded != "\u{FFFD}"
            else { throw MultibaseError.unknownBase }
            scalar = decoded
            width = sequenceWidth
        }

        guard let base = BaseEncoding(prefix: scalar) else {
            if reservedPrefixes.contains(scalar) { throw MultibaseError.reservedPrefix(scalar) }
            throw MultibaseError.unknownBase
        }
        return (base, bytes[bytes.index(bytes.startIndex, offsetBy: width)...])
    }

    /// Decodes a multibase prefixed buffer.
    ///
    /// ```swift
    /// let (base, bytes) = try BaseEncoding.decode(prefixed: buffer)
    /// ```
    ///
    /// - Parameter bytes: The multibase bytes to decode.
    /// - Returns: The base the buffer was decoded with, and a slice of the buffer holding
    ///   everything after the prefix.
    /// - Throws:
    ///   - ``MultibaseError/unknownBase`` if the buffer is empty or its leading character isn't in the table.
    ///   - ``MultibaseError/reservedPrefix(_:)`` if the table reserves that character.
    ///   - ``MultibaseError/decodingFailed(_:)`` if the base's decoder rejects the payload.
    ///
    /// - Note: A CIDv0 buffer (`Qm…`) is decoded as ``base58btc``. CIDv0 predates
    ///   multibase and carries no prefix, and the table reserves `Q` partly to keep that
    ///   shape unambiguous.
    public static func decode<Bytes: Collection<UInt8>>(
        prefixed bytes: Bytes
    ) throws(MultibaseError) -> (base: BaseEncoding, bytes: [UInt8]) {
        if isCIDv0(bytes) {
            return (.base58btc, try decode(bytes, as: .base58btc))
        }
        let (base, body) = try split(prefixed: bytes)
        return (base, try decode(body, as: base))
    }

    /// Decodes a payload that carries no multibase prefix, in the base given.
    ///
    /// - Parameters:
    ///   - body: The encoded characters, without a prefix.
    ///   - base: The base to decode them in.
    /// - Returns: The decoded body as a UInt8 Array
    /// - Throws:
    ///   - ``MultibaseError/decodingFailed(_:)`` if the base's decoder rejects the payload.
    public static func decode(
        _ body: some Collection<UInt8>,
        as base: BaseEncoding
    ) throws(MultibaseError) -> [UInt8] {
        do throws(BasesError) {
            switch base {
            case .identity: return Array(body)
            case .base2: return try Base2.decode(body)
            case .base8: return try Base8.decode(body)
            case .base10: return try BaseX.decode(body, as: .base10Decimal)
            // base16 and base36 decoders are case insensitive now
            case .base16: return try BaseX.decode(body, as: .base16Hex)
            case .base16Upper: return try BaseX.decode(body, as: .base16HexUpper)
            case .base32, .base32Upper, .base32Pad, .base32PadUpper:
                return try Base32.decode(body, variant: .standard)
            case .base32Hex, .base32HexUpper, .base32HexPad, .base32HexPadUpper:
                return try Base32.decode(body, variant: .hex)
            case .base32z: return try Base32.decode(body, variant: .z)
            case .base36: return try BaseX.decode(body, as: .base36)
            case .base36Upper: return try BaseX.decode(body, as: .base36Upper)
            case .base58btc: return try BaseX.decode(body, as: .base58BTC)
            case .base58flickr: return try BaseX.decode(body, as: .base58Flickr)
            // Base64 decoding is padding-tolerant, so the unpadded forms need no pre-padding.
            case .base64, .base64Pad: return try Base64.decode(body, variant: .standard)
            case .base64Url, .base64UrlPad: return try Base64.decode(body, variant: .url)
            }
        } catch {
            throw MultibaseError.decodingFailed(error)
        }
    }

    /// Decodes a multibase prefixed `String`.
    public static func decode(
        _ string: some StringProtocol
    ) throws(MultibaseError) -> (base: BaseEncoding, bytes: [UInt8]) {
        try decode(prefixed: string.utf8)
    }

    /// Decodes a `String` that carries no multibase prefix, in the specified base.
    public static func decode(
        _ string: some StringProtocol,
        as base: BaseEncoding
    ) throws(MultibaseError) -> [UInt8] {
        try decode(string.utf8, as: base)
    }

    /// Whether `bytes` looks like a CIDv0, base58btc with no multibase prefix, always `Qm…`.
    private static func isCIDv0(_ bytes: some Collection<UInt8>) -> Bool {
        var iterator = bytes.makeIterator()
        return iterator.next() == UInt8(ascii: "Q") && iterator.next() == UInt8(ascii: "m")
    }
}

// MARK: - Alphabets

extension BaseEncoding {

    /// This base's alphabet, as the characters it encodes to in value order.
    ///
    /// ```swift
    /// BaseEncoding.base32.alphabet   // "abcdefghijklmnopqrstuvwxyz234567"
    /// ```
    ///
    /// Read from swift-bases rather than duplicated here, so there is one definition of
    /// each alphabet. A padded variant appends `=`, and ``identity`` has no alphabet.
    public var alphabet: String {
        guard let alphabet = codingAlphabet else { return "" }
        return alphabet.characterString + (isPadded ? String(UnicodeScalar(Alphabet.paddingCharacter)) : "")
    }

    /// Whether every character of `characters` can be decoded in this base.
    ///
    /// - Parameter characters: The encoded payload, *without* a multibase prefix.
    ///
    /// - Note: Checked against swift-bases' reverse lookup table, so it accepts either case
    ///   for the case-insensitive bases (base16, base32, base36), which is what their
    ///   decoders accept. ``identity`` places no constraint and always returns `true`.
    public func isValid(_ characters: some Collection<UInt8>) -> Bool {
        guard let alphabet = codingAlphabet else { return true }
        let padding = Alphabet.paddingCharacter
        return characters.allSatisfy { alphabet.contains($0) || (isPadded && $0 == padding) }
    }

    /// The swift-bases alphabet backing this encoding, or `nil` for ``identity``.
    internal var codingAlphabet: Alphabet? {
        switch self {
        case .identity: nil
        case .base2: Base2.alphabet
        case .base8: Base8.alphabet
        case .base10: BaseX.Alphabets.base10Decimal.alphabet
        case .base16: BaseX.Alphabets.base16Hex.alphabet
        case .base16Upper: BaseX.Alphabets.base16HexUpper.alphabet
        case .base32, .base32Pad: Base32.Variant.standard.alphabet(.lower)
        case .base32Upper, .base32PadUpper: Base32.Variant.standard.alphabet(.upper)
        case .base32Hex, .base32HexPad: Base32.Variant.hex.alphabet(.lower)
        case .base32HexUpper, .base32HexPadUpper: Base32.Variant.hex.alphabet(.upper)
        case .base32z: Base32.Variant.z.alphabet(.lower)
        case .base36: BaseX.Alphabets.base36.alphabet
        case .base36Upper: BaseX.Alphabets.base36Upper.alphabet
        case .base58btc: BaseX.Alphabets.base58BTC.alphabet
        case .base58flickr: BaseX.Alphabets.base58Flickr.alphabet
        case .base64, .base64Pad: Base64.Variant.standard.alphabet
        case .base64Url, .base64UrlPad: Base64.Variant.url.alphabet
        }
    }

    /// Whether this encoding pads its final block with `=`.
    internal var isPadded: Bool {
        switch self {
        case .base32Pad, .base32PadUpper, .base32HexPad, .base32HexPadUpper, .base64Pad, .base64UrlPad: true
        default: false
        }
    }
}

// MARK: - Internal

/// The number of bytes in the UTF-8 sequence beginning with `byte`, or `nil` if it isn't a
/// leading byte.
internal func utf8SequenceWidth(_ byte: UInt8) -> Int? {
    switch byte {
    case 0x00...0x7F: 1
    case 0xC2...0xDF: 2
    case 0xE0...0xEF: 3
    case 0xF0...0xF4: 4
    default: nil
    }
}
