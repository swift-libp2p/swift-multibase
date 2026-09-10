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
import Testing

@testable import Multibase

/// Covers the byte-native API added in 0.3.0. `MultibaseTests` covers the same ground
/// through the deprecated `Data`/`String` surface.
@Suite("Multibase Byte Tests")
struct MultibaseByteTests {

    let plaintext = Array("yes mani !".utf8)

    /// The upstream multibase test vectors for "yes mani !", prefix included.
    static let vectors: [(base: BaseEncoding, encoded: String)] = [
        (.base2, "001111001011001010111001100100000011011010110000101101110011010010010000000100001"),
        (.base8, "7362625631006654133464440102"),
        (.base10, "9573277761329450583662625"),
        (.base16, "f796573206d616e692021"),
        (.base16Upper, "F796573206D616E692021"),
        (.base32, "bpfsxgidnmfxgsibb"),
        (.base32Upper, "BPFSXGIDNMFXGSIBB"),
        (.base32Hex, "vf5in683dc5n6i811"),
        (.base32HexUpper, "VF5IN683DC5N6I811"),
        (.base32z, "hxf1zgedpcfzg1ebb"),
        (.base36, "k2lcpzo5yikidynfl"),
        (.base36Upper, "K2LCPZO5YIKIDYNFL"),
        (.base58btc, "z7paNL19xttacUY"),
        (.base58flickr, "Z7Pznk19XTTzBtx"),
        (.base64, "meWVzIG1hbmkgIQ"),
        (.base64Pad, "MeWVzIG1hbmkgIQ=="),
        (.base64Url, "ueWVzIG1hbmkgIQ"),
        (.base64UrlPad, "UeWVzIG1hbmkgIQ=="),
    ]

    // MARK: - Encoding

    @Test func testEncodesUpstreamVectors() {
        for vector in Self.vectors {
            #expect(vector.base.encode(plaintext) == vector.encoded)
            #expect(vector.base.encodedBytes(plaintext) == Array(vector.encoded.utf8))
        }
    }

    /// `withPrefix: false` skips the prefix rather than encoding it and dropping it.
    @Test func testEncodingWithoutPrefix() {
        for vector in Self.vectors {
            let body = String(vector.encoded.dropFirst())
            #expect(vector.base.encode(plaintext, withPrefix: false) == body)
            #expect(vector.base.encodedBytes(plaintext, withPrefix: false) == Array(body.utf8))
        }
    }

    /// A slice encodes without first being copied into an array.
    @Test func testEncodesASliceWithoutCopying() {
        let padded = Array("<<>>".utf8) + plaintext
        #expect(padded.dropFirst(4).multibaseEncoded(.base58btc) == "z7paNL19xttacUY")
    }

    @Test func testCollectionAndStringEntryPoints() {
        #expect(plaintext.multibaseEncoded(.base16) == "f796573206d616e692021")
        #expect(plaintext.multibaseEncodedBytes(.base16) == Array("f796573206d616e692021".utf8))
        #expect("yes mani !".multibaseEncoded(.base16) == "f796573206d616e692021")
        #expect(plaintext.multibaseEncoded(.base16, withPrefix: false) == "796573206d616e692021")
    }

    // MARK: - Decoding

    @Test func testDecodesUpstreamVectors() throws {
        for vector in Self.vectors {
            let (base, bytes) = try BaseEncoding.decode(prefixed: Array(vector.encoded.utf8))
            #expect(base == vector.base)
            #expect(bytes == plaintext)

            // The same through the String and Collection entry points.
            #expect(try vector.encoded.multibase().bytes == plaintext)
            #expect(try Array(vector.encoded.utf8).multibase().base == vector.base)
        }
    }

    @Test func testDecodesAPayloadWithoutAPrefix() throws {
        for vector in Self.vectors {
            let body = Array(vector.encoded.dropFirst().utf8)
            #expect(try BaseEncoding.decode(body, as: vector.base) == plaintext)
        }
    }

