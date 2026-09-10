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

public enum MultibaseError: Error, Hashable, Sendable {

    /// The input was empty, or its leading character is not in the Multibase table.
    case unknownBase

    /// The leading character names a table row that is reserved for something other than a
    /// base encoding.
    ///
    /// The table reserves:
    /// - `1`
    /// - `Q`
    /// - `/`
    ///
    /// - Note: A `Q` prefixed string is only accepted when it's a valid CIDv0 (`Qm…`),
    ///   which is base58btc without the multibase prefix.
    case reservedPrefix(Unicode.Scalar)

    /// The base's decoder failed during decoding.
    ///
    /// Passes the underlying ``BasesError`` along for further information.
    case decodingFailed(BasesError)

    /// The decoded bytes could not be represented in the requested `String.Encoding`.
    case invalidStringEncoding
}

extension MultibaseError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknownBase:
            "the input is empty, or its leading character is not a recognized multibase prefix"
        case .reservedPrefix(let scalar):
            "the multibase table reserves the prefix '\(scalar)' for something other than a base encoding"
        case .decodingFailed(let underlying):
            "the payload could not be decoded in the requested base: \(underlying)"
        case .invalidStringEncoding:
            "the decoded bytes could not be represented in the requested string encoding"
        }
    }
}
