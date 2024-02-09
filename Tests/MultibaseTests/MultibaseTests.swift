import XCTest
@testable import Multibase

let BasicTests = [
    "base2"             :"001111001011001010111001100100000011011010110000101101110011010010010000000100001",
    "base8"             :"7362625631006654133464440102",
    "base10"            :"9573277761329450583662625",
    "base16"            :"f796573206d616e692021", //f796573206d616e692021
    "base16upper"       :"F796573206D616E692021", //F796573206D616E692021
    "base32"            :"bpfsxgidnmfxgsibb",
    "base32upper"       :"BPFSXGIDNMFXGSIBB",
    "base32hex"         :"vf5in683dc5n6i811",
    "base32hexupper"    :"VF5IN683DC5N6I811",
    "base32pad"         :"cpfsxgidnmfxgsibb",
    "base32padupper"    :"CPFSXGIDNMFXGSIBB",
    "base32hexpad"      :"tf5in683dc5n6i811",
    "base32hexpadupper" :"TF5IN683DC5N6I811",
    "base32z"           :"hxf1zgedpcfzg1ebb",
    "base36"            :"k2lcpzo5yikidynfl",
    "base36upper"       :"K2LCPZO5YIKIDYNFL",
    "base58flickr"      :"Z7Pznk19XTTzBtx",
    "base58btc"         :"z7paNL19xttacUY",
    "base64"            :"meWVzIG1hbmkgIQ",
    "base64pad"         :"MeWVzIG1hbmkgIQ==",
    "base64url"         :"ueWVzIG1hbmkgIQ",
    "base64urlpad"      :"UeWVzIG1hbmkgIQ==",
]

let CaseInsensitivityTests = [
    "base16"            :"f68656c6c6f20776F726C64",
    "base16upper"       :"F68656c6c6f20776F726C64",
    "base32"            :"bnbswy3dpeB3W64TMMQ",
    "base32upper"       :"Bnbswy3dpeB3W64TMMQ",
    "base32hex"         :"vd1imor3f41RMUSJCCG",
    "base32hexupper"    :"Vd1imor3f41RMUSJCCG",
    "base32pad"         :"cnbswy3dpeB3W64TMMQ======",
    "base32padupper"    :"Cnbswy3dpeB3W64TMMQ======",
    "base32hexpad"      :"td1imor3f41RMUSJCCG======",
    "base32hexpadupper" :"Td1imor3f41RMUSJCCG======",
    "base36"            :"kfUvrsIvVnfRbjWaJo",
    "base36upper"       :"KfUVrSIVVnFRbJWAJo",
]

let CaseLeadingZero = [
    "base2"             :"00000000001111001011001010111001100100000011011010110000101101110011010010010000000100001",
    "base8"             :"7000745453462015530267151100204",
    "base10"            :"90573277761329450583662625",
    "base16"            :"f00796573206d616e692021",
    "base16upper"       :"F00796573206D616E692021",
    "base32"            :"bab4wk4zanvqw42jaee",
    "base32upper"       :"BAB4WK4ZANVQW42JAEE",
    "base32hex"         :"v01smasp0dlgmsq9044",
    "base32hexupper"    :"V01SMASP0DLGMSQ9044",
    "base32pad"         :"cab4wk4zanvqw42jaee======",
    "base32padupper"    :"CAB4WK4ZANVQW42JAEE======",
    "base32hexpad"      :"t01smasp0dlgmsq9044======",
    "base32hexpadupper" :"T01SMASP0DLGMSQ9044======",
    "base32z"           :"hybhskh3ypiosh4jyrr",
    "base36"            :"k02lcpzo5yikidynfl",
    "base36upper"       :"K02LCPZO5YIKIDYNFL",
    "base58flickr"      :"Z17Pznk19XTTzBtx",
    "base58btc"         :"z17paNL19xttacUY",
    "base64"            :"mAHllcyBtYW5pICE",
    "base64pad"         :"MAHllcyBtYW5pICE=",
    "base64url"         :"uAHllcyBtYW5pICE",
    "base64urlpad"      :"UAHllcyBtYW5pICE=",
]

