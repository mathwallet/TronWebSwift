//
//  File.swift
//  
//
//  Created by mathwallet on 2022/7/2.
//

import Foundation

extension Protocol_Transaction {
    public func sign(_ signer: TronSigner) throws -> Protocol_Transaction {
        var tx = self
        let hash = try tx.rawData.serializedData().sha256()
        guard let sig = signer.signDigest(hash) else {
            throw TronWebError.processingError(desc: "Sign transaction error.")
        }
        tx.signature = [sig]
        return tx
    }
}
