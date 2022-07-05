//
//  TronSigner.swift
//  
//
//  Created by math on 2021/12/27.
//

import Foundation
import Secp256k1Swift
import BIP39swift
import BIP32Swift

public struct TronSigner: CustomStringConvertible {
    public static let PATH = "m/44'/195'/0'/0/0"
    
    public var mnemonics: String?
    public var privateKey: Data
    public var publicKey: Data
    
    public var address: TronAddress {
        return TronAddress(publicKey: publicKey)!
    }
    
    public init(privateKey: Data) throws {
        guard TronSigner.isValidPrivateKey(privateKey), let publicKey = SECP256K1.privateToPublic(privateKey: privateKey, compressed: false) else {
            throw Error.invalidPrivateKey
        }
        
        self.mnemonics = nil
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    public init(mnemonics: String) throws {
        guard let seed = BIP39.seedFromMmemonics(mnemonics) else {
            throw Error.invalidMnemonics
        }
        guard let node = HDNode(seed: seed), let treeNode = node.derive(path: TronSigner.PATH) else {
            throw Error.invalidMnemonics
        }
        guard let privateKey = treeNode.privateKey else {
            throw Error.invalidMnemonics
        }
        guard let publicKey = SECP256K1.privateToPublic(privateKey: privateKey, compressed: false) else {
            throw Error.invalidPrivateKey
        }
        self.mnemonics = mnemonics
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    public static func generate() throws -> TronSigner {
        guard let mnemonics = try BIP39.generateMnemonics(bitsOfEntropy: 128, language: .english) else {
            throw Error.invalidMnemonics
        }
        return try TronSigner(mnemonics: mnemonics)
    }
    
    public static func isValidPrivateKey(_ privateKey: Data) -> Bool{
        return SECP256K1.verifyPrivateKey(privateKey: privateKey)
    }
    
    public var description: String {
        return """
            mnemonics: \(mnemonics ?? ""),
            address: \(address.address),
            publicKey: \(publicKey.toHexString())
            privateKey: \(privateKey.toHexString())
        """
    }
}

extension TronSigner {
    public func signDigest(_ hash: Data) -> Data? {
        let signedData = SECP256K1.signForRecovery(hash: hash, privateKey: privateKey, useExtraVer: false)
        return signedData.serializedSignature
    }
    
    public func signPersonalMessage(_ personalMessage: Data, useTronHeader: Bool = true) -> Data? {
        let prefix = useTronHeader ? "\u{19}TRON Signed Message:\n32" : "\u{19}Ethereum Signed Message:\n32"
        
        guard let prefixData = prefix.data(using: .ascii) else { return nil }
        
        var data = Data()
        if personalMessage.count >= prefixData.count && prefixData == personalMessage[0 ..< prefixData.count] {
            data.append(personalMessage)
        } else {
            data.append(prefixData)
            data.append(personalMessage)
        }
        let hash = data.sha3(.keccak256)
        return signDigest(hash)
    }
}

extension TronSigner {
    public enum Error: String, LocalizedError {
        case invalidMnemonics
        case invalidPrivateKey
        
        public var errorDescription: String? {
            return "TronWeb.Signer.Error.\(rawValue)"
        }
    }
}
