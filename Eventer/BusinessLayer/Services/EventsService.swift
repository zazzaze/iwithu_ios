//
//  EventsService.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation

final class EventsService: BaseService {
    func loadEvents(completion: @escaping (([EventModel]?) -> Void)) {
        guard let url = URL(string: "\(Self.api)/events") else {
            return completion(nil)
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            guard
                let data = data,
                let json = try? decoder.decode(EventResponse.self, from: data)
            else {
                return completion(nil)
            }

            completion(json.content)
        }

        task.resume()
    }

    func loadMyEvents(completion: @escaping (([EventModel]?) -> Void)) {
        guard let url = URL(string: "\(Self.api)/events/my") else {
            return completion(nil)
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            guard
                let data = data,
                let json = try? decoder.decode(EventResponse.self, from: data)
            else {
                return completion(nil)
            }

            completion(json.content)
        }

        task.resume()
    }

    func loadEvent(id: Int, completion: @escaping ((FullEvent?) -> Void)) {
        guard let url = URL(string: "\(Self.api)/events/\(id)") else {
            return completion(nil)
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            guard
                let data = data,
                let json = try? decoder.decode(FullEvent.self, from: data)
            else {
                return completion(nil)
            }

            completion(json)
        }

        task.resume()
    }

    func createEvent(model: CreateEventModel, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: "\(Self.api)/events") else {
            return completion(false)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(model)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }

        task.resume()
    }

    func joinEvent(id: Int, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: "\(Self.api)/events/\(id)/join") else {
            return completion(false)
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            guard
                let response = response as? HTTPURLResponse
            else {
                return completion(false)
            }

            completion(response.statusCode == 200)
        }

        task.resume()
    }
}
