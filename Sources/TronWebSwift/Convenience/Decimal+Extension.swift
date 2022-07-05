//
//  Decimal+Extension.swift
//  
//
//  Created by mathwallet on 2022/7/5.
//

import Foundation

extension Decimal {
    
    /// power10
    /// - Parameter exponent: 10^exponent
    /// - Returns: n * 10^exponent
    func power10(_ exponent: Int) -> Decimal {
        Decimal(sign: self.sign, exponent: self.exponent + exponent, significand: self.significand)
    }
}
