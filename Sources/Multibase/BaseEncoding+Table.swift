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
//  BaseEncoding+Table.swift
//
//  https://github.com/multiformats/multibase/blob/master/multibase.csv
//
//  Updated on: 2026-09-09
//

/// The base encodings listed in the [multibase table](https://github.com/multiformats/multibase).
///
/// The raw value matches the table's `Unicode` column.
///
/// - Note: We comment out the unsupported Base encodings so that we can keep
///   ``encode(_:withPrefix:)`` non-throwing. As `swift-bases` adds support,
///   we'll update this enum accordingly.
public enum BaseEncoding: UInt32, CaseIterable, Equatable, Sendable {

    /// Raw bytes, no transformation.
    ///
    /// A documented extension to the table rather than a row of it, upstream lists U+0000
    /// as `none`/`reserved`, and this package exposes it as a usable pass-through encoding.
    /// Its ``status`` is therefore ``BaseStatus/reserved``.
    case identity = 0x0000  // NUL

    case base2 = 0x0030  // 0
    case base8 = 0x0037  // 7
    case base10 = 0x0039  // 9
    case base16 = 0x0066  // f
    case base16Upper = 0x0046  // F
    case base32Hex = 0x0076  // v
    case base32HexUpper = 0x0056  // V
    case base32HexPad = 0x0074  // t
    case base32HexPadUpper = 0x0054  // T
    case base32 = 0x0062  // b
    case base32Upper = 0x0042  // B
    case base32Pad = 0x0063  // c
    case base32PadUpper = 0x0043  // C
    case base32z = 0x0068  // h
    case base36 = 0x006B  // k
    case base36Upper = 0x004B  // K
    // case base45 = 0x0052  // R  — RFC9285, not implemented
    case base58btc = 0x007A  // z
    case base58flickr = 0x005A  // Z
    case base64 = 0x006D  // m
    case base64Pad = 0x004D  // M
    case base64Url = 0x0075  // u
    case base64UrlPad = 0x0055  // U
    // case proquint = 0x0070  // p  — https://arxiv.org/html/0901.4016, not implemented
    // case base256emoji = 0x1F680  // 🚀 — not implemented

    /// The `encoding`s human readable name.
    public var name: String {
        switch self {
        case .identity: "identity"
        case .base2: "base2"
        case .base8: "base8"
        case .base10: "base10"
        case .base16: "base16"
        case .base16Upper: "base16upper"
        case .base32Hex: "base32hex"
        case .base32HexUpper: "base32hexupper"
        case .base32HexPad: "base32hexpad"
        case .base32HexPadUpper: "base32hexpadupper"
        case .base32: "base32"
        case .base32Upper: "base32upper"
        case .base32Pad: "base32pad"
        case .base32PadUpper: "base32padupper"
        case .base32z: "base32z"
        case .base36: "base36"
        case .base36Upper: "base36upper"
        case .base58btc: "base58btc"
        case .base58flickr: "base58flickr"
        case .base64: "base64"
        case .base64Pad: "base64pad"
        case .base64Url: "base64url"
        case .base64UrlPad: "base64urlpad"
        }
    }

    /// The table's `description` column for this encoding.
    public var details: String? {
        switch self {
        case .identity: "8-bit binary (encoder and decoder keeps data unmodified)"
        case .base2: "Binary (01010101)"
        case .base8: "Octal"
        case .base10: "Decimal"
        case .base16: "Hexadecimal (lowercase)"
        case .base16Upper: "Hexadecimal (uppercase)"
        case .base32Hex: "RFC4648 case-insensitive - no padding - highest char"
        case .base32HexUpper: "RFC4648 case-insensitive - no padding - highest char"
        case .base32HexPad: "RFC4648 case-insensitive - with padding"
        case .base32HexPadUpper: "RFC4648 case-insensitive - with padding"
        case .base32: "RFC4648 case-insensitive - no padding"
        case .base32Upper: "RFC4648 case-insensitive - no padding"
        case .base32Pad: "RFC4648 case-insensitive - with padding"
        case .base32PadUpper: "RFC4648 case-insensitive - with padding"
        case .base32z: "z-base-32 (used by Tahoe-LAFS)"
        case .base36: "Base36 [0-9a-z] case-insensitive - no padding"
        case .base36Upper: "Base36 [0-9a-z] case-insensitive - no padding"
        case .base58btc: "Base58 Bitcoin"
        case .base58flickr: "Base58 Flicker"
        case .base64: "RFC4648 no padding"
        case .base64Pad: "RFC4648 with padding - MIME encoding"
        case .base64Url: "RFC4648 no padding"
        case .base64UrlPad: "RFC4648 with padding"
        }
    }

    /// The `encoding`s current status according to the spec.
    public var status: BaseStatus {
        switch self {
        case .identity: .reserved
        case .base2: .experimental
        case .base8: .draft
        case .base10: .draft
        case .base16: .final
        case .base16Upper: .final
        case .base32Hex: .experimental
        case .base32HexUpper: .experimental
        case .base32HexPad: .experimental
        case .base32HexPadUpper: .experimental
        case .base32: .final
        case .base32Upper: .final
        case .base32Pad: .draft
        case .base32PadUpper: .draft
        case .base32z: .draft
        case .base36: .draft
        case .base36Upper: .draft
        case .base58btc: .final
        case .base58flickr: .experimental
        case .base64: .final
        case .base64Pad: .experimental
        case .base64Url: .final
        case .base64UrlPad: .final
        }
    }

    /// The prefixes the table reserves for something other than a base encoding.
    ///
    /// U+0000 is a `none` row too, but this package exposes it as ``identity``, so it is
    /// not listed here.
    ///
    /// - Note: `Q` is reserved, yet a `Qm…` string might be a CIDv0, base58btc with no
    ///   multibase prefix. ``decode(prefixed:)`` handles that shape before it consults
    ///   this set.
    internal static let reservedPrefixes: Set<Unicode.Scalar> = ["1", "Q", "/"]
}

/// How settled an encoding's entry is in the multibase table / spec.
///
/// - Warning: An `experimental` or `draft` encoding's prefix character can still change.
///   Prefer a `final` encoding when writing a new multibase string.
public enum BaseStatus: String, CaseIterable, Equatable, Sendable {
    case reserved
    case experimental
    case draft
    case final
}
