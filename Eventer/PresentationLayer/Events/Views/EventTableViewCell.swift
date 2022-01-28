//
//  EventTableViewCell.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

class EventTableViewCell: UITableViewCell {
    static let identifier = "EventCell"

    private let separatorView = UIView()
    private let container = UIStackView()
    private let eventTag = EventTag()
    private let infoBlock = TextInfoView()
    private let details = EventDetails()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: EventModel) {
        eventTag.text = model.category
        infoBlock.titleLabel.text = model.title
        infoBlock.infoLabel.text = model.description
        details.participantsCountLabel.text = "\(model.membersCount)/\(model.capacity ?? 1)"
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formater.date(from: model.time) else { return }
        formater.dateFormat = "dd.MM.yyyy"
        let dateString = formater.string(from: date)
        details.dateOfEventLabel.text = dateString
    }

    private func configureUI() {
        backgroundColor = .clear

        container.alignment = .fill
        container.distribution = .fill
        container.axis = .vertical
        container.spacing = 10
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        container.backgroundColor = Colors.foregroundColor
        container.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        container.isLayoutMarginsRelativeArrangement = true

        separatorView.backgroundColor = .clear

        eventTag.tagColor = UIColor(hex: 0xF16567, alpha: 1.0)

        addSubview(container)
        addSubview(separatorView)

        container.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        container.addArrangedSubview(eventTag)
        container.addArrangedSubview(infoBlock)
        container.addArrangedSubview(details)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),

            separatorView.topAnchor.constraint(equalTo: container.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 15),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

class EventTag: UIView {
    private let tagColorView = UIView()
    private let tagLabel = UILabel()

    var text: String? {
        get { return tagLabel.text }
        set { tagLabel.text = newValue }
    }

    var tagColor: UIColor? {
        get { return tagColorView.backgroundColor }
        set { tagColorView.backgroundColor = newValue }
    }

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        tagColorView.layer.cornerRadius = 2

        tagLabel.textColor = Colors.subtitleTextColor
        tagLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        tagColorView.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tagColorView)
        addSubview(tagLabel)

        NSLayoutConstraint.activate([
            tagColorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagColorView.heightAnchor.constraint(equalToConstant: 12),
            tagColorView.widthAnchor.constraint(equalTo: tagColorView.heightAnchor),
            tagColorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagColorView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),

            tagLabel.leadingAnchor.constraint(equalTo: tagColorView.trailingAnchor, constant: 5),
            tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: tagColorView.centerYAnchor),
            tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

fileprivate class TextInfoView: UIView {
    let titleLabel = UILabel()
    let infoLabel = UILabel()

    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        titleLabel.textColor = Colors.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        infoLabel.textColor = Colors.subtitleTextColor
        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        infoLabel.numberOfLines = 10

        addSubview(titleLabel)
        addSubview(infoLabel)

        [infoLabel, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            infoLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 150),
            infoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

fileprivate class EventDetails: UIView {
    private let container = UIStackView()

    let participantsCountLabel = LabelWithIcon()
    let dateOfEventLabel = LabelWithIcon()

    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        container.spacing = 10
        container.axis = .horizontal
        container.alignment = .leading
        container.distribution = .fill

        container.addArrangedSubview(participantsCountLabel)
        container.addArrangedSubview(dateOfEventLabel)
        container.translatesAutoresizingMaskIntoConstraints = false

        participantsCountLabel.image = Images.userIcon
        participantsCountLabel.text = "6/10"

        dateOfEventLabel.image = Images.calendarIcon
        dateOfEventLabel.text = "27.02.2022"

        addSubview(container)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }
}

fileprivate class LabelWithIcon: UIStackView {
    private let icon = UIImageView()
    private let label = UILabel()

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var image: UIImage? {
        get { icon.image }
        set { icon.image = newValue }
    }

    init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.spacing = 2
        self.alignment = .leading
        self.distribution = .fill

        label.textColor = Colors.subtitleTextColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        icon.tintColor = Colors.subtitleTextColor

        addArrangedSubview(icon)
        addArrangedSubview(label)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
