//
//  TronWebContract.swift
//  
//
//  Created by mathwallet on 2022/7/1.
//

import UIKit

public struct TronWebContract {
    public let contractAddress: TronAddress
    
    public init(_ contractAddress: TronAddress) {
        self.contractAddress = contractAddress
    }
    
    public var trc20: TRC20 {
        return TRC20(contractAddress)
    }
}
