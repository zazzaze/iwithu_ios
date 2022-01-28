//
//  BaseService.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation

class BaseService {
    static let api = "http://51.250.14.207:8080"

    var token: String?

    init() {
        token = Storage.shared.token
    }

    func updateToken(_ token: String) {
        Storage.shared.saveToken(token)
        self.token = token
    }
}

extension URL {
    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems

        self = urlComponents.url!
    }
}
