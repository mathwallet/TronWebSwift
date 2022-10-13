//
//  TronContractTests.swift
//  
//
//  Created by mathwallet on 2022/7/2.
//

import XCTest
import BigInt
@testable import TronWebSwift

class TronWebTests: XCTestCase {
    let provider = TronWebHttpProvider(URL(string: "https://tron.maiziqianbao.net")!)!
    let signer = try! TronSigner(privateKey: Data(hex: "4705824132a933e466df987395d398ff31603fc0e08b447a7be1fce841ce21c9"))
    var tronWeb: TronWeb { return TronWeb(provider: provider) }

    func testCreateAccountExample() throws {
        debugPrint(try TronSigner.generate())
    }
    
    func testGetChainParameterExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let resp = try self.provider.getChainParameters().wait()
                debugPrint(resp)
                reqeustExpectation.fulfill()
            } catch _ {
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }
    
    func testGetAccountExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let ownerAddress = TronAddress("TSCDnDiJfrLB4yGDzcC8F6vvtNvPAjyerZ")!
                let resp = try self.provider.getAccount(ownerAddress).wait()
                debugPrint(resp)
                reqeustExpectation.fulfill()
            } catch _ {
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }
    
    func testGetAccountResourceExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let ownerAddress = TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!
                let resp = try self.provider.getAccountResource(ownerAddress).wait()
                debugPrint(resp)
                reqeustExpectation.fulfill()
            } catch _ {
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }
    
    func testContractsExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let toAddress = TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!
                let contractAddress = TronAddress("TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8")
                
                guard let c = self.tronWeb.contract(TronWeb.Utils.trc20ABI, at: contractAddress) else {
                    reqeustExpectation.fulfill()
                    return
                }
                
                var opts = TronTransactionOptions.defaultOptions
                opts.ownerAddress = self.signer.address
                opts.feeLimit = 15000000
                
                let parameters = [toAddress, BigUInt(100)] as [AnyObject]
                let response = try c.write("transfer", parameters: parameters, signer: self.signer, transactionOptions: opts).wait()
                debugPrint(response)
                
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error.localizedDescription)
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }
    
    func testAssetExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let toAddress = TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!
                let amount: Int64 = 100
                let contract = Protocol_TransferContract.with {
                    $0.ownerAddress = self.signer.address.data
                    $0.toAddress = toAddress.data
                    $0.amount = amount
                }
                let tx =  try self.provider.createTransaction(contract).wait()
                let signedTx = try tx.sign(self.signer)
                
                let response = try self.provider.broadcastTransaction(signedTx).wait()
                debugPrint(response)
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error.localizedDescription)
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }
    
    func testTRC20InfoExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let contractAddress = TronAddress("TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8")
                
                guard let c = self.tronWeb.contract(TronWeb.Utils.trc20ABI, at: contractAddress) else {
                    reqeustExpectation.fulfill()
                    return
                }
                
                let response = try c.read("name").wait()
                debugPrint(response)
                
                let response2 = try c.read("balanceOf", parameters: [TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!] as! [AnyObject]).wait()
                debugPrint(response2)
                
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error.localizedDescription)
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }
    
    func testEstimateEnergyExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let toAddress = TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!
                let contractAddress = TronAddress("TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8")
                
                guard let c = self.tronWeb.contract(TronWeb.Utils.trc20ABI, at: contractAddress) else {
                    reqeustExpectation.fulfill()
                    return
                }
                
                var opts = TronTransactionOptions.defaultOptions
                opts.ownerAddress = TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!
                
                let parameters = [toAddress, BigUInt(100)] as [AnyObject]
                let response = try c.estimateEnergy("transfer", parameters: parameters, transactionOptions: opts).wait()
                debugPrint(response)
                
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error.localizedDescription)
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }
    
    func testBuildTransactionExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let ownerAddress = TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!
                let toAddress = TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!
                let tx = try self.tronWeb.build(toAddress, ownerAddress: ownerAddress, amount: BigUInt(100)).wait()
                debugPrint(tx)
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error.localizedDescription)
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }
    
    func testDecodeRawTransactionExample() throws {
        let txRawHex = "0a02152822082dfe40c369deb19640a8fea0ea9c305ab101081f12ac010a31747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e54726967676572536d617274436f6e747261637412770a1541ac63d1d65800312f5946de9cc25bb8a10c3f49ec1215413487b63d30b5b2c87fb7ffa8bcfade38eaac1abe18e8072244a9059cbb000000000000000000000041da1ed679700721f29310112b0d7a4b690e14c63500000000000000000000000000000000000000000000000000000000000000647091b19dea9c309001c0c39307"
        let tx = try TronTransaction.with {
            $0.rawData = try TronTransaction.raw(serializedData: Data(hex: txRawHex))
        }
        let human = try tx.toHuman()
        debugPrint(human)
    }
    
    func testDecodeInputDataExample() throws {
        guard let tronContract = TronContract(TronWeb.Utils.trc20ABI, at: nil) else { return }
        let method = "transfer"
        guard let function = tronContract.methods[method] else { return }
        guard case .function(_) = function else { return}
        // a9059cbb
        // 00000000000000000000004141a768c9797b8b1a1d41d25ba603f68326fcfc40
        // 00000000000000000000000000000000000000000000000000000000000186a0
        let returns = function.decodeInputData(Data(hex: "a9059cbb00000000000000000000004141a768c9797b8b1a1d41d25ba603f68326fcfc4000000000000000000000000000000000000000000000000000000000000186a0"))
        debugPrint(returns ?? [:])
    }
}
