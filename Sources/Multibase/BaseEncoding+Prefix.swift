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

extension BaseEncoding {

    // MARK: - Prefix

    /// This encoding's multibase prefix character.
    ///
    /// ```swift
    /// BaseEncoding.base16.prefix   // "f"
    /// ```
    ///
    /// A `Unicode.Scalar` rather than a byte, because the table's prefixes are specified as
    /// characters and not all of them are ASCII, base256emoji's is 🚀 (U+1F680).
    public var prefix: Unicode.Scalar {
        // Every raw value in the table is a valid scalar, so this cannot fail.
        Unicode.Scalar(rawValue)!
    }

    /// This encoding's multibase prefix, UTF-8 encoded.
    ///
    /// One byte for every encoding currently implemented, up to four in general.
    public var prefixBytes: [UInt8] {
        Array(String(prefix).utf8)
    }

    /// The encoding whose prefix is `prefix`, if the table has one.
    ///
    /// ```swift
    /// BaseEncoding(prefix: "z")   // .base58btc
    /// ```
    ///
    /// - Returns: `nil` for a prefix the table doesn't list, one it reserves, or for
    ///   one this package hasn't implemented.
    public init?(prefix: Unicode.Scalar) {
        guard let match = BaseEncoding.byPrefix[prefix] else { return nil }
        self = match
    }

    /// The encoding the table calls `name`, if it has one.
    ///
    /// ```swift
    /// BaseEncoding(name: "base32hexpad")   // .base32HexPad
    /// ```
    ///
    /// - Parameter name: A table spelling, such as `"base58btc"`. Matched exactly first,
    ///   then case-insensitively.
    public init?(name: String) {
        if let match = BaseEncoding.byName[name] {
            self = match
            return
        }
        guard let match = BaseEncoding.byName[name.lowercased()] else { return nil }
        self = match
    }

    // MARK: - Lookups

    /// Every encoding keyed by its prefix character, built once.
    internal static let byPrefix: [Unicode.Scalar: BaseEncoding] = {
        var map = [Unicode.Scalar: BaseEncoding](minimumCapacity: allCases.count)
        for base in allCases { map[base.prefix] = base }
        return map
    }()

    /// Every encoding keyed by its table name, built once.
    internal static let byName: [String: BaseEncoding] = {
        var map = [String: BaseEncoding](minimumCapacity: allCases.count)
        for base in allCases { map[base.name] = base }
        return map
    }()
}
