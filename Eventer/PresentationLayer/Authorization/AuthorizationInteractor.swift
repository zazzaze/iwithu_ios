//
//  AuthorizationInteractor.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation

class AuthorizationInteractor {
    private let authService = AuthorizationService()
    private let presenter: AuthorizationPresenter

    init(presenter: AuthorizationPresenter) {
        self.presenter = presenter
    }

    func loginUser(_ login: String, password: String) {
        let user = UserModel(login: login, password: password)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.authService.loginUser(user) { token in
                guard let token = token else {
                    DispatchQueue.main.async {
                        self?.presenter.didReceiveError()
                    }
                    return
                }

                DispatchQueue.main.async {
                    self?.presenter.didReceiveToken(token)
                }
            }
        }
    }
}
