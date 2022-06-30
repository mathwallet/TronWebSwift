//
//  TronWeb+RPCs.swift
//  
//
//  Created by mathwallet on 2022/6/29.
//

import Foundation

public enum TronWebRequestType: String {
    case getAccount
    case getNowBlock
    case createTransaction
    case transferAsset
    case triggerSmartContract
    case broadcastTransaction
    
    var path: String {
        switch self {
        case .getAccount:
            return "/wallet/getaccount"
        case .getNowBlock:
            return "/wallet/getnowblock"
        case .createTransaction:
            return "/wallet/createtransaction"
        case .transferAsset:
            return "/wallet/transferasset"
        case .triggerSmartContract:
            return "/wallet/triggersmartcontract"
        case .broadcastTransaction:
            return "/wallet/broadcasttransaction"
        }
    }
}

public struct TronWebResponse {
    public struct Error: Decodable {
        public var error: String
    }
}


// MARK: Addition
struct Protocol_Asset: Decodable {
    public var key: String
    public var value: Int64
}

extension Protocol_Vote: Decodable {
    enum CodingKeys: String, CodingKey {
        case voteAddress = "vote_address"
        case voteCount = "vote_count"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.voteAddress = TronAddress(try container.decode(String.self, forKey: .voteAddress))!.data
        self.voteCount = try container.decode(Int64.self, forKey: .voteCount)
    }
}

extension Protocol_Account.Frozen: Decodable {
    enum CodingKeys: String, CodingKey {
        case frozenBalance = "frozen_balance"
        case expireTime = "expire_time"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.frozenBalance = try container.decode(Int64.self, forKey: .frozenBalance)
        self.expireTime = try container.decode(Int64.self, forKey: .expireTime)
    }
}

extension Protocol_Account: Decodable {
    enum CodingKeys: String, CodingKey {
        case address
        case accountName = "account_name"
        case balance
        case asset
        case assetV2
        case votes
        case frozen
        case netUsage = "net_usage"
        case createTime = "create_time"
        case latestOprationTime = "latest_opration_time"
        case allowance
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = TronAddress(try container.decode(String.self, forKey: .address))!.data
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .accountName) {
            self.accountName =  rawValue.data(using: .utf8) ?? Data()
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .balance) {
            self.balance =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent([Protocol_Asset].self, forKey: .asset) {
            var assetDict: [String: Int64] = [:]
            rawValue.forEach {
                assetDict[$0.key] = $0.value
            }
            self.asset = assetDict
        }
        if let rawValue = try? container.decodeIfPresent([Protocol_Asset].self, forKey: .assetV2) {
            var assetDict: [String: Int64] = [:]
            rawValue.forEach {
                assetDict[$0.key] = $0.value
            }
            self.assetV2 = assetDict
        }
        if let rawValue = try? container.decodeIfPresent([Protocol_Vote].self, forKey: .votes) {
            self.votes =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent([Protocol_Account.Frozen].self, forKey: .frozen) {
            self.frozen =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .netUsage) {
            self.netUsage =  rawValue
        }
        self.createTime = try container.decode(Int64.self, forKey: .createTime)
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .latestOprationTime) {
            self.latestOprationTime =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .allowance) {
            self.allowance =  rawValue
        }
    }
}

extension Protocol_Transaction.raw: Decodable {
    enum CodingKeys: String, CodingKey {
        case refBlockBytes = "ref_block_bytes"
        case refBlockHash = "ref_block_hash"
        case expiration
        case timestamp
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .refBlockBytes) {
            self.refBlockBytes =  Data(hex: rawValue)
    }
}

extension Protocol_Transaction: Decodable {
    enum CodingKeys: String, CodingKey {
        case signature = "signature"
        case rawData = "raw_data"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .rawData) {
            self.rawData =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent([String].self, forKey: .signature) {
            self.signature =  rawValue.map({Data(hex: $0)})
        }
    }
}

extension Protocol_BlockHeader.raw: Decodable {
    enum CodingKeys: String, CodingKey {
        case timestamp
        case txTrieRoot
        case parentHash
        case number
        case witnessID
        case witnessAddress
        case version
        case accountStateRoot
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .timestamp) {
            self.timestamp =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .txTrieRoot) {
            self.txTrieRoot =  Data(hex: rawValue)
        }
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .parentHash) {
            self.parentHash =  Data(hex: rawValue)
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .number) {
            self.number =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .witnessID) {
            self.witnessID =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .witnessAddress) {
            self.witnessAddress =  Data(hex: rawValue)
        }
        if let rawValue = try? container.decodeIfPresent(Int32.self, forKey: .version) {
            self.version =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .accountStateRoot) {
            self.accountStateRoot =  Data(hex: rawValue)
        }
    }
}

extension Protocol_BlockHeader: Decodable {
    enum CodingKeys: String, CodingKey {
        case witnessSignature = "witness_signature"
        case rawData = "raw_data"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawData = try container.decode(Protocol_BlockHeader.raw.self, forKey: .rawData)
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .witnessSignature) {
            self.witnessSignature =  Data(hex: rawValue)
        }
    }
}

extension Protocol_Block: Decodable {
    enum CodingKeys: String, CodingKey {
        case blockHeader = "block_header"
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.blockHeader = try container.decode(Protocol_BlockHeader.self, forKey: .blockHeader)
    }
}
