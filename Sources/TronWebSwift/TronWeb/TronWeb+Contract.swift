//
//  TronWeb+Contract.swift
//  
//
//  Created by mathwallet on 2022/7/2.
//

import Foundation
import PromiseKit

extension TronWeb {
    public func contract(_ abiString: String, at: TronAddress?) -> WebContract? {
        return WebContract(provider: self.provider, abiString: abiString, at: at, transactionOptions: self.transactionOptions)
    }
    
    public class WebContract {
        var contract: TronContract
        var provider : TronWebHttpProvider
        public var transactionOptions: TronTransactionOptions? = nil
        
        public init?(provider: TronWebHttpProvider, abiString: String, at: TronAddress? = nil, transactionOptions: TronTransactionOptions? = nil) {
            self.provider = provider
            self.transactionOptions = transactionOptions
            guard let c = TronContract(abiString, at: at) else {
                return nil
            }
            self.contract = c
        }
        
        public func write(_ method: String, parameters: [AnyObject] = [AnyObject](), signer: TronSigner, transactionOptions: TronTransactionOptions? = nil) -> Promise<TronTransctionResponse> {
            let opts = transactionOptions ?? self.transactionOptions
            guard let request = contract.method(method, parameters: parameters, transactionOptions: opts) else {
                return Promise { resolver in
                    resolver.reject(TronWebError.processingError(desc: "Contract writing error."))
                }
            }
            
            return self.provider.triggerSmartContract(request).then({ (resp) in
                return try self.provider.broadcastTransaction(resp.transaction.sign(signer))
            })
        }
    }
}
