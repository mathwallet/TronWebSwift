//
//  TronAccount.swift
//  
//
//  Created by math on 2021/12/27.
//

import Foundation
import Secp256k1Swift

public struct TronAccount {
    public var privateKey: Data
    public var publicKey: Data
    
    public var address: TronAddress {
        return TronAddress(publicKey: publicKey)!
    }
    
    init(privateKey: Data) throws {
        guard TronAccount.isValidPrivateKey(privateKey), let publicKey = SECP256K1.privateToPublic(privateKey: privateKey, compressed: false) else {
            throw Error.invalidPrivateKey
        }
        
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    static func isValidPrivateKey(_ privateKey: Data) -> Bool{
        return SECP256K1.verifyPrivateKey(privateKey: privateKey)
    }
}

extension TronAccount {
    func signDigest(_ hash: Data) -> Data? {
        let signedData = SECP256K1.signForRecovery(hash: hash, privateKey: privateKey, useExtraVer: false)
        return signedData.serializedSignature
    }
    
    func signPersonalMessage(_ personalMessage: Data) -> Data? {
        var prefix = "\u{19}TRON Signed Message:\n"
        prefix += String(personalMessage.count)
        
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

extension TronAccount {
    enum Error: String, LocalizedError {
        case invalidPrivateKey
        
        var errorDescription: String? {
            return "TronWeb.Account.Error.\(rawValue)"
        }
    }
}
