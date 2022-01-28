//
//  AuthorizationService.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation

class AuthorizationService: BaseService {
    func loginUser(_ user: UserModel, completion: @escaping ((String?) -> Void)) {
        guard let url = URL(string: "\(Self.api)/login") else {
            return completion(nil)
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        request.httpBody = try? jsonEncoder.encode(user)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .json5Allowed) as? [String: Any],
                let token = json["token"] as? String
            else {
                return completion(nil)
            }

            completion(token)
        }

        task.resume()
    }
}
