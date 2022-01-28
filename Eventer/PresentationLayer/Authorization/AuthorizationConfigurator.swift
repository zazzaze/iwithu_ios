//
//  AuthorizationConfigurator.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

struct AuthorizationConfigurator {
    func makeAuthorizationView(eventsViewcontroller: ViewController) -> UIViewController {
        let view = AuthorizationViewController()
        let router = AuthorizationRouter(
            view: view,
            baseView: eventsViewcontroller
        )
        let presenter = AuthorizationPresenter(view: view, router: router)
        let interactor = AuthorizationInteractor(presenter: presenter)
        view.interactor = interactor

        return view
    }
}
