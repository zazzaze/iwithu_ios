//
//  CreateEventViewController.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

final class CreateEventViewController: UIViewController {
    var interactor: CreateEventInteractor?
    var router: CreateEventRouter?

    private let scrollView = UIScrollView()

    private let titleInput: TitleWithInputView = {
        let view = TitleWithInputView()
        view.title = "Название"

        return view
    }()
    private let tagInput: TitleWithInputView = {
        let view = TitleWithInputView()
        view.title = "Тэг"

        return view
    }()
    private let maxMembers: TitleWithInputView = {
        let view = TitleWithInputView()
        view.title = "Участники"
        view.text = "3"
        view.keyboardType = .numberPad

        return view
    }()
    private let descriptionView = DescriptionView()
    private let addressPick = EventAddressView()
    private let datePickerView = DatePickView()
    private let createEventButton = SubmitButton()

    private let container = UIStackView()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundColor

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.barTintColor = Colors.backgroundColor
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()

        let titleLabel = UILabel()
        titleLabel.text = "Новое событие"
        titleLabel.textColor = Colors.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        navigationItem.titleView = titleLabel
        navigationItem.hidesBackButton = true
        let closeButton = UIBarButtonItem(image: Images.crossIcon, style: .plain, target: self, action: #selector(close))
        closeButton.tintColor = Colors.titleColor
        navigationItem.rightBarButtonItem = closeButton

        configureUI()
    }

    private func configureUI() {
        container.axis = .vertical
        container.spacing = 20
        container.distribution = .equalSpacing
        container.translatesAutoresizingMaskIntoConstraints = false

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(container)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 110, right: 10)
        view.addSubview(scrollView)

        addressPick.titleTextColor = Colors.subtitleTextColor


        container.addArrangedSubview(titleInput)
        container.addArrangedSubview(tagInput)
        container.addArrangedSubview(maxMembers)
        container.addArrangedSubview(descriptionView)
        container.addArrangedSubview(datePickerView)
        container.addArrangedSubview(addressPick)

        createEventButton.setTitle("Создать", for: .normal)
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        createEventButton.addTarget(self, action: #selector(didTapCreateEventButton(_:)), for: .touchUpInside)
        view.addSubview(createEventButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),

            createEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            createEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            createEventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            createEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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

    func closeOnSuccessfulLoading() {
        router?.updateAndGoBack()
    }

    @objc func didTapCreateEventButton(_ sender: AnyObject) {
        guard
            let title = titleInput.text,
            let description = descriptionView.text,
            let tag = tagInput.text,
            let membersCountString = maxMembers.text,
            let membersCount = Int(membersCountString)
        else { return }
        let date = datePickerView.date
        interactor?.createEvent(
            title: title,
            tag: tag,
            description: description,
            capacity: membersCount,
            date: date
        )
    }

    @objc func close() {
        router?.goBack()
    }
}

fileprivate final class TitleWithInputView: UIView {
    private let container = UIStackView()
    private let titleLabel = UILabel()
    private let titleTextField = UITextField()

    var text: String? {
        get { titleTextField.text }
        set { titleTextField.text = newValue }
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { titleTextField.keyboardType }
        set { titleTextField.keyboardType = newValue }
    }

    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        container.axis = .vertical
        container.alignment = .fill
        container.distribution = .fillProportionally
        container.spacing = 5
        container.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = Colors.subtitleTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        titleTextField.textColor = Colors.titleColor
        titleTextField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "Оно тут",
            attributes: [NSAttributedString.Key.foregroundColor: Colors.subtitleTextColor]
        )
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 0))
        titleTextField.leftView = paddingView
        titleTextField.leftViewMode = .always
        titleTextField.backgroundColor = Colors.foregroundColor
        titleTextField.layer.cornerRadius = 8

        [titleLabel, titleTextField].forEach {
            container.addArrangedSubview($0)
        }

        addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

fileprivate final class DescriptionView: UIView {
    private let container = UIStackView()
    private let title = UILabel()
    private let descriptionTextView = UITextView()
    private let descriptionContainer = UIView()

    var text: String? {
        descriptionTextView.text
    }

    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        container.axis = .vertical
        container.alignment = .fill
        container.distribution = .fillProportionally
        container.spacing = 5
        container.translatesAutoresizingMaskIntoConstraints = false

        title.text = "Описание:"
        title.textColor = Colors.subtitleTextColor
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        descriptionTextView.backgroundColor = Colors.foregroundColor
        descriptionTextView.textColor = Colors.titleColor
        descriptionTextView.isSelectable = true
        descriptionTextView.isEditable = true
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        descriptionContainer.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionContainer.topAnchor.constraint(equalTo: descriptionContainer.topAnchor),
            descriptionContainer.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor),
            descriptionContainer.trailingAnchor.constraint(equalTo: descriptionContainer.trailingAnchor),
        ])

        [title, descriptionTextView].forEach {
            container.addArrangedSubview($0)
        }

        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

fileprivate final class DatePickView: UIView {
    private let container = UIStackView()
    private let title = UILabel()
    private let datePicker = UIDatePicker()

    var date: Date {
        datePicker.date
    }

    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = Colors.foregroundColor
        layer.cornerRadius = 8

        container.axis = .horizontal
        container.alignment = .fill
        container.distribution = .fill
        container.spacing = 15

        title.text = "Когда?"
        title.textColor = Colors.subtitleTextColor
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        datePicker.datePickerMode = .dateAndTime

        [title, datePicker].forEach {
            container.addArrangedSubview($0)
        }

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
