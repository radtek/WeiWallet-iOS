//
//  DeepLinkAction.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/12.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import EthereumKit

enum DeepLinkAction {
    case signMessage(message: String, callbackScheme: String)
    case signTransaction(rawTransaction: RawTransaction, callbackScheme: String)
    
    init?(url: URL) throws {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let host = urlComponents.host else {
                return nil
        }
        
        switch (host, urlComponents.path) {
        case ("sdk", "/personal_sign"):
            guard let message = urlComponents.queryItems?.first(where: { $0.name == "message"})?.value,
                let callBackScheme = urlComponents.queryItems?.first(where: { $0.name == "callback_scheme" })?.value else {
                return nil
            }
            self = .signMessage(message: message, callbackScheme: callBackScheme)
            
        case ("sdk", "/sign_transaction"):
            guard let hex = urlComponents.queryItems?.first(where: { $0.name == "raw_transaction" })?.value,
                let callBackScheme = urlComponents.queryItems?.first(where: { $0.name == "callback_scheme" })?.value else {
                return nil
            }
            
            let rawTransaction = try JSONDecoder().decode(RawTransaction.self, from: Data(hex: hex))
            self = .signTransaction(rawTransaction: rawTransaction, callbackScheme: callBackScheme)
            
        default:
            return nil
        }
    }
}
