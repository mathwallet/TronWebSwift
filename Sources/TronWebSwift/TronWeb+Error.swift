//
//  TronWeb+Error.swift
//  
//
//  Created by math on 2021/12/27.
//

import Foundation

extension TronWeb {
    enum Error: LocalizedError {
        case invalidProvider
        case unknown(message: String)
        
        var errorDescription: String? {
            switch self {
            case .invalidProvider:
                return "TronWeb.Error.invalidProvider"
            case .unknown(let message):
                return message
            }
        }
    }
}
