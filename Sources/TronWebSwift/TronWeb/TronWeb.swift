import Foundation
import PromiseKit
import BigInt

public typealias TronTransaction = Protocol_Transaction
public typealias TronTransferContract = Protocol_TransferContract
public typealias TronTransferAssetContract = Protocol_TransferAssetContract
public typealias TronTriggerSmartContract = Protocol_TriggerSmartContract

public enum TronWebError: LocalizedError {
    case invalidProvider
    case nodeError(desc:String)
    case processingError(desc:String)
    case unknown(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidProvider:
            return "TronWeb.Error.invalidProvider"
        case .nodeError(let desc):
            return desc
        case .processingError(let desc):
            return desc
        case .unknown(let message):
            return message
        }
    }
}
    
public struct TronWeb {
    let provider: TronWebHttpProvider
    let transactionOptions: TronTransactionOptions?
    
    public init(provider: TronWebHttpProvider, options: TronTransactionOptions? = nil) {
        self.provider = provider
        self.transactionOptions = options
    }
}