let CaseTwoLeadingZeros = [
    "base2"             :"0000000000000000001111001011001010111001100100000011011010110000101101110011010010010000000100001",
    "base8"             :"700000171312714403326055632220041",
    "base10"            :"900573277761329450583662625",
    "base16"            :"f0000796573206d616e692021",
    "base16upper"       :"F0000796573206D616E692021",
    "base32"            :"baaahszltebwwc3tjeaqq",
    "base32upper"       :"BAAAHSZLTEBWWC3TJEAQQ",
    "base32hex"         :"v0007ipbj41mm2rj940gg",
    "base32hexupper"    :"V0007IPBJ41MM2RJ940GG",
    "base32pad"         :"caaahszltebwwc3tjeaqq====",
    "base32padupper"    :"CAAAHSZLTEBWWC3TJEAQQ====",
    "base32hexpad"      :"t0007ipbj41mm2rj940gg====",
    "base32hexpadupper" :"T0007IPBJ41MM2RJ940GG====",
    "base32z"           :"hyyy813murbssn5ujryoo",
    "base36"            :"k002lcpzo5yikidynfl",
    "base36upper"       :"K002LCPZO5YIKIDYNFL",
    "base58flickr"      :"Z117Pznk19XTTzBtx",
    "base58btc"         :"z117paNL19xttacUY",
    "base64"            :"mAAB5ZXMgbWFuaSAh",
    "base64pad"         :"MAAB5ZXMgbWFuaSAh",
    "base64url"         :"uAAB5ZXMgbWFuaSAh",
    "base64urlpad"      :"UAAB5ZXMgbWFuaSAh",
]


final class MultibaseTests: XCTestCase {
    