    /// `split` hands back a slice of the input, and decodes nothing.
    @Test func testSplitDoesNotCopyOrDecode() throws {
        let encoded = Array("z7paNL19xttacUY".utf8)
        let (base, body) = try BaseEncoding.split(prefixed: encoded)
        #expect(base == .base58btc)
        #expect(Array(body) == Array("7paNL19xttacUY".utf8))
        // The body is a slice, so its indices are still those of the original buffer.
        #expect(body.startIndex == 1)
        #expect(try BaseEncoding.decode(body, as: base) == plaintext)

        let (sameBase, sameBody) = try encoded.strippingMultibasePrefix()
        #expect(sameBase == .base58btc)
        #expect(Array(sameBody) == Array(body))
    }

    @Test func testRoundTripsEveryBaseAndLength() throws {
        let bytes = (0...255).map { UInt8($0) }
        for base in BaseEncoding.allCases {
            for length in [0, 1, 2, 3, 5, 8, 32, 256] {
                let payload = Array(bytes.prefix(length))
                let encoded = base.encodedBytes(payload)
                let (decodedBase, decoded) = try BaseEncoding.decode(prefixed: encoded)
                #expect(decodedBase == base, "\(base.name) length \(length) failed")
                #expect(decoded == payload, "\(base.name) length \(length) failed")
            }
        }
    }

    /// The byte path is lossless for `identity`, where the `String` path is not, a
    /// non-UTF8 payload survives as bytes but renders as U+FFFD as text.
    @Test func testIdentityIsLosslessOnTheBytePath() throws {
        let binary: [UInt8] = [0x00, 0xFF, 0xFE, 0x80, 0x01]
        let encoded = BaseEncoding.identity.encodedBytes(binary)
        #expect(encoded == [0x00] + binary)

        let (base, decoded) = try BaseEncoding.decode(prefixed: encoded)
        #expect(base == .identity)
        #expect(decoded == binary)

        // The String rendering is lossy, which is why the byte path exists.
        #expect(Array(BaseEncoding.identity.encode(binary).utf8) != encoded)
    }

    // MARK: - Prefixes

    @Test func testPrefixes() {
        #expect(BaseEncoding.base16.prefix == "f")
        #expect(BaseEncoding.base58btc.prefix == "z")
        #expect(BaseEncoding.identity.prefix == "\u{0000}")
        #expect(BaseEncoding.base16.prefixBytes == [UInt8(ascii: "f")])
        #expect(BaseEncoding.identity.prefixBytes == [0x00])

        #expect(BaseEncoding(prefix: "f") == .base16)
        #expect(BaseEncoding(prefix: "m") == .base64)
        #expect(BaseEncoding(prefix: "\u{0000}") == .identity)
    }

    /// Every case's prefix round-trips, and no two cases share the same prefix.
    @Test func testPrefixesAreUniqueAndRoundTrip() {
        var seen = Set<Unicode.Scalar>()
        for base in BaseEncoding.allCases {
            #expect(BaseEncoding(prefix: base.prefix) == base)
            #expect(seen.insert(base.prefix).inserted, "duplicate prefix for \(base.name)")
            #expect(base.prefixBytes == Array(String(base.prefix).utf8))
        }
    }

    @Test func testNameLookup() {
        #expect(BaseEncoding(name: "base32hexpad") == .base32HexPad)
        #expect(BaseEncoding(name: "base58btc") == .base58btc)
        #expect(BaseEncoding(name: "BASE58BTC") == .base58btc)
        #expect(BaseEncoding(name: "base45") == nil)
        #expect(BaseEncoding(name: "proquint") == nil)
        #expect(BaseEncoding(name: "base256emoji") == nil)
        for base in BaseEncoding.allCases {
            #expect(BaseEncoding(name: base.name) == base)
        }
    }

