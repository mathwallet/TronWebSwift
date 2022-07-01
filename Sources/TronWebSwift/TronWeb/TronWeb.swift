import Foundation
import PromiseKit
import BigInt

typealias TronTransaction = Protocol_Transaction
typealias TronTransferContract = Protocol_TransferContract
typealias TronTransferAssetContract = Protocol_TransferAssetContract
typealias TronTriggerSmartContract = Protocol_TriggerSmartContract

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
    let feeLimit: Int64
    
    public init(provider: TronWebHttpProvider, feeLimit: Int64 = 150000000) {
        self.provider = provider
        self.feeLimit = feeLimit
    }

    // MARK: - Transaction
    
    public func sendTRX(to toAddress: TronAddress,
                        amount: BigUInt,
                        signer: TronSigner) -> Promise<String> {
        let (promise, seal) = Promise<String>.pending()
        DispatchQueue.global().async {
            do {
                let contract = Protocol_TransferContract.with {
                    $0.ownerAddress = signer.address.data
                    $0.toAddress = toAddress.data
                    $0.amount = Int64(amount.description)!
                }
                var tx =  try provider.createTransaction(contract).wait()
                let hash = try tx.rawData.serializedData().sha256()
                tx.signature = [signer.signDigest(hash)!]
                
                let response = try provider.broadcastTransaction(tx).wait()
                guard response.result else {
                    let errMessage = String(data: response.message, encoding: .utf8) ?? ""
                    DispatchQueue.main.async {
                        seal.reject(TronWebError.unknown(message: errMessage))
                    }
                    return
                }
                
                let txHash = hash.toHexString()
                DispatchQueue.main.async {
                    seal.fulfill(txHash)
                }
            } catch let error {
                DispatchQueue.main.async {
                    seal.reject(error)
                }
            }
        }
        return promise
    }
    
    public func sendTRC10(to toAddress: TronAddress,
                          amount: BigUInt,
                          assetName: String,
                          signer: TronSigner) -> Promise<String> {
        let (promise, seal) = Promise<String>.pending()
        DispatchQueue.global().async {
            do {
                let contract = Protocol_TransferAssetContract.with {
                    $0.assetName = assetName.data(using: .utf8)!
                    $0.ownerAddress = signer.address.data
                    $0.toAddress = toAddress.data
                    $0.amount = Int64(amount.description)!
                }
                var tx =  try provider.transferAsset(contract).wait()
                let hash = try tx.rawData.serializedData().sha256()
                tx.signature = [signer.signDigest(hash)!]
                
                let response = try provider.broadcastTransaction(tx).wait()
                guard response.result else {
                    let errMessage = String(data: response.message, encoding: .utf8) ?? ""
                    DispatchQueue.main.async {
                        seal.reject(TronWebError.unknown(message: errMessage))
                    }
                    return
                }
                
                let txHash = hash.toHexString()
                DispatchQueue.main.async {
                    seal.fulfill(txHash)
                }
            } catch let error {
                DispatchQueue.main.async {
                    seal.reject(error)
                }
            }
        }
        return promise
    }
    
    public func sendTRC20(to toAddress: TronAddress,
                          contract contractAddress: TronAddress,
                          amount: BigUInt,
                          signer: TronSigner) -> Promise<String> {
        let (promise, seal) = Promise<String>.pending()
        DispatchQueue.global().async {
            do {
                let contract = TRC20(contractAddress: contractAddress).transfer(from: signer.address, to: toAddress, value: amount)
                let txExtension =  try provider.triggerSmartContract(contract, functionSelector: "transfer(address)",feeLimit: self.feeLimit).wait()
                var tx = txExtension.transaction
                tx.rawData.feeLimit = Int64(self.feeLimit.description)!
                let hash = try tx.rawData.serializedData().sha256()
                tx.signature = [signer.signDigest(hash)!]
                
                let response = try provider.broadcastTransaction(tx).wait()
                guard response.result else {
                    let errMessage = String(data: response.message, encoding: .utf8) ?? ""
                    DispatchQueue.main.async {
                        seal.reject(TronWebError.unknown(message: errMessage))
                    }
                    return
                }

                let txHash = hash.toHexString()
                DispatchQueue.main.async {
                    seal.fulfill(txHash)
                }
            } catch let error {
                DispatchQueue.main.async {
                    seal.reject(error)
                }
            }
        }
        return promise
    }
}
