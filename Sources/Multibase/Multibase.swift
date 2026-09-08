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

import Base2
import Base32
import Base64
import Base8
import BaseX
import Foundation

public enum BaseEncoding: UInt8, CaseIterable, Equatable, Sendable {
    case identity = 000  // 0x00
    case base2 = 048  // 0 String(... radix: 2)
    case base8 = 055  // 7
    case base10 = 057  // 9
    case base16 = 102  // f
    case base16Upper = 070  // F
    case base32Hex = 118  // v Base32 extended hex alphabet
    case base32HexUpper = 086  // V Base32 extended hex alphabet
    case base32HexPad = 116  // t Base32 extended hex alphabet
    case base32HexPadUpper = 084  // T Base32 extended hex alphabet
    case base32 = 098  // b Base32 regular alphabet
    case base32Upper = 066  // B Base32 regular alphabet
    case base32Pad = 099  // c Base32 regular alphabet
    case base32PadUpper = 067  // C Base32 regular alphabet
    case base32z = 104  // h Base32 extended Z alphabet
    case base36 = 107  // k
    case base36Upper = 075  // K
    case base58btc = 122  // z
    case base58flickr = 090  // Z
    case base64 = 109  // m
    case base64Pad = 077  // M
    case base64Url = 117  // u
    case base64UrlPad = 085  // U
    //case proquint          = 113 // q

    public var alphabet: String {
        switch self {
        case .identity: return ""
        case .base2: return "01"
        case .base8: return "01234567"
        case .base10: return "0123456789"
        case .base16: return "0123456789abcdef"
        case .base16Upper: return "0123456789ABCDEF"
        case .base32: return "abcdefghijklmnopqrstuvwxyz234567"
        case .base32Pad: return "abcdefghijklmnopqrstuvwxyz234567="
        case .base32Upper: return "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        case .base32PadUpper: return "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
        case .base32Hex: return "0123456789abcdefghijklmnopqrstuv"
        case .base32HexPad: return "0123456789abcdefghijklmnopqrstuv="
        case .base32HexUpper: return "0123456789ABCDEFGHIJKLMNOPQRSTUV"
        case .base32HexPadUpper: return "0123456789ABCDEFGHIJKLMNOPQRSTUV="
        case .base32z: return "ybndrfg8ejkmcpqxot1uwisza345h769"
        case .base36: return "0123456789abcdefghijklmnopqrstuvwxyz"
        case .base36Upper: return "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case .base58btc: return "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
        case .base58flickr: return "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"
        case .base64: return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        case .base64Pad: return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
        case .base64Url: return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
        case .base64UrlPad: return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_="
        //case .proquint:          return ""
        }
    }

    public var status: String {
        switch self {
        case .identity:
            return "default"
        case .base2:
            return "candidate"
        case .base8:
            return "draft"
        case .base10:
            return "draft"
        case .base16:
            return "default"
        case .base16Upper:
            return "default"
        case .base32Hex:
            return "candidate"
        case .base32HexUpper:
            return "candidate"
        case .base32HexPad:
            return "candidate"
        case .base32HexPadUpper:
            return "candidate"
        case .base32:
            return "default"
        case .base32Upper:
            return "default"
        case .base32Pad:
            return "candidate"
        case .base32PadUpper:
            return "candidate"
        case .base32z:
            return "draft"
        case .base36:
            return "draft"
        case .base36Upper:
            return "draft"
        case .base58btc:
            return "default"
        case .base58flickr:
            return "candidate"
        case .base64:
            return "default"
        case .base64Pad:
            return "candidate"
        case .base64Url:
            return "default"
        case .base64UrlPad:
            return "default"
        //case .proquint:
        //    return "draft"
        }
    }

    public var description: String? {
        switch self {
        case .identity:
            return "8-bit binary (encoder and decoder keeps data unmodified)"
        case .base2:
            return "binary (01010101)"
        case .base8:
            return "octal"
        case .base10:
            return "decimal"
        case .base16:
            return "hexadecimal"
        case .base16Upper:
            return "hexadecimal"
        case .base32Hex:
            return "rfc4648 case-insensitive - no padding - highest char"
        case .base32HexUpper:
            return "rfc4648 case-insensitive - no padding - highest char"
        case .base32HexPad:
            return "rfc4648 case-insensitive - with padding"
        case .base32HexPadUpper:
            return "rfc4648 case-insensitive - with padding"
        case .base32:
            return "rfc4648 case-insensitive - no padding"
        case .base32Upper:
            return "rfc4648 case-insensitive - no padding"
        case .base32Pad:
            return "rfc4648 case-insensitive - with padding"
        case .base32PadUpper:
            return "rfc4648 case-insensitive - with padding"
        case .base32z:
            return "z-base-32 (used by Tahoe-LAFS)"
        case .base36:
            return "base36 [0-9a-z] case-insensitive - no padding"
        case .base36Upper:
            return "base36 [0-9a-z] case-insensitive - no padding"
        case .base58btc:
            return "base58 bitcoin"
        case .base58flickr:
            return "base58 flicker"
        case .base64:
            return "rfc4648 no padding"
        case .base64Pad:
            return "rfc4648 with padding - MIME encoding"
        case .base64Url:
            return "rfc4648 no padding"
        case .base64UrlPad:
            return "rfc4648 with padding"
        //case .proquint:
        //    return "PRO-QUINT https://arxiv.org/html/0901.4016"
        }
    }

