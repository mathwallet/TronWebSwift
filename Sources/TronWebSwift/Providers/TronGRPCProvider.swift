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
    private let channel: ClientConnection
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 5)
        self.channel = ClientConnection.insecure(group: group).connect(host: host, port: port)
    }
    
    // MARK: - Query
    
    public func getCurrentBlock() -> EventLoopFuture<Protocol_Block> {
        let wallet = Protocol_WalletClient(channel: self.channel)
        return wallet.getNowBlock(Protocol_EmptyMessage()).response
    }
    
    public func getAccount(_ address: TronAddress) -> EventLoopFuture<Protocol_Account> {
        let account = Protocol_Account.with {
            $0.address = address.data
        }
        
        let wallet = Protocol_WalletClient(channel: self.channel)
        return wallet.getAccount(account).response
    }
    
    
    // MARK: - Transaction
    
    public func transferContract(_ request: Protocol_TransferContract) -> EventLoopFuture<Protocol_Transaction> {
        let wallet = Protocol_WalletClient(channel: self.channel)
        return wallet.createTransaction(request).response
    }
    
    public func transferAssetContract(_ request: Protocol_TransferAssetContract) -> EventLoopFuture<Protocol_Transaction> {
        let wallet = Protocol_WalletClient(channel: self.channel)
        return wallet.transferAsset(request).response
    }
    
    public func triggerSmartContract(_ request: Protocol_TriggerSmartContract) -> EventLoopFuture<Protocol_TransactionExtention> {
        let wallet = Protocol_WalletClient(channel: self.channel)
        return wallet.triggerContract(request).response
    }
    
    public func broadcastTransaction(_ request: Protocol_Transaction) -> EventLoopFuture<Protocol_Return> {
        let wallet = Protocol_WalletClient(channel: self.channel)
        return wallet.broadcastTransaction(request).response
    }
}
