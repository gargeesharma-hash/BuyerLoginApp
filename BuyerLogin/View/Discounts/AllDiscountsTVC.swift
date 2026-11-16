//
//  AllDiscountsTVC.swift
//  Customer BBC
//
//  Created by Akshay Kumar on 04/06/26.
//

import UIKit
import Kingfisher

class AllDiscountsTVC: UITableViewCell {

    //MARK: Cell Outlets
    @IBOutlet weak var viewYellowGrdient: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var vwMainBg: UIView!
    @IBOutlet weak var vwBgImage: UIView!
    @IBOutlet weak var imgStoreImage: UIImageView!
    @IBOutlet weak var lblDiscountFlatPercent: UILabel!
    @IBOutlet weak var vwMoreBg: UIView!
    @IBOutlet weak var lblCountMore: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblStoreLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblKilloMeter: UILabel!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnActOffer: UIButton!
    
    var callBackOffer:(()-> Void )?
    
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addShadowAround()
        roundCorners()
        DispatchQueue.main.async {
            self.viewYellowGrdient.removeOldGradient()
            self.viewYellowGrdient.applyLinearGradientLeftRight(
                colors: [
                    #colorLiteral(red: 0.8183535337, green: 0.4861452579, blue: 0.011535706, alpha: 1),
                    #colorLiteral(red: 0.9186652303, green: 0.6141083241, blue: 0.1795410812, alpha: 1)
                ]
            )
        }
    }

    
    //MARK: Configure
    func configure(with coupon: CouponListItem) {
        self.viewCategory.layer.cornerRadius = self.viewCategory.frame.height / 2
        self.viewCategory.layer.masksToBounds = true
        lblStoreName.text = coupon.storeName ?? coupon.couponTitle
        lblStoreLocation.text = coupon.storeAddress
        lblDiscountFlatPercent.text = coupon.discountText
        lblTime.text = coupon.deliveryTime
        lblKilloMeter.text = coupon.distance
        lblCategory.text = coupon.categoryName

        // "+X more" badge — show only when there is more than one offer
        let offers = Int(coupon.offerCount ?? "0") ?? 0
        if offers > 1 {
            vwMoreBg.isHidden = false
            lblCountMore.text = "+\(offers - 1) more"
        } else {
            vwMoreBg.isHidden = true
            lblCountMore.text = ""
        }
//        if let urlStr = coupon.storeImage, let url = URL(string: urlStr) {
//            imgStoreImage.kf.setImage(with: url, placeholder: UIImage(named: "ic_store_placeholder"))
//        } else {
//            imgStoreImage.image = UIImage(named: "ic_store_placeholder")
//        }
        imgStoreImage.kf.cancelDownloadTask()
        imgStoreImage.image = UIImage(named: "ic_store_placeholder")

        if let imageUrl = coupon.storeImage,
           !imageUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let storeImageUrl = URL(string: imageUrl) {
            
            imgStoreImage.kf.setImage(
                with: storeImageUrl,
                placeholder: UIImage(named: "ic_store_placeholder")
            )
            
        } else {
            imgStoreImage.image = UIImage(named: "ic_store_placeholder")
        }
    }
    @IBAction func btnActOffer(_ sender: Any) {
        self.callBackOffer?()
    }
    
    //MARK: Corner Radius
    private func roundCorners() {
        // Top side only corner radius
        vwBgImage.clipsToBounds = true
        vwBgImage.layer.cornerRadius = 15
        vwBgImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        vwBottom.clipsToBounds = true
        vwBottom.layer.cornerRadius = 15
        vwBottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    //MARK: Shadow
    private func addShadowAround() {
        vwMainBg.clipsToBounds = false
        vwMainBg.layer.masksToBounds = false
        vwMainBg.layer.shadowColor = UIColor.black.withAlphaComponent(0.10).cgColor
        vwMainBg.layer.shadowOffset = .zero          // shadow on all sides
        vwMainBg.layer.shadowOpacity = 2.0
        vwMainBg.layer.shadowRadius = 4.0
    }

    //MARK: setSelected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
