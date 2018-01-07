//
//  UserMerchantTableViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 20..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

class UserMerchantTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView! //로고이미지
    @IBOutlet weak var merchantName: UILabel! //가맹점 이름
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
