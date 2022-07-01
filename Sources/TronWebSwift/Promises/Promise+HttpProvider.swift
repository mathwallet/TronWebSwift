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
    
    public func triggerSmartContract(_ ex: Protocol_TriggerSmartContractExtension) -> Promise<Protocol_TransactionExtention> {
        let parameters: [String: Encodable] = [
            "owner_address": ex.contract.ownerAddress.toHexString(),
            "contract_address": ex.contract.contractAddress.toHexString(),
            "function_selector": ex.functionSelector,
            "parameter": ex.parameter,
            "fee_limit": ex.feeLimit,
            "call_value": ex.contract.callValue,
            "token_id": ex.contract.tokenID,
            "call_token_value": ex.contract.callTokenValue,
            "visible": false
        ]
        let providerURL = self.url.appending(.triggerSmartContract)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
    
    public func triggerConstantContract(_ ex: Protocol_TriggerSmartContractExtension) -> Promise<Protocol_TransactionExtention> {
        let parameters: [String: Encodable] = [
            "owner_address": ex.contract.ownerAddress.toHexString(),
            "contract_address": ex.contract.contractAddress.toHexString(),
            "function_selector": ex.functionSelector,
            "parameter": ex.feeLimit,
            "call_value": ex.contract.callValue,
            "visible": false
        ]
        let providerURL = self.url.appending(.triggerConstantContract)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
    
    public func broadcastTransaction(_ transaction: Protocol_Transaction) -> Promise<Protocol_Return> {
        let parameters: [String: Encodable] = [
            "transaction": try! transaction.serializedData().toHexString()
        ]
        let providerURL = self.url.appending(.broadcastTransaction)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
}
