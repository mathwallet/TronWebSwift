//
//  TronHumanDecodable.swift
//  
//
//  Created by mathwallet on 2022/6/28.
//

import Foundation
import CryptoSwift

public protocol TronHumanDecodable {
    func toHuman() throws -> [String: Any]
}

extension Protocol_AccountCreateContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "accountAddress": TronAddress(accountAddress)?.address ?? "",
            "type": self.type.rawValue
        ]
    }
}

extension Protocol_TransferContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "toAddress": TronAddress(toAddress)?.address ?? "",
            "amount": amount
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
            "url": String(data: assetName, encoding: .utf8) ?? "",
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
            "frozenBalance": frozenBalance,
            "frozenDuration": frozenDuration,
            "resource": resource.rawValue
        ]
    }
}

extension Protocol_UnfreezeBalanceContract: TronHumanDecodable {
    public func toHuman() throws -> [String : Any] {
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "receiverAddress": TronAddress(receiverAddress)?.address ?? "",
            "resource": resource.rawValue
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
                    "callValue": newContract.callValue,
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
        return [
            "ownerAddress": TronAddress(ownerAddress)?.address ?? "",
            "contractAddress": TronAddress(contractAddress)?.address ?? "",
            "callValue": callValue,
            "data": data.toHexString(),
            "callTokenValue": callTokenValue,
            "tokenID": tokenID
        ]
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
                "type": owner.type.rawValue,
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
                "type": witness.type.rawValue,
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
                    "type": $0.type.rawValue,
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
    public func toHuman() throws -> Array<[String: Any]> {
        var humanList = [[String : Any]]()
        for contract in self.rawData.contract {
            var humanMap = [String : Any]()
            humanMap["type"] = contract.type.rawValue
            humanMap["typeURL"] = contract.parameter.typeURL
            let data = contract.parameter.value
            switch contract.type {
            case .accountCreateContract:
                humanMap["value"] = try Protocol_AccountCreateContract(serializedData: data).toHuman()
            case .transferContract:
                humanMap["value"] = try Protocol_TransferContract(serializedData: data).toHuman()
            case .transferAssetContract:
                humanMap["value"] = try Protocol_TransferAssetContract(serializedData: data).toHuman()
            case .voteAssetContract:
                humanMap["value"] = try Protocol_VoteAssetContract(serializedData: data).toHuman()
            case .voteWitnessContract:
                humanMap["value"] = try Protocol_VoteWitnessContract(serializedData: data).toHuman()
            case .witnessCreateContract:
                humanMap["value"] = try Protocol_WitnessCreateContract(serializedData: data).toHuman()
            case .assetIssueContract:
                humanMap["value"] = try Protocol_AssetIssueContract(serializedData: data).toHuman()
            case .witnessUpdateContract:
                humanMap["value"] = try Protocol_WitnessUpdateContract(serializedData: data).toHuman()
            case .participateAssetIssueContract:
                humanMap["value"] = try Protocol_ParticipateAssetIssueContract(serializedData: data).toHuman()
            case .accountUpdateContract:
                humanMap["value"] = try Protocol_AccountUpdateContract(serializedData: data).toHuman()
            case .freezeBalanceContract:
                humanMap["value"] = try Protocol_FreezeBalanceContract(serializedData: data).toHuman()
            case .unfreezeBalanceContract:
                humanMap["value"] = try Protocol_UnfreezeBalanceContract(serializedData: data).toHuman()
            case .withdrawBalanceContract:
                humanMap["value"] = try Protocol_WithdrawBalanceContract(serializedData: data).toHuman()
            case .unfreezeAssetContract:
                humanMap["value"] = try Protocol_UnfreezeAssetContract(serializedData: data).toHuman()
            case .updateAssetContract:
                humanMap["value"] = try Protocol_UpdateAssetContract(serializedData: data).toHuman()
            case .proposalCreateContract:
                humanMap["value"] = try Protocol_ProposalCreateContract(serializedData: data).toHuman()
            case .proposalApproveContract:
                humanMap["value"] = try Protocol_ProposalApproveContract(serializedData: data).toHuman()
            case .proposalDeleteContract:
                humanMap["value"] = try Protocol_ProposalDeleteContract(serializedData: data).toHuman()
            case .setAccountIDContract:
                humanMap["value"] = try Protocol_SetAccountIdContract(serializedData: data).toHuman()
            case .createSmartContract:
                humanMap["value"] = try Protocol_CreateSmartContract(serializedData: data).toHuman()
            case .triggerSmartContract:
                humanMap["value"] = try Protocol_TriggerSmartContract(serializedData: data).toHuman()
            case .updateSettingContract:
                humanMap["value"] = try Protocol_UpdateSettingContract(serializedData: data).toHuman()
            case .exchangeCreateContract:
                humanMap["value"] = try Protocol_ExchangeCreateContract(serializedData: data).toHuman()
            case .exchangeInjectContract:
                humanMap["value"] = try Protocol_ExchangeInjectContract(serializedData: data).toHuman()
            case .exchangeWithdrawContract:
                humanMap["value"] = try Protocol_ExchangeWithdrawContract(serializedData: data).toHuman()
            case .exchangeTransactionContract:
                humanMap["value"] = try Protocol_ExchangeTransactionContract(serializedData: data).toHuman()
            case .updateEnergyLimitContract:
                humanMap["value"] = try Protocol_UpdateEnergyLimitContract(serializedData: data).toHuman()
            case .accountPermissionUpdateContract:
                humanMap["value"] = try Protocol_AccountPermissionUpdateContract(serializedData: data).toHuman()
            case .clearAbicontract:
                humanMap["value"] = try Protocol_ClearABIContract(serializedData: data).toHuman()
            case .updateBrokerageContract:
                humanMap["value"] = try Protocol_UpdateBrokerageContract(serializedData: data).toHuman()
            case .shieldedTransferContract:
                humanMap["value"] = try Protocol_ShieldedTransferContract(serializedData: data).toHuman()
            case .marketSellAssetContract:
                humanMap["value"] = try Protocol_MarketSellAssetContract(serializedData: data).toHuman()
            case .marketCancelOrderContract:
                humanMap["value"] = try Protocol_MarketCancelOrderContract(serializedData: data).toHuman()
            default:
                humanMap["value"] = [:]
            }
            humanList.append(humanMap)
        }
        return humanList
    }
}
