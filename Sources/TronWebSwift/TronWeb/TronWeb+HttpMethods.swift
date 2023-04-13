//
//  TronWeb+RPCs.swift
//  
//
//  Created by mathwallet on 2022/6/29.
//

import Foundation

public enum TronWebRequestType: String {
    case getChainParameters
    case getNowBlock
    case getAccount
    case getAccountResource
    case createTransaction
    case transferAsset
    case triggerSmartContract
    case triggerConstantContract
    case broadcastTransaction
    
    var path: String {
        switch self {
        case .getChainParameters:
            return "/wallet/getchainparameters"
        case .getNowBlock:
            return "/wallet/getnowblock"
        case .getAccount:
            return "/wallet/getaccount"
        case .getAccountResource:
            return "/wallet/getaccountresource"
        case .createTransaction:
            return "/wallet/createtransaction"
        case .transferAsset:
            return "/wallet/transferasset"
        case .triggerSmartContract:
            return "/wallet/triggersmartcontract"
        case .triggerConstantContract:
            return "/wallet/triggerconstantcontract"
        case .broadcastTransaction:
            return "/wallet/broadcasthex"
        }
    }
}

public struct TronWebSmartContractResponse: Decodable {
    public struct Result: Decodable {
        public var result: Bool?
        public var code: String?
        public var message: String?
    }
    
    public var result: Result?
    public var transaction: Protocol_Transaction?
}

public struct TronWebConstantContractResponse: Decodable {
    public struct Result: Decodable {
        public var result: Bool?
        public var code: String?
        public var message: String?
    }
    
    public var result: Result?
    public var transaction: Protocol_Transaction?
}

public struct TronWebResponse {
    public struct Error: Decodable {
        public var error: String
        
        enum CodingKeys: String, CodingKey {
            case error = "Error"
        }
    }
}

// MARK: Addition

public struct TronTriggerSmartContractExtension {
    public var contract: Protocol_TriggerSmartContract
    public var functionSelector: String
    public var feeLimit: Int64 = 0
    public var parameter: Data {
        guard contract.data.count >= 4 else {
            return Data()
        }
        return contract.data.suffix(from: 4)
    }
}

public struct TronTransactionSendingResult: Decodable {
    public var result: Bool
    public var code: String?
    public var message: String?
    public var txid: String
    public var transaction: String
    
    enum CodingKeys: String, CodingKey {
        case result
        case code
        case message
        case txid
        case transaction
    }
}

public struct Protocol_Asset: Decodable {
    public var key: String
    public var value: Int64
}

extension Protocol_ChainParameters.ChainParameter: Decodable{
    enum CodingKeys: String, CodingKey {
        case key
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.key = try container.decode(String.self, forKey: .key)
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .value) {
            self.value = rawValue
        }
    }
}

extension Protocol_ChainParameters: Decodable {
    enum CodingKeys: String, CodingKey {
        case chainParameter
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let rawValue = try? container.decodeIfPresent([Protocol_ChainParameters.ChainParameter].self, forKey: .chainParameter) {
            self.chainParameter = rawValue
        }
    }
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

extension Protocol_Account.FreezeV2: Decodable {
    enum CodingKeys: String, CodingKey {
        case amount
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let rawValue = try container.decodeIfPresent(String.self, forKey: .type) {
            switch rawValue {
            case "ENERGY":
                self.type = Protocol_ResourceCode.energy
            case "TRON_POWER":
                self.type = Protocol_ResourceCode.tronPower
            default:
                self.type = Protocol_ResourceCode.bandwidth
            }
        } else {
            self.type = Protocol_ResourceCode.bandwidth
        }
        self.amount = try container.decodeIfPresent(Int64.self, forKey: .amount) ?? 0
    }
}

extension Protocol_Account.AccountResource: Decodable {
    enum CodingKeys: String, CodingKey {
        case frozenBalanceForEnergy = "frozen_balance_for_energy"
        case latestConsumeTimeForEnergy = "latest_consume_time_for_energy"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let rawValue = try? container.decodeIfPresent(Protocol_Account.Frozen.self, forKey: .frozenBalanceForEnergy) {
            self.frozenBalanceForEnergy =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .latestConsumeTimeForEnergy) {
            self.latestConsumeTimeForEnergy =  rawValue
        }
    }
}

extension Protocol_Account: Decodable {
    private enum CodingKeys: String, CodingKey {
        case address
        case accountName = "account_name"
        case balance
        case asset
        case assetV2
        case votes
        case frozen
        case frozenV2
        case netUsage = "net_usage"
        case freeNetUsage = "free_net_usage"
        case createTime = "create_time"
        case latestOprationTime = "latest_opration_time"
        case allowance
        case accountResource = "account_resource"
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
        if let rawValue = try? container.decodeIfPresent([Protocol_Account.FreezeV2].self, forKey: .frozenV2) {
            self.frozenV2 =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .netUsage) {
            self.netUsage =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .freeNetUsage) {
            self.freeNetUsage =  rawValue
        }
        self.createTime = try container.decode(Int64.self, forKey: .createTime)
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .latestOprationTime) {
            self.latestOprationTime =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .allowance) {
            self.allowance =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Protocol_Account.AccountResource.self, forKey: .accountResource) {
            self.accountResource =  rawValue
        }
    }
}


