//
//  EventPresenter.swift
//  Eventer
//
//  Created by Egor Anikeev on 28.01.2022.
//

import Foundation

class EventPresenter {
    private weak var view: EventViewController?

    init(view: EventViewController) {
        self.view = view
    }

    func loadEventSuccessful(_ event: FullEvent) {
        view?.update(with: event)
    }

    func loadEventUnsuccessful() {
        view?.showError(title: "Ошибка", message: "Не удалось получить информацию о событии", close: true)
    }

    func didFailToJoinEvent() {
        view?.showError(title: "Ошибка", message: "Не удалось присоединиться к событию", close: false)
    }
}
