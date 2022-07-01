//
//  TrowWebProviderTests..swift
//  
//
//  Created by mathwallet on 2022/6/30.
//

import XCTest
import BigInt
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
    
    func testCreateTransactionExample() throws {
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
    
    func testTransferAssetContractExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        let reqeust = Protocol_TransferAssetContract.with {
            $0.ownerAddress = TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!.data
            $0.toAddress = TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!.data
            $0.assetName = "1004031".data(using: .utf8)!
            $0.amount = 10
        }
        provider.transferAsset(reqeust).done { (resp: Protocol_Transaction) in
            debugPrint(resp)
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testTriggerSmartContractExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        let contractAddress = TronAddress("TCFLL5dx5ZJdKnWuesXxi1VPwjLVmWZZy9")!
        let from = TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!
        let to = TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!
        let trc20 = TRC20(contractAddress: contractAddress)
        let request = trc20.transfer(from: from, to: to, value: BigUInt("10000"))
        provider.triggerSmartContract(request, functionSelector: "transfer(address,uint256)").done { (resp: Protocol_TransactionExtention) in
            debugPrint(resp)
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testTriggerConstantContractExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        let contractAddress = TronAddress("TCFLL5dx5ZJdKnWuesXxi1VPwjLVmWZZy9")!
        let from = TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!
        let trc20 = TRC20(contractAddress: contractAddress)
        let request = trc20.balanceOf(owner: from)
        provider.triggerConstantContract(request, functionSelector: "balanceOf11(address)").done { (resp: Protocol_TransactionExtention) in
            debugPrint(resp)
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
}
