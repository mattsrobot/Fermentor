//
//  UIView+Extensions.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 23/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

extension UIView {

    static func setLayersBackground(_ layers: [CALayer?],
                                    to color: CGColor,
                                    animated: Bool = true,
                                    duration: TimeInterval = 1) {
        
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction] , animations: {
                layers.forEach({ $0?.backgroundColor = color })
            }, completion: nil)
        } else {
            layers.forEach({ $0?.backgroundColor = color })
        }
    }
}

#if os(iOS) || os(tvOS)
    
    import RxCocoa
    import RxSwift
    
    extension Reactive where Base: UIView {
        public var backgroundColor: Binder<UIColor?> {
            return Binder(self.base) { view, color in
                view.backgroundColor = color
            }
        }
    }
    
#endif
