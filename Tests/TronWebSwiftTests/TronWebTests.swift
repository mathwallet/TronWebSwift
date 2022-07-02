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
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error.localizedDescription)
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 30)
    }

}
