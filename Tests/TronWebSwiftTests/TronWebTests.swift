import XCTest
import CryptoSwift
import BigInt

@testable import TronWebSwift

final class TronWebTests: XCTestCase {
    let provider = TronGRPCProvider(host: "tronfull.maiziqianbao.net", port: 80)
    let signer = try! TronAccount(privateKey: Data(hex: "4705824132a933e466df987395d398ff31603fc0e08b447a7be1fce841ce21c9"))
    var tronWeb: TronWeb { return TronWeb(provider: provider) }
    
    func testAddressExample() throws {
        XCTAssertTrue(TronAddress.isValid(string: "TRgioeTKEW31c1D35EHqBe9hnR5Fzwkbks"))
        XCTAssertTrue(signer.address == TronAddress("TRgioeTKEW31c1D35EHqBe9hnR5Fzwkbks"))
    }
    
    func testProviderExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        DispatchQueue.global().async {
            do {
                // Block
                let block = try self.provider.getCurrentBlock().wait()
                debugPrint("BlockNumber: \(block.blockHeader.rawData.number)")
                
                // Account
                let account = try self.provider.getAccount(TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!).wait()
                debugPrint("AccountName: \(String(data: account.accountName, encoding: .utf8) ?? "")")
                debugPrint("TRX Balance: \(account.balance)")
                
                reqeustExpectation.fulfill()
            } catch _ {
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testSignMessageExample() throws {
        guard let signature = signer.signPersonalMessage(Data(hex: "010203")) else {
            return
        }
        debugPrint(signature.toHexString())
    }
    
    func testSendTRXExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        tronWeb.sendTRX(to: TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!,
                        amount: BigUInt(1000),
                        signer: signer).done { txHash in
            debugPrint("Hash -> \(txHash)")
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testSendTRC10Example() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        tronWeb.sendTRC10(to: TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!,
                          amount: BigUInt(100000),
                          assetName: "1004031",
                          signer: signer).done { txHash in
            debugPrint("Hash -> \(txHash)")
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testSendTRC20Example() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        tronWeb.sendTRC20(to: TronAddress("TVrXFXRHZtJaEWAgr5h5LChCLFWe2WjaiB")!,
                          contract: TronAddress("TCFLL5dx5ZJdKnWuesXxi1VPwjLVmWZZy9")!,
                          amount: BigUInt("10000000000000"),
                          signer: signer).done { txHash in
            debugPrint("Hash -> \(txHash)")
            reqeustExpectation.fulfill()
        }.catch { error in
            debugPrint(error.localizedDescription)
            reqeustExpectation.fulfill()
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testTRC20BalanceOfExample() {
        let reqeustExpectation = expectation(description: "testReqeust")
        
        DispatchQueue.global().async {
            do {
                let contract = TronContract_TRC20(contractAddress: TronAddress("TCFLL5dx5ZJdKnWuesXxi1VPwjLVmWZZy9")!).balanceOf(owner: TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!)
                let txExtension =  try self.provider.triggerSmartContract(contract).wait()
                debugPrint(BigUInt(txExtension.constantResult.first!).description)
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error.localizedDescription)
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
}
