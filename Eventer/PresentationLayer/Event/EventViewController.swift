//
//  EventViewController.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

class EventViewController: UIViewController {
    var interactor: EventInteractor?

    private var model: FullEvent?

    private let scrollView = UIScrollView()
    private let topLine = UIView()
    private let details = EventDetailsView()
    private let titleLabel = UILabel()
    private let joinButton = SubmitButton()
    private let eventTag = EventTag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    func update(with model: FullEvent) {
        self.model = model
        titleLabel.text = model.title
        eventTag.text = model.category
        details.update(with: model)
        updateButtonEnabled(model.canJoin)
        view.layoutIfNeeded()
    }

    private func updateButtonEnabled(_ enabled: Bool) {
        joinButton.isEnabled = enabled
    }

    func showError(title: String?, message: String?, close: Bool) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Закрыть", style: .default) { [weak self] _ in
            alert.dismiss(animated: true, completion: nil)
            if close {
                self?.dismiss(animated: true, completion: nil)
            }
        })

        present(alert, animated: true, completion: nil)
    }

    @objc func didTapJoinButton(_ sender: AnyObject) {
        interactor?.joinEvent(model: self.model)
    }

    private func configureUI() {
        view.backgroundColor = Colors.backgroundColor

        topLine.backgroundColor = Colors.dividerColor
        topLine.layer.cornerRadius = 2

        titleLabel.textColor = Colors.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center

        eventTag.translatesAutoresizingMaskIntoConstraints = false
        eventTag.tagColor = UIColor(hex: 0xF16567, alpha: 1.0)

        joinButton.setTitle("Учавствовать", for: .normal)
        joinButton.setTitle("Вы учавствуете", for: .disabled)
        joinButton.addTarget(self, action: #selector(didTapJoinButton(_:)), for: .touchUpInside)

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 114, right: 0)

        [topLine, titleLabel, details, joinButton, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(scrollView)
        [titleLabel, eventTag, details].forEach {
            scrollView.addSubview($0)
        }

        [topLine, joinButton].forEach {
            view.addSubview($0)
        }


        NSLayoutConstraint.activate([
            topLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLine.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            topLine.widthAnchor.constraint(equalToConstant: 80),
            topLine.heightAnchor.constraint(equalToConstant: 4),

            scrollView.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),

            eventTag.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            eventTag.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            eventTag.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.leadingAnchor),
            eventTag.trailingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor),

            details.topAnchor.constraint(equalTo: eventTag.bottomAnchor, constant: 10),
            details.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            details.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            details.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -10),

            joinButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            joinButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            joinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            joinButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
