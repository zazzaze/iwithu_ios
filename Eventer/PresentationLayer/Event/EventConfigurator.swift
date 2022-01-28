//
//  EventConfigurator.swift
//  Eventer
//
//  Created by Egor Anikeev on 28.01.2022.
//

import Foundation

class EventConfigurator {
    func makeEventViewController(for event: EventModel) -> EventViewController {
        let view = EventViewController()
        let presenter = EventPresenter(view: view)
        let interactor = EventInteractor(presenter: presenter)
        view.interactor = interactor
        interactor.loadFullEvent(model: event)

        return view
    }
}
