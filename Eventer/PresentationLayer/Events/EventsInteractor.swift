//
//  EventsInteractor.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation

class EventsInteractor {
    private let presenter: EventsPresenter
    let eventsService = EventsService()

    init(presenter: EventsPresenter) {
        self.presenter = presenter
    }

    func updateToken(_ token: String) {
        eventsService.updateToken(token)
        loadEvents()
        loadMyEvents()
    }

    func loadEvents() {
        eventsService.loadEvents { [weak self] events in
            DispatchQueue.main.async {
                guard let events = events else {
                    self?.presenter.showAllEvents([])
                    return
                }

                self?.presenter.showAllEvents(events)
            }
        }
    }

    func loadMyEvents() {
        eventsService.loadMyEvents { [weak self] events in
            DispatchQueue.main.async {
                guard let events = events else {
                    self?.presenter.showMyEvents([])
                    return
                }

                self?.presenter.showMyEvents(events)
            }
        }
    }
}
