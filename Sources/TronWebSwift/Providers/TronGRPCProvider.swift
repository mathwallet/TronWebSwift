//
//  TronGRPCProvider.swift
//  
//
//  Created by math on 2021/12/27.
//

import Foundation
import GRPC
import NIO
import SwiftProtobuf

public struct TronGRPCProvider {
    public let host: String
    public let port: Int
    
    private let wallet: Protocol_WalletClient
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
        
        self.wallet =  Protocol_WalletClient(channel: ClientConnection.insecure(group: MultiThreadedEventLoopGroup(numberOfThreads: 5)).connect(host: host, port: port))
    }
    
    // MARK: - Query
    
    public func getCurrentBlock() -> EventLoopFuture<Protocol_Block> {
        return wallet.getNowBlock(Protocol_EmptyMessage()).response
    }
    
    public func getAccount(_ address: TronAddress) -> EventLoopFuture<Protocol_Account> {
        let account = Protocol_Account.with {
            $0.address = address.data
        }
        return wallet.getAccount(account).response
    }
    
    
    // MARK: - Transaction
    
    public func transferContract(_ request: Protocol_TransferContract) -> EventLoopFuture<Protocol_Transaction> {
        return wallet.createTransaction(request).response
    }
    
    public func transferAssetContract(_ request: Protocol_TransferAssetContract) -> EventLoopFuture<Protocol_Transaction> {
        return wallet.transferAsset(request).response
    }
    
    public func triggerSmartContract(_ request: Protocol_TriggerSmartContract) -> EventLoopFuture<Protocol_TransactionExtention> {
        return wallet.triggerContract(request).response
    }
    
    public func broadcastTransaction(_ request: Protocol_Transaction) -> EventLoopFuture<Protocol_Return> {
        return wallet.broadcastTransaction(request).response
    }
}
