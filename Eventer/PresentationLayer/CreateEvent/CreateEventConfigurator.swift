//
//  CreateEventConfigurator.swift
//  Eventer
//
//  Created by Egor Anikeev on 28.01.2022.
//

import Foundation
import UIKit

struct CreateEventConfigurator {
    func makeCreateEventViewController(baseView: ViewController) -> UIViewController {
        let view = CreateEventViewController()
        let router = CreateEventRouter(view: view, baseView: baseView)
        let presenter = CreateEventPresenter(view: view)
        let interactor = CreateEventInteractor(view: view, presenter: presenter)
        view.interactor = interactor
        view.router = router

        return view
    }
}
