//
//  Styles.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 19/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol Stylable {
    
    var pickleGreenShade1: BehaviorRelay<UIColor> { get }
    var pickleGreenShade2: BehaviorRelay<UIColor> { get }
    var pickleGreenShade3: BehaviorRelay<UIColor> { get }
    var pickleGreenShade4: BehaviorRelay<UIColor> { get }
    var pickleGreenShade5: BehaviorRelay<UIColor> { get }
    var paleGreen: BehaviorRelay<UIColor> { get }
    var mediumAquamarine: BehaviorRelay<UIColor> { get }
    var sunsetOrange: BehaviorRelay<UIColor> { get }
    var mediumYellow: BehaviorRelay<UIColor> { get }

}

struct PickleTheme : Stylable {

    var pickleGreenShade1 = BehaviorRelay(value: #colorLiteral(red: 0.4093435768, green: 0.8931559865, blue: 0.4188986676, alpha: 1))
    var pickleGreenShade2 = BehaviorRelay(value: #colorLiteral(red: 0.3941122918, green: 0.859922502, blue: 0.4033118467, alpha: 1))
    var pickleGreenShade3 = BehaviorRelay(value: #colorLiteral(red: 0.2862745098, green: 0.7725490196, blue: 0.2823529412, alpha: 1))
    var pickleGreenShade4 = BehaviorRelay(value: #colorLiteral(red: 0.1882352941, green: 0.6666666667, blue: 0.1882352941, alpha: 1))
    var pickleGreenShade5 = BehaviorRelay(value: #colorLiteral(red: 0.1137254902, green: 0.5568627451, blue: 0.1137254902, alpha: 1))
    var paleGreen = BehaviorRelay(value: #colorLiteral(red: 0.6666666667, green: 0.9647058824, blue: 0.5137254902, alpha: 1))
    var mediumAquamarine = BehaviorRelay(value: #colorLiteral(red: 0.462745098, green: 1, blue: 0.01176470588, alpha: 1))
    var sunsetOrange = BehaviorRelay(value: #colorLiteral(red: 0.2, green: 0.4117647059, blue: 0.1176470588, alpha: 1))
    var mediumYellow = BehaviorRelay(value: #colorLiteral(red: 1, green: 0.8509803922, blue: 0.4901960784, alpha: 1))
    
}