    /// The prefixes the table reserves are rejected.
    @Test func testReservedPrefixesAreRejected() {
        for reserved in ["1", "Q", "/"] {
            let input = Array((reserved + "abc").utf8)
            #expect(throws: MultibaseError.reservedPrefix(Unicode.Scalar(reserved.first!.asciiValue!))) {
                try BaseEncoding.split(prefixed: input)
            }
        }
    }

    /// A CIDv0 is base58btc carrying no prefix, so `Qm…` is decoded despite `Q`
    /// being reserved.
    @Test func testCIDv0IsDecodedDespiteTheReservedQPrefix() throws {
        let cid = "QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG"
        let (base, bytes) = try BaseEncoding.decode(prefixed: Array(cid.utf8))
        #expect(base == .base58btc)
        #expect(bytes.count == 34)
        // A `Q` prefixed string that isn't a CIDv0 still reports the reserved prefix.
        #expect(throws: MultibaseError.reservedPrefix("Q")) {
            try BaseEncoding.split(prefixed: Array("Qz123".utf8))
        }
    }

    /// The three unimplemented rows are commented out of the table, so their prefixes are
    /// unknown rather than reserved.
    @Test func testUnimplementedBasesAreUnknown() {
        for prefix in ["R", "p", "🚀"] {
            #expect(throws: MultibaseError.unknownBase) {
                try BaseEncoding.split(prefixed: Array((prefix + "abc").utf8))
            }
        }
    }

    @Test func testEmptyAndMalformedInput() {
        #expect(throws: MultibaseError.unknownBase) {
            try BaseEncoding.split(prefixed: [UInt8]())
        }
        // A continuation byte can't start a UTF-8 character.
        #expect(throws: MultibaseError.unknownBase) {
            try BaseEncoding.split(prefixed: [0x80, 0x41])
        }
        // A truncated multi-byte character.
        #expect(throws: MultibaseError.unknownBase) {
            try BaseEncoding.split(prefixed: [0xF0, 0x9F])
        }
    }

    @Test func testMultibasePrefixReportsUnknownCharacters() throws {
        #expect(try Array("f48656c".utf8).multibasePrefix() == "f")
        #expect(try Array("🚀abc".utf8).multibasePrefix() == "🚀")
        #expect(throws: MultibaseError.unknownBase) {
            try [UInt8]().multibasePrefix()
        }
    }

    // MARK: - Table

    @Test func testTableMetadata() {
        #expect(BaseEncoding.base32HexPadUpper.name == "base32hexpadupper")
        #expect(BaseEncoding.base58btc.name == "base58btc")
        #expect(BaseEncoding.base16.details == "Hexadecimal (lowercase)")
        #expect(BaseEncoding.base32z.details == "z-base-32 (used by Tahoe-LAFS)")

        // Statuses match the multibase spec table.
        #expect(BaseEncoding.base16.status == .final)
        #expect(BaseEncoding.base58btc.status == .final)
        #expect(BaseEncoding.base2.status == .experimental)
        #expect(BaseEncoding.base8.status == .draft)
        #expect(BaseEncoding.base64Pad.status == .experimental)
        #expect(BaseEncoding.identity.status == .reserved)
        #expect(Set(BaseStatus.allCases.map(\.rawValue)) == ["reserved", "experimental", "draft", "final"])
    }

    /// Every case carries a name, details and a prefix, and no two cases share a name.
    @Test func testTableIsComplete() {
        #expect(BaseEncoding.allCases.count == 23)
        var names = Set<String>()
        for base in BaseEncoding.allCases {
            #expect(!base.name.isEmpty)
            #expect(base.details?.isEmpty == false)
            #expect(names.insert(base.name).inserted, "duplicate name \(base.name)")
        }
    }

    // MARK: - Alphabets

    @Test func testAlphabetsMatchTheirBases() {
        #expect(BaseEncoding.identity.alphabet == "")
        #expect(BaseEncoding.base2.alphabet == "01")
        #expect(BaseEncoding.base8.alphabet == "01234567")
        #expect(BaseEncoding.base10.alphabet == "0123456789")
        #expect(BaseEncoding.base16.alphabet == "0123456789abcdef")
        #expect(BaseEncoding.base16Upper.alphabet == "0123456789ABCDEF")
        #expect(BaseEncoding.base32.alphabet == "abcdefghijklmnopqrstuvwxyz234567")
        #expect(BaseEncoding.base32Pad.alphabet == "abcdefghijklmnopqrstuvwxyz234567=")
        #expect(BaseEncoding.base32Upper.alphabet == "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")
        #expect(BaseEncoding.base32PadUpper.alphabet == "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=")
        #expect(BaseEncoding.base32Hex.alphabet == "0123456789abcdefghijklmnopqrstuv")
        #expect(BaseEncoding.base32HexPad.alphabet == "0123456789abcdefghijklmnopqrstuv=")
        #expect(BaseEncoding.base32HexUpper.alphabet == "0123456789ABCDEFGHIJKLMNOPQRSTUV")
        #expect(BaseEncoding.base32HexPadUpper.alphabet == "0123456789ABCDEFGHIJKLMNOPQRSTUV=")
        #expect(BaseEncoding.base32z.alphabet == "ybndrfg8ejkmcpqxot1uwisza345h769")
        #expect(BaseEncoding.base36.alphabet == "0123456789abcdefghijklmnopqrstuvwxyz")
        #expect(BaseEncoding.base36Upper.alphabet == "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        #expect(BaseEncoding.base58btc.alphabet == "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")
        #expect(BaseEncoding.base58flickr.alphabet == "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ")
        #expect(
            BaseEncoding.base64.alphabet == "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        )
        #expect(
            BaseEncoding.base64Pad.alphabet == "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
        )
        #expect(
            BaseEncoding.base64Url.alphabet == "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
        )
        #expect(
            BaseEncoding.base64UrlPad.alphabet
                == "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_="
        )
    }

    /// Every encoded body validates against its own base's alphabet.
    @Test func testIsValidAcceptsWhatEncodingProduces() {
        for base in BaseEncoding.allCases {
            let body = base.encodedBytes(plaintext, withPrefix: false)
            #expect(base.isValid(body), "\(base.name) rejected its own output")
        }
        #expect(BaseEncoding.base16.isValid(Array("48656c6c6f".utf8)))
        #expect(!BaseEncoding.base16.isValid(Array("xyz".utf8)))
        #expect(BaseEncoding.identity.isValid(Array("anything at all".utf8)))
        // Case-insensitive bases accept either case, which is what their decoders accept.
        #expect(BaseEncoding.base16.isValid(Array("48656C6C6F".utf8)))
    }

    // MARK: - Errors

    /// Compiles only if the decoders are declared `throws(MultibaseError)`.
    @Test func testDecodeUsesTypedThrows() {
        let thrown: MultibaseError? = {
            do throws(MultibaseError) {
                _ = try BaseEncoding.decode(Array("!!!".utf8), as: .base58btc)
                return nil
            } catch {
                return error
            }
        }()
        #expect(thrown == .decodingFailed(.nonAlphabetCharacter))
    }

    @Test func testErrorIsHashable() {
        let errors: Set<MultibaseError> = [
            .unknownBase,
            .unknownBase,
            .reservedPrefix("Q"),
            .decodingFailed(.nonAlphabetCharacter),
            .decodingFailed(.invalidLength),
            .invalidStringEncoding,
        ]
        #expect(errors.count == 5)
        #expect(errors.contains(.reservedPrefix("Q")))
        #expect(!errors.contains(.reservedPrefix("1")))
    }

    @Test func testSendableConformances() {
        let _: any Sendable = BaseEncoding.base58btc
        let _: any Sendable = BaseStatus.final
        let _: any Sendable = MultibaseError.unknownBase
    }
}
