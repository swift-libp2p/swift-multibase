# Multibase

[![](https://img.shields.io/badge/made%20by-Breth-blue.svg?style=flat-square)](https://breth.app)
[![](https://img.shields.io/badge/project-multiformats-blue.svg?style=flat-square)](https://github.com/multiformats/multiformats)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-blue.svg?style=flat-square)](https://github.com/apple/swift-package-manager)
![Build & Test (macos and linux)](https://github.com/swift-libp2p/swift-multibase/actions/workflows/build+test.yml/badge.svg)


> Self identifying base encodings using the Multibase spec

## Table of Contents

- [Overview](#overview)
- [Supported Encodings](#supported-encodings)
- [Install](#install)
- [Usage](#usage)
  - [Example](#example)
  - [Error Handling](#error-handling)
  - [API](#api)
- [Contributing](#contributing)
- [Credits](#credits)
- [License](#license)

## Overview
Multibase is a protocol for disambiguating the encoding of base-encoded (e.g.,
base32, base36, base64, base58, etc.) binary appearing in text.

When text is encoded as bytes, we can usually use a one-size-fits-all encoding
(UTF-8) because we're always encoding to the same set of 256 bytes (+/- the NUL
byte). When that doesn't work, usually for historical or performance reasons, we
can usually infer the encoding from the context.

However, when bytes are encoded as text (using a base encoding), the base choice
of base encoding is often restricted by the context. Worse, these restrictions
can change based on where the data appears in the text. In some cases, we can
only use `[a-z0-9]`. In others, we can use a larger set of characters but need a
compact encoding. This has lead to a large set of "base encodings", one for
every use-case. Unlike when encoding text to bytes, we can't just standardize
around a single base encoding because there is no optimal encoding for all
cases.

Unfortunately, it's not always clear *what* base encoding is used; that's where
multibase comes in. It answers the question:

> Given data d encoded into text s, what base is it encoded with?

#### Heads up ‼️
- This library was originally built as part of a larger project, but now ships with a test suite that
  exercises the full multibase table (empty input, leading-zero payloads, arbitrary `0x00...0xFF`
  binary, case-insensitivity, and padding tolerance).
- All base-specific decode failures are surfaced as a single `BaseEncoding.MultibaseError` so you never
  have to catch the underlying encoder's error types. See [Error Handling](#error-handling).
- As always, vet it against your own requirements before relying on it in production.

#### For more details see 
- [Multiformats / Mulitbase Spec](https://github.com/multiformats/multibase)


## Supported Encodings

The prefix character is prepended on encode (and consumed on decode) so the base is
self-describing.

| Prefix    | Encoding                                    | Description                           | Status       |
|-----------|---------------------------------------------|---------------------------------------|--------------|
| `0x00`    | `.identity`                                 | 8-bit binary (raw bytes)              | reserved     |
| `0`       | `.base2`                                    | binary (`01010101`)                   | experimental |
| `7`       | `.base8`                                    | octal                                 | draft        |
| `9`       | `.base10`                                   | decimal                               | draft        |
| `f` / `F` | `.base16` / `.base16Upper`                  | hexadecimal                           | final        |
| `b` / `B` | `.base32` / `.base32Upper`                  | rfc4648 - no padding                  | final        |
| `c` / `C` | `.base32Pad` / `.base32PadUpper`            | rfc4648 - with padding                | draft        |
| `v` / `V` | `.base32Hex` / `.base32HexUpper`            | rfc4648 extended hex - no padding     | experimental |
| `t` / `T` | `.base32HexPad` / `.base32HexPadUpper`      | rfc4648 extended hex - with padding   | experimental |
| `h`       | `.base32z`                                  | z-base-32                             | draft        |
| `k` / `K` | `.base36` / `.base36Upper`                  | base36 `[0-9a-z]`                     | draft        |
| `z`       | `.base58btc`                                | base58 bitcoin                        | final        |
| `Z`       | `.base58flickr`                             | base58 flickr                         | experimental |
| `m`       | `.base64`                                   | rfc4648 - no padding                  | final        |
| `M`       | `.base64Pad`                                | rfc4648 - with padding (MIME)         | experimental |
| `u`       | `.base64Url`                                | rfc4648 url-safe - no padding         | final        |
| `U`       | `.base64UrlPad`                             | rfc4648 url-safe - with padding       | final        |

Three rows of the table are **not implemented** and are commented out of `BaseEncoding`:
`base45` (`R`), `proquint` (`p`) and `base256emoji` (`🚀`). Leaving them out is what keeps
`encode` non-throwing, every case that's present in the enum can actually be encoded. Their
prefixes decode as `MultibaseError.unknownBase`.

The table also reserves `1`, `Q` and `/` for something other than a base encoding, those
report `MultibaseError.reservedPrefix(_:)`.

> A base58btc payload carrying no multibase prefix at all, a legacy `Qm…` CIDv0 or Peer ID,
> is still recognized by `BaseEncoding.decode(prefixed:)`, which is why `Q` is reserved.


## Install

Include the following dependency in your Package.swift file
```Swift
let package = Package(
    ...
    dependencies: [
        ...
        .package(url: "https://github.com/swift-libp2p/swift-multibase.git", .upToNextMinor(from: "0.3.0"))
    ],
    ...
    targets: [
        .target(
            ...
            dependencies: [
                ...
                .product(name: "Multibase", package: "swift-multibase"),
            ]),
    ]
    ...
)
```

## Usage

### Example

Every encoder takes any collection of bytes and every decoder returns `[UInt8]`, so a
`Data`, an `[UInt8]`, or a slice of either all work without being copied first.

```Swift
import Multibase

/// The Multibase format is:
/// <base-encoding-character><base-encoded-data>
/// Where `<base-encoding-character>` is used according to the multibase table.

let bytes = Array("Decentralize everything!!".utf8)

// Encode, prefix included...
bytes.multibaseEncoded(.base8)   // -> "72106254331267164344605543227514510062566312711713506415133463441102"
bytes.multibaseEncoded(.base64)  // -> "mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ"

// ...or without, when something else already records the base
bytes.multibaseEncoded(.base64, withPrefix: false)  // -> "RGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ"

// Decode a prefixed string or buffer, inferring the base from the prefix
let (base, decoded) = try "mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ".multibase()
base                                         // -> .base64
String(decoding: decoded, as: UTF8.self)     // -> "Decentralize everything!!"

// The same, from bytes
try Array("mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ".utf8).multibase()

// Decode a payload that carries no prefix, when you already know the base
try BaseEncoding.decode("796573206d616e692021", as: .base16)  // -> [UInt8]

// Split the prefix off without decoding, the body is a slice, not a copy
let (b, body) = try Array("f48656c6c6f".utf8).strippingMultibasePrefix()
b                                            // -> .base16
try BaseEncoding.decode(body, as: b)         // -> the bytes of "Hello"

/// `identity` round-trips losslessly on the byte path, where the String path can't
BaseEncoding.identity.encodedBytes([0x00, 0xFF, 0xFE])  // -> [0x00, 0x00, 0xFF, 0xFE]
```

### Error Handling

Decoding funnels every base-specific failure into `MultibaseError`, so callers only ever
have to catch one type. It's `Hashable`, and the decoders are declared
`throws(MultibaseError)`, so `catch` binds the concrete type with no cast:

```Swift
public enum MultibaseError: Error, Hashable, Sendable {
    /// The input is empty, or its leading character is not in the multibase table.
    case unknownBase
    
    /// The table reserves that prefix for something other than a base encoding (`1`, `Q`, `/`).
    case reservedPrefix(Unicode.Scalar)
    
    /// The decoded bytes could not be represented in the requested `String.Encoding`.
    case invalidStringEncoding
    
    /// The base's decoder rejected the payload. Carries the specific `BasesError`.
    case decodingFailed(BasesError)
}

do throws(MultibaseError) {
    let (base, bytes) = try "m****".multibase()  // '*' is not in the base64 alphabet
} catch {
    // Annotating the `do` binds `error` as a `MultibaseError`
    error == .decodingFailed(.nonAlphabetCharacter)  // -> true
}
```

### API
```Swift

/// Encoding
BaseEncoding.encode(_: some Collection<UInt8>, withPrefix: Bool = true) -> String
BaseEncoding.encodedBytes(_: some Collection<UInt8>, withPrefix: Bool = true) -> [UInt8]

/// Decoding
BaseEncoding.decode(prefixed: some Collection<UInt8>) throws(MultibaseError) -> (base: BaseEncoding, bytes: [UInt8])
BaseEncoding.decode(_: some Collection<UInt8>, as: BaseEncoding) throws(MultibaseError) -> [UInt8]
BaseEncoding.decode(_: some StringProtocol) throws(MultibaseError) -> (base: BaseEncoding, bytes: [UInt8])
BaseEncoding.decode(_: some StringProtocol, as: BaseEncoding) throws(MultibaseError) -> [UInt8]
BaseEncoding.split(prefixed: Bytes) throws(MultibaseError) -> (base: BaseEncoding, body: Bytes.SubSequence)

/// Prefix lookup & table metadata
BaseEncoding.init?(prefix: Unicode.Scalar)  // e.g. "f" -> .base16
BaseEncoding.init?(name: String)            // e.g. "base32hexpad" -> .base32HexPad
BaseEncoding.prefix -> Unicode.Scalar       // the prefix character
BaseEncoding.prefixBytes -> [UInt8]         // the prefix, UTF-8 encoded (1-4 bytes)
BaseEncoding.name -> String                 // the table's spelling, e.g. "base32hexpad"
BaseEncoding.details -> String?             // the table's description column
BaseEncoding.status -> BaseStatus           // .reserved | .experimental | .draft | .final
BaseEncoding.alphabet -> String             // read through to swift-bases
BaseEncoding.isValid(_: some Collection<UInt8>) -> Bool

/// Byte Collection Extensions
Collection<UInt8>.multibaseEncoded(_: BaseEncoding, withPrefix: Bool = true) -> String
Collection<UInt8>.multibaseEncodedBytes(_: BaseEncoding, withPrefix: Bool = true) -> [UInt8]
Collection<UInt8>.multibase() throws(MultibaseError) -> (base: BaseEncoding, bytes: [UInt8])
Collection<UInt8>.strippingMultibasePrefix() throws(MultibaseError) -> (base: BaseEncoding, body: SubSequence)
Collection<UInt8>.multibasePrefix() throws(MultibaseError) -> Unicode.Scalar
Collection<UInt8>.asString(base: BaseEncoding, withMultibasePrefix: Bool = false) -> String

/// String Extensions
StringProtocol.multibase() throws(MultibaseError) -> (base: BaseEncoding, bytes: [UInt8])
StringProtocol.multibaseEncoded(_: BaseEncoding, withPrefix: Bool = true) -> String

```

## Contributing

Contributions are welcomed! This code is very much a proof of concept. I can guarantee you there's a better / safer way to accomplish the same results. Any suggestions, improvements, or even just critques, are welcome! 

Let's make this code better together! 🤝

## Credits

- [Multiformat / Multibase Spec](https://github.com/multiformats/multibase)


## License

[MIT](LICENSE) © 2026 Breth Inc.
