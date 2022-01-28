//
//  CreateEventInteractor.swift
//  Eventer
//
//  Created by Egor Anikeev on 28.01.2022.
//

import Foundation

class CreateEventInteractor {
    private let view: CreateEventViewController
    private let presenter: CreateEventPresenter
    private let eventService = EventsService()

    internal init(
        view: CreateEventViewController,
        presenter: CreateEventPresenter
    ) {
        self.view = view
        self.presenter = presenter
    }

    func createEvent(
        title: String,
        tag: String,
        description: String,
        capacity: Int,
        date: Date
    ) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateString = formatter.string(from: date)
        let model = CreateEventModel(
            title: title,
            category: tag,
            description: description,
            capacity: capacity,
            time: dateString
        )

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.eventService.createEvent(model: model) { isSuccess in
                DispatchQueue.main.async {
                    if isSuccess {
                        self?.presenter.didCreateSuccesfull()
                    } else {
                        self?.presenter.didCreateFailure()
                    }
                }
            }
        }
    }
}
