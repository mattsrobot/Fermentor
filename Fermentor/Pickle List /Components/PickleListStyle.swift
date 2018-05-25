//
//  PickleListStyle.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 21/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// A style defining colors, padding, related to the Pickle List
struct PickleListStyle {
    
    let itemHeight = CGFloat(80)

    var listViewBackgroundColor: Observable<UIColor>
    
    var style: Stylable
    
    init(workspace: Workspace) {
        self.style = workspace.style
        self.listViewBackgroundColor = Observable<UIColor>.create { observer in
            let shades = [workspace.style.pickleGreenShade2,
                          workspace.style.pickleGreenShade3,
                          workspace.style.pickleGreenShade4]
            observer.onNext(shades[0].value)
            var index = 0
            func flipColor() {
                index += 1
                let nextShade = shades[index % shades.count]
                DispatchQueue.main.asyncAfter(deadline: .now() + 3,
                                              execute: {
                                                observer.onNext(nextShade.value)
                                                flipColor()
                })
            }
            flipColor()
            return Disposables.create()
        }
    }
    
}

