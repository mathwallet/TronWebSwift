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
            return Promise { resolver in
                let opts = transactionOptions ?? self.transactionOptions
                guard let request = contract.method(method, parameters: parameters, transactionOptions: opts) else {
                    resolver.reject(TronWebError.processingError(desc: "Contract writing error."))
                    return
                }
                let txEx = try self.provider.triggerSmartContract(request).wait()
                let signedTx = try txEx.transaction.sign(signer)
                let res = try self.provider.broadcastTransaction(signedTx).wait()
                
                resolver.fulfill(res)
            }
        }
        
        public func read(_ method: String, parameters: [AnyObject] = [AnyObject](), transactionOptions: TronTransactionOptions? = nil) -> Promise<[String: Any]> {
            return Promise { resolver in
                let opts = transactionOptions ?? self.transactionOptions
                guard let request = contract.method(method, parameters: parameters, transactionOptions: opts) else {
                    resolver.reject(TronWebError.processingError(desc: "Contract read error."))
                    return
                }
                let res = try self.provider.triggerConstantContract(request).wait()
                if let returnData = res.constantResult.first {
                    resolver.fulfill(contract.decodeReturnData(method, data: returnData) ?? [:])
                } else {
                    resolver.fulfill([:])
                }
            }
        }
    }
}
