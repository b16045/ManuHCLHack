//
//  Icons.swift
//  ManuHCLHack
//
//  Created by Arpit on 22/07/17.
//  Copyright © 2017 Sayan. All rights reserved.
//

import Foundation
import UIKit


enum Icons: Int {

    case trophyCabinet=0
    case legend
    case ot
    case euroChamps
    case treble
    
    func image() -> UIImage? {
        return UIImage(named: "\(self.name())")
    }
    
    func name() -> String {
        switch self {
        case .legend: return "Icon_Legend"
        case .ot: return "Icon_OT"
        case .trophyCabinet: return "Icon_TrophyCabinet"
        case .euroChamps: return "Icon_EuroChamps"
        case .treble: return "Icon_Treble"
        }
    }
    
    static func icon(forTag tag: Int) -> Icons {
        return Icons(rawValue: tag) ?? .trophyCabinet
    }
    
    static let allIcons: [Icons] = {
        var all = [Icons]()
        var index: Int = 0
        while let icon = Icons(rawValue: index) {
            all += [icon]
            index += 1
        }
        return all.sorted { $0.rawValue < $1.rawValue }
    }()
}

