//
//  TronContract_TRC20.swift
//  
//
//  Created by math on 2021/12/27.
//

import Foundation
import BigInt
import CryptoSwift

public struct TronContract_TRC20 {
    public let contractAddress: TronAddress
    
    public init(contractAddress: TronAddress) {
        self.contractAddress = contractAddress
    }
    
    // MARK: - Method
    
    public func balanceOf(owner ownerAddress: TronAddress) -> Protocol_TriggerSmartContract {
        let functionSelector = "balanceOf(address)"
        
        var encodeData = Data()
        encodeData.append(Data(hex: functionSelector.sha3(.keccak256)).prefix(4))
        encodeData.append(Data(hex: ownerAddress.data.subdata(in: 1..<ownerAddress.data.count).toHexString().leftPadding(toLength: 64, withPad: "0")))
        
        return Protocol_TriggerSmartContract.with {
            $0.ownerAddress = ownerAddress.data
            $0.contractAddress = contractAddress.data
            $0.callValue = 0
            $0.data = encodeData
        }
    }
    
    public func transfer(from fromAddress: TronAddress, to toAddress: TronAddress, value: BigUInt) -> Protocol_TriggerSmartContract {
        let functionSelector = "transfer(address,uint256)"
        
        var encodeData = Data()
        encodeData.append(Data(hex: functionSelector.sha3(.keccak256)).prefix(4))
        encodeData.append(Data(hex: toAddress.data.subdata(in: 1..<toAddress.data.count).toHexString().leftPadding(toLength: 64, withPad: "0")))
        encodeData.append(Data(hex: String(value, radix: 16).leftPadding(toLength: 64, withPad: "0")))
        
        return Protocol_TriggerSmartContract.with {
            $0.ownerAddress = fromAddress.data
            $0.contractAddress = contractAddress.data
            $0.callValue = 0
            $0.data = encodeData
        }
    }
}
