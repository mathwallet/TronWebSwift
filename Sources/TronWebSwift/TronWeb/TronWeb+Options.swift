//
//  File.swift
//  
//
//  Created by mathwallet on 2022/7/2.
//

import Foundation

public struct TronTransactionOptions {
    public var ownerAddress: TronAddress = TronAddress.empty
    public var feeLimit: Int64 = 0
    public var callValue: Int64 = 0
    
    public init() {
    }
    
    public static var defaultOptions: TronTransactionOptions {
        return TronTransactionOptions()
    }
}
