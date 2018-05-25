//
//  PickleListItemView.swift
//  Fermentor
//
//  Created by Matthew Wilkinson on 15/5/18.
//  Copyright © 2018 Matthew Wilkinson. All rights reserved.
//

import UIKit

final class PickleListItemView: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(with item: PickleListItem) {
        textLabel.text = item.title
        detailLabel.text = item.subtitle
    }
    
}
