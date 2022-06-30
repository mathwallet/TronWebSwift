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
            "amount": contract.amount
        ]
        let providerURL = self.url.appending(.createTransaction)
        return TronWebHttpProvider.POST(parameters, providerURL: providerURL, session: self.session)
    }
}
