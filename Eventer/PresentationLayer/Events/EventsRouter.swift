//
//  EventsRouter.swift
//  Eventer
//
//  Created by Egor Anikeev on 27.01.2022.
//

import Foundation
import UIKit

class EventsRouter {
    private weak var view: ViewController?
    private var navController: UINavigationController? {
        view?.navigationController
    }

    internal init(view: ViewController) {
        self.view = view
    }

    func show(event: EventModel) {
        let eventConfigurator = EventConfigurator()
        let viewController = eventConfigurator.makeEventViewController(for: event)

        view?.present(viewController, animated: true, completion: nil)
    }

    func createEvent() {
        guard let view = view else {
            return
        }
        
        let configurator = CreateEventConfigurator()
        let vc = configurator.makeCreateEventViewController(baseView: view)
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navController?.view.layer.add(transition, forKey: nil)

        navController?.pushViewController(vc, animated: false)
    }
}
