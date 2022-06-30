//
//  Web3HttpProvider.swift
//  
//
//  Created by mathwallet on 2022/6/29.
//

import Foundation
import PromiseKit

public struct TronWebErrorResponse: Decodable {
    public var error: String
}

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
    static func GET<V: Decodable>(_ request: [String: Any]? = nil, providerURL: URL, queue: DispatchQueue = .main, session: URLSession) -> Promise<V> {
        let rp = Promise<Data>.pending()
        var task: URLSessionTask? = nil
        queue.async {
            let url = providerURL.appendingQueryParameters(request)
            var urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            debugPrint("GET \(url)")
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
            }.map(on: queue){ (data: Data) throws -> V in
                debugPrint(String(data: data, encoding: .utf8) ?? "")
                if let resp = try? JSONDecoder().decode(V.self, from: data) {
                    return resp
                }
                if let errResp = try? JSONDecoder().decode(TronWebErrorResponse.self, from: data) {
                    throw TronWebError.processingError(desc: errResp.error)
                }
                throw TronWebError.nodeError(desc: "Received an error message from node")
            }
    }
    
    static func POST<K: Encodable, V: Decodable>(_ request: K, providerURL: URL, queue: DispatchQueue = .main, session: URLSession) -> Promise<V> {
        let rp = Promise<Data>.pending()
        var task: URLSessionTask? = nil
        queue.async {
            do {
                let requestData = try JSONEncoder().encode(request)
                var urlRequest = URLRequest(url: providerURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
                urlRequest.httpMethod = "POST"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
                urlRequest.httpBody = requestData
                
                debugPrint("POST \(providerURL)")
                debugPrint(String(data: requestData, encoding: .utf8) ?? "")
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
            }.map(on: queue){ (data: Data) throws -> V in
                debugPrint(String(data: data, encoding: .utf8) ?? "")
                if let resp = try? JSONDecoder().decode(V.self, from: data) {
                    return resp
                }
                if let errResp = try? JSONDecoder().decode(TronWebErrorResponse.self, from: data) {
                    throw TronWebError.processingError(desc: errResp.error)
                }
                throw TronWebError.nodeError(desc: "Received an error message from node")
            }
    }
}
