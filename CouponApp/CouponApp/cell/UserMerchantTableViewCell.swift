//
//  UserMerchantTableViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 20..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

class UserMerchantTableViewCell: UITableViewCell {

    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}