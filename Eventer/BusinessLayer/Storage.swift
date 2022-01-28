//
//  Storage.swift
//  Eventer
//
//  Created by Egor Anikeev on 28.01.2022.
//

import Foundation

class Storage {
    static let shared = Storage()

    private let userDefaults = UserDefaults.standard

    var token: String? {
        userDefaults.string(forKey: "token")
    }

    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: "token")
    }
}
