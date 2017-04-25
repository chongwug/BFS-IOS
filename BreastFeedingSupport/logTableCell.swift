//
//  logTableCell.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/3/17.
//  Copyright © 2017 CHONG W GUO. All rights reserved.
//
import UIKit
class logTableCell: UITableViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var diaperLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
