//
//  TrowWebProviderTests..swift
//  
//
//  Created by mathwallet on 2022/6/30.
//

import XCTest
@testable import TronWebSwift

class TrowWebProviderTests: XCTestCase {
    
    let provider = TronWebHttpProvider(URL(string: "https://tron.maiziqianbao.net")!)!
    
    func testGetAccountExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        let address = TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!
        
        provider.getAccount(address).done { (resp: Protocol_Account) in
            debugPrint(resp)
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testGetNowBlockExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        provider.getNowBlock().done { (resp: Protocol_Block) in
            debugPrint(resp)
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testGetCreateTransactionExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        let reqeust = Protocol_TransferContract.with {
            $0.ownerAddress = TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!.data
            $0.toAddress = TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!.data
            $0.amount = 1000
        }
        provider.createTransaction(reqeust).done { (resp: Protocol_Transaction) in
            debugPrint(resp)
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
}