extension Protocol_AccountResourceMessage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case freeNetUsed
        case freeNetLimit
        case netUsed = "NetUsed"
        case netLimit = "NetLimit"
        case assetNetUsed
        case assetNetLimit
        case totalNetLimit = "TotalNetLimit"
        case totalNetWeight = "TotalNetWeight"
        case tronPowerLimit
        case energyUsed = "EnergyUsed"
        case energyLimit = "EnergyLimit"
        case totalEnergyLimit = "TotalEnergyLimit"
        case totalEnergyWeight = "TotalEnergyWeight"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .freeNetUsed) {
            self.freeNetUsed =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .freeNetLimit) {
            self.freeNetLimit =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .netUsed) {
            self.netUsed =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .netLimit) {
            self.netLimit =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent([Protocol_Asset].self, forKey: .assetNetUsed) {
            var assetDict: [String: Int64] = [:]
            rawValue.forEach {
                assetDict[$0.key] = $0.value
            }
            self.assetNetUsed = assetDict
        }
        if let rawValue = try? container.decodeIfPresent([Protocol_Asset].self, forKey: .assetNetLimit) {
            var assetDict: [String: Int64] = [:]
            rawValue.forEach {
                assetDict[$0.key] = $0.value
            }
            self.assetNetLimit = assetDict
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .totalNetLimit) {
            self.totalNetLimit =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .totalNetWeight) {
            self.totalNetWeight =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .tronPowerLimit) {
            self.tronPowerLimit =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .energyUsed) {
            self.energyUsed =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .energyLimit) {
            self.energyLimit =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .totalEnergyLimit) {
            self.totalEnergyLimit =  rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .totalEnergyWeight) {
            self.totalEnergyWeight =  rawValue
        }
    }
}

extension Protocol_Return: Decodable {
    private enum CodingKeys: String, CodingKey {
        case result
        case code
        case message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let rawValue = try? container.decodeIfPresent(Bool.self, forKey: .result) {
            self.result = rawValue
        }
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .code), rawValue.lowercased() != "success" {
            self.code = .otherError
        }
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .message) {
            self.message = rawValue.data(using: .utf8) ?? Data()
        }
    }
}

extension Protocol_Transaction: Decodable {
    private enum CodingKeys: String, CodingKey {
        case signature = "signature"
        case rawData = "raw_data_hex"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let rawValue = try? container.decodeIfPresent(String.self, forKey: .rawData) {
            self.rawData = try Protocol_Transaction.raw(serializedData: Data(hex: rawValue))
        }
        if let rawValue = try? container.decodeIfPresent([String].self, forKey: .signature) {
            self.signature =  rawValue.map({Data(hex: $0)})
        }
    }
}

extension Protocol_TransactionExtention: Decodable {
    private enum CodingKeys: String, CodingKey {
        case result
        case transaction = "transaction"
        case constantResult = "constant_result"
        case energyUsed = "energy_used"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let rawValue = try? container.decodeIfPresent(Protocol_Return.self, forKey: .result) {
            self.result = rawValue
        }
        if let rawValue = try? container.decodeIfPresent(Protocol_Transaction.self, forKey: .transaction) {
            self.transaction = rawValue
        }
        if let rawValue = try? container.decodeIfPresent([String].self, forKey: .constantResult) {
            self.constantResult = rawValue.map({Data(hex: $0)})
        }
        if let rawValue = try? container.decodeIfPresent(Int64.self, forKey: .energyUsed) {
            self.energyUsed = rawValue
        }
    }
}

extension Protocol_BlockHeader.raw: Decodable {
    private enum CodingKeys: String, CodingKey {
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
    private enum CodingKeys: String, CodingKey {
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
    private enum CodingKeys: String, CodingKey {
        case blockHeader = "block_header"
        case transactions = "transactions"
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.blockHeader = try container.decode(Protocol_BlockHeader.self, forKey: .blockHeader)
        self.transactions = try container.decode([Protocol_Transaction].self, forKey: .transactions)
    }
}
