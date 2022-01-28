//
//  EventsPresenter.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation

class EventsPresenter {
    private weak var view: ViewController?

    init(view: ViewController) {
        self.view = view
    }

    func showAllEvents(_ events: [EventModel]) {
        view?.updateAllEvents(events)
    }

    func showMyEvents(_ events: [EventModel]) {
        view?.updateMyEvents(events)
    }
}
