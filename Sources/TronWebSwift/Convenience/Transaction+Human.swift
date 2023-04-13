//
//  TronHumanDecodable.swift
//  
//
//  Created by mathwallet on 2022/6/28.
//

import Foundation
import CryptoSwift
import SwiftProtobuf


public struct TronHumanToken {
    public static var MAIN: TronHumanToken = TronHumanToken(symbol: "TRX", decimal: 6)
    
    public var symbol: String
    public var decimal: Int
    
    public init(symbol: String, decimal: Int) {
        self.symbol = symbol
        self.decimal = decimal
    }
    
    public func formatString(amount: Int64) -> String {
        return "\(Decimal(amount).power10(-decimal).description) \(symbol)"
    }
}

public protocol TronHumanDecodable {
    func toHuman() throws -> [String: Any]
}

extension Protocol_AccountType {
    var desc: String {
        switch self {
        case .normal:
            return "normal"
        case .assetIssue:
            return "assetIssue"
        case .contract:
            return "contract"
        case .UNRECOGNIZED(let i):
            return "unrecognized(\(i)"
        }
    }
}
extension Protocol_Permission.PermissionType {
    var desc: String {
        switch self {
        case .owner:
            return "owner"
        case .witness:
            return "witness"
        case .active:
            return "active"
        case .UNRECOGNIZED(let i):
            return "unrecognized(\(i)"
        }
    }
}

extension Protocol_ResourceCode {
    var desc: String {
        switch self {
        case .bandwidth:
            return "bandwidth"
        case .energy:
            return "energy"
        case .tronPower:
            return "tronPower"
        case .UNRECOGNIZED(let i):
            return "unrecognized(\(i)"
        }
    }
}

extension Protocol_AccountCreateContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "accountAddress": TronAddress(accountAddress)?.address ?? "",
            "type": self.type.desc
        ]
    }
}

extension Protocol_TransferContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "toAddress": TronAddress(toAddress)?.address ?? "",
            "amount": TronHumanToken.MAIN.formatString(amount: amount)
        ]
    }
}

extension Protocol_TransferAssetContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "assetName": String(data: assetName, encoding: .utf8) ?? "",
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "toAddress": TronAddress(toAddress)?.address ?? "",
            "amount": amount
        ]
    }
}

extension Protocol_VoteAssetContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "voteAddress": voteAddress.map({ TronAddress($0)?.address ?? "" }),
            "support": support,
            "count": count
        ]
    }
}

extension Protocol_VoteWitnessContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "votes": votes.map({ ["voteAddress": TronAddress($0.voteAddress)?.address ?? "", "voteCount": $0.voteCount] }),
            "support": support
        ]
    }
}

extension Protocol_WitnessCreateContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "url": String(data: url, encoding: .utf8) ?? ""
        ]
    }
}

extension Protocol_AssetIssueContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "id": id,
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "name": String(data: name, encoding: .utf8) ?? "",
            "abbr": String(data: abbr, encoding: .utf8) ?? "",
            "totalSupply": totalSupply,
            "frozenSupply": frozenSupply.map({["frozenAmount": $0.frozenAmount, "frozenDays": $0.frozenDays]}),
            "precision": precision
        ]
    }
}

extension Protocol_WitnessUpdateContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "updateURL": String(data: updateURL, encoding: .utf8) ?? ""
        ]
    }
}

extension Protocol_ParticipateAssetIssueContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "toAddress": TronAddress(toAddress)?.address ?? "",
            "assetName": String(data: assetName, encoding: .utf8) ?? "",
            "amount": amount
        ]
    }
}

extension Protocol_AccountUpdateContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "accountName": String(data: accountName, encoding: .utf8) ?? "",
            "ownerAddress": TronAddress(ownerAddress)?.address ?? ""
        ]
    }
}

extension Protocol_FreezeBalanceContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "receiverAddress": TronAddress(receiverAddress)?.address ?? "",
            "frozenBalance": TronHumanToken.MAIN.formatString(amount: frozenBalance),
            "frozenDuration": frozenDuration,
            "resource": resource.desc
        ]
    }
}

extension Protocol_UnfreezeBalanceContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "receiverAddress": TronAddress(receiverAddress)?.address ?? "",
            "resource": resource.desc
        ]
    }
}

extension Protocol_FreezeBalanceV2Contract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "frozenBalance": TronHumanToken.MAIN.formatString(amount: frozenBalance),
            "resource": resource.desc
        ]
    }
}

extension Protocol_UnfreezeBalanceV2Contract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "unfreezeBalance": TronHumanToken.MAIN.formatString(amount: unfreezeBalance),
            "resource": resource.desc
        ]
    }
}

