import Foundation
import PromiseKit
import BigInt

public struct TronWeb {
    let provider: TronGRPCProvider
    var feeLimit: Int64 = 150000000
    
    public init(provider: TronGRPCProvider, feeLimit: Int64 = 150000000) {
        self.provider = provider
        self.feeLimit = feeLimit
    }

    // MARK: - Transaction
    
    public func sendTRX(to toAddress: TronAddress,
                        amount: Int64,
                        signer: TronAccount) -> Promise<String> {
        let (promise, seal) = Promise<String>.pending()
        DispatchQueue.global().async {
            do {
                let contract = Protocol_TransferContract.with {
                    $0.ownerAddress = signer.address.data
                    $0.toAddress = toAddress.data
                    $0.amount = amount
                }
                var tx =  try provider.transferContract(contract).wait()
                tx.signature = [signer.sign(try tx.rawData.serializedData())]
                
                let response = try provider.broadcastTransaction(tx).wait()
                guard response.result else {
                    let errMessage = String(data: response.message, encoding: .utf8) ?? ""
                    DispatchQueue.main.async {
                        seal.reject(Error.unknown(message: errMessage))
                    }
                    return
                }
                
                let txHash = try! tx.rawData.serializedData().sha256().toHexString()
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
                          amount: Int64,
                          assetName: String,
                          signer: TronAccount) -> Promise<String> {
        let (promise, seal) = Promise<String>.pending()
        DispatchQueue.global().async {
            do {
                let contract = Protocol_TransferAssetContract.with {
                    $0.assetName = assetName.data(using: .utf8)!
                    $0.ownerAddress = signer.address.data
                    $0.toAddress = toAddress.data
                    $0.amount = amount
                }
                var tx =  try provider.transferAssetContract(contract).wait()
                tx.signature = [signer.sign(try tx.rawData.serializedData())]
                
                let response = try provider.broadcastTransaction(tx).wait()
                guard response.result else {
                    let errMessage = String(data: response.message, encoding: .utf8) ?? ""
                    DispatchQueue.main.async {
                        seal.reject(Error.unknown(message: errMessage))
                    }
                    return
                }
                
                let txHash = try! tx.rawData.serializedData().sha256().toHexString()
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
                          signer: TronAccount) -> Promise<String> {
        let (promise, seal) = Promise<String>.pending()
        DispatchQueue.global().async {
            do {
                let contract = TronContract_TRC20(contractAddress: contractAddress).transfer(from: signer.address, to: toAddress, value: amount)
                let txExtension =  try provider.triggerSmartContract(contract).wait()
                var tx = txExtension.transaction
                tx.rawData.feeLimit = self.feeLimit
                tx.signature = [signer.sign(try tx.rawData.serializedData())]
                
                let response = try provider.broadcastTransaction(tx).wait()
                guard response.result else {
                    let errMessage = String(data: response.message, encoding: .utf8) ?? ""
                    DispatchQueue.main.async {
                        seal.reject(Error.unknown(message: errMessage))
                    }
                    return
                }

                let txHash = try! tx.rawData.serializedData().sha256().toHexString()
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
