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
        let txRawHex = "0a028c232208a61909582699932540c093ddb79c305acf01081f12ca010a31747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e54726967676572536d617274436f6e74726163741294010a1541e17813c29a72d0f706d3d1bdf47d5b8181e3fb67121541ec5e8661f8855b1724d4f668f11ab722b4b3b74d2264999bb7ac000000000000000000000000000000000000000000000000000000000008cd62000000000000000000000000000000000000000000000000000000000082a7cb0000000000000000000000000000000000000000000000000000000062c24b9a709dccd9b79c30900180c2d72f"
        let tx = try TronTransaction.with {
            $0.rawData = try TronTransaction.raw(serializedData: Data(hex: txRawHex))
        }
        let human = try tx.toHuman()
        debugPrint(human)
    }

}
