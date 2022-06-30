//
//  Promise+HttpProvider.swift
//  
//
//  Created by mathwallet on 2022/6/29.
//

import Foundation
import PromiseKit

extension TronWebHttpProvider {
    public func getAccount(_ address: TronAddress) -> Promise<GetAccountResponse> {
        let request = GetAccountRequest(address: address.address, visible: true)
        let providerURL = self.url.appending(.getAccount)
        return TronWebHttpProvider.POST(request, providerURL: providerURL, session: self.session)
    }
}
