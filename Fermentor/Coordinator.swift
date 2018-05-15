//
//  Coordinator.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

protocol Coordinating {
    
    func display(pickle: Pickle)
    
    func display(error: Swift.Error)
    
}

final class Coordinator : Coordinating {
    
    fileprivate let context: Context
    fileprivate let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, context: Context) {
        self.navigationController = navigationController
        self.context = context
    }
    
    func displayPickleList() {
        
        let viewModel = PickleListViewModel(context: context,
                                            coordinator: self,
                                            service: PickleService())
        
        let pickelLet = PickleListView(viewModel: viewModel,
                                       coordinator: self)
        
        navigationController.setViewControllers([pickelLet], animated: false)
    }

    func display(pickle: Pickle) {
        let viewModel = PickleDetailViewModel(context: context, pickle: pickle)
        let pickeDetail = PickleDetailView(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(pickeDetail, animated: true)
    }
    
    func display(error: Error) {
        
    }
    
}
