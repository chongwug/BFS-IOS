//
//  CheckBox.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/1/17.
//  Copyright © 2017 CHONG W GUO. All rights reserved.
//

//ui checkbox helper class
import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.isChecked = false
    }
    

}
