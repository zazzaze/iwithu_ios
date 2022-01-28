//
//  EventModel.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation

struct EventResponse: Codable {
    let content: [EventModel]
}

struct EventModel: Codable {
    let id: Int
    let category: String
    let title: String
    let description: String
    let capacity: Int?
    let membersCount: Int
    let time: String
}

struct FullEvent: Codable {
    let category: String
    let title: String
    let description: String
    let capacity: Int?
    let members: [String]
    let time: String
    let canJoin: Bool
}
