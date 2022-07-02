//
//  TronContractProtocol.swift
//  
//
//  Created by mathwallet on 2022/7/2.
//

import Foundation

public protocol TronContractProtocol {
    var address: TronAddress? {get set}
    var allMethods: [String] {get}
    func method(_ method:String, parameters: [AnyObject], transactionOptions: TronTransactionOptions?) -> TronTriggerSmartContractExtension?
    init?(_ abiString: String, at: TronAddress?)
    func decodeReturnData(_ method:String, data: Data) -> [String:Any]?
}
