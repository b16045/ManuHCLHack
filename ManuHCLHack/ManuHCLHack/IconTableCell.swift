//
//  IconTableCell.swift
//  ManuHCLHack
//
//  Created by Arpit on 22/07/17.
//  Copyright © 2017 Sayan. All rights reserved.
//

import Foundation
import UIKit

class IconTableCell: UICollectionViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    var icon: Icons? {
        didSet {
            guard let icon = icon else { return }
            imgIcon.image = icon.image()
        }
    }
    
}
