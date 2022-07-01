import XCTest
import CryptoSwift
import BigInt

@testable import TronWebSwift

final class TronWebTests: XCTestCase {
    let provider = TronWebHttpProvider(URL(string: "https://tron.maiziqianbao.net")!)!
    let signer = try! TronSigner(privateKey: Data(hex: "4705824132a933e466df987395d398ff31603fc0e08b447a7be1fce841ce21c9"))
    var tronWeb: TronWeb { return TronWeb(provider: provider) }
    
    func testAddressExample() throws {
        XCTAssertTrue(TronAddress.isValid(string: "TRgioeTKEW31c1D35EHqBe9hnR5Fzwkbks"))
        XCTAssertTrue(TronAddress.isValid(string: "QXEx2ZL6WkFxsUfLsyx8LvHo4CqYv31kX") == false)

        XCTAssertTrue(signer.address == TronAddress("TRgioeTKEW31c1D35EHqBe9hnR5Fzwkbks"))
        
        XCTAssertTrue(TronAddress(Data(hex: "41E17813C29A72D0F706D3D1BDF47D5B8181E3FB67")) == TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2"))
    }
    
    func testProviderExample() throws {
        let reqeustExpectation = expectation(description: "testReqeust")
        DispatchQueue.global().async {
            do {
                // Block
                let block = try self.provider.getNowBlock().wait()
                debugPrint("BlockNumber: \(block.blockHeader.rawData.number)")
                
                // Account
                let account = try self.provider.getAccount(TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!).wait()
                debugPrint("AccountName: \(String(data: account.accountName, encoding: .utf8) ?? "")")
                debugPrint("Address: \(account.address.toHexString())")
                debugPrint("TRX Balance: \(account.balance)")
                debugPrint("Account Asset: \(account.asset)")
                debugPrint("Account Asset2: \(account.assetV2)")
                
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error)
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
                        amount: BigUInt(100000),
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
                let contractEx = TRC20(contractAddress: TronAddress("TCFLL5dx5ZJdKnWuesXxi1VPwjLVmWZZy9")!).balanceOf(owner: TronAddress("TWXNtL6rHGyk2xeVR3QqEN9QGKfgyRTeU2")!)
                let txExtension =  try self.provider.triggerConstantContract(contractEx).wait()
                debugPrint(BigUInt(txExtension.constantResult.first!).description)
                reqeustExpectation.fulfill()
            } catch let error {
                debugPrint(error.localizedDescription)
                reqeustExpectation.fulfill()
            }
        }
        wait(for: [reqeustExpectation], timeout: 10)
    }
    
    func testRawDataExample() throws {
        // TxID -> sha256(rawData)
        // c9c03a70a777900b32cbac5ffadddce5d17867494fdc8f4332aef34ea97448c5
        let rawData = Data(hex: "0a0294cb2208142b7e076262aa7b40e88cb7a2e02f5aae01081f12a9010a31747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e54726967676572536d617274436f6e747261637412740a1541e17813c29a72d0f706d3d1bdf47d5b8181e3fb671215413dfe637b2b9ae4190a458b5f3efc1969afe278192244095ea7b30000000000000000000000006e0617948fe030a7e4970f8389d4ad295f249b7effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff70d3beb3a2e02f900180c2d72f")
        
        let tx = Protocol_Transaction.with {
            $0.rawData = try! Protocol_Transaction.raw(serializedData: rawData)
        }
        XCTAssertTrue(rawData == (try? tx.rawData.serializedData()))
        
    }
}
