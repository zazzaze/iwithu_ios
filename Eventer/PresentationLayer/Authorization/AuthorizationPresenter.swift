import Foundation

final class AuthorizationPresenter {
    private weak var view: AuthorizationViewController?
    private let router: AuthorizationRouter

    init(
        view: AuthorizationViewController,
        router: AuthorizationRouter
    ) {
        self.view = view
        self.router = router
    }

    func didReceiveToken(_ token: String) {
        router.goWithToken(token)
    }

    func didReceiveError() {
        view?.showError(title: "Ошибка", message: "Не удалось авторизоваться")
    }
}
