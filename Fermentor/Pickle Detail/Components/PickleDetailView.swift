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
    
    init(viewModel: PickleDetailModelable, style: PickleListStyle)
}

fileprivate struct Constants {
    static let maxTitleLength = 15
    static let colorFlipDuration = TimeInterval(1)
}

final class PickleDetailView : UIViewController, PickleDetailViewable {

    @IBOutlet weak var pickleNameLabel: UILabel?
    @IBOutlet weak var pickleNameTextField: UITextField?
    @IBOutlet weak var pickledOnLabel: UILabel?
    @IBOutlet weak var pickleDatePicker: UIDatePicker?
    @IBOutlet weak var usesVinegarLabel: UILabel?
    @IBOutlet weak var usesVinegarSwitch: UISwitch?
    @IBOutlet weak var sealedOnDatePicker: UIDatePicker!
    @IBOutlet var editButton: UIBarButtonItem?
    @IBOutlet var doneButton: UIBarButtonItem?
    
    fileprivate let disposeBag = DisposeBag()

    fileprivate let viewModel: PickleDetailModelable
    fileprivate let style: PickleListStyle
    
    init(viewModel: PickleDetailModelable, style: PickleListStyle) {
        self.viewModel = viewModel
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(viewModel:,coordinator:)")
    }
    
    fileprivate func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButton
    }
    
    func bindTo(viewModel: PickleDetailModelable) {
        
        guard let pickleNameLabel = pickleNameLabel,
              let pickleNameTextField = pickleNameTextField,
              let pickledOnLabel = pickledOnLabel,
              let usesVinegarLabel = usesVinegarLabel,
              let usesVinegarSwitch = usesVinegarSwitch,
              let sealedOnDatePicker = sealedOnDatePicker,
              let editButton = editButton,
              let doneButton = doneButton else {
            return
        }
        
        viewModel.sealedOnTitle
            .bind(to: pickledOnLabel.rx.text)
            .disposed(by: disposeBag)
        
        var animated = false
        style.listViewBackgroundColor
            .subscribe(onNext: { color in
                UIView.setLayersBackground([self.view.layer],
                                           to: color.cgColor,
                                           animated: animated,
                                           duration: Constants.colorFlipDuration)
                animated = true
            })
            .disposed(by: disposeBag)
        
        let title = viewModel.title.asObservable()
        
        title.map({ $0?.trunc(length: Constants.maxTitleLength) })
             .bind(to: navigationItem.rx.title)
             .disposed(by: disposeBag)
    
        title.bind(to: pickleNameTextField.rx.text)
             .disposed(by: disposeBag)
        
        pickleNameTextField.rx.text
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
        
        usesVinegarSwitch.onTintColor = style.style.mediumYellow.value
        
        usesVinegarSwitch.rx.isOn
            .bind(to: usesVinegar)
            .disposed(by: disposeBag)
        
        viewModel.sealedOn
            .bind(to: sealedOnDatePicker.rx.date)
            .disposed(by: disposeBag)
        
        sealedOnDatePicker.rx.date
            .bind(to: viewModel.sealedOn)
            .disposed(by: disposeBag)
        
        viewModel.mode
            .map({ $0.isEditing })
            .bind(to: pickleNameTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.mode
            .map({ !$0.isEditing })
            .bind(to: pickleNameTextField.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.mode
            .map({ !$0.isEditing })
            .bind(to: sealedOnDatePicker.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.mode
            .map({ !$0.isEditing })
            .bind(to: usesVinegarSwitch.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.mode
            .map({ mode in
                switch mode {
                case .compose:
                    return []
                case .read:
                    return [editButton]
                case .update:
                    return [doneButton]
                }
            })
            .subscribe(onNext: { items in
                self.navigationItem.setRightBarButtonItems(items, animated: true)
            })
            .disposed(by: disposeBag)

        editButton.rx.tap
            .map({PickleDetailMode.update})
            .throttle(1, scheduler: MainScheduler.instance)
            .bind(to: viewModel.mode)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .map({PickleDetailMode.read})
            .throttle(1, scheduler: MainScheduler.instance)
            .bind(to: viewModel.mode)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .throttle(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                viewModel
                    .update()?
                    .subscribe(onNext: { (event) in
                        switch event {
                        case .completed:
                            break
                        case .error(_):
                            break
                        case .updating:
                            break
                        }
                    })
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTo(viewModel: viewModel)
    }

}

