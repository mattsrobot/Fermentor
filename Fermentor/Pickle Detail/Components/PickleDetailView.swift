//
//  PickleDetailView.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

protocol PickleDetailViewable {
    
    var view: UIView! { get }
    
    init(viewModel: PickleDetailModelable, coordinator: Coordinating)
}

final class PickleDetailView : UIViewController, PickleDetailViewable {

    @IBOutlet weak var pickleNameTextField: UITextField?
    @IBOutlet weak var pickleDatePicker: UIDatePicker?
    @IBOutlet weak var usesVinegarSwitch: UISwitch?
    
    fileprivate let viewModel: PickleDetailModelable
    fileprivate let coordinator: Coordinating
    
    init(viewModel: PickleDetailModelable, coordinator: Coordinating) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(viewModel:,coordinator:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
