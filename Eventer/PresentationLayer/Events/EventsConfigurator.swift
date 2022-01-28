//
//  EventsConfigurator.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation

struct EventsConfigurator {
    func makeEventsViewController() -> ViewController {
        let view = ViewController()
        let router = EventsRouter(view: view)
        let presenter = EventsPresenter(view: view)
        let interactor = EventsInteractor(presenter: presenter)
        view.router = router
        view.interactor = interactor

        return view
    }
}
