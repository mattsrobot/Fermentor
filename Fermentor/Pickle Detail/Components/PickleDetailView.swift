//
//  PickleDetailView.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit
import RxSwift

protocol PickleDetailViewable {
    
    var view: UIView! { get }
    
    init(viewModel: PickleDetailModelable)
}

fileprivate struct Constants {
    static let maxTitleLength = 15
}

final class PickleDetailView : UIViewController, PickleDetailViewable {

    @IBOutlet weak var pickleNameLabel: UILabel?
    @IBOutlet weak var pickleNameTextField: UITextField?
    @IBOutlet weak var pickledOnLabel: UILabel?
    @IBOutlet weak var pickleDatePicker: UIDatePicker?
    @IBOutlet weak var usesVinegarLabel: UILabel?
    @IBOutlet weak var usesVinegarSwitch: UISwitch?
    
    fileprivate let disposeBag = DisposeBag()

    fileprivate let viewModel: PickleDetailModelable
    
    init(viewModel: PickleDetailModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(viewModel:,coordinator:)")
    }
    
    func bindTo(viewModel: PickleDetailModelable) {
        
        guard let pickleNameLabel = pickleNameLabel, let pickleNameTextField = pickleNameTextField, let usesVinegarLabel = usesVinegarLabel, let usesVinegarSwitch = usesVinegarSwitch else {
            return
        }
        
        let title = viewModel.title.asObservable()
        
        title.map({ $0?.trunc(length: Constants.maxTitleLength) })
             .bind(to: navigationItem.rx.title)
             .disposed(by: disposeBag)
    
        title.bind(to: pickleNameTextField.rx.text)
             .disposed(by: disposeBag)
        
        pickleNameTextField.rx.text
            .map({ $0?.capitalized })
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
        
        let pickNameTitle = viewModel.pickNameTitle
        
        pickNameTitle
            .bind(to: pickleNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        let usesVinegarTitle = viewModel.usesVinegarTitle
        
        usesVinegarTitle
            .bind(to: usesVinegarLabel.rx.text)
            .disposed(by: disposeBag)
        
        let usesVinegar = viewModel.usesVinegar
        
        usesVinegar
            .bind(to: usesVinegarSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        usesVinegarSwitch.rx.isOn
            .bind(to: usesVinegar)
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTo(viewModel: viewModel)
    }

}

