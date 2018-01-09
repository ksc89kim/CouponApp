//
//  NearMerchantTableViewCell.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 9..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

//근처 가맹점 테이블 뷰 셀 
class NearMerchantTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!  //로고 이미지
    @IBOutlet weak var merchantName: UILabel!   //가맹점 이미지
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
