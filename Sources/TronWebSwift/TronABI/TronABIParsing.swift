//
//  Created by Alex Vlasov on 25/10/2018.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation

extension TronABI {
    
    public enum ParsingError: Swift.Error {
        case invalidJsonFile
        case elementTypeInvalid
        case elementNameInvalid
        case functionInputInvalid
        case functionOutputInvalid
        case eventInputInvalid
        case parameterTypeInvalid
        case parameterTypeNotFound
        case abiInvalid
    }
    
    enum TypeParsingExpressions {
        static var typeEatingRegex = "^((u?int|bytes)([1-9][0-9]*)|(address|bool|string|tuple|bytes)|(\\[([1-9][0-9]*)\\]))"
        static var arrayEatingRegex = "^(\\[([1-9][0-9]*)?\\])?.*$"
    }
    
    
    fileprivate enum ElementType: String {
        case function
        case constructor
        case fallback
        case event
    }
    
}

extension TronABI.Record {
    public func parse() throws -> TronABI.Element {
        let typeString = self.type != nil ? self.type! : "function"
        guard let type = TronABI.ElementType(rawValue: typeString) else {
            throw TronABI.ParsingError.elementTypeInvalid
        }
        return try parseToElement(from: self, type: type)
    }
}

fileprivate func parseToElement(from abiRecord: TronABI.Record, type: TronABI.ElementType) throws -> TronABI.Element {
    switch type {
    case .function:
        let function = try parseFunction(abiRecord: abiRecord)
        return TronABI.Element.function(function)
    case .constructor:
        let constructor = try parseConstructor(abiRecord: abiRecord)
        return TronABI.Element.constructor(constructor)
    case .fallback:
        let fallback = try parseFallback(abiRecord: abiRecord)
        return TronABI.Element.fallback(fallback)
    case .event:
        let event = try parseEvent(abiRecord: abiRecord)
        return TronABI.Element.event(event)
    }
    
}

fileprivate func parseFunction(abiRecord: TronABI.Record) throws -> TronABI.Element.Function {
    let inputs = try abiRecord.inputs?.map({ (input: TronABI.Input) throws -> TronABI.Element.InOut in
        let nativeInput = try input.parse()
        return nativeInput
    })
    let abiInputs = inputs != nil ? inputs! : [TronABI.Element.InOut]()
    let outputs = try abiRecord.outputs?.map({ (output: TronABI.Output) throws -> TronABI.Element.InOut in
        let nativeOutput = try output.parse()
        return nativeOutput
    })
    let abiOutputs = outputs != nil ? outputs! : [TronABI.Element.InOut]()
    let name = abiRecord.name != nil ? abiRecord.name! : ""
    
    let payable = abiRecord.stateMutability != nil ? (abiRecord.stateMutability == "payable" || (abiRecord.payable ?? false)) : false
    let constant = (abiRecord.constant == true || abiRecord.stateMutability == "view" || abiRecord.stateMutability == "pure")
    let functionElement = TronABI.Element.Function(name: name, inputs: abiInputs, outputs: abiOutputs, constant: constant, payable: payable)
    return functionElement
}

fileprivate func parseFallback(abiRecord: TronABI.Record) throws -> TronABI.Element.Fallback {
    let payable = (abiRecord.stateMutability == "payable" || abiRecord.payable!)
    var constant = abiRecord.constant == true
    if (abiRecord.stateMutability == "view" || abiRecord.stateMutability == "pure") {
        constant = true
    }
    let functionElement = TronABI.Element.Fallback(constant: constant, payable: payable)
    return functionElement
}

fileprivate func parseConstructor(abiRecord: TronABI.Record) throws -> TronABI.Element.Constructor {
    let inputs = try abiRecord.inputs?.map({ (input: TronABI.Input) throws -> TronABI.Element.InOut in
        let nativeInput = try input.parse()
        return nativeInput
    })
    let abiInputs = inputs != nil ? inputs! : [TronABI.Element.InOut]()
    var payable = false
    if (abiRecord.payable != nil) {
        payable = abiRecord.payable!
    }
    if (abiRecord.stateMutability == "payable") {
        payable = true
    }
    let constant = false
    let functionElement = TronABI.Element.Constructor(inputs: abiInputs, constant: constant, payable: payable)
    return functionElement
}

fileprivate func parseEvent(abiRecord: TronABI.Record) throws -> TronABI.Element.Event {
    let inputs = try abiRecord.inputs?.map({ (input: TronABI.Input) throws -> TronABI.Element.Event.Input in
        let nativeInput = try input.parseForEvent()
        return nativeInput
    })
    let abiInputs = inputs != nil ? inputs! : [TronABI.Element.Event.Input]()
    let name = abiRecord.name != nil ? abiRecord.name! : ""
    let anonymous = abiRecord.anonymous != nil ? abiRecord.anonymous! : false
    let functionElement = TronABI.Element.Event(name: name, inputs: abiInputs, anonymous: anonymous)
    return functionElement
}

extension TronABI.Input {
    func parse() throws -> TronABI.Element.InOut {
        let name = self.name != nil ? self.name! : ""
        let parameterType = try TronABITypeParser.parseTypeString(self.type)
        if case .tuple(types: _) = parameterType {
            let components = try self.components?.compactMap({ (inp: TronABI.Input) throws -> TronABI.Element.ParameterType in
                let input = try inp.parse()
                return input.type
            })
            let type = TronABI.Element.ParameterType.tuple(types: components!)
            let nativeInput = TronABI.Element.InOut(name: name, type: type)
            return nativeInput
        }
        else {
            let nativeInput = TronABI.Element.InOut(name: name, type: parameterType)
            return nativeInput
        }
    }
    
    func parseForEvent() throws -> TronABI.Element.Event.Input{
        let name = self.name != nil ? self.name! : ""
        let parameterType = try TronABITypeParser.parseTypeString(self.type)
        let indexed = self.indexed == true
        return TronABI.Element.Event.Input(name:name, type: parameterType, indexed: indexed)
    }
}

extension TronABI.Output {
    func parse() throws -> TronABI.Element.InOut {
        let name = self.name != nil ? self.name! : ""
        let parameterType = try TronABITypeParser.parseTypeString(self.type)
        switch parameterType {
        case .tuple(types: _):
            let components = try self.components?.compactMap({ (inp: TronABI.Output) throws -> TronABI.Element.ParameterType in
                let input = try inp.parse()
                return input.type
            })
            let type = TronABI.Element.ParameterType.tuple(types: components!)
            let nativeInput = TronABI.Element.InOut(name: name, type: type)
            return nativeInput
        case .array(type: let subtype, length: let length):
            switch subtype {
            case .tuple(types: _):
                let components = try self.components?.compactMap({ (inp: TronABI.Output) throws -> TronABI.Element.ParameterType in
                    let input = try inp.parse()
                    return input.type
                })
                let nestedSubtype = TronABI.Element.ParameterType.tuple(types: components!)
                let properType = TronABI.Element.ParameterType.array(type: nestedSubtype, length: length)
                let nativeInput = TronABI.Element.InOut(name: name, type: properType)
                return nativeInput
            default:
                let nativeInput = TronABI.Element.InOut(name: name, type: parameterType)
                return nativeInput
            }
        default:
            let nativeInput = TronABI.Element.InOut(name: name, type: parameterType)
            return nativeInput
        }
    }
}


