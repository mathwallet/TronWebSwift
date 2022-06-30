//
//  TronWeb+RPCs.swift
//  
//
//  Created by mathwallet on 2022/6/29.
//

import Foundation

public enum TronWebRPCType: String {
    case getAccount
    case getNowBlock
    
    var path: String {
        switch self {
        case .getAccount:
            return "/wallet/getaccount"
        case .getNowBlock:
            return "/wallet/getnowblock"
        }
    }
}

public enum TronWebRPCMethod: String {
    case get = "GET"
    case post = "POST"
}

public struct TRONRGetAccountRequest: Encodable {
    // address should be converted to a hex string
    public var address: String
    // Optional,whether the address is in base58 format
    public var visible: Bool? = true
    
    enum GetAccountRequestKeys: String, CodingKey {
        case address
        case visible
    }
}

public struct GetAccountResponse: Decodable {
    public var address: String
    public var account_name: String
}

public struct TronWebRPCs {
    
}
