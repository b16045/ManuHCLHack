//
//  CellDetail.swift
//  ManuHCLHack
//
//  Created by Arpit on 22/07/17.
//  Copyright © 2017 Sayan. All rights reserved.
//

import Foundation
import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    var item: TableItem? = nil {
        didSet {
            if let item = item {
                imgIcon.image = Icons(rawValue: item.icon)?.image()
                lblName.text = item.name
                
                //Uncomment the next line and comment the line after that ßif viewing in iPhone device to see how location is tracked.
//                lblLocation.text = item.locationString()
                lblLocation.text = ""
                
            } else {
                imgIcon.image = nil
                lblName.text = ""
                lblLocation.text = ""
            }
        }
    }
    
    func refreshLocation() {
        lblLocation.text = item?.locationString() ?? ""
    }
}
