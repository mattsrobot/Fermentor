//
//  Coordinator.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

/// Coordinating confirming classes will aid navigation of the app to different screens
protocol Coordinating {
    
    /// Navigates app to displaying a list of pickles
    func displayPickleList()
    
    /// Navigates app to displaying a pickle detail screen
    ///
    /// - Parameter pickle: the pickle to display
    func display(pickle: Pickle)
    
    /// Pops up an alert displaying an error
    ///
    /// - Parameter error: the error to display
    func display(error: Swift.Error)
    
}

final class Coordinator : Coordinating {
    
    fileprivate let workspace: Workspace
    fileprivate let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, workspace: Workspace) {
        self.navigationController = navigationController
        self.workspace = workspace
    }
    
    func displayPickleList() {
        print("Navigating to Pickle List 🥒🥒🥒")
        let viewModel = PickleListViewModel(workspace: workspace,
                                            coordinator: self,
                                            service: PickleService())
        
        let pickelLet = PickleListView(viewModel: viewModel)
        
        navigationController.setViewControllers([pickelLet], animated: false)
    }

    func display(pickle: Pickle) {
        print("Navigating to a Pickle 🥒")
        let viewModel = PickleDetailViewModel(workspace: workspace,
                                              pickle: pickle)
        
        let pickeDetail = PickleDetailView(viewModel: viewModel)
        
        navigationController.pushViewController(pickeDetail, animated: true)
    }
    
    func display(error: Error) {
        print("🔔 Displaying an error alert 🔔")
        
    }
    
}
