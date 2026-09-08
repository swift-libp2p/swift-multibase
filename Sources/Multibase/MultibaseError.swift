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

public enum MultibaseError: Error, Sendable {  // TODO: Hashable once we rethrow a typed error

    case unknownBase

    case invalidStringEncoding

    /// A base-specific decoder rejected the input (e.g. an invalid character for the base's alphabet).
    /// The underlying swift-bases error is preserved for diagnostics.
    case decodingFailed(underlying: any Error)
}

extension MultibaseError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknownBase:
            return "The string is empty or its leading character is not a recognized multibase prefix."
        case .invalidStringEncoding:
            return "The data could not be represented in the requested string encoding."
        case .decodingFailed(let underlying):
            return "The payload could not be decoded in the requested base: \(underlying)"
        }
    }
}