    public var bytePrefix: UInt8 {
        self.rawValue
    }

    public var charPrefix: String {
        String(UnicodeScalar(self.rawValue))
    }

    /// Resolves a base encoding from its multibase prefix byte (identical to its raw value).
    public init?(prefixByte: UInt8) {
        self.init(rawValue: prefixByte)
    }

    /// Resolves a base encoding from its multibase prefix character (e.g. `"f"` -> `.base16`).
    public init?(prefix: Character) {
        guard let ascii = prefix.asciiValue else { return nil }
        self.init(rawValue: ascii)
    }

    /// Returns `true` when every character of `string` belongs to this base's canonical alphabet.
    ///
    /// - Note: `string` is expected to be the encoded body *without* the multibase prefix. The check
    ///   is case-sensitive against the canonical alphabet, and `.identity` (which has no alphabet
    ///   constraint) always returns `true`.
    public func isValid(_ string: String) -> Bool {
        if self == .identity { return true }
        let allowed = Set(self.alphabet)
        return string.allSatisfy { allowed.contains($0) }
    }

    public func encode(data: Data) -> String {
        var encoding = ""
        switch self {
        case .identity:
            // Identity output is the 0x00 prefix followed by the raw bytes. Because this API returns a
            // String, non-UTF8 payloads are rendered lossily (U+FFFD) rather than crashing; use the
            // Data(decoding:as: .identity) path when a lossless round-trip is required.
            return String(decoding: [self.rawValue] + data, as: UTF8.self)
        case .base2:
            encoding = data.binaryEncoded(byteSpacing: false)
        case .base8:
            encoding = Base8.encode(data, options: .pad(false))
        case .base10:
            encoding = BaseX.encode(data, into: .base10Decimal)
        case .base16:
            encoding = BaseX.encode(data, into: .base16Hex)
        case .base16Upper:
            encoding = BaseX.encode(data, into: .base16HexUpper)
        case .base32:
            encoding = Base32.encode(data, options: .pad(false), .letterCase(.lower))
        case .base32Pad:
            encoding = Base32.encode(data, options: .pad(true), .letterCase(.lower))
        case .base32Upper:
            encoding = Base32.encode(data, options: .pad(false), .letterCase(.upper))
        case .base32PadUpper:
            encoding = Base32.encode(data, options: .pad(true), .letterCase(.upper))
        case .base32Hex:
            encoding = Base32.encode(data, variant: .hex, options: .pad(false), .letterCase(.lower))
        case .base32HexPad:
            encoding = Base32.encode(data, variant: .hex, options: .pad(true), .letterCase(.lower))
        case .base32HexUpper:
            encoding = Base32.encode(data, variant: .hex, options: .pad(false), .letterCase(.upper))
        case .base32HexPadUpper:
            encoding = Base32.encode(data, variant: .hex, options: .pad(true), .letterCase(.upper))
        case .base32z:
            encoding = Base32.encode(data, variant: .z, options: .pad(false), .letterCase(.lower))
        case .base36:
            encoding = BaseX.encode(data, into: .base36)
        case .base36Upper:
            encoding = BaseX.encode(data, into: .base36Upper)
        case .base58btc:
            encoding = BaseX.encode(data, into: .base58BTC)
        case .base58flickr:
            encoding = BaseX.encode(data, into: .base58Flickr)
        case .base64:
            encoding = Base64.encode(data, variant: .standard, pad: false)
        case .base64Pad:
            encoding = Base64.encode(data, variant: .standard, pad: true)
        case .base64Url:
            encoding = Base64.encode(data, variant: .url, pad: false)
        case .base64UrlPad:
            encoding = Base64.encode(data, variant: .url, pad: true)
        //case .proquint:
        //    // TODO: Implement Me
        }

        return self.charPrefix + encoding
    }

