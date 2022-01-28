//
//  CreateEventPresenter.swift
//  Eventer
//
//  Created by Egor Anikeev on 28.01.2022.
//

import Foundation

class CreateEventPresenter {
    private weak var view: CreateEventViewController?

    init(view: CreateEventViewController?) {
        self.view = view
    }

    func didCreateSuccesfull() {
        view?.closeOnSuccessfulLoading()
    }

    func didCreateFailure() {
        view?.showError(title: "Ошибка", message: "Не удалось создать событие")
    }
}
