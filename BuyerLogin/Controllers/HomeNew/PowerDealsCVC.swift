//
//  PowerDealsCVC.swift
//  Customer BBC
//
//  Created by Mayank Bimbra on 08/02/25.
//

import UIKit
import Kingfisher

class PowerDealsCVC: UICollectionViewCell {
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var dicountImageView: UIImageView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var vwTopShadow: UIView!
    @IBOutlet weak var imgShadow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