extension Protocol_WithdrawBalanceContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? ""
        ]
    }
}

extension Protocol_UnfreezeAssetContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? ""
        ]
    }
}

extension Protocol_UpdateAssetContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "description_p": String(data: description_p, encoding: .utf8) ?? "",
            "url": String(data: url, encoding: .utf8) ?? "",
            "newLimit": newLimit,
            "newPublicLimit": newPublicLimit
        ]
    }
}

extension Protocol_ProposalCreateContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "parameters": parameters
        ]
    }
}

extension Protocol_ProposalApproveContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "proposalID": proposalID,
            "isAddApproval": isAddApproval
        ]
    }
}

extension Protocol_ProposalDeleteContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "proposalID": proposalID
        ]
    }
}

extension Protocol_SetAccountIdContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "accountID": String(data: accountID, encoding: .utf8) ?? accountID.toHexString()
        ]
    }
}

extension Protocol_CreateSmartContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        if hasNewContract {
            return [
                "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
                "newContract": [
                    "originAddress": TronAddress(newContract.originAddress)?.address ?? "",
                    "contractAddress": TronAddress(newContract.contractAddress)?.address ?? "",
                    "bytecode": newContract.bytecode.toHexString(),
                    "callValue": TronHumanToken.MAIN.formatString(amount: callTokenValue),
                    "codeHash": newContract.codeHash,
                    "version": newContract.version
                ],
                "callTokenValue": callTokenValue,
                "tokenID": tokenID
            ]
        } else {
            return [
                "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
                "callTokenValue": callTokenValue,
                "tokenID": tokenID
            ]
        }
    }
}

extension Protocol_TriggerSmartContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        var map: [String: Any] = [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "contractAddress": TronAddress(contractAddress)?.address ?? "",
            "callValue": TronHumanToken.MAIN.formatString(amount: callValue),
            "data": data.toHexString()
        ]
        if tokenID > 0 {
            map["tokenID"] = tokenID
            map["callTokenValue"] = callTokenValue
        }
        return map
    }
}

extension Protocol_UpdateSettingContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "contractAddress": TronAddress(contractAddress)?.address ?? "",
            "consumeUserResourcePercent": consumeUserResourcePercent
        ]
    }
}

extension Protocol_ExchangeCreateContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "firstTokenID": firstTokenID.toHexString(),
            "firstTokenBalance": firstTokenBalance,
            "secondTokenID": secondTokenID.toHexString(),
            "secondTokenBalance": secondTokenBalance
        ]
    }
}

extension Protocol_ExchangeInjectContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "exchangeID": exchangeID,
            "tokenID": tokenID.toHexString(),
            "quant": quant
        ]
    }
}

extension Protocol_ExchangeWithdrawContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "exchangeID": exchangeID,
            "tokenID": tokenID.toHexString(),
            "quant": quant
        ]
    }
}

extension Protocol_ExchangeTransactionContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "exchangeID": exchangeID,
            "tokenID": tokenID.toHexString(),
            "quant": quant,
            "expected": expected
        ]
    }
}

extension Protocol_UpdateEnergyLimitContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "contractAddress": TronAddress(contractAddress)?.address ?? "",
            "originEnergyLimit": originEnergyLimit
        ]
    }
}

extension Protocol_AccountPermissionUpdateContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "owner": hasOwner ? [
                "type": owner.type.desc,
                "id": owner.id,
                "permissionName": owner.permissionName,
                "threshold": owner.threshold,
                "parentID": owner.parentID,
                "operations": owner.operations.toHexString(),
                "keys": owner.keys.map({[
                    "address": TronAddress($0.address)?.address ?? "", "weight": $0.weight
                ]})
            ] : [:],
            "witness": hasWitness ? [
                "type": witness.type.desc,
                "id": witness.id,
                "permissionName": witness.permissionName,
                "threshold": witness.threshold,
                "parentID": witness.parentID,
                "operations": witness.operations.toHexString(),
                "keys": witness.keys.map({[
                    "address": TronAddress($0.address)?.address ?? "", "weight": $0.weight
                ]})
            ] : [:],
            "actives": actives.map({
                [
                    "type": $0.type.desc,
                    "id": $0.id,
                    "permissionName": $0.permissionName,
                    "threshold": $0.threshold,
                    "parentID": $0.parentID,
                    "operations": $0.operations.toHexString(),
                    "keys": $0.keys.map({[
                        "address": TronAddress($0.address)?.address ?? "", "weight": $0.weight
                    ]})
                ]
            })
        ]
    }
}

