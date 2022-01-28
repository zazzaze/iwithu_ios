//
//  CreateEventModel.swift
//  Eventer
//
//  Created by Egor Anikeev on 28.01.2022.
//

import Foundation

struct CreateEventModel: Codable {
    let title: String
    let category: String
    let description: String
    let capacity: Int
    let time: String
}
