//
//  AuthorizationRouter.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

class AuthorizationRouter {
    private weak var view: AuthorizationViewController?
    private weak var baseView: ViewController?
    private var navController: UINavigationController? {
        view?.navigationController
    }

    init(
        view: AuthorizationViewController?,
        baseView: ViewController?
    ) {
        self.view = view
        self.baseView = baseView
    }

    func goWithToken(_ token: String) {
        baseView?.updateToken(token)

        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navController?.view.layer.add(transition, forKey: kCATransition)
        navController?.popViewController(animated: false)
    }
}
