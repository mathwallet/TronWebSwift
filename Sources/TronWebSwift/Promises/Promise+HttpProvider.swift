//
//  Promise+HttpProvider.swift
//  
//
//  Created by mathwallet on 2022/6/29.
//

import Foundation
import PromiseKit

extension TronWebHttpProvider {
    public func getAccount(_ address: TronAddress) -> Promise<Protocol_Account> {
        let parameters: [String: Encodable] = [
            "address": address.address,
            "visible": true
        ]
        let providerURL = self.url.appending(.getAccount)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
    
    public func getNowBlock() -> Promise<Protocol_Block> {
        let providerURL = self.url.appending(.getNowBlock)
        return TronWebHttpProvider.POST(nil, providerURL: providerURL, session: self.session)
    }
    
    public func createTransaction(_ contract: Protocol_TransferContract) -> Promise<Protocol_Transaction> {
        let parameters: [String: Encodable] = [
            "owner_address": contract.ownerAddress.toHexString(),
            "to_address": contract.toAddress.toHexString(),
            "amount": contract.amount,
            "visible": false
        ]
        let providerURL = self.url.appending(.createTransaction)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
    
    public func transferAsset(_ contract: Protocol_TransferAssetContract) -> Promise<Protocol_Transaction> {
        let parameters: [String: Encodable] = [
            "owner_address": contract.ownerAddress.toHexString(),
            "to_address": contract.toAddress.toHexString(),
            "asset_name": contract.assetName.toHexString(),
            "amount": contract.amount,
            "visible": false
        ]
        let providerURL = self.url.appending(.transferAsset)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
    
    public func triggerSmartContract(_ contract: Protocol_TriggerSmartContract, functionSelector: String, feeLimit: Int64 = 150000000) -> Promise<Protocol_TransactionExtention> {
        let parameters: [String: Encodable] = [
            "owner_address": contract.ownerAddress.toHexString(),
            "contract_address": contract.contractAddress.toHexString(),
            "function_selector": functionSelector,
            "parameter": contract.data.toHexString(),
            "fee_limit": feeLimit,
            "call_value": contract.callValue,
            "token_id": contract.tokenID,
            "call_token_value": contract.callTokenValue,
            "visible": false
        ]
        let providerURL = self.url.appending(.triggerSmartContract)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
    
    public func triggerConstantContract(_ contract: Protocol_TriggerSmartContract, functionSelector: String, feeLimit: Int64 = 150000000) -> Promise<Protocol_TransactionExtention> {
        let parameters: [String: Encodable] = [
            "owner_address": contract.ownerAddress.toHexString(),
            "contract_address1": contract.contractAddress.toHexString(),
            "function_selector": functionSelector,
            "parameter": contract.data.toHexString(),
            "fee_limit": feeLimit,
            "call_value": contract.callValue,
            "token_id": contract.tokenID,
            "call_token_value": contract.callTokenValue,
            "visible": false
        ]
        let providerURL = self.url.appending(.triggerConstantContract)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
}
