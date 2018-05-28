//
//  Coordinator.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum PickleComposeEvent {
    case composing
    case cancelled
    case completed
}

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
    func display(error: DisplayableError)
    
    /// Composes a pickle, returns a pickle compose event stream
    var composePickle: Observable<PickleComposeEvent> { get }
}

final class Coordinator : Coordinating {
    
    fileprivate let workspace: Workspace
    fileprivate let navigationController: UINavigationController
    
    var composePickle: Observable<PickleComposeEvent> {
        Log.debug("Navigating to composing a Pickle 🥒")

        let pickle =  Pickle(id: -1, name: "", pickledOn: Date(), usesVinegar: true)

        let viewModel = PickleDetailViewModel(workspace: workspace,
                                              pickle: pickle,
                                              coordinator: self,
                                              service: PickleService(),
                                              mode: .compose)
        
        let style = PickleListStyle(workspace: workspace)
        
        let pickeDetail = PickleDetailView(viewModel: viewModel, style: style)
        
        navigationController.pushViewController(pickeDetail, animated: true)
        
        return Observable.create({ observer in
            return Disposables.create()
        })
    }
    
    init(navigationController: UINavigationController, workspace: Workspace) {
        self.navigationController = navigationController
        self.workspace = workspace
    }
    
    func displayPickleList() {
        Log.debug("Navigating to Pickle List 🥒🥒🥒")
        let viewModel = PickleListViewModel(workspace: workspace,
                                            coordinator: self,
                                            service: PickleService())
        
        let style = PickleListStyle(workspace: workspace)
        
        let pickelLet = PickleListView(viewModel: viewModel, style: style)
        
        navigationController.setViewControllers([pickelLet], animated: false)
    }

    func display(pickle: Pickle) {
        Log.debug("Navigating to a Pickle 🥒")
        let viewModel = PickleDetailViewModel(workspace: workspace,
                                              pickle: pickle,
                                              coordinator: self,
                                              service: PickleService(),
                                              mode: .read)
        
        let style = PickleListStyle(workspace: workspace)
        
        let pickeDetail = PickleDetailView(viewModel: viewModel, style: style)
        
        navigationController.pushViewController(pickeDetail, animated: true)
    }
    
    fileprivate func display(banner: DisplayableError) {
        
    }
    
    fileprivate func display(alert: DisplayableError) {
        let alert = UIAlertController(title: alert.title,
                                      message: alert.subtitle,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func display(error: DisplayableError) {
        Log.debug("Displaying an error alert 🔔")
        switch error.type {
        case .alert:
            display(alert: error)
        case .banner:
            display(banner: error)
        }
    }
    
}