    /// Given a Multibase compliant String, this method will attempt to extract the base prefix from the string and decode it
    public static func decode(_ d: String) throws -> (base: BaseEncoding, data: Data) {
        guard let prefixByte = d.utf8.first else { throw MultibaseError.unknownBase }

        // Identity is a NUL (0x00) prefix followed by the raw bytes; the payload is everything after it.
        if prefixByte == BaseEncoding.identity.rawValue {
            return (base: .identity, data: Data(d.utf8.dropFirst()))
        }

        guard let base = BaseEncoding(prefixByte: prefixByte) else {
            // Special case for Base58BTC Peer IDs, which carry no multibase prefix (e.g. "Qm…").
            if d.hasPrefix("Qm") {
                do {
                    return (base: .base58btc, data: try BaseX.decode(d, as: .base58BTC))
                } catch {
                    throw MultibaseError.decodingFailed(underlying: error)
                }
            }
            throw MultibaseError.unknownBase
        }

        return try self.decode(String(d.dropFirst()), as: base)
    }

    /// Given an encoded String that is not Multibase compliant (aka missing the Multibase prefix) this method will attempt to decode the string in the base specified.
    public static func decode(_ encodedData: String, as base: BaseEncoding) throws -> (base: BaseEncoding, data: Data) {
        // Every base delegates to a swift-bases decoder that throws its own error type (Base64.Error,
        // BaseX/Base32/Base8 errors, etc.). We funnel those into MultibaseError so consumers only ever
        // have to catch a single, base-agnostic error type.
        do {
            switch base {
            case .base2:
                return (base: .base2, data: try Data(binaryString: encodedData))  // .binaryDecoded)
            case .base8:
                return (base: .base8, data: try Base8.decode(encodedData))
            case .base10:
                return (base: .base10, data: try BaseX.decode(encodedData, as: .base10Decimal))
            case .base16:
                return (base: .base16, data: try BaseX.decode(encodedData.lowercased(), as: .base16Hex))
            case .base16Upper:
                return (base: .base16Upper, data: try BaseX.decode(encodedData.uppercased(), as: .base16HexUpper))
            case .base32:
                return (base: .base32, data: try Base32.decode(encodedData))
            case .base32Pad:
                return (base: .base32Pad, data: try Base32.decode(encodedData))
            case .base32Upper:
                return (base: .base32Upper, data: try Base32.decode(encodedData))
            case .base32PadUpper:
                return (base: .base32PadUpper, data: try Base32.decode(encodedData))
            case .base32Hex:
                return (base: .base32Hex, data: try Base32.decode(encodedData, variant: .hex))
            case .base32HexPad:
                return (base: .base32HexPad, data: try Base32.decode(encodedData, variant: .hex))
            case .base32HexUpper:
                return (base: .base32HexUpper, data: try Base32.decode(encodedData, variant: .hex))
            case .base32HexPadUpper:
                return (base: .base32HexPadUpper, data: try Base32.decode(encodedData, variant: .hex))
            case .base32z:
                return (base: .base32z, data: try Base32.decode(encodedData, variant: .z))
            case .base36:
                return (base: .base36, data: try BaseX.decode(encodedData.lowercased(), as: .base36))
            case .base36Upper:
                return (base: .base36Upper, data: try BaseX.decode(encodedData.uppercased(), as: .base36Upper))
            case .base58btc:
                return (base: .base58btc, data: try BaseX.decode(encodedData, as: .base58BTC))
            case .base58flickr:
                return (base: .base58flickr, data: try BaseX.decode(encodedData, as: .base58Flickr))
            case .base64:
                // Base64.decode is padding-tolerant, so the unpadded (`m`) form round-trips without pre-padding.
                return (base: .base64, try Base64.decode(encodedData, variant: .standard))
            case .base64Pad:
                return (base: .base64Pad, try Base64.decode(encodedData, variant: .standard))
            case .base64Url:
                return (base: .base64Url, try Base64.decode(encodedData, variant: .url))
            case .base64UrlPad:
                return (base: .base64UrlPad, try Base64.decode(encodedData, variant: .url))
            case .identity:
                // The payload is the raw bytes; this method receives the string without its multibase prefix.
                return (base: .identity, data: Data(encodedData.utf8))
            //case .proquint:
            //    // TODO: Implement me
            }
        } catch let error as MultibaseError {
            throw error
        } catch {
            throw MultibaseError.decodingFailed(underlying: error)
        }
    }

    public static func decodeIntoString(
        _ encodedData: String,
        using encoding: String.Encoding = .utf8
    ) throws -> (base: BaseEncoding, string: String) {
        let (base, data) = try self.decode(encodedData)
        guard let string = String(data: data, encoding: encoding) else {
            throw MultibaseError.invalidStringEncoding
        }
        return (base: base, string: string)
    }
}

