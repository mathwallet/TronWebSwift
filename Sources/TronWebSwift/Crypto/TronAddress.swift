//
//  TronAddress.swift
//  
//
//  Created by math on 2021/12/27.
//

import Foundation
import BIP32Swift
import CryptoSwift

public struct TronAddress: CustomStringConvertible {
    public static let size = 20
    public static let addressPrefix: UInt8 = 0x41
    
    public var address: String
    public var data: Data
    
    public init?(_ data: Data) {
        guard TronAddress.isValid(data: data) else { return nil }
        
        self.data = data
        self.address = data.bytes.base58CheckEncodedString
    }
    
    public init?(_ string: String) {
        guard let decodeData = string.base58CheckDecodedData else { return nil }
        
        self.init(decodeData)
    }
    
    public init?(publicKey: Data) {
        let hash = Data([TronAddress.addressPrefix]) + publicKey.dropFirst().sha3(.keccak256).suffix(TronAddress.size)
        self.init(hash)
    }
    
    public static func isValid(string: String) -> Bool {
        guard let decodeData = string.base58CheckDecodedData else { return false }
        
        return TronAddress.isValid(data: decodeData)
    }
    
    public static func isValid(data: Data) -> Bool {
        guard data.count == 1 + TronAddress.size else { return false }
        return data.bytes[0] == TronAddress.addressPrefix
    }
    
    public var description: String {
        return address
    }
}

extension TronAddress: Equatable {
    public static func == (lhs: TronAddress, rhs: TronAddress) -> Bool {
        return lhs.address == rhs.address
    }
}
