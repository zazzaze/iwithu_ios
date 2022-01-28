//
//  EventInteractor.swift
//  Eventer
//
//  Created by Egor Anikeev on 28.01.2022.
//

import Foundation

class EventInteractor {
    private let presenter: EventPresenter
    private let eventService = EventsService()

    private var connectedEvent: EventModel?

    init(presenter: EventPresenter) {
        self.presenter = presenter
    }

    func loadFullEvent(model: EventModel?) {
        guard let model = model else {
            return
        }

        connectedEvent = model
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.eventService.loadEvent(id: model.id) { event in
                DispatchQueue.main.async {
                    guard let event = event else {
                        self?.presenter.loadEventUnsuccessful()
                        return
                    }

                    self?.presenter.loadEventSuccessful(event)
                }
            }
        }
    }

    func joinEvent(model: FullEvent?) {
        guard
            let connectedEvent = connectedEvent,
            let model = model
        else {
            return
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.eventService.joinEvent(id: connectedEvent.id) { isSuccess in
                DispatchQueue.main.async {
                    if isSuccess {
                        let newMembers = [""] + model.members
                        let newModel = FullEvent(
                            category: model.category,
                            title: model.title,
                            description: model.description,
                            capacity: model.capacity,
                            members: newMembers,
                            time: model.time,
                            canJoin: false
                        )
                        self?.presenter.loadEventSuccessful(newModel)
                    } else {
                        self?.presenter.didFailToJoinEvent()
                    }
                }
            }
        }
    }
}