extension String {
    /// Attempts to decode a Base encoded string into plain text
    /// - Parameters:
    ///   - encodedString: A base encoded string (ex: binary, hex, decimal, base32, base58 etc...)
    ///   - base: The base of the string
    ///   - stringEncoding: The string encoding to use when converting to plain text....
    /// - Throws: Decoding and Encoding Errors
    /// Example:
    /// ```
    /// try String(decoding: "429328951066508984658627669258025763026247056774804621697313", as: .base10Decimal, using: .utf8) => "Decentralize everything!!"
    /// ```
    public init(
        decoding encodedString: String,
        as base: BaseEncoding,
        using stringEncoding: String.Encoding = .utf8
    ) throws {
        let d = try Data(decoding: encodedString, as: base)
        guard let str = String(data: d, encoding: stringEncoding) else {
            throw MultibaseError.invalidStringEncoding
        }
        self = str
    }

    public var baseEncoding: BaseEncoding {
        guard let base = self.utf8.first else { return .identity }
        return BaseEncoding(rawValue: base) ?? .identity
    }

    public func encodeUTF8(base: BaseEncoding) -> String {
        base.encode(data: self.data(using: .utf8) ?? Data())
    }

    public func encodeASCII(base: BaseEncoding) -> String {
        base.encode(data: self.data(using: .ascii) ?? Data())
    }

    /// Takes a string, converts it to data using the specified String.Encoding and then encodes that data into the specified base
    /// - Parameters:
    ///   - base: The base to encode the data representation of the string
    ///   - encoding: The String.Encoding to use when converting the string into data (ex: .utf8, or .ascii)
    /// - Returns: The base encoded string representation of the string data 🤔
    ///
    /// Example:
    /// ```
    /// "Hello World".encode(as: .base16, using: .utf8) // -> "f48656c6c6f20576f726c64"
    /// ```
    public func encode(as base: BaseEncoding, using encoding: String.Encoding = .ascii) -> String {
        base.encode(data: self.data(using: encoding) ?? Data())
    }
}

extension Data {
    /// Attempts to decode a Base encoded string into it's Data representation
    /// - Parameters:
    ///   - encodedString: A base encoded string (ex: binary, hex, decimal, base32, base58 etc...)
    ///   - base: The base of the string
    /// - Throws: Decoding and Encoding Errors
    ///
    /// Example:
    /// ```
    /// try Data(decoding: "429328951066508984658627669258025763026247056774804621697313" as: .base10Decimal) // -> Data
    /// ```
    public init(decoding encodedString: String, as base: BaseEncoding) throws {
        self = try BaseEncoding.decode(encodedString, as: base).data
    }

    /// Encodes the data into the spcified base
    /// - Parameters:
    ///   - base: The base to encode the data into
    ///   - prefix: Include the Multibase encoding prefix or not
    /// - Returns: The String representation of the data encoded into the specifed base
    ///
    /// Example:
    /// ```
    /// "Hello World".data(using: .utf8)!.asString(base: .base16, withMultibasePrefix: true) // -> "f48656c6c6f20576f726c64"
    /// ```
    public func asString(base: BaseEncoding, withMultibasePrefix prefix: Bool = false) -> String {
        prefix ? base.encode(data: self) : String(base.encode(data: self).dropFirst(1))
    }
}

extension Array where Element == UInt8 {
    /// Attempts to decode a Base encoded string into it's UInt8 Array representation
    /// - Parameters:
    ///   - encodedString: A base encoded string (ex: binary, hex, decimal, base32, base58 etc...)
    ///   - base: The base of the string
    /// - Throws: Decoding and Encoding Errors
    ///
    /// Example:
    /// ```
    /// try Array<UInt8>(decoding: "429328951066508984658627669258025763026247056774804621697313" as: .base10Decimal) // -> [UInt8]
    /// ```
    public init(decoding encodedString: String, as base: BaseEncoding) throws {
        self = Array(try Data(decoding: encodedString, as: base))
    }

    /// Encodes the bytes into the spcified base
    /// - Parameters:
    ///   - base: The base to encode the bytes into
    ///   - prefix: Include the Multibase encoding prefix or not
    /// - Returns: The String representation of the bytes encoded into the specifed base
    ///
    /// Example:
    /// ```
    /// Array<UInt8>("Hello World".data(using: .utf8)!).asString(base: .base16, withMultibasePrefix: true) // -> "f48656c6c6f20576f726c64"
    /// ```
    public func asString(base: BaseEncoding, withMultibasePrefix prefix: Bool = false) -> String {
        prefix ? base.encode(data: Data(self)) : String(base.encode(data: Data(self)).dropFirst(1))
    }
}
