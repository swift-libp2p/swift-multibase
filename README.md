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

Every encoding from the multibase table is supported. The single-character prefix is prepended on
encode (and consumed on decode) so the base is self-describing.

| Prefix    | Encoding                                    | Description                          | Status    |
|-----------|---------------------------------------------|--------------------------------------|-----------|
| `0x00`    | `.identity`                                 | 8-bit binary (raw bytes)             | default   |
| `0`       | `.base2`                                    | binary (`01010101`)                  | candidate |
| `7`       | `.base8`                                    | octal                                | draft     |
| `9`       | `.base10`                                   | decimal                              | draft     |
| `f` / `F` | `.base16` / `.base16Upper`                  | hexadecimal                          | default   |
| `b` / `B` | `.base32` / `.base32Upper`                  | rfc4648 - no padding                 | default   |
| `c` / `C` | `.base32Pad` / `.base32PadUpper`            | rfc4648 - with padding               | candidate |
| `v` / `V` | `.base32Hex` / `.base32HexUpper`            | rfc4648 extended hex - no padding    | candidate |
| `t` / `T` | `.base32HexPad` / `.base32HexPadUpper`      | rfc4648 extended hex - with padding  | candidate |
| `h`       | `.base32z`                                  | z-base-32                            | draft     |
| `k` / `K` | `.base36` / `.base36Upper`                  | base36 `[0-9a-z]`                    | draft     |
| `z`       | `.base58btc`                                | base58 bitcoin                       | default   |
| `Z`       | `.base58flickr`                             | base58 flickr                        | candidate |
| `m` / `M` | `.base64` / `.base64Pad`                    | rfc4648 - without / with padding     | default   |
| `u` / `U` | `.base64Url` / `.base64UrlPad`              | rfc4648 url-safe - without / with pad | default  |

> Base58btc payloads that carry no multibase prefix (e.g. legacy `Qm…` Peer IDs) are also recognized
> by `BaseEncoding.decode(_:)`.


## Install

Include the following dependency in your Package.swift file
```Swift
let package = Package(
    ...
    dependencies: [
        ...
        .package(url: "https://github.com/swift-libp2p/swift-multibase.git", .upToNextMinor(from: "0.2.0"))
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

```Swift
import Multibase

/// The Multibase format is:
/// <base-encoding-character><base-encoded-data>
/// Where `<base-encoding-character>` is used according to the multibase table.

// To Encode a human readable string into a certain base encoding...
"Decentralize everything!!".encode(as: .base8) // -> "72106254331267164344605543227514510062566312711713506415133463441102" -- Note the '7' multibase prefix tag
"Decentralize everything!!".encode(as: .base64) // -> "mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ" -- Note the 'm' multibase prefix tag

// To Decode a Multibase encoded string (one that has the proper base prefix prepended)...
try BaseEncoding.decodeIntoString("72106254331267164344605543227514510062566312711713506415133463441102") // -> (base: .base8, string: "Decentralize everything!!")
try BaseEncoding.decodeIntoString("mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ") // -> (base: .base64, string: "Decentralize everything!!")

// Decode straight to raw bytes, inferring the base from the prefix...
try BaseEncoding.decode("mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ") // -> (base: .base64, data: Data)

// ...or decode a prefix-less string when you already know the base...
try BaseEncoding.decode("796573206d616e692021", as: .base16) // -> (base: .base16, data: Data)

/// String/Data/[UInt8] extensions (NOTE: all extensions default to no Multibase prefix!)
"Hello World".data(using: .utf8)!.asString(base: .base16)                              // ->  48656c6c6f20576f726c64 
"Hello World".data(using: .utf8)!.asString(base: .base16, withMultibasePrefix: true)   // -> f48656c6c6f20576f726c64

```

### Error Handling

Decoding funnels every base-specific failure into a single `BaseEncoding.MultibaseError`, so callers only
ever have to catch one error type:

```Swift
public enum MultibaseError: Error {
    /// The string is empty or its leading character is not a recognized multibase prefix.
    case unknownBase
    /// The decoded bytes could not be represented in the requested `String.Encoding`.
    case invalidStringEncoding
    /// A base-specific decoder rejected the input (e.g. an invalid character for the base's
    /// alphabet). The underlying swift-bases error is preserved for diagnostics.
    case decodingFailed(underlying: any Error)
}

do {
    let (base, data) = try BaseEncoding.decode("m****") // '*' is not in the base64 alphabet
} catch let error as BaseEncoding.MultibaseError {
    // handle unknownBase / invalidStringEncoding / decodingFailed
}
```

### API
```Swift

/// BaseEncoding Enum
let multibase = try BaseEncoding.decodeIntoString("t8him6pbeehp62r39f9ii0pbmclp7it38d5n6e891")
multibase.base   // -> .base32HexPad
multibase.string // -> "Decentralize everything!!"

/// Encoding
BaseEncoding.encode(data: Data) -> String                                              // prepends the multibase prefix

/// Decoding
BaseEncoding.decode(_: String) throws -> (base: BaseEncoding, data: Data)              // infers base from the prefix
BaseEncoding.decode(_: String, as: BaseEncoding) throws -> (base: BaseEncoding, data: Data)  // prefix-less input
BaseEncoding.decodeIntoString(_: String, using: String.Encoding = .utf8) throws -> (base: BaseEncoding, string: String)

/// Prefix lookup & metadata
BaseEncoding.init?(prefix: Character)      // e.g. "f" -> .base16
BaseEncoding.init?(prefixByte: UInt8)      // e.g. 0x00 -> .identity
BaseEncoding.charPrefix -> String          // the single-character multibase prefix
BaseEncoding.bytePrefix -> UInt8           // the prefix as a raw byte
BaseEncoding.alphabet -> String            // the canonical alphabet for this base
BaseEncoding.status -> String              // "default" | "candidate" | "draft"
BaseEncoding.description -> String?        // human readable description
BaseEncoding.isValid(_: String) -> Bool    // is every character in this base's alphabet?


/// String Extensions
String(decoding:String, as:BaseEncoding, using:String.Encoding = .utf8) throws
String.baseEncoding -> BaseEncoding
String.encode(as: BaseEncoding, using:String.Encoding = .ascii) -> String
String.encodeUTF8(base: BaseEncoding) -> String
String.encodeASCII(base: BaseEncoding) -> String


/// Data Extensions
Data.init(decoding:String, as:BaseEncoding) throws
Data.asString(base:BaseEncoding, withMultibasePrefix:Bool = false) -> String


/// Array<UInt8> Extensions
Array<UInt8>(decoding:String, as:BaseEncoding) throws
Array<UInt8>.asString(base:BaseEncoding, withMultibasePrefix:Bool = false) -> String

```

## Contributing

Contributions are welcomed! This code is very much a proof of concept. I can guarantee you there's a better / safer way to accomplish the same results. Any suggestions, improvements, or even just critques, are welcome! 

Let's make this code better together! 🤝

## Credits

- [Multiformat / Multibase Spec](https://github.com/multiformats/multibase)


## License

[MIT](LICENSE) © 2026 Breth Inc.
