//
//  File.swift
//  
//
//  Created by mathwallet on 2022/6/28.
//

import Foundation

public extension Protocol_Transaction.Contract {
    func decodeJsonString() throws -> String? {
        let data = self.parameter.value
        switch self.type {
        case .accountCreateContract:
            return try Protocol_AccountCreateContract(serializedData: data).jsonString()
        case .transferContract:
            return try Protocol_TransferContract(serializedData: data).jsonString()
        case .transferAssetContract:
            return try Protocol_TransferAssetContract(serializedData: data).jsonString()
        case .voteAssetContract:
            return try Protocol_VoteAssetContract(serializedData: data).jsonString()
        case .voteWitnessContract:
            return try Protocol_VoteWitnessContract(serializedData: data).jsonString()
        case .witnessCreateContract:
            return try Protocol_WitnessCreateContract(serializedData: data).jsonString()
        case .assetIssueContract:
            return try Protocol_AssetIssueContract(serializedData: data).jsonString()
        case .witnessUpdateContract:
            return try Protocol_WitnessUpdateContract(serializedData: data).jsonString()
        case .participateAssetIssueContract:
            return try Protocol_ParticipateAssetIssueContract(serializedData: data).jsonString()
        case .accountUpdateContract:
            return try Protocol_AccountUpdateContract(serializedData: data).jsonString()
        case .freezeBalanceContract:
            return try Protocol_FreezeBalanceContract(serializedData: data).jsonString()
        case .unfreezeBalanceContract:
            return try Protocol_UnfreezeBalanceContract(serializedData: data).jsonString()
        case .withdrawBalanceContract:
            return try Protocol_WithdrawBalanceContract(serializedData: data).jsonString()
        case .unfreezeAssetContract:
            return try Protocol_UnfreezeAssetContract(serializedData: data).jsonString()
        case .updateAssetContract:
            return try Protocol_UpdateAssetContract(serializedData: data).jsonString()
        case .proposalCreateContract:
            return try Protocol_ProposalCreateContract(serializedData: data).jsonString()
        case .proposalApproveContract:
            return try Protocol_ProposalApproveContract(serializedData: data).jsonString()
        case .proposalDeleteContract:
            return try Protocol_ProposalDeleteContract(serializedData: data).jsonString()
        case .setAccountIDContract:
            return try Protocol_SetAccountIdContract(serializedData: data).jsonString()
        case .createSmartContract:
            return try Protocol_CreateSmartContract(serializedData: data).jsonString()
        case .triggerSmartContract:
            return try Protocol_TriggerSmartContract(serializedData: data).jsonString()
        case .updateSettingContract:
            return try Protocol_UpdateSettingContract(serializedData: data).jsonString()
        case .exchangeCreateContract:
            return try Protocol_ExchangeCreateContract(serializedData: data).jsonString()
        case .exchangeInjectContract:
            return try Protocol_ExchangeInjectContract(serializedData: data).jsonString()
        case .exchangeWithdrawContract:
            return try Protocol_ExchangeWithdrawContract(serializedData: data).jsonString()
        case .exchangeTransactionContract:
            return try Protocol_ExchangeTransactionContract(serializedData: data).jsonString()
        case .updateEnergyLimitContract:
            return try Protocol_UpdateEnergyLimitContract(serializedData: data).jsonString()
        case .accountPermissionUpdateContract:
            return try Protocol_AccountPermissionUpdateContract(serializedData: data).jsonString()
        case .clearAbicontract:
            return try Protocol_ClearABIContract(serializedData: data).jsonString()
        case .updateBrokerageContract:
            return try Protocol_UpdateBrokerageContract(serializedData: data).jsonString()
        case .shieldedTransferContract:
            return try Protocol_ShieldedTransferContract(serializedData: data).jsonString()
        case .marketSellAssetContract:
            return try Protocol_MarketSellAssetContract(serializedData: data).jsonString()
        case .marketCancelOrderContract:
            return try Protocol_MarketCancelOrderContract(serializedData: data).jsonString()
        default:
            return "{}"
        }
    }
}
