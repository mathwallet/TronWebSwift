//
//  TronContract.swift
//  
//
//  Created by mathwallet on 2022/7/2.
//

import Foundation
import SwiftProtobuf

public struct TronContract: TronContractProtocol {
    public var address: TronAddress? = nil
    
    var _abi: [TronABI.Element]
    
    public var allMethods: [String] {
        return methods.keys.compactMap({ (s) -> String in
            return s
        })
    }
    
    public var methods: [String: TronABI.Element] {
        var toReturn = [String: TronABI.Element]()
        for m in self._abi {
            switch m {
            case .function(let function):
                guard let name = function.name else {continue}
                toReturn[name] = m
            default:
                continue
            }
        }
        return toReturn
    }
    
    public var constructor: TronABI.Element? {
        var toReturn : TronABI.Element? = nil
        for m in self._abi {
            if toReturn != nil {
                break
            }
            switch m {
            case .constructor(_):
                toReturn = m
                break
            default:
                continue
            }
        }
        if toReturn == nil {
            let defaultConstructor = TronABI.Element.constructor(TronABI.Element.Constructor(inputs: [], constant: false, payable: false))
            return defaultConstructor
        }
        return toReturn
    }
    
    public init?(_ abiString: String, at: TronAddress?) {
        do {
            let jsonData = abiString.data(using: .utf8)
            let abi = try JSONDecoder().decode([TronABI.Record].self, from: jsonData!)
            let abiNative = try abi.map({ (record) -> TronABI.Element in
                return try record.parse()
            })
            _abi = abiNative
            if at != nil {
                self.address = at
            }
        }
        catch{
            return nil
        }
    }
    
    public func method(_ method: String,
                       parameters: [AnyObject] = [AnyObject](),
                       transactionOptions: TronTransactionOptions? = nil) -> TronTriggerSmartContractExtension? {
        guard let to = self.address else {return nil}

        let foundMethod = self.methods.filter { (key, value) -> Bool in
            return key == method
        }
        guard foundMethod.count == 1 else {return nil}
        let abiMethod = foundMethod[method]
        guard let encodedData = abiMethod?.encodeParameters(parameters) else {return nil}

        let opt = transactionOptions ?? .defaultOptions
        let triggerSmartContract =  Protocol_TriggerSmartContract.with {
            $0.ownerAddress = opt.ownerAddress.data
            $0.contractAddress = to.data
            $0.callValue = opt.callValue
            $0.data = encodedData
        }
        let functionSelector: String
        switch abiMethod {
        case .function(let f):
            functionSelector = "\(f.name ?? method)(\(f.inputs.map({ $0.type.abiRepresentation}).joined(separator: ",")))"
        default:
            return nil
        }
        return TronTriggerSmartContractExtension(contract: triggerSmartContract,
                                                 functionSelector: functionSelector,
                                                 feeLimit: opt.feeLimit)
    }
    
    public func decodeReturnData(_ method: String, data: Data) -> [String : Any]? {
        guard let function = methods[method] else {return nil}
        guard case .function(_) = function else {return nil}
        return function.decodeReturnData(data)
    }
    
    public func decodeMethodData(_ data: Data) -> (method: String, inputs: [String : Any]?)? {
        guard data.count >= 4 else { return nil }
        let methods = methods.compactMap { (_, value) in
            if case .function(let f) = value, f.methodEncoding == data.subdata(in: 0..<4) {
                return (f.signature, value)
            }
            return nil
        }
        guard let method = methods.first else { return nil }
        return (method.0, method.1.decodeInputData(data) ?? [:])
    }
}

