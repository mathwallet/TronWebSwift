//
//  TronABI.swift
//
//
//  Created by mathwallet on 2022/6/29.
//


import Foundation

public struct TronABI {
    
}

protocol TronABIElementPropertiesProtocol {
    var isStatic: Bool {get}
    var isArray: Bool {get}
    var isTuple: Bool {get}
    var arraySize: TronABI.Element.ArraySize {get}
    var subtype: TronABI.Element.ParameterType? {get}
    var memoryUsage: UInt64 {get}
    var emptyValue: Any {get}
}

protocol TronABIEncoding {
    var abiRepresentation: String {get}
}

protocol TronABIValidation {
    var isValid: Bool {get}
}
