//
//  AuthorizationViewController.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

final class AuthorizationViewController: UIViewController {

    var interactor: AuthorizationInteractor?

    private let appTitleLabel = UILabel()
    private let appLogo = UIImageView()

    private let container = UIStackView()

    private let simpleText = UILabel()
    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    private let authButton = SubmitButton()
    private let registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        configureUI()
    }

    func showError(title: String?, message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        })

        present(alert, animated: true, completion: nil)
    }

    private func configureUI() {
        view.backgroundColor = Colors.backgroundColor

        appTitleLabel.text = "Я.СВами"
        appTitleLabel.textColor = Colors.titleColor
        appTitleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        appTitleLabel.textAlignment = .center

        appLogo.image = Images.appIcon
        appLogo.tintColor = Colors.accentColor

        simpleText.text = "Напомни нам о себе"
        simpleText.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        simpleText.textColor = Colors.subtitleTextColor
        simpleText.textAlignment = .center

        loginTextField.attributedPlaceholder = NSAttributedString(
            string: "Логин",
            attributes: [NSAttributedString.Key.foregroundColor: Colors.subtitleTextColor]
        )
        loginTextField.textColor = Colors.titleColor
        loginTextField.layer.cornerRadius = 8
        loginTextField.backgroundColor = Colors.foregroundColor
        let loginLeftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        loginTextField.leftView = loginLeftPaddingView
        loginTextField.leftViewMode = .always

        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Пароль",
            attributes: [NSAttributedString.Key.foregroundColor: Colors.subtitleTextColor]
        )
        passwordTextField.textColor = Colors.titleColor
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = Colors.foregroundColor
        let passwordLeftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordTextField.leftView = passwordLeftPaddingView
        passwordTextField.leftViewMode = .always

        authButton.setTitle("Войти", for: .normal)
        authButton.addTarget(self, action: #selector(didTapAuthButton(_:)), for: .touchUpInside)

        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.setTitleColor(Colors.accentColor, for: .normal)

        container.spacing = 10
        container.axis = .vertical
        container.distribution = .fillEqually
        container.alignment = .fill

        [appTitleLabel, appLogo, container].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [simpleText, loginTextField, passwordTextField, authButton, registerButton].forEach {
            container.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            appTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            appTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),

            appLogo.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 55),
            appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogo.widthAnchor.constraint(equalToConstant: 107),
            appLogo.heightAnchor.constraint(equalTo: appLogo.widthAnchor),

            container.topAnchor.constraint(greaterThanOrEqualTo: appLogo.bottomAnchor, constant: 20),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 250),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }

    @objc private func didTapAuthButton(_ button: UIButton) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
        else {
            return
        }

        interactor?.loginUser(login, password: password)
    }
}
