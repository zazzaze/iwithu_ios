//
//  EventDetailedView.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

class EventDetailsView: UIView {

    private let container = UIStackView()
    private let infoButtonsList = InfoButtonsList(buttons: [.chat, .participants, .calendar, .share])
    private let descriptionView = EventDescriptionView()
    private let addressView = EventAddressView()

    init() {
        super.init(frame: .zero)

        container.axis = .vertical
        container.alignment = .fill
        container.distribution = .equalSpacing
        container.spacing = 24


        container.addArrangedSubview(infoButtonsList)
        container.addArrangedSubview(descriptionView)
        container.addArrangedSubview(addressView)

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: FullEvent) {
        infoButtonsList.update(with: model)
        descriptionView.update(with: model)
    }
}

fileprivate class InfoButtonsList: UIView {

    private let container = UIStackView()

    init(buttons: [InfoButtonView.InfoButtonType]) {
        super.init(frame: .zero)
        configureUI(buttons: buttons)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: FullEvent) {
        for view in container.arrangedSubviews {
            if let buttonView = view as? InfoButtonView {
                buttonView.update(with: model)
            }
        }
    }

    private func configureUI(buttons: [InfoButtonView.InfoButtonType]) {
        container.axis = .horizontal
        container.alignment = .fill
        container.spacing = 15
        container.distribution = .fillEqually

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addButtons(buttons)
    }

    private func addButtons(_ buttons: [InfoButtonView.InfoButtonType]) {
        buttons.forEach { buttonType in
            switch buttonType {
            case .chat: container.addArrangedSubview(makeChatButton())
            case .participants: container.addArrangedSubview(makeParticipantsButton())
            case .calendar: container.addArrangedSubview(makeCalendarButton())
            case.share: container.addArrangedSubview(makeShareButton())
            }
        }
    }

    private func makeChatButton() -> InfoButtonView {
        let button = InfoButtonView(type: .chat)
        button.image = Images.chatIcon
        button.text = "Chat"

        return button
    }

    private func makeParticipantsButton() -> InfoButtonView {
        let button = InfoButtonView(type: .participants)
        button.image = Images.userIcon
        button.imageTintColor = .white

        return button
    }

    private func makeCalendarButton() -> InfoButtonView {
        let button = InfoButtonView(type: .calendar)
        button.image = Images.calendarIcon
        button.imageTintColor = .white
        button.text = "22.02.2021"

        return button
    }

    private func makeShareButton() -> InfoButtonView {
        let button = InfoButtonView(type: .share)
        button.image = Images.shareIcon
        button.imageTintColor = .white
        button.text = "Share"

        return button
    }
}

fileprivate class InfoButtonView: UIView {
    let type: InfoButtonType
    private let icon = UIImageView()
    private let label = UILabel()

    var image: UIImage? {
        get { icon.image }
        set { icon.image = newValue }
    }

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var imageTintColor: UIColor? {
        get { icon.tintColor }
        set { icon.tintColor = newValue }
    }

    init(type: InfoButtonType) {
        self.type = type
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = Colors.foregroundColor
        layer.cornerRadius = 8

        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.subtitleTextColor

        [icon, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            icon.heightAnchor.constraint(equalToConstant: 20),
            icon.widthAnchor.constraint(equalToConstant: 20),

            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func update(with model: FullEvent) {
        switch type {
        case .participants:
            text = "\(model.members.count)/\(model.capacity ?? 1)"
        case .calendar:
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let date = formater.date(from: model.time) else { return }
            formater.dateFormat = "dd.MM"
            text = formater.string(from: date)
        default: break
        }
    }

    enum InfoButtonType {
        case chat
        case participants
        case calendar
        case share
    }
}

fileprivate class EventDescriptionView: UIView {
    private let container = UIStackView()

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: FullEvent) {
        descriptionLabel.text = model.description
    }

    private func configureUI() {
        backgroundColor = Colors.foregroundColor
        layer.cornerRadius = 8

        container.axis = .vertical
        container.spacing = 2
        container.distribution = .fillProportionally
        container.alignment = .fill

        titleLabel.textColor = Colors.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLabel.text = "Описание"

        descriptionLabel.textColor = Colors.subtitleTextColor
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 10
        descriptionLabel.text = "Покер (англ. poker) — карточная игра, цель которой собрать выигрышную комбинацию или вынудить всех соперников прекратить участвовать в игре. Игра идёт с полностью или частично закрытыми картами"

        [titleLabel, descriptionLabel].forEach {
            container.addArrangedSubview($0)
        }

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}

class EventAddressView: UIView {
    private let container = UIStackView()

    private let titleLabel = UILabel()
    private let addAddressButton = UIButton()

    var titleTextColor: UIColor? {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = Colors.foregroundColor
        layer.cornerRadius = 8

        titleLabel.textColor = Colors.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLabel.text = "Место проведения"

        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "+ Добавить адресс", attributes: underlineAttribute)
        addAddressButton.setAttributedTitle(underlineAttributedString, for: .normal)
        addAddressButton.setTitleColor(Colors.accentColor, for: .normal)
        addAddressButton.contentHorizontalAlignment = .left
        addAddressButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)


        container.axis = .vertical
        container.spacing = 2
        container.distribution = .fillProportionally
        container.alignment = .fill

        [titleLabel, addAddressButton].forEach {
            container.addArrangedSubview($0)
        }

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }

}
