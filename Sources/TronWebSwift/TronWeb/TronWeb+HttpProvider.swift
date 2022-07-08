//
//  Web3HttpProvider.swift
//  
//
//  Created by mathwallet on 2022/6/29.
//

import Foundation
import PromiseKit

public class TronWebHttpProvider {
    public var url: URL
    public var session: URLSession = {() -> URLSession in
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        return urlSession
    }()
    
    public init?(_ httpProviderURL: URL) {
        guard httpProviderURL.scheme == "http" || httpProviderURL.scheme == "https" else {return nil}
        self.url = httpProviderURL
    }
}

extension TronWebHttpProvider {
    static func GET<K: Decodable>(_ parameters: [String: Any]? = nil, providerURL: URL, queue: DispatchQueue = .main, session: URLSession) -> Promise<K> {
        let rp = Promise<Data>.pending()
        var task: URLSessionTask? = nil
        queue.async {
            let url = providerURL.appendingQueryParameters(parameters)
            debugPrint("GET \(url)")
            var urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            task = session.dataTask(with: urlRequest){ (data, response, error) in
                guard error == nil else {
                    rp.resolver.reject(error!)
                    return
                }
                guard data != nil else {
                    rp.resolver.reject(TronWebError.nodeError(desc: "Node response is empty"))
                    return
                }
                rp.resolver.fulfill(data!)
            }
            task?.resume()
        }
        return rp.promise.ensure(on: queue) {
                task = nil
            }.map(on: queue){ (data: Data) throws -> K in
                debugPrint(String(data: data, encoding: .utf8) ?? "")
                if let errResp = try? JSONDecoder().decode(TronWebResponse.Error.self, from: data) {
                    throw TronWebError.processingError(desc: errResp.error)
                }
                
                if let resp = try? JSONDecoder().decode(K.self, from: data) {
                    return resp
                }
                throw TronWebError.nodeError(desc: "Received an error message from node")
            }
    }
    
    static func POST<K: Decodable>(_ parameters: [String: Any]? = nil, providerURL: URL, queue: DispatchQueue = .main, session: URLSession) -> Promise<K> {
        let rp = Promise<Data>.pending()
        var task: URLSessionTask? = nil
        queue.async {
            do {
                debugPrint("POST \(providerURL)")
                var urlRequest = URLRequest(url: providerURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
                urlRequest.httpMethod = "POST"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
                if let p = parameters {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: p, options: .fragmentsAllowed)
                    debugPrint(p)
                }
                
                task = session.dataTask(with: urlRequest){ (data, response, error) in
                    guard error == nil else {
                        rp.resolver.reject(error!)
                        return
                    }
                    guard data != nil else {
                        rp.resolver.reject(TronWebError.nodeError(desc: "Node response is empty"))
                        return
                    }
                    rp.resolver.fulfill(data!)
                }
                task?.resume()
            } catch {
                rp.resolver.reject(error)
            }
        }
        return rp.promise.ensure(on: queue) {
                task = nil
            }.map(on: queue){ (data: Data) throws -> K in
                debugPrint(String(data: data, encoding: .utf8) ?? "")
                
                if let errResp = try? JSONDecoder().decode(TronWebResponse.Error.self, from: data) {
                    throw TronWebError.processingError(desc: errResp.error)
                }
                
                if let resp = try? JSONDecoder().decode(K.self, from: data) {
                    return resp
                }
                throw TronWebError.nodeError(desc: "Received an error message from node")
            }
    }
}