extension Protocol_ClearABIContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "contractAddress": TronAddress(contractAddress)?.address ?? ""
        ]
    }
}

extension Protocol_UpdateBrokerageContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "brokerage": brokerage
        ]
    }
}

extension Protocol_ShieldedTransferContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "transparentFromAddress": TronAddress(transparentFromAddress)?.address ?? transparentToAddress.toHexString(),
            "fromAmount": fromAmount,
            "bindingSignature": bindingSignature,
            "transparentToAddress": TronAddress(transparentToAddress)?.address ?? transparentToAddress.toHexString(),
            "toAmount": toAmount,
            "spendDescription": spendDescription.map({[
                "valueCommitment", $0.valueCommitment.toHexString(),
                "anchor", $0.anchor.toHexString(),
                "nullifier", $0.nullifier.toHexString(),
                "rk", $0.rk.toHexString(),
                "zkproof", $0.zkproof.toHexString(),
                "spendAuthoritySignature", $0.spendAuthoritySignature.toHexString()
            ]}),
            "receiveDescription": receiveDescription.map({[
                "valueCommitment", $0.valueCommitment.toHexString(),
                "noteCommitment", $0.noteCommitment.toHexString(),
                "epk", $0.epk.toHexString(),
                "cEnc", $0.cEnc.toHexString(),
                "cOut", $0.cOut.toHexString(),
                "zkproof", $0.zkproof.toHexString()
            ]})
        ]
    }
}

extension Protocol_MarketSellAssetContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "sellTokenID": sellTokenID.toHexString(),
            "sellTokenQuantity": sellTokenQuantity,
            "buyTokenID": buyTokenID.toHexString(),
            "buyTokenQuantity": buyTokenQuantity
        ]
    }
}

extension Protocol_MarketCancelOrderContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "orderID": orderID.toHexString()
        ]
    }
}

extension Protocol_Transaction {
    public func toHuman(_ main: TronHumanToken? = nil) throws -> Array<[String: Any]> {
        if let _main = main {
            TronHumanToken.MAIN = _main
        }
        let types: [SwiftProtobuf.Message.Type] = [
            Protocol_AccountCreateContract.self,
            Protocol_TransferContract.self,
            Protocol_TransferAssetContract.self,
            Protocol_VoteAssetContract.self,
            Protocol_VoteWitnessContract.self,
            Protocol_WitnessCreateContract.self,
            Protocol_AssetIssueContract.self,
            Protocol_WitnessUpdateContract.self,
            Protocol_ParticipateAssetIssueContract.self,
            Protocol_AccountUpdateContract.self,
            Protocol_FreezeBalanceContract.self,
            Protocol_UnfreezeBalanceContract.self,
            Protocol_FreezeBalanceV2Contract.self,
            Protocol_UnfreezeBalanceV2Contract.self,
            Protocol_WithdrawBalanceContract.self,
            Protocol_UnfreezeAssetContract.self,
            Protocol_UpdateAssetContract.self,
            Protocol_ProposalCreateContract.self,
            Protocol_ProposalApproveContract.self,
            Protocol_ProposalDeleteContract.self,
            Protocol_SetAccountIdContract.self,
            Protocol_CreateSmartContract.self,
            Protocol_TriggerSmartContract.self,
            Protocol_UpdateSettingContract.self,
            Protocol_ExchangeCreateContract.self,
            Protocol_ExchangeInjectContract.self,
            Protocol_ExchangeWithdrawContract.self,
            Protocol_ExchangeTransactionContract.self,
            Protocol_UpdateEnergyLimitContract.self,
            Protocol_AccountPermissionUpdateContract.self,
            Protocol_ClearABIContract.self,
            Protocol_UpdateBrokerageContract.self,
            Protocol_ShieldedTransferContract.self,
            Protocol_MarketSellAssetContract.self,
            Protocol_MarketCancelOrderContract.self,
        ]
        var humanList = [[String : Any]]()
        for contract in self.rawData.contract {
            var humanMap = [String : Any]()
            humanMap["type"] = contract.type.rawValue
            humanMap["typeURL"] = contract.parameter.typeURL
            let data = contract.parameter.value
            
            if let messageType = types.filter({contract.parameter.typeURL.hasSuffix($0.protoMessageName)}).first {
                let message = try messageType.init(serializedData: data)
                humanMap["value"] = try (message as? TronHumanDecodable)?.toHuman() ?? [:]
            } else {
                humanMap["value"] = [:]
            }
            humanList.append(humanMap)
        }
        return humanList
    }
}
