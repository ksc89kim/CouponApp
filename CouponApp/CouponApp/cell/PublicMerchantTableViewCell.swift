//
//  PublicMerchantTableViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 31..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

/*
     전체 가맹점 테이블 뷰 셀
 */
class PublicMerchantTableViewCell: UITableViewCell {
    @IBOutlet weak var merchantName: UILabel!   //가맹점 이름
    @IBOutlet weak var logoImage: UIImageView!  //로고 이미지
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
