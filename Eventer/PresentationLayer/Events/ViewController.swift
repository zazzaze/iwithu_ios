//
//  ViewController.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import UIKit

class ViewController: UIViewController {
    var interactor: EventsInteractor?
    var router: EventsRouter?

    private var allEvents: [EventModel] = []
    private var myEvents: [EventModel] = []

    private let allEventsRefreshControl = UIRefreshControl()
    private let myEventsRefreshControl = UIRefreshControl()

    private let allEventsTableView = UITableView()
    private let myEventsTableView = UITableView()
    private var allEventsLeadingConstraint: NSLayoutConstraint?
    private var allEventsTrailingConstraint: NSLayoutConstraint?
    private var myEventsTrailingConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.barTintColor = Colors.backgroundColor
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()

        view.backgroundColor = Colors.backgroundColor

        navigationController?.isNavigationBarHidden = false
        let switcher = Switcher()
        switcher.firstLabel.text = "Все события"
        switcher.secondLabel.text = "Мои события"
        switcher.delegate = self
        navigationItem.titleView = switcher
        let addButtonImage = UIImageView(image: Images.plusIcon)
        addButtonImage.tintColor = Colors.accentColor
        let addButton = UIBarButtonItem(image: Images.plusIcon, style: .plain, target: self, action: #selector(createNewEvent))
        addButton.tintColor = Colors.accentColor
        navigationItem.rightBarButtonItem = addButton

        configureUI()

        updateAllData()
    }

    func updateToken(_ token: String) {
        interactor?.updateToken(token)
    }

    func updateAllEvents(_ events: [EventModel]) {
        self.allEvents = events
        allEventsTableView.reloadData()
        allEventsRefreshControl.endRefreshing()
    }

    func updateMyEvents(_ events: [EventModel]) {
        self.myEvents = events
        myEventsTableView.reloadData()
        myEventsRefreshControl.endRefreshing()
    }

    private func configureUI() {
        allEventsRefreshControl.addTarget(self, action: #selector(updateAllEventsTable(_:)), for: .valueChanged)
        allEventsRefreshControl.tintColor = Colors.titleColor
        allEventsTableView.addSubview(allEventsRefreshControl)

        myEventsRefreshControl.addTarget(self, action: #selector(updateMyEventsTable(_:)), for: .valueChanged)
        myEventsRefreshControl.tintColor = Colors.titleColor
        myEventsTableView.addSubview(myEventsRefreshControl)

        [myEventsTableView, allEventsTableView].forEach { table in
            table.backgroundColor = UIColor.clear
            table.dataSource = self
            table.delegate = self
            table.translatesAutoresizingMaskIntoConstraints = false
            table.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
            table.separatorStyle = .none
            table.showsVerticalScrollIndicator = false
            table.showsHorizontalScrollIndicator = false
            view.addSubview(table)
        }

        NSLayoutConstraint.activate([
            allEventsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allEventsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            myEventsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myEventsTableView.leadingAnchor.constraint(equalTo: allEventsTableView.trailingAnchor, constant: 24),
            myEventsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        allEventsLeadingConstraint = allEventsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        allEventsLeadingConstraint?.isActive = true

        allEventsTrailingConstraint = allEventsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        allEventsTrailingConstraint?.isActive = true
        myEventsTrailingConstraint = myEventsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: allEventsTableView.frame.width + 12)
        myEventsTrailingConstraint?.isActive = true
    }

    func updateAllData() {
        updateAllEventsTable(showRefresh: true)
        updateMyEventsTable(showRefresh: true)
    }

    @objc func createNewEvent() {
        router?.createEvent()
    }

    @objc func updateAllEventsTable(_ sender: AnyObject) {
        updateAllEventsTable(showRefresh: false)
    }

    private func updateAllEventsTable(showRefresh: Bool) {
        if showRefresh {
            allEventsRefreshControl.beginRefreshing()
        }
        self.interactor?.loadEvents()
    }

    @objc func updateMyEventsTable(_ sender: AnyObject) {
        updateMyEventsTable(showRefresh: false)
    }

    private func updateMyEventsTable(showRefresh: Bool) {
        if showRefresh {
            myEventsRefreshControl.beginRefreshing()
        }
        self.interactor?.loadMyEvents()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === allEventsTableView {
            return allEvents.count
        } else {
            return myEvents.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as! EventTableViewCell
        cell.selectionStyle = .none
        let model: EventModel
        if tableView === allEventsTableView {
            model = allEvents[indexPath.row]
        } else {
            model = myEvents[indexPath.row]
        }

        cell.update(with: model)

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: EventModel
        if tableView === allEventsTableView {
            model = allEvents[indexPath.row]
        } else {
            model = myEvents[indexPath.row]
        }

        router?.show(event: model)
    }
}

extension ViewController: SwitcherDelegate {
    func switcher(_ switcher: Switcher, didChangeActive: SwitcherSelection) {
        if didChangeActive == .second {
            UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
                self.allEventsLeadingConstraint?.constant = -(self.allEventsTableView.frame.width + 36)
                self.allEventsTrailingConstraint?.constant = -(self.allEventsTableView.frame.width + 36)
                self.myEventsTrailingConstraint?.constant = -12
                self.view.layoutSubviews()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
                self.allEventsLeadingConstraint?.constant = 12
                self.allEventsTrailingConstraint?.constant = -12
                self.myEventsTrailingConstraint?.constant = self.allEventsTableView.frame.width + 12
                self.view.layoutSubviews()
            }, completion: nil)
        }
    }
}