    func testBinary() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base2
        XCTAssertEqual(testString.encodeASCII(base: .base2), BasicTests["base2"]) //BasicTests["base2"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base2), "001000100011001010110001101100101011011100111010001110010011000010110110001101001011110100110010100100000011001010111011001100101011100100111100101110100011010000110100101101110011001110010000100100001")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("001111001011001010111001100100000011011010110000101101110011010010010000000100001")
        XCTAssertEqual(multibase1.base, .base2)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("001000100011001010110001101100101011011100111010001110010011000010110110001101001011110100110010100100000011001010111011001100101011100100111100101110100011010000110100101101110011001110010000100100001")
        XCTAssertEqual(multibase2.base, .base2)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testOctal() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base 8 (3 bits per char)
        XCTAssertEqual(testString.encodeUTF8(base: .base8), BasicTests["base8"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base8), "72106254331267164344605543227514510062566312711713506415133463441102")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("7362625631006654133464440102")
        XCTAssertEqual(multibase1.base, .base8)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("72106254331267164344605543227514510062566312711713506415133463441102")
        XCTAssertEqual(multibase2.base, .base8)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testDecimal() throws {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        // Base 10 (4 bits per character) (works with the Base58 algo using BigInt)
        XCTAssertEqual(testString.encodeUTF8(base: .base10), BasicTests["base10"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base10), "9429328951066508984658627669258025763026247056774804621697313")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("9573277761329450583662625")
        XCTAssertEqual(multibase1.base, .base10)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("9429328951066508984658627669258025763026247056774804621697313")
        XCTAssertEqual(multibase2.base, .base10)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testHex() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        // Base 16
        XCTAssertEqual(testString.encodeUTF8(base: .base16), BasicTests["base16"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base16), "f446563656e7472616c697a652065766572797468696e672121")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("f796573206d616e692021")
        XCTAssertEqual(multibase1.base, .base16)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("f446563656e7472616c697A652065766572797468696e672121")
        XCTAssertEqual(multibase2.base, .base16)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testHexUpper() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        // Base 16
        XCTAssertEqual(testString.encodeUTF8(base: .base16Upper), BasicTests["base16upper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base16Upper), "F446563656E7472616C697A652065766572797468696E672121")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("F796573206d616e692021")
        XCTAssertEqual(multibase1.base, .base16Upper)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("F446563656e7472616c697a652065766572797468696e672121")
        XCTAssertEqual(multibase2.base, .base16Upper)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32
        XCTAssertEqual(testString.encodeUTF8(base: .base32), BasicTests["base32"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32), "birswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("bpfsxgidnmfxgsibb")
        XCTAssertEqual(multibase1.base, .base32)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("birswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb")
        XCTAssertEqual(multibase2.base, .base32)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32Upper() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base32Upper), BasicTests["base32upper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32Upper), "BIRSWGZLOORZGC3DJPJSSAZLWMVZHS5DINFXGOIJB")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("BPFSXGIDNMFXGSIBB")
        XCTAssertEqual(multibase1.base, .base32Upper)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("BIRSWGZLOORZGC3DJPJSSAZLWMVZHS5DINFXGOIJB")
        XCTAssertEqual(multibase2.base, .base32Upper)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32Pad() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base32Pad), BasicTests["base32pad"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32Pad), "cirswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("cpfsxgidnmfxgsibb")
        XCTAssertEqual(multibase1.base, .base32Pad)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("cirswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb")
        XCTAssertEqual(multibase2.base, .base32Pad)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32PadUpper() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32PadUpper
        XCTAssertEqual(testString.encodeUTF8(base: .base32PadUpper), BasicTests["base32padupper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32PadUpper), "CIRSWGZLOORZGC3DJPJSSAZLWMVZHS5DINFXGOIJB")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("CPFSXGIDNMFXGSIBB")
        XCTAssertEqual(multibase1.base, .base32PadUpper)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("CIRSWGZLOORZGC3DJPJSSAZLWMVZHS5DINFXGOIJB")
        XCTAssertEqual(multibase2.base, .base32PadUpper)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32Hex() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32PadUpper
        XCTAssertEqual(testString.encodeUTF8(base: .base32Hex), BasicTests["base32hex"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32Hex), "v8him6pbeehp62r39f9ii0pbmclp7it38d5n6e891")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("vf5in683dc5n6i811")
        XCTAssertEqual(multibase1.base, .base32Hex)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("v8him6pbeehp62r39f9ii0pbmclp7it38d5n6e891")
        XCTAssertEqual(multibase2.base, .base32Hex)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32HexUpper() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32PadUpper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexUpper), BasicTests["base32hexupper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32HexUpper), "V8HIM6PBEEHP62R39F9II0PBMCLP7IT38D5N6E891")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("VF5IN683DC5N6I811")
        XCTAssertEqual(multibase1.base, .base32HexUpper)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("V8HIM6PBEEHP62R39F9II0PBMCLP7IT38D5N6E891")
        XCTAssertEqual(multibase2.base, .base32HexUpper)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32HexPad() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32PadUpper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexPad), BasicTests["base32hexpad"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32HexPad), "t8him6pbeehp62r39f9ii0pbmclp7it38d5n6e891")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("tf5in683dc5n6i811")
        XCTAssertEqual(multibase1.base, .base32HexPad)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("t8him6pbeehp62r39f9ii0pbmclp7it38d5n6e891")
        XCTAssertEqual(multibase2.base, .base32HexPad)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32HexPadUpper() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32PadUpper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexPadUpper), BasicTests["base32hexpadupper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32HexPadUpper), "T8HIM6PBEEHP62R39F9II0PBMCLP7IT38D5N6E891")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("TF5IN683DC5N6I811")
        XCTAssertEqual(multibase1.base, .base32HexPadUpper)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("T8HIM6PBEEHP62R39F9II0PBMCLP7IT38D5N6E891")
        XCTAssertEqual(multibase2.base, .base32HexPadUpper)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase32z() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base32z
        XCTAssertEqual(testString.encodeUTF8(base: .base32z), BasicTests["base32z"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32z), "het1sg3mqqt3gn5djxj11y3msci3817depfzgqejb")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("hxf1zgedpcfzg1ebb")
        XCTAssertEqual(multibase1.base, .base32z)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("het1sg3mqqt3gn5djxj11y3msci3817depfzgqejb")
        XCTAssertEqual(multibase2.base, .base32z)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase36() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base36
        XCTAssertEqual(testString.encodeUTF8(base: .base36), BasicTests["base36"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base36), "k343ixo7d49hqj1ium15pgy1wzww5fxrid21td7l")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("k2lcpzo5yikidynFl")
        XCTAssertEqual(multibase1.base, .base36)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("k343ixo7d49hqj1ium15pgy1wzww5fxrid21td7l")
        XCTAssertEqual(multibase2.base, .base36)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase36Upper() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base36 Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base36Upper), BasicTests["base36upper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base36Upper), "K343IXO7D49HQJ1IUM15PGY1WZWW5FXRID21TD7L")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("K2LCPZO5YIKIDYNfL")
        XCTAssertEqual(multibase1.base, .base36Upper)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("K343IXO7D49HQJ1IUM15PGY1WZWW5FXRID21TD7L")
        XCTAssertEqual(multibase2.base, .base36Upper)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBTCBase58() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        //Base58 BTC
        XCTAssertEqual(testString.encodeUTF8(base: .base58btc), BasicTests["base58btc"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base58btc), "zUXE7GvtEk8XTXs1GF8HSGbVA9FCX9SEBPe")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("z7paNL19xttacUY")
        XCTAssertEqual(multibase1.base, .base58btc)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("zUXE7GvtEk8XTXs1GF8HSGbVA9FCX9SEBPe")
        XCTAssertEqual(multibase2.base, .base58btc)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testFlickrBase58() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        //Base58 BTC
        XCTAssertEqual(testString.encodeUTF8(base: .base58flickr), BasicTests["base58flickr"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base58flickr), "Ztwe7gVTeK8wswS1gf8hrgAua9fcw9reboD")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("Z7Pznk19XTTzBtx")
        XCTAssertEqual(multibase1.base, .base58flickr)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("Ztwe7gVTeK8wswS1gf8hrgAua9fcw9reboD")
        XCTAssertEqual(multibase2.base, .base58flickr)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase64() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base64
        XCTAssertEqual(testString.encodeUTF8(base: .base64), BasicTests["base64"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base64), "mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("meWVzIG1hbmkgIQ")
        XCTAssertEqual(multibase1.base, .base64)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ")
        XCTAssertEqual(multibase2.base, .base64)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase64Pad() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base64
        XCTAssertEqual(testString.encodeUTF8(base: .base64Pad), BasicTests["base64pad"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base64Pad), "MRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ==")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("MeWVzIG1hbmkgIQ==")
        XCTAssertEqual(multibase1.base, .base64Pad)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("MRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ==")
        XCTAssertEqual(multibase2.base, .base64Pad)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase64Url() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base64
        XCTAssertEqual(testString.encodeUTF8(base: .base64Url), BasicTests["base64url"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base64Url), "uRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("ueWVzIG1hbmkgIQ")
        XCTAssertEqual(multibase1.base, .base64Url)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("uRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ==")
        XCTAssertEqual(multibase2.base, .base64Url)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase64UrlPad() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base64
        XCTAssertEqual(testString.encodeUTF8(base: .base64UrlPad), BasicTests["base64urlpad"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base64UrlPad), "URGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ==")
        
        let multibase1 = try! BaseEncoding.decodeIntoString("UeWVzIG1hbmkgIQ==")
        XCTAssertEqual(multibase1.base, .base64UrlPad)
        XCTAssertEqual(multibase1.string, "yes mani !")
        
        let multibase2 = try! BaseEncoding.decodeIntoString("URGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ==")
        XCTAssertEqual(multibase2.base, .base64UrlPad)
        XCTAssertEqual(multibase2.string, "Decentralize everything!!")
    }
    
    func testBase64CrazyStrings() {
        let tests = [
            "f": "mZg",
            "fo": "mZm8",
            "foo": "mZm9v",
            "foob": "mZm9vYg",
            "fooba": "mZm9vYmE",
            "foobar": "mZm9vYmFy",
            "÷ïÿ": "mw7fDr8O/",
            "÷ïÿ🥰÷ïÿ😎🥶🤯": "mw7fDr8O/8J+lsMO3w6/Dv/CfmI7wn6W28J+krw"
        ]
        
        for test in tests.sorted(by: { $0.key.count < $1.key.count }) {
            let encoded = test.key.encode(as: .base64, using: .utf8)
            print("\"\(test.key)\".encode(as: .base64, using: .utf8) => \(encoded)")
            XCTAssertEqual(encoded, test.value)
            
            let decoded = try! BaseEncoding.decodeIntoString(encoded)
            XCTAssertEqual(decoded.base, .base64)
            XCTAssertEqual(decoded.string, test.key)
        }
    }
    
    func testBase64PadCrazyStrings() {
        let tests = [
            "f": "MZg==",
            "fo": "MZm8=",
            "foo": "MZm9v",
            "foob": "MZm9vYg==",
            "fooba": "MZm9vYmE=",
            "foobar": "MZm9vYmFy",
            "÷ïÿ": "Mw7fDr8O/",
            "÷ïÿ🥰÷ïÿ😎🥶🤯": "Mw7fDr8O/8J+lsMO3w6/Dv/CfmI7wn6W28J+krw=="
        ]
        
        for test in tests.sorted(by: { $0.key.count < $1.key.count }) {
            let encoded = test.key.encode(as: .base64Pad, using: .utf8)
            print("\"\(test.key)\".encode(as: .base64Pad, using: .utf8) => \(encoded)")
            XCTAssertEqual(encoded, test.value)
            
            let decoded = try! BaseEncoding.decodeIntoString(encoded)
            XCTAssertEqual(decoded.base, .base64Pad)
            XCTAssertEqual(decoded.string, test.key)
        }
    }
    
    func testBase64URLCrazyStrings() {
        let tests = [
            "f": "uZg",
            "fo": "uZm8",
            "foo": "uZm9v",
            "foob": "uZm9vYg",
            "fooba": "uZm9vYmE",
            "foobar": "uZm9vYmFy",
            "÷ïÿ": "uw7fDr8O_",
            "÷ïÿ🥰÷ïÿ😎🥶🤯": "uw7fDr8O_8J-lsMO3w6_Dv_CfmI7wn6W28J-krw"
        ]
        
        for test in tests.sorted(by: { $0.key.count < $1.key.count }) {
            let encoded = test.key.encode(as: .base64Url, using: .utf8)
            print("\"\(test.key)\".encode(as: .base64Url, using: .utf8) => \(encoded)")
            XCTAssertEqual(encoded, test.value)
            
            let decoded = try! BaseEncoding.decodeIntoString(encoded)
            XCTAssertEqual(decoded.base, .base64Url)
            XCTAssertEqual(decoded.string, test.key)
        }
    }
    
    func testBase64URLPadCrazyStrings() {
        let tests = [
            "f": "UZg==",
            "fo": "UZm8=",
            "foo": "UZm9v",
            "foob": "UZm9vYg==",
            "fooba": "UZm9vYmE=",
            "foobar": "UZm9vYmFy",
            "÷ïÿ": "Uw7fDr8O_",
            "÷ïÿ🥰÷ïÿ😎🥶🤯": "Uw7fDr8O_8J-lsMO3w6_Dv_CfmI7wn6W28J-krw=="
        ]
        
        for test in tests.sorted(by: { $0.key.count < $1.key.count }) {
            let encoded = test.key.encode(as: .base64UrlPad, using: .utf8)
            print("\"\(test.key)\".encode(as: .base64UrlPad, using: .utf8) => \(encoded)")
            XCTAssertEqual(encoded, test.value)
            
            let decoded = try! BaseEncoding.decodeIntoString(encoded)
            XCTAssertEqual(decoded.base, .base64UrlPad)
            XCTAssertEqual(decoded.string, test.key)
        }
    }
    
    func testBase32CrazyStrings() {
        let tests = [
            "f":               "cmy======",
            "fo":              "cmzxq====",
            "foo":             "cmzxw6===",
            "foob":            "cmzxw6yq=",
            "fooba":           "cmzxw6ytb",
            "foobar":          "cmzxw6ytboi======",
            "÷ïÿ":             "cyo34hl6dx4======",
            "÷ïÿ🥰÷ïÿ😎🥶🤯": "cyo34hl6dx7yj7jnqyo34hl6dx7yj7geo6cp2lnxqt6sk6==="
        ]
        
        for test in tests.sorted(by: { $0.key.count < $1.key.count }) {
            let encoded = test.key.encode(as: .base32Pad, using: .utf8)
            print("\"\(test.key)\".encode(as: .base32Pad, using: .utf8) => \(encoded)")
            XCTAssertEqual(encoded, test.value)
            
            let decoded = try! BaseEncoding.decodeIntoString(encoded)
            XCTAssertEqual(decoded.base, .base32Pad)
            XCTAssertEqual(decoded.string, test.key)
        }
    }
    
    func testUTF8() {
        //hello world
//        let helloBytes:[UInt8] = [
//            104,
//            101,
//            108,
//            108,
//            111,
//            32,
//            119,
//            111,
//            114,
//            108,
//            100,
//          ]
//
//        let encoded = Array("hello world".utf8)
//        print(encoded)
//
//        let decoded = String(bytes: helloBytes, encoding: .utf8)
//        print(decoded)
//
//        let base16 = "hello world".encodeUTF8(base: .base16)
//        let base16Test = "yes mani !".encodeUTF8(base: .base16Upper)
//        print(base16)
//        print(base16Test)
    }
    
    func testBasicEncoding() {
        let testString = "yes mani !"
        let testString2 = "Decentralize everything!!"
        
        //Base2
        XCTAssertEqual(testString.encodeUTF8(base: .base2), BasicTests["base2"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base2), "001000100011001010110001101100101011011100111010001110010011000010110110001101001011110100110010100100000011001010111011001100101011100100111100101110100011010000110100101101110011001110010000100100001")
        
        // Base 8 (3 bits per character)
        XCTAssertEqual(testString.encodeUTF8(base: .base8), BasicTests["base8"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base8), "72106254331267164344605543227514510062566312711713506415133463441102")
        
        // Base 10
        XCTAssertEqual(testString.encodeUTF8(base: .base10), BasicTests["base10"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base10), "9429328951066508984658627669258025763026247056774804621697313")
        
        //Base16 lowercased
        XCTAssertEqual(testString.encodeUTF8(base: .base16), BasicTests["base16"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base16), "f446563656e7472616c697a652065766572797468696e672121")
        
        //Base16 uppercased
        XCTAssertEqual(testString.encodeUTF8(base: .base16Upper), BasicTests["base16upper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base16Upper), "F446563656E7472616C697A652065766572797468696E672121")
        
        //Base32
        XCTAssertEqual(testString.encodeUTF8(base: .base32), BasicTests["base32"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32), "birswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb")
        
        //Base32Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base32Upper), BasicTests["base32upper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32Upper), "BIRSWGZLOORZGC3DJPJSSAZLWMVZHS5DINFXGOIJB")
        
        //Base32Hex
        XCTAssertEqual(testString.encodeUTF8(base: .base32Hex), BasicTests["base32hex"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32Hex), "v8him6pbeehp62r39f9ii0pbmclp7it38d5n6e891")
        
        //Base32HexUpper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexUpper), BasicTests["base32hexupper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32HexUpper), "V8HIM6PBEEHP62R39F9II0PBMCLP7IT38D5N6E891")
        
        //Base32Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base32Pad), BasicTests["base32pad"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32Pad), "cirswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb")
        
        //Base32PadUpper
        XCTAssertEqual(testString.encodeUTF8(base: .base32PadUpper), BasicTests["base32padupper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32PadUpper), "CIRSWGZLOORZGC3DJPJSSAZLWMVZHS5DINFXGOIJB")
        
        //Base32HexPad
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexPad), BasicTests["base32hexpad"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32HexPad), "t8him6pbeehp62r39f9ii0pbmclp7it38d5n6e891")
        
        //Base32HexPadUpper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexPadUpper), BasicTests["base32hexpadupper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32HexPadUpper), "T8HIM6PBEEHP62R39F9II0PBMCLP7IT38D5N6E891")
        
        //Base32z
        XCTAssertEqual(testString.encodeUTF8(base: .base32z), BasicTests["base32z"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base32z), "het1sg3mqqt3gn5djxj11y3msci3817depfzgqejb")
        
        //Base36
        XCTAssertEqual(testString.encodeUTF8(base: .base36), BasicTests["base36"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base36), "k343ixo7d49hqj1ium15pgy1wzww5fxrid21td7l")
        
        //Base36Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base36Upper), BasicTests["base36upper"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base36Upper), "K343IXO7D49HQJ1IUM15PGY1WZWW5FXRID21TD7L")
        
        //Base58 Flickr
        XCTAssertEqual(testString.encodeUTF8(base: .base58flickr), BasicTests["base58flickr"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base58flickr), "Ztwe7gVTeK8wswS1gf8hrgAua9fcw9reboD")
        
        //Base58 BTC
        XCTAssertEqual(testString.encodeUTF8(base: .base58btc), BasicTests["base58btc"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base58btc), "zUXE7GvtEk8XTXs1GF8HSGbVA9FCX9SEBPe")
        
        //Base64
        XCTAssertEqual(testString.encodeUTF8(base: .base64), BasicTests["base64"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base64), "mRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ")
        
        //Base64Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base64Pad), BasicTests["base64pad"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base64Pad), "MRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ==")
        
        //Base64Url
        XCTAssertEqual(testString.encodeUTF8(base: .base64Url), BasicTests["base64url"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base64Url), "uRGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ")
        
        //Base64UrlPad
        XCTAssertEqual(testString.encodeUTF8(base: .base64UrlPad), BasicTests["base64urlpad"])
        XCTAssertEqual(testString2.encodeUTF8(base: .base64UrlPad), "URGVjZW50cmFsaXplIGV2ZXJ5dGhpbmchIQ==")
        
    }
    
    func testCaseInsensitivity() {
        let testString = "hello world"
        
        //Base16 Lower
        let base16Lower = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base16"]!)
        XCTAssertEqual(base16Lower.base, .base16)
        XCTAssertEqual(base16Lower.string, testString)
        
        //Base16 Upper
        let base16Upper = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base16upper"]!)
        XCTAssertEqual(base16Upper.base, .base16Upper)
        XCTAssertEqual(base16Upper.string, testString)
        
        //Base32
        let base32 = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base32"]!)
        XCTAssertEqual(base32.base, .base32)
        XCTAssertEqual(base32.string, testString)
        
        //Base32 Upper
        let base32Upper = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base32upper"]!)
        XCTAssertEqual(base32Upper.base, .base32Upper)
        XCTAssertEqual(base32Upper.string, testString)
        
        //Base32 Pad
        let base32Pad = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base32pad"]!)
        XCTAssertEqual(base32Pad.base, .base32Pad)
        XCTAssertEqual(base32Pad.string, testString)
        
        //Base32 Upper Pad
        let base32PadUpper = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base32padupper"]!)
        XCTAssertEqual(base32PadUpper.base, .base32PadUpper)
        XCTAssertEqual(base32PadUpper.string, testString)
        
        //Base32 Hex
        let base32Hex = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base32hex"]!)
        XCTAssertEqual(base32Hex.base, .base32Hex)
        XCTAssertEqual(base32Hex.string, testString)
        
        //Base32 Hex Upper
        let base32HexUpper = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base32hexupper"]!)
        XCTAssertEqual(base32HexUpper.base, .base32HexUpper)
        XCTAssertEqual(base32HexUpper.string, testString)
        
        //Base32 Hex Pad
        let base32HexPad = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base32hexpad"]!)
        XCTAssertEqual(base32HexPad.base, .base32HexPad)
        XCTAssertEqual(base32HexPad.string, testString)
        
        //Base32 Hex Pad Upper
        let base32HexPadUpper = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base32hexpadupper"]!)
        XCTAssertEqual(base32HexPadUpper.base, .base32HexPadUpper)
        XCTAssertEqual(base32HexPadUpper.string, testString)
        
        //Base36
        let base36 = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base36"]!)
        XCTAssertEqual(base36.base, .base36)
        XCTAssertEqual(base36.string, testString)
        
        //Base36 Upper
        let base36Upper = try! BaseEncoding.decodeIntoString(CaseInsensitivityTests["base36upper"]!)
        XCTAssertEqual(base36Upper.base, .base36Upper)
        XCTAssertEqual(base36Upper.string, testString)
    }
    
    func testLeadingZero() {
        //let testString = "\\x00yes mani !"
        let testString = "\0yes mani !"
        
        //Base2
        XCTAssertEqual(testString.encodeUTF8(base: .base2), CaseLeadingZero["base2"])
        
        //Base8
        XCTAssertEqual(testString.encodeUTF8(base: .base8), CaseLeadingZero["base8"])
        
        //Base10
        XCTAssertEqual(testString.encodeUTF8(base: .base10), CaseLeadingZero["base10"])
        
        //Base16 Lower
        XCTAssertEqual(testString.encodeUTF8(base: .base16), CaseLeadingZero["base16"])
        
        //Base16 Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base16Upper), CaseLeadingZero["base16upper"])
        
        //Base32
        XCTAssertEqual(testString.encodeUTF8(base: .base32), CaseLeadingZero["base32"])
        
        //Base32 Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base32Upper), CaseLeadingZero["base32upper"])
        
        //Base32 Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base32Pad), CaseLeadingZero["base32pad"])
        
        //Base32 Upper Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base32PadUpper), CaseLeadingZero["base32padupper"])
        
        //Base32 Hex
        XCTAssertEqual(testString.encodeUTF8(base: .base32Hex), CaseLeadingZero["base32hex"])
        
        //Base32 Hex Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexUpper), CaseLeadingZero["base32hexupper"])
        
        //Base32 Hex Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexPad), CaseLeadingZero["base32hexpad"])
        
        //Base32 Hex Pad Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexPadUpper), CaseLeadingZero["base32hexpadupper"])
        
        //Base32 Z
        XCTAssertEqual(testString.encodeUTF8(base: .base32z), CaseLeadingZero["base32z"])
        
        //Base36
        XCTAssertEqual(testString.encodeUTF8(base: .base36), CaseLeadingZero["base36"])
        
        //Base36 Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base36Upper), CaseLeadingZero["base36upper"])
        
        //Base58 BTC
        XCTAssertEqual(testString.encodeUTF8(base: .base58btc), CaseLeadingZero["base58btc"])
        
        //Base58 Flickr
        XCTAssertEqual(testString.encodeUTF8(base: .base58flickr), CaseLeadingZero["base58flickr"])
        
        //Base64
        XCTAssertEqual(testString.encodeUTF8(base: .base64), CaseLeadingZero["base64"])
        
        //Base64 Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base64Pad), CaseLeadingZero["base64pad"])
        
        //Base64 URL
        XCTAssertEqual(testString.encodeUTF8(base: .base64Url), CaseLeadingZero["base64url"])
        
        //Base64 URL Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base64UrlPad), CaseLeadingZero["base64urlpad"])
    }
    
    func testTwoLeadingZero() {
        //let testString = "\\x00\\x00yes mani !"
        let testString = "\0\0yes mani !"
        
        //Base2
        XCTAssertEqual(testString.encodeUTF8(base: .base2), CaseTwoLeadingZeros["base2"])
        
        //Base8
        XCTAssertEqual(testString.encodeUTF8(base: .base8), CaseTwoLeadingZeros["base8"])
        
        //Base10
        XCTAssertEqual(testString.encodeUTF8(base: .base10), CaseTwoLeadingZeros["base10"])
        
        //Base16
        XCTAssertEqual(testString.encodeUTF8(base: .base16), CaseTwoLeadingZeros["base16"])
        
        //Base16 Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base16Upper), CaseTwoLeadingZeros["base16upper"])
        
        //Base32
        XCTAssertEqual(testString.encodeUTF8(base: .base32), CaseTwoLeadingZeros["base32"])
        
        //Base32 Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base32Upper), CaseTwoLeadingZeros["base32upper"])
        
        //Base32 Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base32Pad), CaseTwoLeadingZeros["base32pad"])
        
        //Base32 Upper Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base32PadUpper), CaseTwoLeadingZeros["base32padupper"])
        
        //Base32 Hex
        XCTAssertEqual(testString.encodeUTF8(base: .base32Hex), CaseTwoLeadingZeros["base32hex"])
        
        //Base32 Hex Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexUpper), CaseTwoLeadingZeros["base32hexupper"])
        
        //Base32 Hex Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexPad), CaseTwoLeadingZeros["base32hexpad"])
        
        //Base32 Hex Pad Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base32HexPadUpper), CaseTwoLeadingZeros["base32hexpadupper"])
        
        //Base32 Z
        XCTAssertEqual(testString.encodeUTF8(base: .base32z), CaseTwoLeadingZeros["base32z"])
        
        //Base36
        XCTAssertEqual(testString.encodeUTF8(base: .base36), CaseTwoLeadingZeros["base36"])
        
        //Base36 Upper
        XCTAssertEqual(testString.encodeUTF8(base: .base36Upper), CaseTwoLeadingZeros["base36upper"])
        
        //Base58 BTC
        XCTAssertEqual(testString.encodeUTF8(base: .base58btc), CaseTwoLeadingZeros["base58btc"])
        
        //Base58 Flickr
        XCTAssertEqual(testString.encodeUTF8(base: .base58flickr), CaseTwoLeadingZeros["base58flickr"])
        
        //Base64
        XCTAssertEqual(testString.encodeUTF8(base: .base64), CaseTwoLeadingZeros["base64"])
        
        //Base64 Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base64Pad), CaseTwoLeadingZeros["base64pad"])
        
        //Base64 URL
        XCTAssertEqual(testString.encodeUTF8(base: .base64Url), CaseTwoLeadingZeros["base64url"])
        
        //Base64 URL Pad
        XCTAssertEqual(testString.encodeUTF8(base: .base64UrlPad), CaseTwoLeadingZeros["base64urlpad"])
    }

//    func testBase32StringEncoding() {
//        XCTAssertEqual(                         "".base32(upper: true, padded: true), ""                                        )
//        XCTAssertEqual(                        "f".base32(upper: true, padded: true), "MY======"                                )
//        XCTAssertEqual(                       "fo".base32(upper: true, padded: true), "MZXQ===="                                )
//        XCTAssertEqual(                      "foo".base32(upper: true, padded: true), "MZXW6==="                                )
//        XCTAssertEqual(                     "foob".base32(upper: true, padded: true), "MZXW6YQ="                                )
//        XCTAssertEqual(                    "fooba".base32(upper: true, padded: true), "MZXW6YTB"                                )
//        XCTAssertEqual(                   "foobar".base32(upper: true, padded: true), "MZXW6YTBOI======"                        )
//        XCTAssertEqual(               "yes mani !".base32()                         , "pfsxgidnmfxgsibb"                        )
//        XCTAssertEqual(              "hello world".base32()                         , "nbswy3dpeb3w64tmmq"                      )
//        XCTAssertEqual("Decentralize everything!!".base32()                         , "irswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb")
//    }
    
    static var allTests = [
        ("testBinary", testBinary),
        ("testOctal", testOctal),
        ("testDecimal", testDecimal),
        ("testHex", testHex),
        ("testHexUpper", testHexUpper),
        ("testBase32", testBase32),
        ("testBase32Upper", testBase32Upper),
        ("testBase32Pad", testBase32Pad),
        ("testBase32PadUpper", testBase32PadUpper),
        ("testBase32Hex", testBase32Hex),
        ("testBase32HexUpper", testBase32HexUpper),
        ("testBase32HexPad", testBase32HexPad),
        ("testBase32HexPadUpper", testBase32HexPadUpper),
        ("testBase32z", testBase32z),
        ("testBase36", testBase36),
        ("testBase36Upper", testBase36Upper),
        ("testBTCBase58", testBTCBase58),
        ("testFlickrBase58", testFlickrBase58),
        ("testBase64", testBase64),
        ("testBase64Pad", testBase64Pad),
        ("testBase64Url", testBase64Url),
        ("testBase64UrlPad", testBase64UrlPad),
        ("testBase64CrazyStrings", testBase64CrazyStrings),
        ("testBase64PadCrazyStrings", testBase64PadCrazyStrings),
        ("testBase64URLCrazyStrings", testBase64URLCrazyStrings),
        ("testBase64URLPadCrazyStrings", testBase64URLPadCrazyStrings),
        ("testBase32CrazyStrings", testBase32CrazyStrings),
        ("testUTF8", testUTF8),
        ("testBasicEncoding", testBasicEncoding),
        ("testCaseInsensitivity", testCaseInsensitivity),
        ("testLeadingZero", testLeadingZero),
        ("testTwoLeadingZero", testTwoLeadingZero),
    ]
}
